# This script serves as a place to generate a count table and a metadata table for the practice scripts in this repository.

# Count table

count_table <- as.data.frame(sample(1:100, 10, replace = T))
colnames(count_table) <- "taxa001"
count_table$taxa002 <- sample(1:100, 10, replace = T)
count_table$taxa003 <- sample(1:100, 10, replace = T)
count_table$taxa004 <- sample(1:100, 10, replace = T)
count_table$taxa005 <- sample(1:100, 10, replace = T)
count_table$taxa006 <- sample(1:75, 10, replace = T)
count_table$taxa007 <- sample(1:75, 10, replace = T)
count_table$taxa008 <- sample(1:50, 10, replace = T)
count_table$taxa009 <- sample(1:50, 10, replace = T)
count_table$taxa010 <- sample(1:25, 10, replace = T)
count_table$taxa011 <- sample(1:25, 10, replace = T)
count_table$taxa012 <- sample(1:25, 10, replace = T)
count_table$taxa013 <- sample(1:25, 10, replace = T)
count_table$taxa014 <- sample(1:10, 10, replace = T)
count_table$taxa015 <- sample(1:10, 10, replace = T)

count_table <- as.data.frame(t(count_table))

colnames(count_table) <- c("Sample01", "Sample02", "Sample03", "Sample04", "Sample05", "Sample06", "Sample07", "Sample08", "Sample09", "Sample10")

write.csv(count_table, file = "example_data/artificial.count.table.csv")

# Metadata table

Sample_names <- c("Sample01", "Sample02", "Sample03", "Sample04", "Sample05", "Sample06", "Sample07", "Sample08", "Sample09", "Sample10")
Random_category <- c("One", "One", "One", "One", "One", "Two", "Two", "Two", "Two", "Two")
Other_category <- c("Yes", "No", "Yes", "No", "Yes", "No", "Yes", "No", "Yes", "No")
metadata <- as.data.frame(cbind(Sample_names, Random_category, Other_category))
row.names(metadata) <- metadata$Sample_names

write.csv(metadata, file = "example_data/metadata.table.csv")