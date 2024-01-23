csv_files <- list.files(path = "Data/",recursive = TRUE)
length(csv_files)
# there are 1023 csv files in data
df <- read.csv('data/wingspan_vs_mass.csv')
head(df, 5)

# list files that start with b
b_files <- list.files("Data/", recursive = TRUE, pattern = "^b")
for (file in b_files) {
  b_first_line <- readLines(file, n=1)
}
cat(b_first_line, "\n")

# list files that end with .csv
csv_list <- list.files("Data/", recursive = TRUE, pattern = "\\.csv$")
for (file in csv_list) {
  csv_first_line <- readLines(file, n=1)
}
cat(csv_first_line, "\n")

