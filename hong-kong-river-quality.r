{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "7b9790a9",
   "metadata": {
    "papermill": {
     "duration": 0.004135,
     "end_time": "2022-11-10T09:52:17.148111",
     "exception": false,
     "start_time": "2022-11-10T09:52:17.143976",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Introduction\n",
    "\n",
    "Hong Kong prides itself in it's ability to provide potable water directly to people's homes straight out of the tap.  But how is it down the line?  In this project I want dive into the water parameter data collected from the territory's major rivers to find out it's current state and to learn which river is the cleanest.\n",
    "\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "15dcbe0a",
   "metadata": {
    "papermill": {
     "duration": 0.00289,
     "end_time": "2022-11-10T09:52:17.154079",
     "exception": false,
     "start_time": "2022-11-10T09:52:17.151189",
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
   "id": "572f88aa",
   "metadata": {
    "papermill": {
     "duration": 0.00281,
     "end_time": "2022-11-10T09:52:17.159589",
     "exception": false,
     "start_time": "2022-11-10T09:52:17.156779",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## Libraries"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "207fe60c",
   "metadata": {
    "_execution_state": "idle",
    "_uuid": "051d70d956493feee0c6d64651c6a088724dca2a",
    "execution": {
     "iopub.execute_input": "2022-11-10T09:52:17.170350Z",
     "iopub.status.busy": "2022-11-10T09:52:17.167504Z",
     "iopub.status.idle": "2022-11-10T09:52:18.637128Z",
     "shell.execute_reply": "2022-11-10T09:52:18.635313Z"
    },
    "papermill": {
     "duration": 1.477847,
     "end_time": "2022-11-10T09:52:18.640119",
     "exception": false,
     "start_time": "2022-11-10T09:52:17.162272",
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
   "id": "a44b879d",
   "metadata": {
    "papermill": {
     "duration": 0.003282,
     "end_time": "2022-11-10T09:52:18.646811",
     "exception": false,
     "start_time": "2022-11-10T09:52:18.643529",
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
   "id": "c9125471",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T09:52:18.684100Z",
     "iopub.status.busy": "2022-11-10T09:52:18.654770Z",
     "iopub.status.idle": "2022-11-10T09:52:19.394890Z",
     "shell.execute_reply": "2022-11-10T09:52:19.392190Z"
    },
    "papermill": {
     "duration": 0.748951,
     "end_time": "2022-11-10T09:52:19.398774",
     "exception": false,
     "start_time": "2022-11-10T09:52:18.649823",
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
   "id": "99bc12eb",
   "metadata": {
    "papermill": {
     "duration": 0.004002,
     "end_time": "2022-11-10T09:52:19.406367",
     "exception": false,
     "start_time": "2022-11-10T09:52:19.402365",
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
   "id": "95bdb7e5",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T09:52:19.416724Z",
     "iopub.status.busy": "2022-11-10T09:52:19.415142Z",
     "iopub.status.idle": "2022-11-10T09:52:19.638555Z",
     "shell.execute_reply": "2022-11-10T09:52:19.636785Z"
    },
    "papermill": {
     "duration": 0.231066,
     "end_time": "2022-11-10T09:52:19.640944",
     "exception": false,
     "start_time": "2022-11-10T09:52:19.409878",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
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
    "                    x5_day_biochemical_oxygen_demand_mg_l, \n",
    "                    chemical_oxygen_demand_mg_l, \n",
    "                    conductivity_m_s_cm, \n",
    "                    dissolved_oxygen_mg_l, \n",
    "                    e_coli_counts_100m_l, \n",
    "                    faecal_coliforms_counts_100m_l, \n",
    "                    # flow_m3_s, \n",
    "                    oil_and_grease_mg_l, \n",
    "                    suspended_solids_mg_l, \n",
    "                    total_solids_mg_l, \n",
    "                    turbidity_ntu)\n",
    "         ) %>% \n",
    "  rename(bod5 = x5_day_biochemical_oxygen_demand_mg_l, \n",
    "         cod = chemical_oxygen_demand_mg_l,\n",
    "         conductivity = conductivity_m_s_cm,\n",
    "         dissolved_oxygen = dissolved_oxygen_mg_l,\n",
    "         e_coli = e_coli_counts_100m_l,\n",
    "         faecal_coliform = faecal_coliforms_counts_100m_l,\n",
    "         fog = oil_and_grease_mg_l,\n",
    "         ss = suspended_solids_mg_l,\n",
    "         ts = total_solids_mg_l,\n",
    "         turbidity = turbidity_ntu\n",
    "         )"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "1b392010",
   "metadata": {
    "papermill": {
     "duration": 0.003645,
     "end_time": "2022-11-10T09:52:19.648311",
     "exception": false,
     "start_time": "2022-11-10T09:52:19.644666",
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
   "id": "93a89544",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T09:52:19.658305Z",
     "iopub.status.busy": "2022-11-10T09:52:19.656832Z",
     "iopub.status.idle": "2022-11-10T09:52:19.688043Z",
     "shell.execute_reply": "2022-11-10T09:52:19.686150Z"
    },
    "papermill": {
     "duration": 0.03884,
     "end_time": "2022-11-10T09:52:19.690445",
     "exception": false,
     "start_time": "2022-11-10T09:52:19.651605",
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
      "Columns: 15\n",
      "$ water_control_zone \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Junk Bay\", \"Junk Bay\", \"Junk Bay\", \"Junk Bay\", \"Ju…\n",
      "$ river              \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Tseng Lan Shue Stream\", \"Tseng Lan Shue Stream\", \"…\n",
      "$ station            \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"JR11\", \"JR…\n",
      "$ dates              \u001b[3m\u001b[90m<date>\u001b[39m\u001b[23m 1986-04-29, 1986-05-19, 1986-06-18, 1986-07-24, 19…\n",
      "$ sample_no          \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …\n",
      "$ bod5               \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"9.7\", \"5.6\", \"9\", \"12.2\", \"8.8\", \"2.1\", \"5.9\", \"8\"…\n",
      "$ cod                \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"13\", \"21\", \"19\", \"17\", \"5\", \"5\", \"29\", \"160\", \"46\"…\n",
      "$ conductivity       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 320, 220, 220, 185, 250, 145, 175, 350, 360, 400, 2…\n",
      "$ dissolved_oxygen   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 6.0, 5.3, 6.2, 5.2, 5.1, 5.6, 6.9, 6.7, 7.7, 0.8, 3…\n",
      "$ e_coli             \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…\n",
      "$ faecal_coliform    \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…\n",
      "$ fog                \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"10\", \"12\", \"0.5\", \"<0.5\", \"<0.5\", \"3.5\", \"<0.5\", \"…\n",
      "$ ss                 \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"6.5\", \"6.5\", \"8.5\", \"6\", \"7\", \"5\", \"3.5\", \"7\", \"10…\n",
      "$ ts                 \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 210, 180, 150, 34, 160, 130, 210, 270, 270, 270, 24…\n",
      "$ turbidity          \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 4.1, 4.2, 5.5, 6.5, 6.7, 3.2, 2.0, 2.3, 5.0, 24.0, …\n"
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
   "id": "39021c4c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T09:52:19.701596Z",
     "iopub.status.busy": "2022-11-10T09:52:19.700135Z",
     "iopub.status.idle": "2022-11-10T09:52:19.720771Z",
     "shell.execute_reply": "2022-11-10T09:52:19.719111Z"
    },
    "papermill": {
     "duration": 0.028481,
     "end_time": "2022-11-10T09:52:19.723069",
     "exception": false,
     "start_time": "2022-11-10T09:52:19.694588",
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
   "id": "9b29f9a8",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T09:52:19.734134Z",
     "iopub.status.busy": "2022-11-10T09:52:19.732665Z",
     "iopub.status.idle": "2022-11-10T09:52:19.750553Z",
     "shell.execute_reply": "2022-11-10T09:52:19.748840Z"
    },
    "papermill": {
     "duration": 0.025979,
     "end_time": "2022-11-10T09:52:19.752952",
     "exception": false,
     "start_time": "2022-11-10T09:52:19.726973",
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
   "duration": 6.37289,
   "end_time": "2022-11-10T09:52:19.877320",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-11-10T09:52:13.504430",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
