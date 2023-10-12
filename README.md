# Nitrate-Corpus
Using the EN Wikipedia-Corpus to pull out film-related data.

Currently, this repo containts R scripts that take a Wikipedia Nightly Export through four steps:

### Step 1: Break the large nightly file into smaller chunks

Get a nightly file from https://dumps.wikimedia.org/other/cirrussearch/ 

I use the latest en-*date*-cirrussearch.json.gz file

### Step 2: Load each json chunk into a dataframe

This step does some basic operations preparing the dataframes for analysis and exporting each as a csv file.

### Step 3: Combine the csv exports into one large dataframe

After getting through all the prepatory steps, the dataframe is now ready for analysis.

### Step 4: Run various tidyverse scripts to get at whatever I'm looking for

This is where the fun begins
