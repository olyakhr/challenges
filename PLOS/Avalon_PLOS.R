install.packages("tidyverse")
install.packages("sf")
library(tidyverse)
library(sf)

sidewalks <- read.csv("/Users/olechka/Documents/R/PLOS_AVALON/sidewalks.csv")
highways <- read_csv("/Users/olechka/Documents/R/PLOS_AVALON/highway.csv")

line_data <- merge(sidewalks, highways, by = c("wkt_geom", "fid", "full_id", "osm_id", "osm_type", "highway", "motor_vehicle", 
                                               "access", "horse", "foot", "lit", "oneway", "surface", "bicycle", "name"), all = TRUE)
str(line_data)


trees <- read.csv("/Users/olechka/Documents/R/PLOS_AVALON/trees.csv")
str(trees)
lights <- read.csv("/Users/olechka/Documents/R/PLOS_AVALON/street_lamp.csv")
str(lights)
parking <- read.csv("/Users/olechka/Documents/R/PLOS_AVALON/parking_aisle.csv")
str(parking)
point_data <- merge( trees, lights, by = c("wkt_geom", "fid", "full_id", "osm_id", "osm_type", "lit"), all = TRUE)
head(point_data)
str(point_data)

point_data_full <- merge( point_data, parking, by = c("wkt_geom", "fid", "full_id", "osm_id", "osm_type"), all = TRUE)
head(point_data_full)
str(point_data_full)

Avalon_PLOS_df <- full_join(point_data_full, line_data)
head(Avalon_PLOS)  


Avalon_PLOS_sf <- st_as_sf(Avalon_PLOS_df, wkt = "wkt_geom", crs = 4326)
point_data_sf <- st_as_sf(point_data_full, wkt = "wkt_geom", crs = 4326)
line_data_sf <- st_as_sf(line_data, wkt = "wkt_geom", crs = 4326)

plot(st_geometry(point_data_sf), col = 'blue')
plot(st_geometry(line_data_sf), col = 'red', add = TRUE)   
plot(st_geometry(Avalon_PLOS_sf), col = "green")



st_write(Avalon_PLOS_sf, "Avalon_PLOS.shp")
colnames(Avalon_PLOS_sf) <- gsub("\\.", "_", colnames(Avalon_PLOS_sf))
print(colnames(Avalon_PLOS_sf))
colnames(Avalon_PLOS_sf) <- c(
  "fid", "full_id", "osm_id", "osm_type", "lit", 
  "natural", "circumf", "species", "height", "leaf_cyc", 
  "leaf_typ", "denot", "hwy_x", "lamp_mnt", "mat_x", 
  "power", "lamp_typ", "hwy_y", "stop", "direct", 
  "mat_y", "trfc_clm", "trfc_sig_dir", "noexit", "crs_mrk", 
  "gate_typ", "name_en", "addr_strt", "addr_pstc", "addr_hsnm", 
  "slpd_curb", "kerb", "lift_gt_typ", "crssng", "btn_oprtd", 
  "amenity", "entrance", "bus", "pub_trns", "name", 
  "rlwy", "acc", "barrier", "trfc_sig", "hwy", 
  "mot_veh", "horse", "foot", "oneway", "surface", 
  "bike", "covered", "embnkmt", "brdg_nam", "trl_vis", 
  "mtb_uphl", "mtb_scl", "incline", "golf", "width", 
  "segrgtd", "footway", "tunnel", "layer", "bridge", 
  "service", "cnstrct", "lns_fwd", "lns_bkwd", "hgv", 
  "junction", "alt_nam", "ln_mrk", "veh", "sdwlk", 
  "psv", "lanes", "maxspd", "loc_nam", "wkt_geom"
)
st_write(Avalon_PLOS_sf, "Avalon_PLOS.shp")


Avalon_PLOS_sf_csv <- as.data.frame(Avalon_PLOS_sf)
write.csv(Avalon_PLOS_sf_csv, "Avalon_PLOS_sf.csv")


