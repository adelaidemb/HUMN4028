# Library
library(leaflet)
library(dplyr)
library(tidyverse)

#Setting working directory, and importing dataset
setwd('/Users/adelaide/Google Drive/University/2022/HUMN4028')
famdata <- read_csv('Map4.csv', show_col_types = FALSE)

# load Familicide data
View(famdata)
df <- data.frame(famdata)
df <- head(df, 99)
View(df)

# Create a color palette for age range.
mybins <- seq(15, 85, by=10)
mypalette <- colorBin( palette="YlOrRd", domain=df$age, na.color="transparent", bins=mybins)

# Prepare the text to be shown when a bubble is hovered over
mytext <- paste(
  "Name: ", df$Name, "<br/>", 
  "Gender: ", df$Gender, "<br/>",
  "Age at Offence: ", df$age, "<br/>",
  "Perpetrator Suicide: ", df$suicide, sep="") %>%
  lapply(htmltools::HTML)
mytext

# Final Map
m <- leaflet(df) %>% 
  addTiles()  %>% 
  setView( lat=-33, lng=155 , zoom=3) %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addCircleMarkers(~long, ~lat, 
                   fillColor = ~mypalette(age), fillOpacity = 0.7, color="white", radius=8, stroke=FALSE,
                   label = mytext,
                   options = markerOptions(riseOnHover = TRUE),
                   labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", noHide = F, direction = "auto"),
  ) %>%
  addLegend( pal=mypalette, values=~age, opacity=0.9, title = "Perpetrator age", position = "bottomright" )
m
#Export widget.