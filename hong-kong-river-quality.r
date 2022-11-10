{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "690f5988",
   "metadata": {
    "_execution_state": "idle",
    "_uuid": "051d70d956493feee0c6d64651c6a088724dca2a",
    "execution": {
     "iopub.execute_input": "2022-11-10T03:36:16.936450Z",
     "iopub.status.busy": "2022-11-10T03:36:16.933075Z",
     "iopub.status.idle": "2022-11-10T03:36:18.639923Z",
     "shell.execute_reply": "2022-11-10T03:36:18.637769Z"
    },
    "papermill": {
     "duration": 1.715941,
     "end_time": "2022-11-10T03:36:18.642760",
     "exception": false,
     "start_time": "2022-11-10T03:36:16.926819",
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
    "library(janitor)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "78f11a2d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T03:36:18.684103Z",
     "iopub.status.busy": "2022-11-10T03:36:18.649431Z",
     "iopub.status.idle": "2022-11-10T03:36:19.678853Z",
     "shell.execute_reply": "2022-11-10T03:36:19.676765Z"
    },
    "papermill": {
     "duration": 1.036571,
     "end_time": "2022-11-10T03:36:19.681756",
     "exception": false,
     "start_time": "2022-11-10T03:36:18.645185",
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
    "df <- read_csv('../input/hkriverhistorical1986-2020/river-historical-1986_2020-en.csv')\n",
    "\n",
    "clean_df <- df %>% \n",
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
   "cell_type": "code",
   "execution_count": 3,
   "id": "abe3eea9",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-10T03:36:19.690891Z",
     "iopub.status.busy": "2022-11-10T03:36:19.689050Z",
     "iopub.status.idle": "2022-11-10T03:36:19.781848Z",
     "shell.execute_reply": "2022-11-10T03:36:19.779476Z"
    },
    "papermill": {
     "duration": 0.100082,
     "end_time": "2022-11-10T03:36:19.784506",
     "exception": false,
     "start_time": "2022-11-10T03:36:19.684424",
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
    "glimpse(clean_df)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "04ec2840",
   "metadata": {
    "papermill": {
     "duration": 0.002819,
     "end_time": "2022-11-10T03:36:19.790051",
     "exception": false,
     "start_time": "2022-11-10T03:36:19.787232",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": []
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
   "duration": 6.763763,
   "end_time": "2022-11-10T03:36:19.916774",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-11-10T03:36:13.153011",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
