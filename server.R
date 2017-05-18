# Include libraries
require(shiny)
require(dplyr)
require(ggplot2)

# Read in data
all.grads <- read.csv("data/all-ages.csv", stringsAsFactors = FALSE)
recent.grads <- read.csv("data/recent-grads.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output, session) {
  
  popularity.data <- reactive({
    
    # Data by sex is flawed and seems to be inaccurate
    # filtered.data <- recent.grads %>% select(Major, Major_category, Men, Women) %>% 
    #                                   mutate(Total = Men + Women) %>% 
    #                                   filter(Major_category == input$category | input$category == "Overall")
    # 
    # filtered.data <- filtered.data %>% arrange_(paste0("desc(", input$sex, ")"))
    
    
    filtered.data <- all.grads %>% select(Major, Major_category, Total) %>%
                                   filter(Major_category == input$category | input$category == "Overall") %>% 
                                   arrange(desc(Total))
    updateSliderInput(session, "num.majors", max = nrow(filtered.data))
    return(filtered.data)
  })
  
  popularity.data.limited <- reactive({
    limited.data <- popularity.data() %>% top_n(input$num.majors[2]) %>% top_n(-(input$num.majors[2] - input$num.majors[1] + 1))
    return(limited.data)
  })
                    
  output$popularity <- renderPlotly({
    
    # plot <- plot_ly(popularity.data.limited(), type = "bar") 
    # 
    # if (input$sex == "Men" | input$sex == "Total") {
    #   plot <- plot %>% add_trace(y = ~Men, x = ~Major, name = "Male", 
    #                              marker = list(color = "rgb(31, 119, 180)"),
    #                              hoverinfo = "text",
    #                              text = ~paste("Major: ", Major, 
    #                                            "</br>Men: ", Men,
    #                                            "</br>Total: ", Total))
    # }
    # 
    # if (input$sex == "Women" | input$sex == "Total") {
    #   plot <- plot %>% add_trace(y = ~Women, x = ~Major, name = "Female", 
    #                              marker = list(color = "rgb(255, 127, 14)"),
    #                              hoverinfo = "text",
    #                              text = ~paste("Major: ", Major, 
    #                                            "</br>Women: ", Women,
    #                                            "</br>Total: ", Total))
    # }
    # 
    plot <- plot_ly(popularity.data.limited(), type = "bar", x = ~Major, y = ~Total,
                    hoverinfo = "text",
                    text = ~paste("Major: ", Major,
                                  "</br>Number of graduates: ", Total))
    plot <- plot %>% layout(xaxis = list(title = "Major",
                                         categoryorder = "array", categoryarray = popularity.data.limited()$Total), 
                            yaxis = list(title = "Count"),
                            barmode = 'stack',
                            margin = list(b = 80, r = 50))
    
    return (plot)
  })     
  
  output$popularity.table <- renderTable({
    return (popularity.data())
  })
    
})