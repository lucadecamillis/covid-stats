# Setting functions
`%>%` <- magrittr::`%>%`

library(ggplot2)
library(dplyr)
library(lubridate)

source("constants.R")

df_cases <- read.csv(CASES_CSV_FILE_PATH)

full_cases <- df_cases %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(cases=sum(CASES))

table_cases <- full_cases %>%
	dplyr::group_by(date=floor_date(date, "week")) %>%
   	dplyr::summarize(cases=sum(cases) / 7)

dev.new();
barplot(
	table_cases$cases,
	names.arg=format(table_cases$date, '%d-%m'),
	main="Daily new cases",
	xlab="date")