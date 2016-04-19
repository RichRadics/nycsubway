# New York Subway Usage - Movement through Time

As part of my Udacity Data Analyst Nanodegree, I performed some cleanup and analysis of some data from the New York subway. The pure numerical data didn't take into account any of the geographical features of the data, so I wanted to explore the usage in a more visual way. This project hopes to show interesting pattterns in the subway ridership both geographically, and over time.


## Summary

This visualisation shows the passenger movement through every NYC subway station over a period of a week (starting 26th April 2016). It shows the areas where more people travel to at different times of day - highlighting commuter and working areas - which nicely aligns with Lower Manhattan.

## Design

### Dataset and preprocessing

I sourced the data for this visualisation from two sources. The New York Metropolitan Transport Agency (MTA) provide a large selection of data from the transport systems which they manage. I selected a random week of their subway turnstile data, and also located a location file linking station names to latitude/longitude data. A large amount of data wrangling was required in order to link these two files - for some unknown reason the station names were not the same. I automagically translated some names (e.g. standardising Av/Ave/Avenue), and manually linked the remainder of the stations. Once this was complete, I used an R script to generate a suitable output for the visualisation to import. 

In particular, making the data easy to handle for the animation of the visualisation was of high importance - as a result, each station consists of a single row, with a long collection of columns corresponding to each day/time observation. The javascript can then easily convert this into an array for simple display/change. The R script and mapping files are in the *data* folder.

Additionally, I located geojson files containing the outline of NYC communities, and the paths of the subway lines. I thinned the community file down to only 'Lower Manhattan', as this is our key area of interest. The subway lines would help a user link the stations together when exploring the data. The files required no additional preprocessing, and is imported as-is.

### Visualisation choice

Displaying the data as a map was a simple choice - in order to investigate geographical relationships, its the only real choice. Exactly how to format the map, however, required more thought. I chose the *d3.carto* library to simplify the presentation, as it works with *d3*, and makes multi-layer maps easy to implement. In my case, I decided on four layers:

- A base tile map, sourced from the *cartodb* website. This is a tile map to allow the user to see detailed mapping of New York.
- A subway route layer
- A 'Lower Manhattan' layer.
- A layer of the individual station locations.

### Visualisation Design

This visualisation has several separate design areas, built up in layers. The design decisions were therefore made similarly, in a series of major steps.

##### Tile map layer

I chose a dark colour scheme to create good contrast with the data points, and a **terrain** level of detail, so the user can see very detailed geographical information including roads, waterways, bridges, and location labels.

##### Subway route layer

The subway route layer was simple to design, being just a set of *d3* paths loaded from a GeoJSON file. Using a narrow stroke-width for the paths, and a unique colour would make the subway routes clear.

##### Manhattan layer

The Lower Manhattan layer was similar to the subway layer, a set of *d3* paths loaded from a GeoJSON file. I used a white border and a 25% opacity background to highlight this area. 

##### Data point layer

The data point layer shows the actual data for the visualisation, so needed to be clear and obvious. I chose circles to represent each station - the size was iterated to find a level where each station was clear, but at the default zoom level a few overlaps occured as possible. 

The colours for positive and negative movement needed to also be clear, and red/green extremities were immediate choices. The scaling of the shading was simple in my early sketches (using Tableau), but in the end required a great deal of experimentation. As some stations had very high movement (+/- 40000) using a complete scale would have dwarfed the smaller station movements. In the end, I chose lower levels of movement to scale the full range - while this loses some detail for the viewer, it makes comparing the majority of the stations more practical.

##### Information and control layer

The *d3.carto* library provided layer and nagivation controls, and I decided to add a further three control/info boxes - the day/time control, a large current day/time display, and a legend. 


## Feedback

I posted an early version of the visualisation on a Google+ group, and asked for some initial feedback. The responses were primarily related to the formatting and visualisation controls.

#### User 1
Looks like the center of the map is in Manhattan, which makes most of Queens and Brooklyn outside default map view. I guess Queens is irrelevant for this viz, since AFAIK there are no metro stations there, but Brooklyn is important, there are many metro stations there.

** This comment was based on the *bl.ocks.org* preview of the vis. When viewed in a full browser, this was not an issue **

#### User 2
A slider to change the value in date-time axis would be very helpful.

** I would love to implement this, but suspect it will be difficult to achieve **

#### User 3
After reading your explanation in the post the visualization becomes more clear. A couple suggestions of things to improve upon.

-Add Text animation with Monday time, Tuesday time... Sunday time, in the Top Center. It is quite hard to see and understand exactly which time and day you are looking at initial animation. It's more relevant to know the day of the week, rather than date in my opinion (excluding holidays).

-Use tag:hover {cursor: pointer;} to not show the text cursor when you hover over the date select list on the left. 

-Change the color of the top three selectors Terrain, Subway Stations, Subway Lines to a color that is not white. When you unselect Terrain, and the background becomes white, the other two selection text disappears into the background.

Otherwise, I think this is great work, adding the legend and explanation would definitely improve the overall clarity as well.

** All excellent suggestions, which I plan to implement. **

### Post-feedback review

I took on board all of the provided comments, but had to consider both time and my D3 skillset in what modifications I would make. As a result, I decided to:
- Change the date/time display to just day/time
- Add a centred 'current' day/time box
- Add a legend 
- Change the cursor behaviour for the day/time selection box
- Standardise the background rectangles
- Add some descriptive text.


## Issues

There is a major browser support issue, at time of writing, with only Chrome functioning as I want. In Firefox, the station tooltips do not display correctly, only showing the data for the alphabetically last station. Also the legend displays outside it's bounding box. On Safari the problems worsen, with no data points visible at all - only a horizontal white line appears. I will work on resolving these issues.

## Resources

#### Data

Subway usage data: http://web.mta.info/developers/download.html
Subway station locations: http://web.mta.info/developers/data/nyct/subway/StationEntrances.csv
Subway routes: https://github.com/daveswartz/mapperly/blob/master/public/data/paths.json
NYC Community areas: http://data.beta.nyc/dataset/nyc-community-districts/resource/d826bbc6-a376-4642-8d8b-3a700d701557

#### Libraries

D3
d3.carto
https://github.com/jgoodall/d3-colorlegend/
