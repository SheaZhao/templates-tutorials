# make sure libraries are installed
library(tidyverse)
library(DBI)

# Do the following for each table
con.Table_A <- dbConnect(
  bigrquery::bigquery(),
  project ="YourProject",
  dataset ="data.Table_A",
  billing = project
)

Table_A <- tbl(con.Table_A, "data.Table_A")
head(Table_A)



#### table atlas #### YOU MAY WANT TO MAKE A TABLE ATLAS TO KEEP TRACK OF WHATS
  # FYI these < nrow(Table_A) & str(Table_A) >  kind of things don't work in the VM :/ 
  #so you may want to make a table atlas to keep track of what's where using:
  colnames(Table_A) # 58,794 rows
      # [1] "ID"  "sent_text"     "drug_name"     "brand_name"    "drug_form"     "strength"      "dose_amt"     








