# Setting functions
`%>%` <- magrittr::`%>%`

library(ggplot2)
library(dplyr)

source("constants.R")

df_hosp <- read.csv(HOSPITALISATIONS_CSV_FILE_PATH)
df_mort <- read.csv(MORTALITY_CSV_FILE_PATH)
df_cases <- read.csv(CASES_CSV_FILE_PATH)

table_hosp <- df_hosp %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(new=sum(NEW_IN), disc=sum(NEW_OUT), total_icu=sum(TOTAL_IN_ICU)) %>%
	dplyr::mutate(total_icu, icu = total_icu - dplyr::lag(total_icu)) %>%
	dplyr::select(-total_icu)

table_mort <- df_mort %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(deaths=sum(DEATHS))

table_cases <- df_cases %>%
	dplyr::mutate(date = as.Date(DATE)) %>%
	dplyr::group_by(date) %>%
	dplyr::summarise(cases=sum(CASES))

join_table <- inner_join(table_hosp, table_mort)

plot_df <- function(df, title, start_date, end_date) {
	# Filter the data by start date
	if(!missing(start_date)){
		df <- df %>% dplyr::filter(date >= start_date)
	}

	# Filter the data by end date
	if(!missing(end_date)){
		df <- df %>% dplyr::filter(date <= end_date)
	}

	# create the matrix with columns
	cols = c("new", "icu", "deaths")
	m <- df[,cols]

    x_axes = format(df$date, '%d-%m')

	colours <- c("yellow", "orange", "red")

	# plot
	dev.new();
	barplot(t(m), beside=TRUE, names.arg=x_axes, las=3, col=colours)
	legend("topleft", cols, bty="n", pch=15, col=colours)
}

two_months_ago = Sys.Date() - 60
plot_df(join_table, 'TITLE', two_months_ago)

dev.new();
barplot(
	table_cases$cases,
	names.arg=format(table_cases$date, '%d-%m'),
	main="New cases",
	xlab="date")