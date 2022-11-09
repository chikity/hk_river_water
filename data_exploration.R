require(tidyverse)
require(janitor)

# Importing the data
# First define the path where the data is stored
path <- "./data/"
filenames <- list.files(path = path)

## Into a list
all_df <- lapply(filenames, function(i) {
  i <- paste(path,i,sep="")
  read.csv(i, header=FALSE)
})
filenames <- gsub("-","_",filenames)
names(all_df) <- gsub(".csv","",filenames)

## Joining all the data frames
joined_df <- all_df %>% 
  reduce(full_join)

## Reduce function above appends a new placeholder column name and pushes the actual name to first row
names(joined_df) <- joined_df[1,]
df <- joined_df %>% 
  slice(-1)

# Basic cleaning
clean_df <- df %>% 
  clean_names() %>% 
  subset(select = c(water_control_zone, 
                    river, 
                    station, 
                    dates, 
                    sample_no, 
                    x5_day_biochemical_oxygen_demand_mg_l, 
                    chemical_oxygen_demand_mg_l, 
                    conductivity_m_s_cm, 
                    dissolved_oxygen_mg_l, 
                    e_coli_counts_100m_l, 
                    faecal_coliforms_counts_100m_l, 
                    # flow_m3_s, 
                    oil_and_grease_mg_l, 
                    suspended_solids_mg_l, 
                    total_solids_mg_l, 
                    turbidity_ntu)
         ) %>% 
  rename(bod5 = x5_day_biochemical_oxygen_demand_mg_l, 
         cod = chemical_oxygen_demand_mg_l,
         conductivity = conductivity_m_s_cm,
         dissolved_oxygen = dissolved_oxygen_mg_l,
         e_coli = e_coli_counts_100m_l,
         faecal_coliform = faecal_coliforms_counts_100m_l,
         fog = oil_and_grease_mg_l,
         ss = suspended_solids_mg_l,
         ts = total_solids_mg_l,
         turbidity = turbidity_ntu
         )
