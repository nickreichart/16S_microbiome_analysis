# In this document I will go over creating ordination plots and useful code to add in to make the figure look more appealing.

library(phyloseq)
library(RColorBrewer) 
library(vegan)
library(ggplot2)

# In order to run an ordination plot we first must do a distance calculation depending on our method and we will need a phyloseq object for this.

setwd("C:/Users/reic006/OneDrive - PNNL/Documents/R_scripts")

count_table <- read.csv(file = "test_plots/artificial.count.table.csv", header = T, row.names = 1)

relabundance_table  <- decostand(count_table, method = "total", MARGIN = 2)

Sample_names <- c("Sample01", "Sample02", "Sample03", "Sample04", "Sample05", "Sample06", "Sample07", "Sample08", "Sample09", "Sample10")
Random_category <- c("One", "One", "One", "One", "One", "Two", "Two", "Two", "Two", "Two")
Other_category <- c("Yes", "No", "Yes", "No", "Yes", "No", "Yes", "No", "Yes", "No")
metadata <- as.data.frame(cbind(Sample_names, Random_category, Other_category))
row.names(metadata) <- metadata$Sample_names

ps <- phyloseq(otu_table(relabundance_table, taxa_are_rows = T), sample_data(metadata))

# Eventually it would be nice to add in a metadata table with sample information

ordination_bray <- ordinate(ps, method = "PCoA", distance = "bray")

ordination_bray_plot <- plot_ordination(ps, ordination_bray) + 
  theme_bw() +
  theme(text = element_text(size = 16),
        axis.text.x = element_text(colour="black"),
        axis.text.y = element_text(colour="black")) +
  geom_point(size = 4)

ordination_bray_plot

# or we can add in shapes and colors to distinguish metadata

ordination_bray_plot <- plot_ordination(ps, ordination_bray,
                                        color = "Random_category",
                                        shape = "Other_category",
                                        title = "PCoA of Bray-Curtis Distances for Samples") + 
  theme_bw() +
  theme(text = element_text(size = 16),
        axis.text.x = element_text(colour="black"),
        axis.text.y = element_text(colour="black"),
        plot.title = element_text(face = "bold")) +
  geom_point(size = 4)

ordination_bray_plot

# Phyloseq objects make it easy to subset out data and run additonal plots based on these subsets

specificcolors <- c("Black", "Blue")

ps.random.category.one <- subset_samples(ps, Random_category == "One")

ordination_bray_cat_one <- ordinate(ps.random.category.one, method = "PCoA", distance = "bray")

ordination_bray_cat_one_plot <- plot_ordination(ps.random.category.one, ordination_bray_cat_one,
                                        color = "Other_category") + 
  theme_bw() +
  theme(text = element_text(size = 16),
        axis.text.x = element_text(colour="black"),
        axis.text.y = element_text(colour="black")) +
  geom_point(size = 4) +
  scale_color_manual(values = specificcolors)

ordination_bray_cat_one_plot

# Other ordination methods exist that do not change the processing too much except for the initial input.

ordination_bray_nmds <- ordinate(ps, method = "NMDS", distance = "bray")

ordination_bray_nmds_plot <- plot_ordination(ps, ordination_bray_nmds,
                                        color = "Random_category",
                                        shape = "Other_category",
                                        title = "NMDS of Bray-Curtis Distances for Samples") + 
  theme_bw() +
  theme(text = element_text(size = 16),
        axis.text.x = element_text(colour="black"),
        axis.text.y = element_text(colour="black"),
        plot.title = element_text(face = "bold")) +
  geom_point(size = 4)

ordination_bray_nmds_plot

# now for cca... this one I have been able to add arrow vectors to in the past

ordination_bray_cca <- ordinate(ps, method = "CCA", distance = "bray")

ordination_bray_cca_plot <- plot_ordination(ps, ordination_bray_cca,
                                             color = "Random_category",
                                             shape = "Other_category",
                                             title = "CCA of Bray-Curtis Distances for Samples") + 
  theme_bw() +
  theme(text = element_text(size = 16),
        axis.text.x = element_text(colour="black"),
        axis.text.y = element_text(colour="black"),
        plot.title = element_text(face = "bold")) +
  geom_point(size = 4)

ordination_bray_cca_plot

# For processing PCoA with unifrac or weighted unifrac distances, a phylo tree must also be added in the phyloseq object when creating it. This is typically generated by the ape package. 



# Below is an example to get arrows on an ordination plot. First version uses the starting relative abundance sheet that has taxa as rows and samples as columns. This will plot the samples based on taxa distribution and use arrows for which samples are driving these taxa.

NMDS.log <- log1p(relabundance_table)
sol <- metaMDS(NMDS.log)
scrs <- as.data.frame(scores(sol, display = "sites"))
scrs <- cbind(scrs, Group = c("taxa001", "taxa002","taxa003", "taxa004","taxa005", "taxa006","taxa007", "taxa008","taxa009", "taxa010","taxa011", "taxa012","taxa013", "taxa014", "taxa015"))
set.seed(123)
vf <- envfit(sol, NMDS.log, perm = 999)
spp.scrs <- as.data.frame(scores(vf, display = "vectors"))
spp.scrs <- cbind(spp.scrs, Species = rownames(spp.scrs))

p <- ggplot(scrs) +
  geom_point(mapping = aes(x = NMDS1, y = NMDS2, color = Group)) +
  coord_fixed() +
  geom_segment(data = spp.scrs,
               aes(x = 0, xend = NMDS1, y = 0, yend = NMDS2),
               arrow = arrow(length = unit(0.25, "cm")), color = "grey") +
  geom_text(data = spp.scrs, aes(x = NMDS1, y = NMDS2, label = Species), size = 3)


p

# This second arrow containing example, the relative abundance table is first transposed so that samples are rows and the taxa are columns. This will keep all the processing steps the same as before but now will plot samples as points (based on their taxa composition) and the arrows will dictate what taxa are driving the differences among samples. This plot matches earlier examples without arrows, but the axis scales are wided here to fit the arrows. 

relabundance_table.t <- as.data.frame(t(relabundance_table))

NMDS.log.t <- log1p(relabundance_table.t)
sol.t <- metaMDS(NMDS.log.t)
scrs.t <- as.data.frame(scores(sol.t, display = "sites"))
scrs.t <- cbind(scrs.t, Group = c("Sample01", "Sample02", "Sample03", "Sample04", "Sample05", "Sample06", "Sample07", "Sample08", "Sample09", "Sample10"))
scrs.t <- cbind(scrs.t, metadata)
set.seed(123)
vf.t <- envfit(sol.t, NMDS.log.t, perm = 999)
spp.scrs.t <- as.data.frame(scores(vf.t, display = "vectors"))
spp.scrs.t <- cbind(spp.scrs.t, Species = rownames(spp.scrs.t))

p.t <- ggplot(scrs.t) +
  geom_point(mapping = aes(x = NMDS1, y = NMDS2, color = Random_category), size =5) +
  coord_fixed() +
  geom_segment(data = spp.scrs.t,
               aes(x = 0, xend = NMDS1, y = 0, yend = NMDS2),
               arrow = arrow(length = unit(0.25, "cm")), color = "black") +
  geom_text(data = spp.scrs.t, aes(x = NMDS1*1.1, y = NMDS2*1.1, label = Species), size = 3) +
  theme_bw() +
  theme(axis.text.x = element_text(colour="black"),
        axis.text.y = element_text(colour="black"))


p.t






