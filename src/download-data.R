source("constants.R")

download_file <- function(file_url, file_path) {
	# Get the directory of the path
	folder_path <- dirname(file_path)
	ifelse(!dir.exists(folder_path), dir.create(folder_path), "Download folder exists already")

	print(sprintf("Downloading file from url '%s' to '%s' ...", file_url, folder_path))

	command <- sprintf("curl %s > %s", file_url, file_path)
	system(command)

	print(sprintf("File saved at '%s'", file_path))
}

download_file(HOSPITALISATIONS_CSV_URL, HOSPITALISATIONS_CSV_FILE_PATH)
download_file(MORTALITY_CSV_URL, MORTALITY_CSV_FILE_PATH)
download_file(CASES_CSV_URL, CASES_CSV_FILE_PATH)