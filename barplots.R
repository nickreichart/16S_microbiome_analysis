# In this document I will go over creating bar plots and useful code to add in to make the figure look more appealing.

library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(cowplot)
library(vegan)

setwd("C:/Users/reic006/OneDrive - PNNL/Documents/R_scripts")

# read in a data file that can be used for abundance like a count table
# sample will be the columns and observations or variables will be the rows
# can either read in a csv file here or generate a random table as shown below

count <- read.csv(file = "filename.csv", header = T, row.names = 1)

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

write.csv(count_table, file = "test_plots/artificial.count.table.csv")

# this table is now in as raw count abundances which is good for alpha diversity metrics but does not work well with barplots which prefer relative abundance. I prefer to standardize my set based on relative abundance but there is also an option to rarify to a certain number of reads. 

relabundance_table  <- decostand(count_table, method = "total", MARGIN = 2)

# this script converted the count table to relative abundance by calculating by the total of each column (2). If we wanted abundance of a taxa's distribution across samples we could enter "MARGIN = 1" for the function to stay in each row.

sum(relabundance_table$Sample01) # sum of column for Sample01 == 1 or figuratively 100 %

# let's convert this to equal 100 for ease of use and more proper visualization later on...

relabundance_table <- relabundance_table[,]*100

sum(relabundance_table$Sample01) # sum of column for Sample01 == 100

# if needed on larger datasets, a threshold can be used to only analyze certain taxa that are above a percent value. I do this across the entire data so taxa## would need to have an average above the threshold across all samples to be kept.

relabundance_table_above0.5 <- relabundance_table[(rowSums(relabundance_table)/ncol(relabundance_table)) >= 00.5,]

# in this case, everything is above this limit

relabundance_table_above1 <- relabundance_table[(rowSums(relabundance_table)/ncol(relabundance_table)) >= 01,]

# taxa15 had an average value below 1 so it was removed with this threshold

sum(relabundance_table_above1$Sample01) # 98.67 so removing taxa15 removed 1.33 % from this sample

# need to fill in for any taxa removed by making an "Other" taxon

other <- as.matrix(100 - colSums(relabundance_table_above1))
other <- t(other)
relabundance_table_above1 <- rbind(relabundance_table_above1, other)
rownames(relabundance_table_above1)[15] <- "Other"

# going to set our colorscheme now but unfortunately most color schemes do not go to 15 colors and most above 5/6 are no longer great at being colorblind friendly

basecolor = brewer.pal(8, "Set1")
expandedcolors = colorRampPalette(basecolor)(15)

# now going to melt the data into a long format with only 3 columns. So there will be a column for the sample, taxon, and rel abund value

relabundance_table_above1_long <- t(relabundance_table_above1)
relabundance_table_above1_long <- melt(relabundance_table_above1_long, id.vars = "rows")
names(relabundance_table_above1_long) <- c("Sample", "Taxon", "Value")

barplot_example <- ggplot(relabundance_table_above1_long, aes(x = Sample, y = Value, fill = Taxon)) +
  geom_bar(stat = "identity", color = "black") +
  xlab("\nSample") + # the \n just adds a return before Sample to space it a little further from the axis 
  ylab("Relative Abundance %\n") +
  theme_bw() +
  theme(legend.position = "right",
        axis.text.x=element_text(colour="black", angle = 90, vjust = 0.5),
        axis.text.y=element_text(colour="black")) +
  guides(fill = guide_legend(ncol = 2)) +
  scale_fill_manual(values = expandedcolors)

barplot_example # I save directly in the side bar window with the export drop down preview where I can adjust size

# Other useful arguments to add into ggplot
# in the theme () axis.text.y=element_blank() to remove the axis title,
# or axis.ticks.y=element_blank() to remove the tick marks

# Changing normal axis titles can be done with + xlabs() or + ylabs()

# + coord_flip() will rotate the plot 90 so the sample names are on Y and relative abundance on X

# in theme () the axis marker names can be adjusted on angle (axis.text.x=element_text(angle=90))
# Will probably need some vjust = or hjust = to make these fit right. Values can range 0 to 1.





