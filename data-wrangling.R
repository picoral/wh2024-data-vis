library(tidyverse)
library(janitor)

# https://irma.nps.gov/Stats/SSRSReports/Park%20Specific%20Reports/Recreation%20Visitors%20By%20Month%20(1979%20-%20Last%20Calendar%20Year)
folder_name <- "original-data"
files2read <- list.files(folder_name,
                         full.names = TRUE)

np_data <- read_csv(files2read, skip = 2, id = "filename") %>% 
  mutate(park = str_remove_all(filename, paste0(folder_name, "/|\\.csv"))) %>% 
  select(-filename) %>% 
  rename("total" = Textbox5) %>% 
  pivot_longer(cols = JAN:DEC,
               names_to = "month",
               values_to = "visitors") %>% 
  filter(!is.na(visitors)) %>% 
  mutate(month_number = recode(month,
                               JAN = 1,
                               FEB = 2,
                               MAR = 3,
                               APR = 4,
                               MAY = 5,
                               JUN = 6,
                               JUL = 7,
                               AUG = 8,
                               SEP = 9,
                               OCT = 10,
                               NOV = 11,
                               DEC = 12)) %>% 
  clean_names() %>% 
  select(park, year, month, month_number, visitors, total) %>% 
  arrange(year)

write_csv(np_data, "tidy-data/national_parks_data.csv")
