#Starting a new project to automate the breaking out of table data from the Senate's website using the rvest package

library(tidyverse)
library(rvest)
library(janitor)

#Using tutorial found here https://cran.r-project.org/web/packages/rvest/vignettes/rvest.html to try to pull html from the senate website and then break out the table elements

#pull in html from senate website I want to scrape  
html <- read_html("https://www.uscapitolchristmastree.com/about-2/")
class(html)

#seeking tables so I look at whether there are multiple table attributes https://rvest.tidyverse.org/reference/html_children.html

#get the name of all the class

tbls <- html_nodes(html, "table")
tbls
#[1] <table class="table tablesorter" border="1" width="100%">\n<thead><tr>\n<t ...


#looks like there's only the one table, so this should be easy
# Identify the information stored in a <table> tag and put it into a data.frame 
note_info <- html %>% 
  html_node("table") %>% 
  html_table() # %>%
  #uses the janitor package to set the top row, as column names  -- for whatever reason the html_table( header = TRUE) just wasn't working in some tables. Probably user error.
  row_to_names(row_number = 1)

#If there were more than one, we'd have to tell R which one we want http://bradleyboehmke.github.io/2015/12/scraping-html-tables.html
#for whatever reason, in his example, he uses [1] instead of [[]]. That didn't work. 

tbls_ls <- html %>%
  html_nodes("table") %>%
  .[[1]] %>% #calls the table number ?
  html_table() 
#it seems to be dropping off the header row. Don't need to deal with it now, but just something for future puzzling.

#write into .csv
write_csv(note_info, "trees.csv", col_names = TRUE)
