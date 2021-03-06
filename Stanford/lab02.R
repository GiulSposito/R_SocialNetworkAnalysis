####################################################################
# LAB 2: Methodological beginnings - Density, Reciprocity, Triads, #
# Transitivity, and heterogeneity. Node and network statistics.    #
####################################################################

##############################################################
# 
# Lab 2 
#
# The purpose of this lab is to acquire basic cohesion 
# metrics of density, reciprocity, reach, path distance, 
# and transitivity. In addition, we'll develop triadic 
# analyses and a measure of ego-network heterogenity. 
#
##############################################################

### 
# 1. SET UP SESSION
###
# install.packages("NetData")

library(igraph)
library(NetData)

### 
# 2. LOAD DATA
###

# We would ordinarily need to follow the same proceedure we did for the Krackhardt data
# as we did in lab 1; see that lab for detail.

data(kracknets, package = "NetData")

# Reduce to non-zero edges and build a graph object
krack_full_nonzero_edges <- subset(krack_full_data_frame, (advice_tie > 0 | friendship_tie > 0 | reports_to_tie > 0))
head(krack_full_nonzero_edges)

krack_full <- graph.data.frame(krack_full_nonzero_edges) 
summary(krack_full)

# Set vertex attributes
for (i in V(krack_full)) {
  for (j in names(attributes)) {
    krack_full <- set.vertex.attribute(krack_full, j, index=i, attributes[i+1,j])
  }
}
summary(krack_full)

# Create sub-graphs based on edge attributes
krack_advice <- delete.edges(krack_full, E(krack_full)[get.edge.attribute(krack_full,name = "advice_tie")==0])
summary(krack_advice)

krack_friendship <- delete.edges(krack_full, E(krack_full)[get.edge.attribute(krack_full,name = "friendship_tie")==0])
summary(krack_friendship)

krack_reports_to <- delete.edges(krack_full, E(krack_full)[get.edge.attribute(krack_full,name = "reports_to_tie")==0])
summary(krack_reports_to)

### 
# 3. NODE-LEVEL STATISTICS
###

# Compute the indegree and outdegree for each node, first in the 
# full graph (accounting for all tie types) and then in each 
# tie-specific sub-graph. 
deg_full_in <- degree(krack_full, mode="in") 
deg_full_out <- degree(krack_full, mode="out") 
deg_full_in
deg_full_out

deg_advice_in <- degree(krack_advice, mode="in") 
deg_advice_out <- degree(krack_advice, mode="out") 
deg_advice_in
deg_advice_out

deg_friendship_in <- degree(krack_friendship, mode="in") 
deg_friendship_out <- degree(krack_friendship, mode="out") 
deg_friendship_in
deg_friendship_out

deg_reports_to_in <- degree(krack_reports_to, mode="in") 
deg_reports_to_out <- degree(krack_reports_to, mode="out") 
deg_reports_to_in
deg_reports_to_out

# Reachability can only be computed on one vertex at a time. To
# get graph-wide statistics, change the value of "vertex"
# manually or write a for loop. 

reachability <- function(g, m) {
  reach_mat = matrix(nrow = vcount(g), 
                     ncol = vcount(g))
  for (i in 1:vcount(g)) {
    reach_mat[i,] = 0
    this_node_reach <- subcomponent(g, i, mode = m)
    
    for (j in 1:(length(this_node_reach))) {
      alter = this_node_reach[j] 
      reach_mat[i, alter] = 1
    }
  }
  return(reach_mat)
}

reach_full_in <- reachability(krack_full, 'in')
reach_full_out <- reachability(krack_full, 'out')
reach_full_in
reach_full_out

reach_advice_in <- reachability(krack_advice, 'in')
reach_advice_out <- reachability(krack_advice, 'out')
reach_advice_in
reach_advice_out

reach_friendship_in <- reachability(krack_friendship, 'in')
reach_friendship_out <- reachability(krack_friendship, 'out')
reach_friendship_in
reach_friendship_out

reach_reports_to_in <- reachability(krack_reports_to, 'in')
reach_reports_to_out <- reachability(krack_reports_to, 'out')
reach_reports_to_in
reach_reports_to_out

# Often we want to know path distances between individuals in a network. 
# This is often done by calculating geodesics, or shortest paths between
# each ij pair. One can symmetrize the data to do this (see lab 1), or 
# calculate it for outward and inward ties separately. Averaging geodesics 
# for the entire network provides an average distance or sort of cohesiveness
# score. Dichotomizing distances reveals reach, and an average of reach for 
# a network reveals what percent of a network is connected in some way.

# Compute shortest paths between each pair of nodes. 
sp_full_in <- shortest.paths(krack_full, mode='in')
sp_full_out <- shortest.paths(krack_full, mode='out')
sp_full_in
sp_full_out

sp_advice_in <- shortest.paths(krack_advice, mode='in')
sp_advice_out <- shortest.paths(krack_advice, mode='out')
sp_advice_in
sp_advice_out

sp_friendship_in <- shortest.paths(krack_friendship, mode='in')
sp_friendship_out <- shortest.paths(krack_friendship, mode='out')
sp_friendship_in
sp_friendship_out

sp_reports_to_in <- shortest.paths(krack_reports_to, mode='in')
sp_reports_to_out <- shortest.paths(krack_reports_to, mode='out')
sp_reports_to_in
sp_reports_to_out

# Assemble node-level stats into single data frame for export as CSV.

# First, we have to compute average values by node for reachability and
# shortest path. (We don't have to do this for degree because it is 
# already expressed as a node-level value.)
reach_full_in_vec <- vector()
reach_full_out_vec <- vector()
reach_advice_in_vec <- vector()
reach_advice_out_vec <- vector()
reach_friendship_in_vec <- vector()
reach_friendship_out_vec <- vector()
reach_reports_to_in_vec <- vector()
reach_reports_to_out_vec <- vector()

sp_full_in_vec <- vector()
sp_full_out_vec <- vector()
sp_advice_in_vec <- vector()
sp_advice_out_vec <- vector()
sp_friendship_in_vec <- vector()
sp_friendship_out_vec <- vector()
sp_reports_to_in_vec <- vector()
sp_reports_to_out_vec <- vector()

for (i in 1:vcount(krack_full)) {
  reach_full_in_vec[i] <- mean(reach_full_in[i,])
  reach_full_out_vec[i] <- mean(reach_full_out[i,])
  reach_advice_in_vec[i] <- mean(reach_advice_in[i,])
  reach_advice_out_vec[i] <- mean(reach_advice_out[i,])
  reach_friendship_in_vec[i] <- mean(reach_friendship_in[i,])
  reach_friendship_out_vec[i] <- mean(reach_friendship_out[i,])
  reach_reports_to_in_vec[i] <- mean(reach_reports_to_in[i,])
  reach_reports_to_out_vec[i] <- mean(reach_reports_to_out[i,])
  
  sp_full_in_vec[i] <- mean(sp_full_in[i,])
  sp_full_out_vec[i] <- mean(sp_full_out[i,])
  sp_advice_in_vec[i] <- mean(sp_advice_in[i,])
  sp_advice_out_vec[i] <- mean(sp_advice_out[i,])
  sp_friendship_in_vec[i] <- mean(sp_friendship_in[i,])
  sp_friendship_out_vec[i] <- mean(sp_friendship_out[i,])
  sp_reports_to_in_vec[i] <- mean(sp_reports_to_in[i,])
  sp_reports_to_out_vec[i] <- mean(sp_reports_to_out[i,])
}

# Next, we assemble all of the vectors of node-levelvalues into a 
# single data frame, which we can export as a CSV to our working
# directory.
node_stats_df <- cbind(deg_full_in,
                       deg_full_out,
                       deg_advice_in,
                       deg_advice_out,
                       deg_friendship_in,
                       deg_friendship_out,
                       deg_reports_to_in,
                       deg_reports_to_out, 
                       
                       reach_full_in_vec, 
                       reach_full_out_vec, 
                       reach_advice_in_vec, 
                       reach_advice_out_vec, 
                       reach_friendship_in_vec, 
                       reach_friendship_out_vec, 
                       reach_reports_to_in_vec, 
                       reach_reports_to_out_vec, 
                       
                       sp_full_in_vec, 
                       sp_full_out_vec, 
                       sp_advice_in_vec, 
                       sp_advice_out_vec, 
                       sp_friendship_in_vec, 
                       sp_friendship_out_vec, 
                       sp_reports_to_in_vec, 
                       sp_reports_to_out_vec)

write.csv(node_stats_df, './Stanford/krack_node_stats.csv')


# Question #1 - What do these statistics tell us about
# each network and its individuals in general? 

### 
# 3. NETWORK-LEVEL STATISTICS
###

# Many initial analyses of networks begin with distances and reach, 
# and then move towards global summary statistics of the network. 
#
# As a reminder, entering a question mark followed by a function 
# name (e.g., ?graph.density) pulls up the help file for that function.
# This can be helpful to understand how, exactly, stats are calculated.

# Degree
mean(deg_full_in)
sd(deg_full_in)
mean(deg_full_out)
sd(deg_full_out)

mean(deg_advice_in)
sd(deg_advice_in)
mean(deg_advice_out)
sd(deg_advice_out)

mean(deg_friendship_in)
sd(deg_friendship_in)
mean(deg_friendship_out)
sd(deg_friendship_out)

mean(deg_reports_to_in)
sd(deg_reports_to_in)
mean(deg_reports_to_out)
sd(deg_reports_to_out)


# Shortest paths
# ***Why do in and out come up with the same results?
# In and out shortest paths are simply transposes of one another; 
# thus, when we compute statistics across the whole network they have to be the same.

mean(sp_full_in[which(sp_full_in != Inf)])
sd(sp_full_in[which(sp_full_in != Inf)])
mean(sp_full_out[which(sp_full_out != Inf)])
sd(sp_full_out[which(sp_full_out != Inf)])

mean(sp_advice_in[which(sp_advice_in != Inf)])
sd(sp_advice_in[which(sp_advice_in != Inf)])
mean(sp_advice_out[which(sp_advice_out != Inf)])
sd(sp_advice_out[which(sp_advice_out != Inf)])

mean(sp_friendship_in[which(sp_friendship_in != Inf)])
sd(sp_friendship_in[which(sp_friendship_in != Inf)])
mean(sp_friendship_out[which(sp_friendship_out != Inf)])
sd(sp_friendship_out[which(sp_friendship_out != Inf)])

mean(sp_reports_to_in[which(sp_reports_to_in != Inf)])
sd(sp_reports_to_in[which(sp_reports_to_in != Inf)])
mean(sp_reports_to_out[which(sp_reports_to_out != Inf)])
sd(sp_reports_to_out[which(sp_reports_to_out != Inf)])

# Reachability
mean(reach_full_in[which(reach_full_in != Inf)])
sd(reach_full_in[which(reach_full_in != Inf)])
mean(reach_full_out[which(reach_full_out != Inf)])
sd(reach_full_out[which(reach_full_out != Inf)])

mean(reach_advice_in[which(reach_advice_in != Inf)])
sd(reach_advice_in[which(reach_advice_in != Inf)])
mean(reach_advice_out[which(reach_advice_out != Inf)])
sd(reach_advice_out[which(reach_advice_out != Inf)])

mean(reach_friendship_in[which(reach_friendship_in != Inf)])
sd(reach_friendship_in[which(reach_friendship_in != Inf)])
mean(reach_friendship_out[which(reach_friendship_out != Inf)])
sd(reach_friendship_out[which(reach_friendship_out != Inf)])

mean(reach_reports_to_in[which(reach_reports_to_in != Inf)])
sd(reach_reports_to_in[which(reach_reports_to_in != Inf)])
mean(reach_reports_to_out[which(reach_reports_to_out != Inf)])
sd(reach_reports_to_out[which(reach_reports_to_out != Inf)])

# Density 
graph.density(krack_full)
graph.density(krack_advice)
graph.density(krack_friendship)
graph.density(krack_reports_to)

# Reciprocity
reciprocity(krack_full)
reciprocity(krack_advice)
reciprocity(krack_friendship)
reciprocity(krack_reports_to)

# Transitivity
transitivity(krack_full)
transitivity(krack_advice)
transitivity(krack_friendship)
transitivity(krack_reports_to)

# Triad census. Here we'll first build a vector of labels for 
# the different triad types. Then we'll combine this vector
# with the triad censuses for the different networks, which 
# we'll export as a CSV.

census_labels = c('003',
                  '012',
                  '102',
                  '021D',
                  '021U',
                  '021C',
                  '111D',
                  '111U',
                  '030T',
                  '030C',
                  '201',
                  '120D',
                  '120U',
                  '120C',
                  '210',
                  '300')
tc_full <- triad.census(krack_full)
tc_advice <- triad.census(krack_advice)
tc_friendship <- triad.census(krack_friendship)
tc_reports_to <- triad.census(krack_reports_to)

triad_df <- data.frame(census_labels,
                       tc_full, 
                       tc_advice, 
                       tc_friendship,
                       tc_reports_to)
triad_df

# To export any of these vectors to a CSV for use in another program, simply
# use the write.csv() command:
write.csv(triad_df, './Stanford/krack_triads.csv')

