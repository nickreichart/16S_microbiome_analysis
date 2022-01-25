# In this document I will go over creating box and whisker plots and useful code to make the final figure more appealing.

library(ggplot2)
library(RColorBrewer)
library(cowplot)
library(phyloseq)

setwd("C:/Users/reic006/OneDrive - PNNL/Documents/R_scripts/16S_microbiome_analysis")

# For box and whisker plots, I am typically using data that is clustered categorically so that I will need some type of metadata table as well as the count table. 

count <- read.csv(file = "example_data/artificial.count.table.csv", header = T, row.names = 1)
metadata <- read.csv(file = "example_data/metadata.table.csv", header = T, row.names = 1)

# For this example, I will be using the alpha diversity metrics for the samples so the count table should remain as integers. You can normalize to a certain number of reads but that is beyond what this guide is for. But we will first need a Phyloseq object.

phyloobject1 <- phyloseq(otu_table(count, taxa_are_rows = T), sample_data(metadata))

# estimate_richness is a function within Phyloseq that will give us something to plot using the raw count data we read in to start with.

sample_richness <- estimate_richness(phyloobject1)

# At this point we will merge together the richness table with a couple of the metadata columns that we can plot based on.

boxwhiskerdata <- as.data.frame(sample_richness$Shannon)
boxwhiskerdata$Simpson <- sample_richness$Simpson
boxwhiskerdata$InvSimpson <- sample_richness$InvSimpson
row.names(boxwhiskerdata) <- row.names(sample_richness)

boxwhiskerdata$Random_category <- metadata$Random_category
boxwhiskerdata$Other_category <- metadata$Other_category

colnames(boxwhiskerdata) <- c("Shannon", "Simpson", "Inv Simpson", "Random_category", "Other_category")

# Our data should be prepared in the way we want it now so we can start plotting. First will be the Shannon Diversity clustered based on the "Other Category".

shannon_fig <- ggplot(boxwhiskerdata, aes(x = Other_category, y = Shannon, fill = Other_category)) +
  geom_boxplot() +
  theme_bw() +
  theme(axis.title.x = element_blank(), legend.position = "right", 
        axis.text.x = element_text(color = "black"), axis.text.y = element_text(color = "black")) +
  ylab("Shannon Diversity") +
  guides(fill = guide_legend(title = "Other Category"))

# Just to make this guide more robust, we will also plot the Simpson diversity and then eventually combine these two plots together to show two alpha diversity metrics.

simpson_fig <- ggplot(boxwhiskerdata, aes(x = Other_category, y = Simpson, fill = Other_category)) +
  geom_boxplot() +
  theme_bw() +
  theme(axis.title.x = element_blank(), legend.position = "right", 
        axis.text.x = element_text(color = "black"), axis.text.y = element_text(color = "black")) +
  ylab("Simpson Diversity") +
  guides(fill = guide_legend(title = "Other Category"))


alphadiv_together <- plot_grid(shannon_fig, simpson_fig)

alphadiv_together

# This is a very basic way to make these plots. There are plenty of ways to spruce them up. Let's remove one of the legends since they are the same and reorder the X axis categories to start with Yes. At this point, I will also give defined values for the Simpson Y-axis so that the extremes have assigned values.

boxwhiskerdata$Other_category <- factor(boxwhiskerdata$Other_category, levels = c("Yes", "No"))

shannon_fig_v2 <- ggplot(boxwhiskerdata, aes(x = Other_category, y = Shannon, fill = Other_category)) +
  geom_boxplot() +
  theme_bw() +
  theme(axis.title.x = element_blank(), legend.position = "none", 
        axis.text.x = element_text(color = "black"), axis.text.y = element_text(color = "black")) +
  ylab("Shannon Diversity") +
  guides(fill = guide_legend(title = "Other Category"))

simpson_fig_v2 <- ggplot(boxwhiskerdata, aes(x = Other_category, y = Simpson, fill = Other_category)) +
  geom_boxplot() +
  theme_bw() +
  theme(axis.title.x = element_blank(), legend.position = "right", 
        axis.text.x = element_text(color = "black"), axis.text.y = element_text(color = "black")) +
  ylab("Simpson Diversity") +
  ylim(0.86, 0.90) +
  guides(fill = guide_legend(title = "Other Category")) 


alphadiv_together_v2 <- plot_grid(shannon_fig_v2, simpson_fig_v2, rel_widths = c(1,1.6))

# Since the two plots were exported as the same size, they need to be adjusted with rel_width since the Shannon Diversity does not have the legend and the plot takes up a larger portion of that figure. 

alphadiv_together_v2

# As with other GGplot figure, we can change the color of the fill with the following code:
# + scale_fill_manual(values = c("Green", "Blue"))





