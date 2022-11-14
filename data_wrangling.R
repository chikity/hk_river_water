# require(tidyverse)
# require(janitor)
# require(lubridate)
# require(plotly)
# library(hrbrthemes)

#automatic install of packages if they are not installed already
list.of.packages <- c(
  "janitor",
  "ggplot2",
  "tidyverse",
  "lubridate",
  "plotly",
  "hrbrthemes"
)

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages) > 0){
  install.packages(new.packages, dep=TRUE)
}

#loading packages
for(package.i in list.of.packages){
  suppressPackageStartupMessages(
    library(
      package.i,
      character.only = TRUE
    )
  )
}

# # Importing the data
# # First define the path where the data is stored
# path <- "./data/"
# filenames <- list.files(path = path)
# 
# ## Into a list
# all_df <- lapply(filenames, function(i) {
#   i <- paste(path,i,sep="")
#   read.csv(i, header=FALSE)
# })
# filenames <- gsub("-","_",filenames)
# names(all_df) <- gsub(".csv","",filenames)
# 
# ## Joining all the data frames
# joined_df <- all_df %>% 
#   reduce(full_join)
# 
# ## Reduce function above appends a new placeholder column name and pushes the actual name to first row
# names(joined_df) <- joined_df[1,]
# df <- joined_df %>% 
#   slice(-1)

df_raw <- read_csv('river-historical-1986_2020-en.csv')

# Basic cleaning
df <- df_raw %>%
  clean_names() %>% 
  filter(!is.na(river)) %>% 
  subset(select = c(water_control_zone, 
                    river, 
                    station, 
                    dates, 
                    sample_no,
                    turbidity_ntu,
                    suspended_solids_mg_l,
                    dissolved_oxygen_mg_l, 
                    x5_day_biochemical_oxygen_demand_mg_l, 
                    chemical_oxygen_demand_mg_l,
                    total_organic_carbon_mg_l,
                    total_phosphorus_mg_l,
                    total_kjeldahl_nitrogen_mg_l,
                    faecal_coliforms_counts_100m_l)
         ) %>% 
  rename(turbidity = turbidity_ntu,
          ss = suspended_solids_mg_l,
          dissolved_oxygen = dissolved_oxygen_mg_l,
          bod5 = x5_day_biochemical_oxygen_demand_mg_l, 
          cod = chemical_oxygen_demand_mg_l,
          t_carbon = total_organic_carbon_mg_l,
          t_phosphorus = total_phosphorus_mg_l,
          t_nitrogen = total_kjeldahl_nitrogen_mg_l,
          faecal_coliform = faecal_coliforms_counts_100m_l) %>% 
  mutate(ss = as.double(ss),
         bod5 = as.double(bod5),
         cod = as.double(cod),
         t_carbon = as.double(t_carbon),
         t_carbon = if_else(is.na(t_carbon), 0.9, t_carbon),
         t_phosphorus = as.double(t_phosphorus),
         t_phosphorus = if_else(is.na(t_phosphorus), 0.01, t_phosphorus),
         t_nitrogen = as.double(t_nitrogen),
         t_nitrogen = if_else(is.na(t_nitrogen), 0.04, t_nitrogen),
         faecal_coliform = if_else(faecal_coliform == '<1', '0.9', faecal_coliform),
         faecal_coliform = as.double(faecal_coliform))

# Calculate subindex (si)
index_df <- df %>% 
  mutate(turbidity_si = case_when(
    turbidity <= 1.5 ~ 10,
    turbidity > 1.5 & turbidity <= 3.0 ~ 20,
    turbidity > 3.0 & turbidity <= 4.0 ~ 30,
    turbidity > 4.0 & turbidity <= 4.5 ~ 40,
    turbidity > 4.5 & turbidity <= 5.2 ~ 50,
    turbidity > 5.2 & turbidity <= 8.8 ~ 60,
    turbidity > 8.8 & turbidity <= 12.2 ~ 70,
    turbidity > 12.2 & turbidity <= 16.5 ~ 80,
    turbidity > 16.5 & turbidity <= 21 ~ 90,
    turbidity > 21 ~ 100
  )) %>% 
  mutate(ss_si = case_when(
    ss <= 2 ~ 10,
    ss > 2 & ss <= 3 ~ 20,
    ss > 3 & ss <= 4 ~ 30,
    ss > 4 & ss <= 5.5 ~ 40,
    ss > 5.5 & ss <= 6.5 ~ 50,
    ss > 6.5 & ss <= 9.5 ~ 60,
    ss > 9.5 & ss <= 12.5 ~ 70,
    ss > 12.5 & ss <= 18 ~ 80,
    ss > 18 & ss <= 26.5 ~ 90,
    ss > 26.5 ~ 100
  )) %>% 
  mutate(dissolved_oxygen_si = case_when(
    dissolved_oxygen >= 8 ~ 10,
    dissolved_oxygen < 8 & dissolved_oxygen >= 7.3 ~ 20,
    dissolved_oxygen < 7.3 & dissolved_oxygen >= 6.7 ~ 30,
    dissolved_oxygen < 6.7 & dissolved_oxygen >= 6.3 ~ 40,
    dissolved_oxygen < 6.3 & dissolved_oxygen >= 5.8 ~ 50,
    dissolved_oxygen < 5.8 & dissolved_oxygen >= 5.3 ~ 60,
    dissolved_oxygen < 5.3 & dissolved_oxygen >= 4.8 ~ 70,
    dissolved_oxygen < 4.8 & dissolved_oxygen >= 4 ~ 80,
    dissolved_oxygen < 4 & dissolved_oxygen >= 3.1 ~ 90,
    dissolved_oxygen < 3.1 ~ 100
  )) %>% 
  mutate(bod5_si = case_when(
    bod5 <= 0.8 ~ 10,
    bod5 > 0.8 & bod5 <= 1 ~ 20,
    bod5 > 1 & bod5 <= 1.1 ~ 30,
    bod5 > 1.1 & bod5 <= 1.3 ~ 40,
    bod5 > 1.3 & bod5 <= 1.5 ~ 50,
    bod5 > 1.5 & bod5 <= 1.9 ~ 60,
    bod5 > 1.9 & bod5 <= 2.3 ~ 70,
    bod5 > 2.3 & bod5 <= 3.3 ~ 80,
    bod5 > 3.3 & bod5 <= 5.1 ~ 90,
    bod5 > 5.1 ~ 100
  )) %>% 
  mutate(cod_si = case_when(
    cod <= 16 ~ 10,
    cod > 16 & cod <= 24 ~ 20,
    cod > 24 & cod <= 32 ~ 30,
    cod > 32 & cod <= 38 ~ 40,
    cod > 38 & cod <= 46 ~ 50,
    cod > 46 & cod <= 58 ~ 60,
    cod > 58 & cod <= 72 ~ 70,
    cod > 72 & cod <= 102 ~ 80,
    cod > 102 & cod <= 146 ~ 90,
    cod > 146 ~ 100
  )) %>% 
  mutate(t_carbon_si = case_when(
    t_carbon <= 5 ~ 10,
    t_carbon > 5 & t_carbon <= 7 ~ 20,
    t_carbon > 7 & t_carbon <= 9.5 ~ 30,
    t_carbon > 9.5 & t_carbon <= 12 ~ 40,
    t_carbon > 12 & t_carbon <= 14 ~ 50,
    t_carbon > 14 & t_carbon <= 17.5 ~ 60,
    t_carbon > 17.5 & t_carbon <= 21 ~ 70,
    t_carbon > 21 & t_carbon <= 27.5 ~ 80,
    t_carbon > 27.5 & t_carbon <= 37 ~ 90,
    t_carbon > 37 ~ 100
  )) %>% 
  mutate(t_nitrogen_si = case_when(
    t_nitrogen <= 0.55 ~ 10,
    t_nitrogen > 0.55 & t_nitrogen <= 0.75 ~ 20,
    t_nitrogen > 0.75 & t_nitrogen <= 0.9 ~ 30,
    t_nitrogen > 0.9 & t_nitrogen <= 1 ~ 40,
    t_nitrogen > 1 & t_nitrogen <= 1.2 ~ 50,
    t_nitrogen > 1.2 & t_nitrogen <= 1.4 ~ 60,
    t_nitrogen > 1.4 & t_nitrogen <= 1.6 ~ 70,
    t_nitrogen > 1.6 & t_nitrogen <= 2 ~ 80,
    t_nitrogen > 2 & t_nitrogen <= 2.7 ~ 90,
    t_nitrogen > 2.7 ~ 100
  )) %>% 
  mutate(t_phosphorus_si = case_when(
    t_phosphorus <= 0.02 ~ 10,
    t_phosphorus > 0.02 & t_phosphorus <= 0.03 ~ 20,
    t_phosphorus > 0.03 & t_phosphorus <= 0.05 ~ 30,
    t_phosphorus > 0.05 & t_phosphorus <= 0.07 ~ 40,
    t_phosphorus > 0.07 & t_phosphorus <= 0.09 ~ 50,
    t_phosphorus > 0.09 & t_phosphorus <= 0.16 ~ 60,
    t_phosphorus > 0.16 & t_phosphorus <= 0.24 ~ 70,
    t_phosphorus > 0.24 & t_phosphorus <= 0.46 ~ 80,
    t_phosphorus > 0.46 & t_phosphorus <= 0.89 ~ 90,
    t_phosphorus > 0.89 ~ 100
  )) %>% 
  mutate(faecal_coliform_si = case_when(
    faecal_coliform <= 10 ~ 10,
    faecal_coliform > 10 & faecal_coliform <= 20 ~ 20,
    faecal_coliform > 20 & faecal_coliform <= 35 ~ 30,
    faecal_coliform > 35 & faecal_coliform <= 55 ~ 40,
    faecal_coliform > 55 & faecal_coliform <= 75 ~ 50,
    faecal_coliform > 75 & faecal_coliform <= 135 ~ 60,
    faecal_coliform > 135 & faecal_coliform <= 190 ~ 70,
    faecal_coliform > 190 & faecal_coliform <= 470 ~ 80,
    faecal_coliform > 470 & faecal_coliform <= 960 ~ 90,
    faecal_coliform > 960 ~ 100,
    is.na(faecal_coliform) ~ 50
  ))
  
index_df$wqi <- round(rowMeans(subset(index_df, select = c(turbidity_si, ss_si, dissolved_oxygen_si, bod5_si, cod_si, t_carbon_si, t_nitrogen_si, t_phosphorus_si, faecal_coliform_si)), na.rm = TRUE))

  
df2 <- index_df %>% 
  mutate(year = year(dates)) %>% 
  mutate(month = month(dates)) %>% 
  subset(select = c(water_control_zone, river, station, year, month, wqi)) %>% 
  mutate(quality = case_when(
    wqi >= 0 & wqi < 45 ~ 'good',
    wqi >= 45 & wqi < 60 ~ 'fair',
    wqi >= 60	~ 'poor'
  ))

river <- df2 %>% 
  group_by(water_control_zone, river, year) %>% 
  summarise(wqi = round(mean(wqi))) 
  # filter(year>= 2010)
         
p <- river %>% 
  # filter(water_control_zone == 'Deep Bay') %>% 
  ggplot(aes(x = year, y = wqi, color = river)) +
  geom_line() +
  theme_bw()
  # facet_wrap(vars(water_control_zone))

ggplotly(p)



# Heat Map

wide <- river %>% 
  spread(year, wqi)

wide$average <- round(rowMeans(subset(wide, select = -c(water_control_zone, river)), na.rm = TRUE))

wide <- wide %>% 
  # mutate(quality = case_when(
  #   average >= 0 & average < 45 ~ 'good',
  #   average >= 45 & average < 60 ~ 'fair',
  #   average >= 60	~ 'poor'
  # )) %>% 
  arrange(average)

long <- wide %>% 
  # Just a place holder to create gap in viz
  add_column('2021' = NA) %>% 
  pivot_longer(cols = !c(water_control_zone, river), names_to = 'year', values_to = 'wqi')

order <- c(rev(unique(long$river)))

x_label <- c()
for (i in 1990:2020) {
  if (i %% 5 == 0) {
    x_label <- append(x_label, i)
  } else {
    x_label <- append(x_label, "")
  }
}

h <- ggplot(mapping = aes(x = year, y = river)) +
  geom_tile(aes(fill = wqi), long) +
  geom_text(aes(label = wqi), subset(long, year == "average")) +
  scale_x_discrete(limits = c(1990:2021, "average"), labels = c(x_label, "", "average"), position = "top") +
  scale_y_discrete(limits = order) +
  theme_bw()

h + 
  scale_fill_gradient(low="green", high="red", na.value = NA) +
  # scale_fill_viridis_c(option = "magma", na.value = NA) +
  # scale_fill_manual(name = "wqi", values = c("green", "yellow", "red"), labels = c("0-45", "46-60", "60-100"), na.value = NA) +
  guides(colour = guide_colorbar(reverse = TRUE)) +
  theme(
  # legend.position="none"
  ) +
  labs(
    title = "Hong Kong River Water Quality Index Scores from 1986 - 2020",
    subtitle = "The lower the better",
    caption = "Data from Hong Kong Environment Protection Department | DATA.GOV.HK | Visualized by Chi Kit Yeung",
    x = NULL,
    y = "Rivers"
  )

ggplotly(h)



categorized <- wide %>%
  mutate(quality = case_when(
    average >= 0 & average < 45 ~ 'good',
    average >= 45 & average < 60 ~ 'fair',
    average >= 60	~ 'poor'
  ))

p <- categorized %>%
  group_by(quality) %>%
  tally() %>%
  ggplot(mapping = aes(x = reorder(quality, -n), y = n, fill = quality)) +
  scale_fill_manual(values = c("orange", "turquoise", "chocolate4")) +
  geom_bar(width = 1, stat = "identity") + 
  # coord_polar("y", start=0) +
  # xlim(c(2, 4)) +
  geom_text(aes(y = n-1, label = paste(round(n/sum(n)*100, 2),"%"), size=50)) +
  geom_text(aes(y = n+1, label = n, size=50)) +
  theme_bw()

p + 
  #   theme_bw() +
  theme(
    panel.grid = element_blank(),
    # title = element_text(size = 20, face = "bold"),
    # plot.subtitle = element_text(size = 15, face = "bold"),
    # plot.caption = element_text(size = 12),
    # axis.text = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    panel.border = element_blank(),
    legend.position = "none"
  ) +
  labs(
    title = "Overview of Hong Kong River's Quality",
    subtitle = "WQI scores averaged with data from 1986 to 2020",
    caption = "Data from Environment Protection Department - Hong Kong | DATA.GOV.HK | Visualized by Chi Kit Yeung",
    x = NULL,
    y = NULL
  )



b <- river %>% 
  filter(year == 2020) %>% 
  ggplot(mapping = aes(y = reorder(river, -wqi), x = wqi, fill = wqi)) +
  geom_col() +
  geom_text(aes(label = wqi, x = wqi+2))

b + 
  scale_fill_gradient(low="turquoise", high="brown", na.value = NA) +
  guides(colour = guide_colorbar(reverse = TRUE)) +
  theme_bw() +
  theme(
    # title = element_text(size = 20, face = "bold"),
    # plot.subtitle = element_text(size = 15, face = "bold"),
    # plot.caption = element_text(size = 12),
    # axis.text.y = element_text(size = 14),
    # axis.text.x = element_text(size = 12, face = "bold"),
    panel.grid.major.y = element_blank(),
    legend.position = "none"
  ) +
  labs(
    title = "Water Quality Index Scores of Hong Kong's Rivers for 2020",
    subtitle = "Sorted by average WQI scores.  The lower the better.",
    caption = "Data from Hong Kong Environment Protection Department | DATA.GOV.HK | Visualized by Chi Kit Yeung",
    x = NULL,
    y = "Rivers"
  )

