# New York Subway Usage - Movement through Time

As part of my Udacity Data Analyst Nanodegree, I performed some cleanup and analysis of some data from the New York subway. The pure numerical data didn't take into account any of the geographical features of the data, so I wanted to explore the usage in a more visual way. This project hopes to show interesting pattterns in the subway ridership both geographically, and over time.


## Summary

TBC

## Design

### Dataset and preprocessing

TBC

### Visualisation choice

TBC

### Visualisation Design

TBC

## Feedback

I posted an early version of the visualisation on a Google+ group, and asked for some initial feedback. The responses were primarily related to the formatting and visualisation controls.

#### User 1
Looks like the center of the map is in Manhattan, which makes most of Queens and Brooklyn outside default map view. I guess Queens is irrelevant for this viz, since AFAIK there are no metro stations there, but Brooklyn is important, there are many metro stations there.

** This comment was based on the *bl.ocks.org* preview of the vis. When viewed in a full browser, this was not an issue **

#### User 2
A slider to change the value in date-time axis would be very helpful.

#### User 3
After reading your explanation in the post the visualization becomes more clear. A couple suggestions of things to improve upon.

-Add Text animation with Monday time, Tuesday time... Sunday time, in the Top Center. It is quite hard to see and understand exactly which time and day you are looking at initial animation. It's more relevant to know the day of the week, rather than date in my opinion (excluding holidays).

-Use tag:hover {cursor: pointer;} to not show the text cursor when you hover over the date select list on the left. 

-Change the color of the top three selectors Terrain, Subway Stations, Subway Lines to a color that is not white. When you unselect Terrain, and the background becomes white, the other two selection text disappears into the background.

Otherwise, I think this is great work, adding the legend and explanation would definitely improve the overall clarity as well.


### Post-feedback review

I took on board all of the provided comments, but had to consider both time and my D3 skillset in what modifications I would make. 

## Resources

#### Data

Subway usage data: http://web.mta.info/developers/download.html
Subway station locations: http://web.mta.info/developers/data/nyct/subway/StationEntrances.csv
Subway routes: https://github.com/daveswartz/mapperly/blob/master/public/data/paths.json

#### Libraries

D3
d3.carto
https://github.com/jgoodall/d3-colorlegend/

#### General

TBC