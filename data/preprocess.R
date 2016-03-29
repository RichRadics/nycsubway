library(dplyr)
library(tidyr)
setwd('~/datasets/subways')

turnstile<-read.csv('turnstile_160130.txt')
id_to_station<-read.csv('turnstile_id_to_station.csv')
gis<-read.csv('turnstile_gis.csv')
manual<-read.csv('manual_map.csv')

# To get the lat/long for each reading, we have to do a fair bit of fiddling.
# The names on the turnstile detail file don't often match the ones in the GIS
#  data file. So... firstly I run some basic translations on the GIS data - first
#  to get some of the names in line, then to pick just one lat/long for each station
#  name. 
new_gis <- gis %>%
select(Station_Name, Station_Latitude, Station_Longitude) %>%
mutate(name=gsub("(?<=[0-9])(ST|ND|TH|RD)",'',toupper(Station_Name), perl=T)) %>%
mutate(name=gsub("^AV ", "AVENUE ", name)) %>%
mutate(name=gsub("HIGHWAY", "HWY", name)) %>%
mutate(name=gsub("PARKWAY", "PKWY", name)) %>%
group_by(name) %>%
mutate(rn=row_number()) %>%
filter(rn==1) %>%
ungroup() %>%
select(name, lat=Station_Latitude, long=Station_Longitude)

# Merge in my manual translation table. This has turnstile station names mapped
#  to GIS names - it creates dummy entries by copying the valid GIS rows.
new_gis2 <- rbind(new_gis,manual   %>% left_join(new_gis, by=c('gis_name'='name')) %>% select(name=turnstile_name, lat, long) %>% filter(!is.na(lat)))
new_gis3 <- turnstile %>% 
  select(STATION) %>% 
  distinct() %>% 
  transmute(name=STATION) %>% 
  left_join(new_gis2)

# Now join in the latlongs to the turnstile data, create a combined datetime col
#  and drop the originals
turnstile <- turnstile %>% inner_join(new_gis3, by=c('STATION'='name'))
turnstile$datetime <- as.POSIXct(strptime(paste0(turnstile$DATE, turnstile$TIME, sep=' '), format='%m/%d/%Y %H:%M:%S'))
turnstile$DATE<-NULL
turnstile$TIME<-NULL

# Build my summary table.
# Couple of fixes here for really odd data. 
# a) Sometimes the counters start to decrease, instead of increase.
# b) They can reset to zero, or just another number
# So i'm using a change of over 20k to be significant. Real
turnstile_summ <-
  turnstile %>% 
    filter(DESC=='REGULAR') %>%
    group_by(C.A, UNIT, SCP, STATION) %>% 
    arrange(datetime) %>% 
    mutate(start_entries=lag(ENTRIES), start_exits=lag(EXITS), start_datetime=lag(datetime)) %>%
    mutate(window_entries=as.numeric(ifelse(ENTRIES==0, 0, ifelse(abs(ENTRIES-start_entries)<20000,abs(ENTRIES-start_entries),ENTRIES))), 
           window_exits=as.numeric(ifelse(EXITS==0, 0, ifelse(abs(EXITS-start_exits)<20000,abs(EXITS-start_exits),EXITS)))) %>%
    ungroup() %>%
    filter(window_exits<20000,window_entries<20000) %>%
    group_by(STATION, start_datetime, datetime, lat, long) %>%
    summarise(total_entries=sum(window_entries), total_exits=sum(window_exits)) %>%
    ungroup()  %>%
    filter(!is.na(start_datetime)) %>%
    filter(!is.na(lat)) %>%
    filter(!is.na(long)) 
  turnstile_summ <- turnstile_summ %>%
    mutate(time_bucket = cut(turnstile_summ$start_datetime, "4 hours")) %>%
    mutate(movement = total_entries - total_exits) %>%
    select(STATION, time_bucket, movement, lat, long) %>%
    group_by(STATION, lat, long, time_bucket) %>%
    summarise(movement = sum(movement)) %>%
    ungroup()

# Spread then gather the data - neatly creates any missing values
turnstile_spread <-spread(turnstile_summ, time_bucket, movement)
turnstile_gathered <-gather(turnstile_spread,time_bucket, movement, 4:44)

# Now to impute the NAs and respread then zero remaining. 
# This is terrible for accurate data, but fine for a vis
turnstile_gathered <- turnstile_gathered %>% mutate(movement=ifelse(is.na(movement),(lead(movement)-lag(movement))/2,movement)) 
turnstile_spread <-spread(turnstile_gathered, time_bucket, movement)
turnstile_spread[is.na(turnstile_spread)] <- 0
write.csv(turnstile_spread, file='turnstile_160130_summ.csv')