# Setting functions
`%>%` <- magrittr::`%>%`

library(ggplot2)
library(dplyr)

source("constants.R")

df_cases <- read.csv(CASES_CSV_FILE_PATH)
df_hosp <- read.csv(HOSPITALISATIONS_CSV_FILE_PATH)

start_date = Sys.Date() - 180

table_hosp <- df_hosp %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(hosp=sum(NEW_IN)) %>%
	dplyr::filter(date >= start_date)

table_cases <- df_cases %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(cases=sum(CASES)) %>%
	dplyr::filter(date >= start_date)

join_table <- inner_join(table_cases, table_hosp) %>%
	dplyr::mutate(ratio = hosp / cases) %>%
	dplyr::mutate(ratio = ifelse(ratio > 1, 0, ratio))

x_axes = format(join_table$date, '%d-%m')

barplot(join_table$ratio, names.arg=x_axes, main="Ratio hospitalisations/new cases", xlab="date")