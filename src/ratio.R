# Setting functions
`%>%` <- magrittr::`%>%`

library(ggplot2)
library(dplyr)
library(lubridate)

source("constants.R")

ratio <- function(df_dividend, df_divisor, title) {
	# rename names of columns
	names(df_dividend) <- c("date", "dividend")
	names(df_divisor) <- c("date", "divisor")

	join_table <- inner_join(df_dividend, df_divisor) %>%
		dplyr::group_by(date=floor_date(date, "week")) %>%
		dplyr::summarize(dividend=sum(dividend) / 7, divisor=sum(divisor) / 7) %>%
		dplyr::mutate(ratio = dividend / divisor) %>%
		dplyr::mutate(ratio = ifelse(ratio > 1, 0, ratio))

	x_axes = format(join_table$date, '%d-%m')
	dev.new()
	barplot(
		join_table$ratio,
		names.arg=x_axes,
		main=title,
		xlab="date")
}

df_cases <- read.csv(CASES_CSV_FILE_PATH)
df_hosp <- read.csv(HOSPITALISATIONS_CSV_FILE_PATH)
df_deaths <- read.csv(MORTALITY_CSV_FILE_PATH)

new_hosp <- df_hosp %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(hosp=sum(NEW_IN))

new_cases <- df_cases %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(cases=sum(CASES))

total_icu <- df_hosp %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(icu=sum(TOTAL_IN_ICU))

total_hosp <- df_hosp %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(hosp=sum(TOTAL_IN))

new_deaths <- df_deaths %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(hosp=sum(DEATHS))

ratio(new_hosp, new_cases, "Ratio new hospitalisations vs new cases")
ratio(total_icu, total_hosp, "Ratio total ICU vs total hospitalisations")
ratio(new_deaths, new_cases, "Ratio deaths vs new cases")
ratio(new_deaths, new_hosp, "Ratio deaths vs new hospitalisations")