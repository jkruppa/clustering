library(shiny)


shinyUI(fluidPage(
    titlePanel("Visualisation of different clustering methods"),
    sidebarLayout(
        ## sidebar panel
        sidebarPanel(
            ## Controls
            h3("Controls"),
            sliderInput("ratio", 
                        "Balanced data", 
                        min = 0.1,
                        max = 1,
                        value = 0.2,
                        step = 0.1),
            helpText("Sample size ratio of the three randomly generated groups with n = 100 if the ratio is 1. Otherwise the three groups have the sample size determined by n * ratio, n * 1, n * 1/ratio."),
            sliderInput("k", 
                        "Number of assumed clusters", 
                        min = 2,
                        max = 10,
                        value = 3,
                        step = 1),
            helpText("The number of assumed clusters k for the methods below."),
            ## Define the sidebar with one input
            selectInput("method", "Method:", 
                        choices = c("k-means", "c-means", "mclust")),
            helpText("The clustering can be done with three different methods: k-means, the standard approach by Harting and Wong (1979), c-means, the support vector machine implementation by Meyer et al. (2015), or through mclust by Fraley and Raftery (2002)."),
            hr(),
            ## Dependencies
            h3("Dependencies"),
            p("The following R packages are needed for the shiny app."),
            code('install.packages("shiny")'),
            br(),
            code('install.packages("ggplot2")'), 
            br(),
            code('install.packages("plyr")'),
            br(),
            code('install.packages("dplyr")'), 
            br(),
            code('install.packages("e1071")'), 
            br(),
            code('install.packages("mclust")'), 
            br(),
            code('install.packages("broom")'), 
            hr(),
            ## References
            h3("References"),
            p("Fraley C and Raftery AE (2002) 'Model-based Clustering, Discriminant Analysis and Density Estimation'. Journal of the American Statistical Association 97:611-631"),
            p("Meyer D, Dimitriadou E, Hornik K, Weingessel A and Leisch F (2015). 'e1071: Misc Functions of the Department of Statistics, Probability Theory Group (Formerly: E1071)', TU Wien. R package version 1.6-7."), 
            p("Hartigan JA and Wong MA (1979). 'A K-means clustering algorithm'.  Applied Statistics 28, 100-108.")
        ),
        ## main panel
        mainPanel(
            plotOutput("plots", width = "100%", height = "600px")
        ),
    )
))
