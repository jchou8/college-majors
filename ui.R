#Require shiny
library(shiny)
library(plotly)

# Generate list of major categories
data <- read.csv("data/all-ages.csv", stringsAsFactors = FALSE)
categories <- sort(data$Major_category)

# Page on most popular majors
popularity <- tabPanel('Popularity',
                titlePanel('Most Popular Majors'),
                p("This plot displays the most popular college majors."),
                
                sidebarLayout(
                  sidebarPanel(
                    #radioButtons('sex', label = 'Sex', choices = list("Female" = "Women", "Male" = "Men", "Both" = "Total"), selected = "Total"),
                    selectInput('category', label = 'Category', choices = c("Overall", categories), selected = "Overall"),
                    sliderInput('num.majors', label = 'Number to Display', min = 1, max = 10, value = c(1, 10))
                  ),
                
                  mainPanel(
                    plotlyOutput('popularity')
                  )
                )
              )

# Page on major salaries
salaries <- tabPanel('Salaries',
                       titlePanel('Majors by Median Salary'),
                       p("Under construction!"),
                       
                       sidebarLayout(
                         sidebarPanel(
                           selectInput('category', label = 'Category', choices = c("Overall", categories), selected = "Overall"),
                           sliderInput('num.majors', label = 'Number to Display', min = 1, max = 10, value = c(1, 10))
                         ),
                         
                         mainPanel(
                           #plotlyOutput('popularity')
                         )
                       )
)

shinyUI(navbarPage('College Majors',
  popularity,
  salaries
                   
))
