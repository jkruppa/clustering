library(shiny)
require(plyr)
require(ggplot2)
require(dplyr)
require(e1071)
require(mclust)
require(broom)
set.seed(2015)
# The palette with black:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73",
                "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
## functions for plotting
plot_kmeans <- function(k, method, ratio) {
    ## data generation
    n <- c(100, 100, 100)
    sizes <- n * c(ratio, 1, 1/ratio) 
    set.seed(2015)
    size <- 1.5
    centers <- data_frame(x = c(1, 4, 6), y = c(5, 0, 6), n = sizes,
                          cluster = factor(1:3))
    dat <- centers %>% group_by(cluster) %>%
        do(data_frame(x = rnorm(.$n, .$x), y = rnorm(.$n, .$y)))
    ## clustering
    clust <- dat %>% ungroup %>% dplyr::select(x, y) %>% kmeans(k, nstart = 100)
    ggplot(augment(clust, dat), aes(x, y)) +
        geom_point(aes(color = .cluster), size = size) +
        theme_bw() +
        ggtitle(paste("Method:", method)) + 
        labs(color = "Clustering")
}
plot_mclust <- function(k, method, ratio) {
    ## data generation
    n <- c(100, 100, 100)
    sizes <- n * c(ratio, 1, 1/ratio) 
    set.seed(2015)
    size <- 1.5
    centers <- data_frame(x = c(1, 4, 6), y = c(5, 0, 6), n = sizes,
                          cluster = factor(1:3))
    dat <- centers %>% group_by(cluster) %>%
        do(data_frame(x = rnorm(.$n, .$x), y = rnorm(.$n, .$y)))
    ## clustering
    BIC <- dat %>% ungroup %>% dplyr::select(x, y) %>% mclustBIC(G = k)
    clust <- dat %>% ungroup %>% dplyr::select(x, y) %>% Mclust(x = BIC)
    ggplot(cbind(.cluster = as.factor(clust$classification), as.data.frame(dat)),
           aes(x, y)) +
        geom_point(aes(color = .cluster), size = size) +
        theme_bw() +
        ggtitle(paste("Method:", method)) + 
        labs(color = "Clustering")
}
plot_cmeans <- function(k, method, ratio) {
        ## data generation
    n <- c(100, 100, 100)
    sizes <- n * c(ratio, 1, 1/ratio) 
    set.seed(2015)
    size <- 1.5
    centers <- data_frame(x = c(1, 4, 6), y = c(5, 0, 6), n = sizes,
                          cluster = factor(1:3))
    dat <- centers %>% group_by(cluster) %>%
        do(data_frame(x = rnorm(.$n, .$x), y = rnorm(.$n, .$y)))
    ## clustering
    clust <- dat %>% ungroup %>% dplyr::select(x, y) %>% cmeans(centers = k, method = "ufcl",
                                                                iter.max = 100)
    ggplot(cbind(.cluster = as.factor(clust$cluster), as.data.frame(dat)), aes(x, y)) +
        geom_point(aes(color = .cluster), size = size) +
        theme_bw() +
        ggtitle(paste("Method:", method)) + 
        labs(color = "Clustering")
}


shinyServer(function(input, output) {
    ## build plots
    output$plots <- renderPlot(
        switch(input$method,
               "k-means" = {
                   plot_kmeans(input$k, input$method, input$ratio)
               },
               "c-means" = {
                   plot_cmeans(input$k, input$method, input$ratio)
               },
               "mclust" = {
                   plot_mclust(input$k, input$method, input$ratio)
               })
    )}    
)
