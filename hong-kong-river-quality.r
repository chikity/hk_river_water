{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "8f0d220f",
   "metadata": {
    "papermill": {
     "duration": 0.004162,
     "end_time": "2022-11-10T15:42:38.772754",
     "exception": false,
     "start_time": "2022-11-10T15:42:38.768592",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Introduction\n",
    "\n",
    "Hong Kong prides itself in it's ability to provide potable water directly to people's homes straight out of the tap.  But how is it down the line?  In this project I want dive into the water parameter data collected from the territory's major rivers to find out it's current state and to learn which river is the cleanest.\n",
    "\n",
    "## Methodology\n",
    "\n",
    "Hong Kong's Environment Protection Department (EPD) collects 48 different physiochemical water parameters.  To effectively compare each river, the use of indexes will be used.\n",
    "\n",
    "### Water Quality Index (WQI)\n",
    "Most people are familiar with AQI (air quality index) but there's also one for water.  The EPD defines it's own WQI calculation based on three parameters out of the 48: Dissolved Oxygen, Biological Oxygen Demand, and Ammonia-Nitrogen.  International calculations of WQI typically uses 5-6 different parameters.  Since EPD already collects such a comprehensive range of water parameters, I decided to use the international calculation\n",
    "\n",
    "http://www.sarasota.wateratlas.usf.edu/library/learn-more/learnmore.aspx?toolsection=lm_wqi#calculations\n",
    "\n",
    "1. Water clarity: turbidity (NTU*) and total suspended solids\n",
    "2. Dissolved oxygen: Dissolved oxygen concentration (mg/l);\n",
    "3. Oxygen demand: biochemical oxygen demand (mg/l), chemical oxygen demand (mg/l) and/or total organic carbon (mg/l);\n",
    "4. Nutrients: total nitrogen (mg/l), and/or total phosphorus (mg/l);\n",
    "5. Bacteria: total coliform (# per mg/l) and/or fecal coliform (# per mg/l).\n",
    "\n",
    "### Trophic State Index (TSI)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "417ee0a2",
   "metadata": {
    "papermill": {
     "duration": 0.003074,
     "end_time": "2022-11-10T15:42:38.779039",
     "exception": false,
     "start_time": "2022-11-10T15:42:38.775965",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## Feature Description\n",
    "\n",
    "1. __5-Day Biochemical Oxygen Demand (mg/L)__, or BOD5 in short, measures the amount of oxygen used after a 5-day incubation period.  What this represents is the amount of organic matter in the water.  The lower the better.\n",
    "\n",
    "2. __Chemical Oxygen Demand (mg/L)__, or COD, is very similar to BOD5 but the incubation process is sped up using some chemical processes.  This broadly represents the amount of foreign chemical substance in water.\n",
    "\n",
    "3. __Conductivity (μS/cm)__ -\n",
    "\n",
    "4. __Dissolved Oxygen (mg/L)__ - DO doesn't really represent how clean water is but the higher the DO, the better the water's ability to purify itself by sustaining good biodiversity.\n",
    "\n",
    "5. __E. coli (counts/100mL)__ - This and Faecal Coliforms basically indicates if the water has poop 💩 in it.  E. coli is one of the various coliforms present in faeces.\n",
    "\n",
    "6. __Faecal Coliforms (counts/100mL)__ - This measure the concentration of 💩 bacteria in the water.  A high level indicates that untreated sewage/adventurous outdoor toilet goer may be leeching into the river at some point.\n",
    "\n",
    "7. __Oil and Grease (mg/L)__ - Also known as FGO (fats, oils, grease).  This is one of the main indicators in waste water treatment that helps quantify whether anthropogenic water is treated properly.  Waste water from kitchens (and people in general) are high in FGOs.\n",
    "\n",
    "8. __Total Solids (mg/L)__ - This measures the amount of solid particles in the water\n",
    "\n",
    "9. __Suspended Solids (mg/L)__ - This measures the amount of tiny particles that are too small to sink in the water column.\n",
    "\n",
    "10. __Turbidity (NTU)__ - Turbidity is a fancy way of saying clarity.  The cloudier the water, the more turbid it is."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "82b4d632",
   "metadata": {
    "papermill": {
     "duration": 0.003244,
     "end_time": "2022-11-10T15:42:38.785331",
     "exception": false,
     "start_time": "2022-11-10T15:42:38.782087",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Analysis\n",
    "\n",
    "## Libraries"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "4f81d09d",
   "metadata": {
    "_execution_state": "idle",
    "_uuid": "051d70d956493feee0c6d64651c6a088724dca2a",
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:38.795200Z",
     "iopub.status.busy": "2022-11-10T15:42:38.793466Z",
     "iopub.status.idle": "2022-11-10T15:42:39.984406Z",
     "shell.execute_reply": "2022-11-10T15:42:39.983153Z"
    },
    "papermill": {
     "duration": 1.198171,
     "end_time": "2022-11-10T15:42:39.986511",
     "exception": false,
     "start_time": "2022-11-10T15:42:38.788340",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "── \u001b[1mAttaching packages\u001b[22m ─────────────────────────────────────── tidyverse 1.3.2 ──\n",
      "\u001b[32m✔\u001b[39m \u001b[34mggplot2\u001b[39m 3.3.6      \u001b[32m✔\u001b[39m \u001b[34mpurrr  \u001b[39m 0.3.5 \n",
      "\u001b[32m✔\u001b[39m \u001b[34mtibble \u001b[39m 3.1.8      \u001b[32m✔\u001b[39m \u001b[34mdplyr  \u001b[39m 1.0.10\n",
      "\u001b[32m✔\u001b[39m \u001b[34mtidyr  \u001b[39m 1.2.1      \u001b[32m✔\u001b[39m \u001b[34mstringr\u001b[39m 1.4.1 \n",
      "\u001b[32m✔\u001b[39m \u001b[34mreadr  \u001b[39m 2.1.3      \u001b[32m✔\u001b[39m \u001b[34mforcats\u001b[39m 0.5.2 \n",
      "── \u001b[1mConflicts\u001b[22m ────────────────────────────────────────── tidyverse_conflicts() ──\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mfilter()\u001b[39m masks \u001b[34mstats\u001b[39m::filter()\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mlag()\u001b[39m    masks \u001b[34mstats\u001b[39m::lag()\n",
      "\n",
      "Attaching package: ‘janitor’\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:stats’:\n",
      "\n",
      "    chisq.test, fisher.test\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse) # metapackage of all tidyverse packages\n",
    "library(janitor) # Useful cleaning functions\n",
    "library(ggplot2) # Data visualization package"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7a8f3aba",
   "metadata": {
    "papermill": {
     "duration": 0.003494,
     "end_time": "2022-11-10T15:42:39.993881",
     "exception": false,
     "start_time": "2022-11-10T15:42:39.990387",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "### Importing the Dataset"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "9e7d902c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:40.026774Z",
     "iopub.status.busy": "2022-11-10T15:42:40.002646Z",
     "iopub.status.idle": "2022-11-10T15:42:40.523685Z",
     "shell.execute_reply": "2022-11-10T15:42:40.522409Z"
    },
    "papermill": {
     "duration": 0.527635,
     "end_time": "2022-11-10T15:42:40.525389",
     "exception": false,
     "start_time": "2022-11-10T15:42:39.997754",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“\u001b[1m\u001b[22mOne or more parsing issues, call `problems()` on your data frame for details,\n",
      "e.g.:\n",
      "  dat <- vroom(...)\n",
      "  problems(dat)”\n",
      "\u001b[1mRows: \u001b[22m\u001b[34m31865\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m56\u001b[39m\n",
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m  (44): Water Control Zone, River, Station, 5-Day Biochemical Oxygen Dema...\n",
      "\u001b[32mdbl\u001b[39m  (11): Sample No, Conductivity (μS/cm), Dissolved Oxygen (%saturation), ...\n",
      "\u001b[34mdate\u001b[39m  (1): Dates\n",
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n"
     ]
    }
   ],
   "source": [
    "df_raw <- read_csv('../input/hkriverhistorical1986-2020/river-historical-1986_2020-en.csv')"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a53a313e",
   "metadata": {
    "papermill": {
     "duration": 0.003541,
     "end_time": "2022-11-10T15:42:40.532924",
     "exception": false,
     "start_time": "2022-11-10T15:42:40.529383",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "### Wrangling"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "f0c977e4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:40.542351Z",
     "iopub.status.busy": "2022-11-10T15:42:40.541191Z",
     "iopub.status.idle": "2022-11-10T15:42:40.757260Z",
     "shell.execute_reply": "2022-11-10T15:42:40.756026Z"
    },
    "papermill": {
     "duration": 0.222512,
     "end_time": "2022-11-10T15:42:40.758916",
     "exception": false,
     "start_time": "2022-11-10T15:42:40.536404",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in mask$eval_all_mutate(quo):\n",
      "“NAs introduced by coercion”\n",
      "Warning message in mask$eval_all_mutate(quo):\n",
      "“NAs introduced by coercion”\n",
      "Warning message in mask$eval_all_mutate(quo):\n",
      "“NAs introduced by coercion”\n",
      "Warning message in mask$eval_all_mutate(quo):\n",
      "“NAs introduced by coercion”\n",
      "Warning message in mask$eval_all_mutate(quo):\n",
      "“NAs introduced by coercion”\n",
      "Warning message in mask$eval_all_mutate(quo):\n",
      "“NAs introduced by coercion”\n",
      "Warning message in mask$eval_all_mutate(quo):\n",
      "“NAs introduced by coercion”\n"
     ]
    }
   ],
   "source": [
    "# Filtering the desired features and simplifying the names\n",
    "\n",
    "df <- df_raw %>% \n",
    "  clean_names() %>% \n",
    "  subset(select = c(water_control_zone, \n",
    "                    river, \n",
    "                    station, \n",
    "                    dates, \n",
    "                    sample_no, \n",
    "#                     conductivity_m_s_cm, \n",
    "#                     e_coli_counts_100m_l, \n",
    "#                     # flow_m3_s, \n",
    "#                     oil_and_grease_mg_l, \n",
    "#                     total_solids_mg_l, \n",
    "                    turbidity_ntu,\n",
    "                    suspended_solids_mg_l,\n",
    "                    dissolved_oxygen_mg_l, \n",
    "                    x5_day_biochemical_oxygen_demand_mg_l, \n",
    "                    chemical_oxygen_demand_mg_l,\n",
    "                    total_organic_carbon_mg_l,\n",
    "                    total_phosphorus_mg_l,\n",
    "                    total_kjeldahl_nitrogen_mg_l,\n",
    "                    faecal_coliforms_counts_100m_l\n",
    "         )) %>% \n",
    "rename(turbidity = turbidity_ntu,\n",
    "        ss = suspended_solids_mg_l,\n",
    "        dissolved_oxygen = dissolved_oxygen_mg_l,\n",
    "        bod5 = x5_day_biochemical_oxygen_demand_mg_l, \n",
    "        cod = chemical_oxygen_demand_mg_l,\n",
    "        t_carbon = total_organic_carbon_mg_l,\n",
    "        t_phosphorus = total_phosphorus_mg_l,\n",
    "        t_nitrogen = total_kjeldahl_nitrogen_mg_l,\n",
    "        faecal_coliform = faecal_coliforms_counts_100m_l\n",
    "        ) %>%\n",
    "mutate(ss = as.double(ss),\n",
    "         bod5 = as.double(bod5),\n",
    "         cod = as.double(cod),\n",
    "         t_carbon = as.double(t_carbon),\n",
    "         t_carbon = if_else(is.na(t_carbon), 0.9, t_carbon),\n",
    "         t_phosphorus = as.double(t_phosphorus),\n",
    "         t_phosphorus = if_else(is.na(t_phosphorus), 0.01, t_phosphorus),\n",
    "         t_nitrogen = as.double(t_nitrogen),\n",
    "         t_nitrogen = if_else(is.na(t_nitrogen), 0.04, t_nitrogen),\n",
    "         faecal_coliform = if_else(faecal_coliform == '<1', '0.9', faecal_coliform),\n",
    "         faecal_coliform = as.double(faecal_coliform))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "49d25569",
   "metadata": {
    "papermill": {
     "duration": 0.003923,
     "end_time": "2022-11-10T15:42:40.767252",
     "exception": false,
     "start_time": "2022-11-10T15:42:40.763329",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Analysis\n",
    "\n",
    "## Getting to Know the Dataset"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "b7335e06",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:40.777658Z",
     "iopub.status.busy": "2022-11-10T15:42:40.776429Z",
     "iopub.status.idle": "2022-11-10T15:42:40.800757Z",
     "shell.execute_reply": "2022-11-10T15:42:40.799270Z"
    },
    "papermill": {
     "duration": 0.032664,
     "end_time": "2022-11-10T15:42:40.803762",
     "exception": false,
     "start_time": "2022-11-10T15:42:40.771098",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Rows: 31,865\n",
      "Columns: 14\n",
      "$ water_control_zone \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Junk Bay\", \"Junk Bay\", \"Junk Bay\", \"Junk Bay\", \"Ju…\n",
      "$ river              \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Tseng Lan Shue Stream\", \"Tseng Lan Shue Stream\", \"…\n",
      "$ station            \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"JR…\n",
      "$ dates              \u001b[3m\u001b[90m<date>\u001b[39m\u001b[23m 1986-04-29, 1986-05-19, 1986-06-18, 1986-07-24, 19…\n",
      "$ sample_no          \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …\n",
      "$ turbidity          \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 4.1, 4.2, 5.5, 6.5, 6.7, 3.2, 2.0, 2.3, 5.0, 24.0, …\n",
      "$ ss                 \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 6.5, 6.5, 8.5, 6.0, 7.0, 5.0, 3.5, 7.0, 10.0, 31.0,…\n",
      "$ dissolved_oxygen   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 6.0, 5.3, 6.2, 5.2, 5.1, 5.6, 6.9, 6.7, 7.7, 0.8, 3…\n",
      "$ bod5               \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 9.7, 5.6, 9.0, 12.2, 8.8, 2.1, 5.9, 8.0, 9.0, 113.3…\n",
      "$ cod                \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 13, 21, 19, 17, 5, 5, 29, 160, 46, 66, 83, 45, 12, …\n",
      "$ t_carbon           \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 0.9, 5.0, 1.0, 0.9, 5.0, 4.0, 0.9, 0.9, 7.0, 10.0, …\n",
      "$ t_phosphorus       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 2.50, 2.00, 1.90, 2.10, 4.50, 1.20, 3.80, 6.80, 5.7…\n",
      "$ t_nitrogen         \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 4.1, 5.1, 3.1, 5.5, 5.3, 1.1, 2.7, 12.0, 20.0, 18.0…\n",
      "$ faecal_coliform    \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…\n"
     ]
    }
   ],
   "source": [
    "glimpse(df)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "bc162503",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:40.815281Z",
     "iopub.status.busy": "2022-11-10T15:42:40.814178Z",
     "iopub.status.idle": "2022-11-10T15:42:40.831352Z",
     "shell.execute_reply": "2022-11-10T15:42:40.829577Z"
    },
    "papermill": {
     "duration": 0.024901,
     "end_time": "2022-11-10T15:42:40.833636",
     "exception": false,
     "start_time": "2022-11-10T15:42:40.808735",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>'Fairview Park Nullah'</li><li>'Ha Pak Nai Stream'</li><li>'Ho Chung River'</li><li>'Kai Tak River'</li><li>'Kam Tin River'</li><li>'Kau Wa Keng Stream'</li><li>'Kwun Yam Shan Stream'</li><li>'Lam Tsuen River'</li><li>'Mui Wo River'</li><li>'Ngau Hom Sha Stream'</li><li>'Pai Min Kok Stream'</li><li>'Pak Nai Stream'</li><li>'River Beas'</li><li>'River Ganges'</li><li>'River Indus'</li><li>'Sam Dip Tam Stream'</li><li>'Sha Kok Mei Stream'</li><li>'Shan Liu Stream'</li><li>'Sheung Pak Nai Stream'</li><li>'Shing Mun River'</li><li>'Siu Lek Yuen Nullah'</li><li>'Tai Chung Hau Stream'</li><li>'Tai Po Kau Stream'</li><li>'Tai Po River'</li><li>'Tai Shui Hang Stream'</li><li>'Tai Wai Nullah'</li><li>'Tin Shui Wai Nullah'</li><li>'Tin Sum Nullah'</li><li>'Tsang Kok Stream'</li><li>'Tseng Lan Shue Stream'</li><li>'Tuen Mun River'</li><li>'Tung Chung River'</li><li>'Tung Tze Stream'</li><li>'Yuen Long Creek'</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 'Fairview Park Nullah'\n",
       "\\item 'Ha Pak Nai Stream'\n",
       "\\item 'Ho Chung River'\n",
       "\\item 'Kai Tak River'\n",
       "\\item 'Kam Tin River'\n",
       "\\item 'Kau Wa Keng Stream'\n",
       "\\item 'Kwun Yam Shan Stream'\n",
       "\\item 'Lam Tsuen River'\n",
       "\\item 'Mui Wo River'\n",
       "\\item 'Ngau Hom Sha Stream'\n",
       "\\item 'Pai Min Kok Stream'\n",
       "\\item 'Pak Nai Stream'\n",
       "\\item 'River Beas'\n",
       "\\item 'River Ganges'\n",
       "\\item 'River Indus'\n",
       "\\item 'Sam Dip Tam Stream'\n",
       "\\item 'Sha Kok Mei Stream'\n",
       "\\item 'Shan Liu Stream'\n",
       "\\item 'Sheung Pak Nai Stream'\n",
       "\\item 'Shing Mun River'\n",
       "\\item 'Siu Lek Yuen Nullah'\n",
       "\\item 'Tai Chung Hau Stream'\n",
       "\\item 'Tai Po Kau Stream'\n",
       "\\item 'Tai Po River'\n",
       "\\item 'Tai Shui Hang Stream'\n",
       "\\item 'Tai Wai Nullah'\n",
       "\\item 'Tin Shui Wai Nullah'\n",
       "\\item 'Tin Sum Nullah'\n",
       "\\item 'Tsang Kok Stream'\n",
       "\\item 'Tseng Lan Shue Stream'\n",
       "\\item 'Tuen Mun River'\n",
       "\\item 'Tung Chung River'\n",
       "\\item 'Tung Tze Stream'\n",
       "\\item 'Yuen Long Creek'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 'Fairview Park Nullah'\n",
       "2. 'Ha Pak Nai Stream'\n",
       "3. 'Ho Chung River'\n",
       "4. 'Kai Tak River'\n",
       "5. 'Kam Tin River'\n",
       "6. 'Kau Wa Keng Stream'\n",
       "7. 'Kwun Yam Shan Stream'\n",
       "8. 'Lam Tsuen River'\n",
       "9. 'Mui Wo River'\n",
       "10. 'Ngau Hom Sha Stream'\n",
       "11. 'Pai Min Kok Stream'\n",
       "12. 'Pak Nai Stream'\n",
       "13. 'River Beas'\n",
       "14. 'River Ganges'\n",
       "15. 'River Indus'\n",
       "16. 'Sam Dip Tam Stream'\n",
       "17. 'Sha Kok Mei Stream'\n",
       "18. 'Shan Liu Stream'\n",
       "19. 'Sheung Pak Nai Stream'\n",
       "20. 'Shing Mun River'\n",
       "21. 'Siu Lek Yuen Nullah'\n",
       "22. 'Tai Chung Hau Stream'\n",
       "23. 'Tai Po Kau Stream'\n",
       "24. 'Tai Po River'\n",
       "25. 'Tai Shui Hang Stream'\n",
       "26. 'Tai Wai Nullah'\n",
       "27. 'Tin Shui Wai Nullah'\n",
       "28. 'Tin Sum Nullah'\n",
       "29. 'Tsang Kok Stream'\n",
       "30. 'Tseng Lan Shue Stream'\n",
       "31. 'Tuen Mun River'\n",
       "32. 'Tung Chung River'\n",
       "33. 'Tung Tze Stream'\n",
       "34. 'Yuen Long Creek'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       " [1] \"Fairview Park Nullah\"  \"Ha Pak Nai Stream\"     \"Ho Chung River\"       \n",
       " [4] \"Kai Tak River\"         \"Kam Tin River\"         \"Kau Wa Keng Stream\"   \n",
       " [7] \"Kwun Yam Shan Stream\"  \"Lam Tsuen River\"       \"Mui Wo River\"         \n",
       "[10] \"Ngau Hom Sha Stream\"   \"Pai Min Kok Stream\"    \"Pak Nai Stream\"       \n",
       "[13] \"River Beas\"            \"River Ganges\"          \"River Indus\"          \n",
       "[16] \"Sam Dip Tam Stream\"    \"Sha Kok Mei Stream\"    \"Shan Liu Stream\"      \n",
       "[19] \"Sheung Pak Nai Stream\" \"Shing Mun River\"       \"Siu Lek Yuen Nullah\"  \n",
       "[22] \"Tai Chung Hau Stream\"  \"Tai Po Kau Stream\"     \"Tai Po River\"         \n",
       "[25] \"Tai Shui Hang Stream\"  \"Tai Wai Nullah\"        \"Tin Shui Wai Nullah\"  \n",
       "[28] \"Tin Sum Nullah\"        \"Tsang Kok Stream\"      \"Tseng Lan Shue Stream\"\n",
       "[31] \"Tuen Mun River\"        \"Tung Chung River\"      \"Tung Tze Stream\"      \n",
       "[34] \"Yuen Long Creek\"      "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# List of Rivers in the Dataset\n",
    "sort(unique(df$river))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "c4c14841",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:40.845113Z",
     "iopub.status.busy": "2022-11-10T15:42:40.843924Z",
     "iopub.status.idle": "2022-11-10T15:42:40.858898Z",
     "shell.execute_reply": "2022-11-10T15:42:40.857287Z"
    },
    "papermill": {
     "duration": 0.023058,
     "end_time": "2022-11-10T15:42:40.861087",
     "exception": false,
     "start_time": "2022-11-10T15:42:40.838029",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "35"
      ],
      "text/latex": [
       "35"
      ],
      "text/markdown": [
       "35"
      ],
      "text/plain": [
       "[1] 35"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Number of Rivers in Dataset\n",
    "length(unique(df$river))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "683b7112",
   "metadata": {
    "papermill": {
     "duration": 0.004418,
     "end_time": "2022-11-10T15:42:40.870245",
     "exception": false,
     "start_time": "2022-11-10T15:42:40.865827",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "### Calculate WQI Subindexes"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "804fd947",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:40.881578Z",
     "iopub.status.busy": "2022-11-10T15:42:40.880242Z",
     "iopub.status.idle": "2022-11-10T15:42:41.149332Z",
     "shell.execute_reply": "2022-11-10T15:42:41.148028Z"
    },
    "papermill": {
     "duration": 0.277055,
     "end_time": "2022-11-10T15:42:41.151606",
     "exception": false,
     "start_time": "2022-11-10T15:42:40.874551",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Calculate subindex (si)\n",
    "index_df <- df %>% \n",
    "  mutate(turbidity_si = case_when(\n",
    "    turbidity <= 1.5 ~ 10,\n",
    "    turbidity > 1.5 & turbidity <= 3.0 ~ 20,\n",
    "    turbidity > 3.0 & turbidity <= 4.0 ~ 30,\n",
    "    turbidity > 4.0 & turbidity <= 4.5 ~ 40,\n",
    "    turbidity > 4.5 & turbidity <= 5.2 ~ 50,\n",
    "    turbidity > 5.2 & turbidity <= 8.8 ~ 60,\n",
    "    turbidity > 8.8 & turbidity <= 12.2 ~ 70,\n",
    "    turbidity > 12.2 & turbidity <= 16.5 ~ 80,\n",
    "    turbidity > 16.5 & turbidity <= 21 ~ 90,\n",
    "    turbidity > 21 ~ 100\n",
    "  )) %>% \n",
    "  mutate(ss_si = case_when(\n",
    "    ss <= 2 ~ 10,\n",
    "    ss > 2 & ss <= 3 ~ 20,\n",
    "    ss > 3 & ss <= 4 ~ 30,\n",
    "    ss > 4 & ss <= 5.5 ~ 40,\n",
    "    ss > 5.5 & ss <= 6.5 ~ 50,\n",
    "    ss > 6.5 & ss <= 9.5 ~ 60,\n",
    "    ss > 9.5 & ss <= 12.5 ~ 70,\n",
    "    ss > 12.5 & ss <= 18 ~ 80,\n",
    "    ss > 18 & ss <= 26.5 ~ 90,\n",
    "    ss > 26.5 ~ 100\n",
    "  )) %>% \n",
    "  mutate(dissolved_oxygen_si = case_when(\n",
    "    dissolved_oxygen >= 8 ~ 10,\n",
    "    dissolved_oxygen < 8 & dissolved_oxygen >= 7.3 ~ 20,\n",
    "    dissolved_oxygen < 7.3 & dissolved_oxygen >= 6.7 ~ 30,\n",
    "    dissolved_oxygen < 6.7 & dissolved_oxygen >= 6.3 ~ 40,\n",
    "    dissolved_oxygen < 6.3 & dissolved_oxygen >= 5.8 ~ 50,\n",
    "    dissolved_oxygen < 5.8 & dissolved_oxygen >= 5.3 ~ 60,\n",
    "    dissolved_oxygen < 5.3 & dissolved_oxygen >= 4.8 ~ 70,\n",
    "    dissolved_oxygen < 4.8 & dissolved_oxygen >= 4 ~ 80,\n",
    "    dissolved_oxygen < 4 & dissolved_oxygen >= 3.1 ~ 90,\n",
    "    dissolved_oxygen < 3.1 ~ 100\n",
    "  )) %>% \n",
    "  mutate(bod5_si = case_when(\n",
    "    bod5 <= 0.8 ~ 10,\n",
    "    bod5 > 0.8 & bod5 <= 1 ~ 20,\n",
    "    bod5 > 1 & bod5 <= 1.1 ~ 30,\n",
    "    bod5 > 1.1 & bod5 <= 1.3 ~ 40,\n",
    "    bod5 > 1.3 & bod5 <= 1.5 ~ 50,\n",
    "    bod5 > 1.5 & bod5 <= 1.9 ~ 60,\n",
    "    bod5 > 1.9 & bod5 <= 2.3 ~ 70,\n",
    "    bod5 > 2.3 & bod5 <= 3.3 ~ 80,\n",
    "    bod5 > 3.3 & bod5 <= 5.1 ~ 90,\n",
    "    bod5 > 5.1 ~ 100\n",
    "  )) %>% \n",
    "  mutate(cod_si = case_when(\n",
    "    cod <= 16 ~ 10,\n",
    "    cod > 16 & cod <= 24 ~ 20,\n",
    "    cod > 24 & cod <= 32 ~ 30,\n",
    "    cod > 32 & cod <= 38 ~ 40,\n",
    "    cod > 38 & cod <= 46 ~ 50,\n",
    "    cod > 46 & cod <= 58 ~ 60,\n",
    "    cod > 58 & cod <= 72 ~ 70,\n",
    "    cod > 72 & cod <= 102 ~ 80,\n",
    "    cod > 102 & cod <= 146 ~ 90,\n",
    "    cod > 146 ~ 100\n",
    "  )) %>% \n",
    "  mutate(t_carbon_si = case_when(\n",
    "    t_carbon <= 5 ~ 10,\n",
    "    t_carbon > 5 & t_carbon <= 7 ~ 20,\n",
    "    t_carbon > 7 & t_carbon <= 9.5 ~ 30,\n",
    "    t_carbon > 9.5 & t_carbon <= 12 ~ 40,\n",
    "    t_carbon > 12 & t_carbon <= 14 ~ 50,\n",
    "    t_carbon > 14 & t_carbon <= 17.5 ~ 60,\n",
    "    t_carbon > 17.5 & t_carbon <= 21 ~ 70,\n",
    "    t_carbon > 21 & t_carbon <= 27.5 ~ 80,\n",
    "    t_carbon > 27.5 & t_carbon <= 37 ~ 90,\n",
    "    t_carbon > 37 ~ 100\n",
    "  )) %>% \n",
    "  mutate(t_nitrogen_si = case_when(\n",
    "    t_nitrogen <= 0.55 ~ 10,\n",
    "    t_nitrogen > 0.55 & t_nitrogen <= 0.75 ~ 20,\n",
    "    t_nitrogen > 0.75 & t_nitrogen <= 0.9 ~ 30,\n",
    "    t_nitrogen > 0.9 & t_nitrogen <= 1 ~ 40,\n",
    "    t_nitrogen > 1 & t_nitrogen <= 1.2 ~ 50,\n",
    "    t_nitrogen > 1.2 & t_nitrogen <= 1.4 ~ 60,\n",
    "    t_nitrogen > 1.4 & t_nitrogen <= 1.6 ~ 70,\n",
    "    t_nitrogen > 1.6 & t_nitrogen <= 2 ~ 80,\n",
    "    t_nitrogen > 2 & t_nitrogen <= 2.7 ~ 90,\n",
    "    t_nitrogen > 2.7 ~ 100\n",
    "  )) %>% \n",
    "  mutate(t_phosphorus_si = case_when(\n",
    "    t_phosphorus <= 0.02 ~ 10,\n",
    "    t_phosphorus > 0.02 & t_phosphorus <= 0.03 ~ 20,\n",
    "    t_phosphorus > 0.03 & t_phosphorus <= 0.05 ~ 30,\n",
    "    t_phosphorus > 0.05 & t_phosphorus <= 0.07 ~ 40,\n",
    "    t_phosphorus > 0.07 & t_phosphorus <= 0.09 ~ 50,\n",
    "    t_phosphorus > 0.09 & t_phosphorus <= 0.16 ~ 60,\n",
    "    t_phosphorus > 0.16 & t_phosphorus <= 0.24 ~ 70,\n",
    "    t_phosphorus > 0.24 & t_phosphorus <= 0.46 ~ 80,\n",
    "    t_phosphorus > 0.46 & t_phosphorus <= 0.89 ~ 90,\n",
    "    t_phosphorus > 0.89 ~ 100\n",
    "  )) %>% \n",
    "  mutate(faecal_coliform_si = case_when(\n",
    "    faecal_coliform <= 10 ~ 10,\n",
    "    faecal_coliform > 10 & faecal_coliform <= 20 ~ 20,\n",
    "    faecal_coliform > 20 & faecal_coliform <= 35 ~ 30,\n",
    "    faecal_coliform > 35 & faecal_coliform <= 55 ~ 40,\n",
    "    faecal_coliform > 55 & faecal_coliform <= 75 ~ 50,\n",
    "    faecal_coliform > 75 & faecal_coliform <= 135 ~ 60,\n",
    "    faecal_coliform > 135 & faecal_coliform <= 190 ~ 70,\n",
    "    faecal_coliform > 190 & faecal_coliform <= 470 ~ 80,\n",
    "    faecal_coliform > 470 & faecal_coliform <= 960 ~ 90,\n",
    "    faecal_coliform > 960 ~ 100,\n",
    "    is.na(faecal_coliform) ~ 50\n",
    "  ))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "5265f219",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:41.163061Z",
     "iopub.status.busy": "2022-11-10T15:42:41.161860Z",
     "iopub.status.idle": "2022-11-10T15:42:41.176768Z",
     "shell.execute_reply": "2022-11-10T15:42:41.175466Z"
    },
    "papermill": {
     "duration": 0.02284,
     "end_time": "2022-11-10T15:42:41.179163",
     "exception": false,
     "start_time": "2022-11-10T15:42:41.156323",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Calculate WQI\n",
    "\n",
    "index_df$wqi <- round(rowMeans(subset(index_df, select = c(turbidity_si, ss_si, dissolved_oxygen_si, bod5_si, cod_si, t_carbon_si, t_nitrogen_si, t_phosphorus_si, faecal_coliform_si)), na.rm = TRUE))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "150bf840",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T15:42:41.190698Z",
     "iopub.status.busy": "2022-11-10T15:42:41.189574Z",
     "iopub.status.idle": "2022-11-10T15:42:41.209743Z",
     "shell.execute_reply": "2022-11-10T15:42:41.208097Z"
    },
    "papermill": {
     "duration": 0.028904,
     "end_time": "2022-11-10T15:42:41.212576",
     "exception": false,
     "start_time": "2022-11-10T15:42:41.183672",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Rows: 31,865\n",
      "Columns: 24\n",
      "$ water_control_zone  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Junk Bay\", \"Junk Bay\", \"Junk Bay\", \"Junk Bay\", \"J…\n",
      "$ river               \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Tseng Lan Shue Stream\", \"Tseng Lan Shue Stream\", …\n",
      "$ station             \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"J…\n",
      "$ dates               \u001b[3m\u001b[90m<date>\u001b[39m\u001b[23m 1986-04-29, 1986-05-19, 1986-06-18, 1986-07-24, 1…\n",
      "$ sample_no           \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…\n",
      "$ turbidity           \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 4.1, 4.2, 5.5, 6.5, 6.7, 3.2, 2.0, 2.3, 5.0, 24.0,…\n",
      "$ ss                  \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 6.5, 6.5, 8.5, 6.0, 7.0, 5.0, 3.5, 7.0, 10.0, 31.0…\n",
      "$ dissolved_oxygen    \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 6.0, 5.3, 6.2, 5.2, 5.1, 5.6, 6.9, 6.7, 7.7, 0.8, …\n",
      "$ bod5                \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 9.7, 5.6, 9.0, 12.2, 8.8, 2.1, 5.9, 8.0, 9.0, 113.…\n",
      "$ cod                 \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 13, 21, 19, 17, 5, 5, 29, 160, 46, 66, 83, 45, 12,…\n",
      "$ t_carbon            \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 0.9, 5.0, 1.0, 0.9, 5.0, 4.0, 0.9, 0.9, 7.0, 10.0,…\n",
      "$ t_phosphorus        \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 2.50, 2.00, 1.90, 2.10, 4.50, 1.20, 3.80, 6.80, 5.…\n",
      "$ t_nitrogen          \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 4.1, 5.1, 3.1, 5.5, 5.3, 1.1, 2.7, 12.0, 20.0, 18.…\n",
      "$ faecal_coliform     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…\n",
      "$ turbidity_si        \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 40, 40, 60, 60, 60, 30, 20, 20, 50, 100, 70, 80, 5…\n",
      "$ ss_si               \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 50, 50, 60, 50, 60, 40, 30, 60, 70, 100, 100, 80, …\n",
      "$ dissolved_oxygen_si \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 50, 60, 50, 70, 70, 60, 30, 30, 20, 100, 90, 100, …\n",
      "$ bod5_si             \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 100, 100, 100, 100, 100, 70, 100, 100, 100, 100, 1…\n",
      "$ cod_si              \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 10, 20, 20, 20, 10, 10, 30, 100, 50, 70, 80, 50, 1…\n",
      "$ t_carbon_si         \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 10, 10, 10, 10, 10, 10, 10, 10, 20, 40, 100, 40, 1…\n",
      "$ t_nitrogen_si       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 100, 100, 100, 100, 100, 50, 90, 100, 100, 100, 10…\n",
      "$ t_phosphorus_si     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, …\n",
      "$ faecal_coliform_si  \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50…\n",
      "$ wqi                 \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 57, 59, 61, 62, 62, 47, 51, 63, 62, 84, 88, 78, 61…\n"
     ]
    }
   ],
   "source": [
    "glimpse(index_df)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 5.767403,
   "end_time": "2022-11-10T15:42:41.339997",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-11-10T15:42:35.572594",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
