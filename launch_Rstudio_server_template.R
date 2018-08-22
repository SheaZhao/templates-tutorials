# tutorial: https://youtu.be/1oM0NZbRhSI ----------------------------------------------------------------
# first sign into Google Cloud console: https://console.cloud.google.com/home/dashboard
# in shell type:
# datalab connect datalab-yourname
# yourname@fpmstanford:~$ datalab connect datalab-yourname

# go to Cloud console Navigation Menu
# API & Services > Enable APIs & Services (button)
# make sure Google Compute Engine is initiated (should say "enabled" or "disabled")
# API & Services > Credentials > Service Account Key (JSON)> Compute Engine Defualt Account > SAVE THIS JSON FILE!!


# setup -------------------------------------------------------------------
project <- "YourProject"
zone <- "us-west2-c" # select zone near you: https://cloud.google.com/compute/docs/regions-zones/
account_key <- "/Users/You/Documents/SomeFolder/blah_blah_blah.json" # path to json key (you will need to download your own key)

Sys.setenv(GCE_AUTH_FILE = account_key,
           GCE_DEFAULT_PROJECT_ID = project,
           GCE_DEFAULT_ZONE = zone) # set environmental variables 

options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/cloud-platform")
# FIX: https://github.com/MarkEdmondson1234/googleAuthR/issues/97

gce_auth()

# install packages ---------------------------------------------------------------
#install.packages("googleComputeEngineR")
library(googleComputeEngineR)

# Set our default global project ------------------------------------------

gce_global_project(project)
gce_global_zone(zone)

default_project <- gce_get_project("YourProject")
default_project$name # confirm


# Deploy instance ----------------------------------------------------------
# copy and paste IP address into web browser to use rstudio server

vm <- gce_vm(template = "rstudio",
             name = "rstudio-yourname",
             username = "whatever",
             password = "yourpassword",
             predefined_type = "n1-highmem-2")

?gce_vm

my_rstudio <- gce_vm("rstudio-yourname") #confirm it's running
my_rstudio$status


# Start and stop instances ------------------------------------------------

stop_job <- gce_vm_stop("rstudio-yourname")
start_job <- gce_vm_start("rstudio-yourname")
gce_list_instances() # list of all instances within this project - COPY & PASTE externalIP address into web browser
# ==Google Compute Engine Instance List==
#   name  machineType  status       zone    externalIP   creationTimestamp
# 1 rstudio-shea n1-highmem-2 RUNNING us-west2-c 35.236.38.118 2018-08-05 14:19:15


# Retrieve data from BigQuery (do this in your VM) ---------------------------------------------

# authorize the application to access Google Cloud services: https://cloud.google.com/blog/products/gcp/google-cloud-platform-for-data-scientists-using-r-with-google-bigquery
# install.packages("devtools")
library(devtools)

# install.packages("bigrquery")
library(bigrquery)
devtools::install_github("rstats-db/bigrquery")

project <- "YourProject"
sql <- "SELECT icd_diagnosis_code FROM `dataten.ALZ` WHERE ALZBOOL = TRUE"
tb <- bq_project_query(project, sql)

#> Auto-refreshing stale OAuth token.
bq_table_download(tb, max_results = 20) # check to see it works

library(DBI)

con <- dbConnect(
  bigrquery::bigquery(),
  project ="YourProject",
  dataset ="YourDataTable",
  billing = project
)

library(tidyverse)

Z <- tbl(con, "YourDataTable") # make sure tidyverse works!
head(Z)

select(Z, column_a,column_b) %>% head(20) # check to see that you can manipulate data




