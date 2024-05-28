---
title: "Avalon PLOS"
author: "Olya"
output: 
  html_document:
    keep_md: true
---

## Avalon (well-mapped in osm neighbourhood) PLOS


##### Reading csv files, merging all line-level data in one table based on the common for sidewalk and highway tables columns.

```r
sidewalks <- read.csv("/Users/olechka/Documents/R/challenges/PLOS_AVALON/sidewalks.csv")
highways <- read_csv("/Users/olechka/Documents/R/challenges/PLOS_AVALON/highway.csv")
```

```
## Rows: 11 Columns: 30
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (27): wkt_geom, full_id, osm_type, highway, service, railway, constructi...
## dbl  (3): fid, osm_id, maxspeed
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
line_data <- merge(sidewalks, highways, by = c("wkt_geom", "fid", "full_id", "osm_id", "osm_type", "highway", "motor_vehicle", "access", "horse", "foot", "lit", "oneway", "surface", "bicycle", "name"), all = TRUE)
```

##### Now moving to point data and repeatins previous actions - merging all point-level data in one table based on the common for trees, lights, and parking tables columns.

```r
trees <- read.csv("/Users/olechka/Documents/R/challenges/PLOS_AVALON/trees.csv")
trees$infra_type <- "tree"
lights <- read.csv("/Users/olechka/Documents/R/challenges/PLOS_AVALON/street_lamp.csv")
lights$infra_type <- "light"
parking <- read.csv("/Users/olechka/Documents/R/challenges/PLOS_AVALON/parking_aisle.csv")
parking$infra_type <- "parking"


point_data <- merge( trees, lights, by = c("wkt_geom", "fid", "full_id", "osm_id", "osm_type", "lit", "infra_type"), all = TRUE)

point_data_full <- merge( point_data, parking, by = c("wkt_geom", "fid", "full_id", "osm_id", "osm_type", "infra_type"), all = TRUE)
```
Now we want to join tables of lines and points using spatial join. One thing to remember is that st_join uses left_join and is only applicable for sf objects. So what we want to do is converting dataframes to simple feature class and join our tables based on the function intersects
But first let's get rid of the NULLs.

##### Performing join of points and lines to create a master df file

```r
points_cleaned <- point_data_full %>%   mutate_if(is.character, ~ if_else(. == "NULL", NA_character_, .))
lines_cleaned <- line_data %>%   mutate_if(is.character, ~ if_else(. == "NULL", NA_character_, .))

points_cleaned_sf <- st_as_sf(points_cleaned, wkt = "wkt_geom", crs = 4326)
lines_cleaned_sf <- st_as_sf(lines_cleaned, wkt = "wkt_geom", crs = 4326)

Avalon_pointstoLines <- st_join(lines_cleaned_sf, points_cleaned_sf, join = st_touches, left = TRUE)
Avalon_linestoPoints <- st_join(points_cleaned_sf, lines_cleaned_sf, join = st_touches, left = TRUE)
```

##### Now let's create a plot and check how it worked

```r
ggplot() +
    geom_sf(data = lines_cleaned_sf, color = "blue", size = 1) +
    geom_sf(data = points_cleaned_sf, color = "red", size = 2) +
    labs(title = "Avalon PLOS",
         subtitle = "Map of available Pedestrian Level of Service features of Avalon",
         x = "Longitude", y = "Latitude") +
    theme_minimal()
```

![](Avalon_PLOS_files/figure-html/unnamed-chunk-4-1.png)<!-- -->
