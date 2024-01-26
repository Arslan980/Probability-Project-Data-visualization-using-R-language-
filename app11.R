# Install necessary packages if not already installed
if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite")
}
if (!requireNamespace("car", quietly = TRUE)) {
  install.packages("car")
}

library(shiny)
library(ggplot2)
library(jsonlite)
library(car)
library(knitr)

# Provided data
Values <- c(27.9, 16.4, 22.6, 25.7, 20.5, 20.9, 22.5, 19.9, 16.8, 23.5, 22.1, 25.7, 27.1, 28.6, 34.8, 26.6, 24.3, 22.8, 28, 23.9, 
            29.6, 26.7, 27.1, 18.3, 29.1, 16.4, 28.4, 19.4, 20.9, 20.4, 24.2, 28.5, 27.5, 27.3, 28.7, 24.5, 26.7, 24.9, 25.3, 
            23.6, 21, 29.1, 25.2, 26.7, 28.3, 35.7, 25.2, 21.8, 9.4, 13.2, 9.1, 8.7, 12, 13.5, 14.1, 12.9, 19.3, 9.5, 11.9, 11, 
            9.2, 9.8, 10.3, 10.2, 10.5, 11, 11.7, 11.3, 11.2, 17.2, 12.7, 12.5, 7.6, 7, 12.5, 12.2, 8.9, 10.8, 13.4, 10.7, 13.9, 
            10.3, 12.1, 12.1, 9, 16, 11.4, 15.1, 9.5, 9.8, 8.8, 9.6, 13.3, 9.9, 12.2, 16, 6.4, 8.5, 11.4, 28.9, 29, 20.5, 30.3, 
            21.9, 27.7, 29.4, 23, 27.6, 26.2, 24.3, 21.1, 26, 25.3, 27.7, 30.1, 30.8, 36.2, 29.9, 28.5, 26.1, 32.5, 28, 32.9, 
            27.7, 29.9, 24.8, 31.3, 19.2, 31.7, 24.4, 25.2, 26.3, 26.9, 30.9, 29.3, 29.5, 33.2, 27.9, 29.9, 27.8, 28.1, 26.8, 
            24.1, 32.7, 27.9, 29.2, 33.1, 36.8, 27.5, 26.3, 12.1, 15.8, 10.8, 15.1, 13.4, 10.6, 9.2, 6.6, 20.8, 9.3, 11.2, 8.2, 
            12.1, 14.4, 9.7, 8.9, 14.3, 14.7, 9.9, 10.8, 11.9, 12.9, 12.1, 11.3, 13.4, 12, 12.6, 10.4, 11.1, 10.1, 7.8, 12.7, 
            11.2, 8.7, 8, 8.5, 13, 15.6, 9.5, 7.5, 9, 7.9, 11.6, 12.7, 17.9, 11.9, 10.1, 14.8, 9.8)

LowCI <- c(24.2, 14.2, 19.4, 22.2, 15.9, 16.3, 19.1, 16.9, 11.8, 20.4, 17.8, 22.2, 23.2, 23.9, 30.2, 20.9, 20, 19.6, 24.8, 21.3, 
           25.6, 21.8, 22.9, 15.3, 24.7, 13.1, 24.5, 16.4, 17.3, 15.8, 20.3, 23.2, 23.3, 22.6, 24.9, 20.6, 21.3, 20.8, 19.9, 
           20, 18.4, 24.7, 21, 22.9, 25.3, 29.6, 21.4, 17.9, 6.1, 10, 7.2, 5.9, 9.9, 11.3, 11.3, 9.4, 15.4, 7.4, 9.6, 7.5, 7.1, 
           7.8, 7.6, 7.3, 8, 7.6, 7.4, 8, 9.1, 14.1, 10.1, 9.5, 5.1, 4.8, 8.9, 8.3, 6.5, 7.9, 10.4, 7.8, 10.2, 10.7, 8.3, 10.4, 
           8.6, 8.4, 8.1, 5.2, 10, 8.2, 6.4, 5.3, 6.1, 10, 13.7, 6.8, 4.5, 6.1, 5.3, 9.2, 10.3, 14.8, 8.2, 7.1, 12.5, 6.6)

HighCI <- c(31.9, 18.8, 26, 29.5, 25.7, 26.2, 26.3, 23.2, 22.8, 26.8, 26.9, 29.6, 31.4, 33.6, 39.5, 32.9, 29.1, 26.2, 31.3, 26.6, 
            33.8, 32.2, 31.7, 21.5, 33.8, 20.1, 32.6, 22.8, 24.8, 25.6, 28.4, 34.3, 32, 32.3, 32.7, 28.7, 32.6, 29.4, 31.2, 27.4, 
            23.9, 33.9, 29.8, 30.8, 31.5, 42.2, 29.2, 26.2, 13.8, 17, 11.2, 12.4, 14.5, 15.9, 17.4, 17.2, 23.7, 11.8, 14.6, 15.3, 
            11.7, 12.1, 13.6, 13.8, 13.6, 15.3, 17.3, 15.5, 13.6, 20.6, 15.7, 16, 10.9, 9.7, 17, 16.9, 11.8, 14.3, 16.9, 14.1, 
            16.9, 13, 17.7, 17.5, 12.2, 19, 14.4, 19.6, 12.6, 14.4, 11.7, 11.6, 16.3, 13.4, 15.6, 18.6, 8.8, 11.7, 16, 34, 34.2, 
            23.5, 34.7, 24.9, 31.3, 33.3, 28.3, 33, 30.3, 27.7, 27.4, 29.7, 30.2, 31.1, 34.7, 36, 41, 36.6, 33.9, 29.6, 35.9, 
            30.8, 37.1, 33.1, 34.7, 29.3, 36.2, 23.3, 36, 28, 29.5, 31.3, 31.1, 36.6, 34, 34.7, 37.3, 32.3, 35.8, 32.7, 34.5, 
            30.3, 27, 37.2, 32.5, 33.4, 36.7, 43.2, 31.7, 31.5, 16.7, 19.4, 13.6, 18.7, 15.9, 13.6, 11.5, 10.8, 26.9, 11.9, 
            14.8, 12.2, 15.2, 18.1, 13, 12.2, 17.4, 19.6, 15.5, 14.6, 15.4, 15.5, 15.1, 15.2, 20.1, 15.8, 17.6, 12.7, 14.6, 
            14.1, 11, 15.9, 15, 11.7, 11.6, 11.4, 16.6, 19, 12.8, 11.8, 12.6, 11.1, 14.2, 15.4, 21.4, 16.5, 13.8, 17.4, 13.8)

# Create a data frame

min_length <- min(length(Values), length(LowCI), length(HighCI))
Values <- Values[1:min_length]
LowCI <- LowCI[1:min_length]
HighCI <- HighCI[1:min_length]
df <- data.frame(Value = Values, LowCI = LowCI, HighCI = HighCI)
# UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background-color: #ff8cbf; /* Set your preferred background color */
      }
    "))
  ),
  titlePanel("Mental Health Data Visualization Desktop App"),
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "input.submitButton === 0",
        textInput("userName", "Enter Your Name", value = ""),
        actionButton("submitButton", "Submit")  # New submit button
      ),
      conditionalPanel(
        condition = "input.submitButton > 0",
        h3(textOutput("welcomeText"))
      ),
      selectInput("plotType", "Select Choice Graphical Or Tabular", 
                  choices = c("Scatter Plot", "Histogram", "Bar Chart", "Box Plot", "Line Plot")),
      actionButton("graphicalButton", "Graphical Representation"),
      actionButton("tabularButton", "Tabular Representation"),
      actionButton("regressionButton", "Show Regression Info")  # New button for regression info
    ),
    mainPanel(
      uiOutput("output"),
      verbatimTextOutput("errorText"),
      verbatimTextOutput("regressionInfoOutput")  # Output for regression info
    )
  )
)

# Server
server <- function(input, output, session) {
  
  user_name_submitted <- reactiveVal(FALSE)  # Reactive value to track whether the username is submitted
  
  observeEvent(input$submitButton, {
    # Check if the username is submitted
    if (!is.null(input$userName) && input$userName != "") {
      user_name_submitted(TRUE)
    }
  })
  
  output$errorText <- renderText({
    # Check if the username is submitted before rendering any text
    req(user_name_submitted())
    ""
  })
  
  output$output <- renderUI({
    # Check if the username is submitted before allowing other interactions
    req(user_name_submitted())
    
    if (input$graphicalButton > 0) {
      plotOutput("plot")
    } else if (input$tabularButton > 0) {
      tableOutput("table")
    } else {
      # Default output, you can customize as needed
      textOutput("defaultOutput")
    }
  })
  
  output$plot <- renderPlot({
    # Check if the username is submitted before generating a plot
    req(user_name_submitted())
    
    switch(input$plotType,
           "Scatter Plot" = plot(df$Value, df$LowCI, col='blue', pch=16, main='Scatter Plot', xlab='Values', ylab='Confidence Interval'),
           "Histogram" = hist(df$Value, breaks=7, col='pink', border='brown', main='Histogram', xlab='Values', ylab='Frequency'),
           "Bar Chart" = barplot(df$HighCI, names.arg=df$Value, col='yellow', border='red', main='Bar Chart', xlab='Values', ylab='Confidence Interval'),
           "Pie Chart" = pie(df$Value, col=c('red', 'blue', 'yellow', 'pink'), main='Pie Chart'),
           "Box Plot" = ggplot(df, aes(x=factor(Value), y=LowCI, fill=factor(Value))) +
             geom_boxplot() +
             scale_fill_manual(values=c('grey', 'green', 'blue', 'brown')) +
             labs(title='Box Plot', x='Values', y='Confidence Interval') +
             theme_minimal(),
           "Line Plot" = ggplot(df, aes(x=Value, y=LowCI)) +
             geom_line(color='blue') +
             labs(title='Line Plot', x='Values', y='Confidence Interval') +
             theme_minimal()
    )
  })
  
  # Render a table based on the selected plot type
  output$table <- renderTable({
    # Check if the username is submitted before rendering a table
    req(user_name_submitted())
    
    switch(input$plotType,
           "Scatter Plot" = df,
           "Histogram" = {
             hist_result <- hist(df$Value, breaks=7, plot=FALSE)
             data.frame(Values = hist_result$mids, Frequency = hist_result$counts)
           },
           "Bar Chart" = data.frame(Values = df$Value, HighCI = df$HighCI),
           "Pie Chart" = data.frame(Values = df$Value),
           "Box Plot" = df,
           "Line Plot" = df
    )
  })
  
  # Default output, you can customize as needed
  output$defaultOutput <- renderText({
    # Check if the username is submitted before rendering default output
    req(user_name_submitted())
    
    paste("Hello, ", input$userName, "! Select a representation type above.")
  })
  
  # Update the output$regressionInfoOutput in the server function
  output$regressionInfoOutput <- renderPrint({
    # Check if the username is submitted before showing regression info
    if (input$regressionButton > 0 && user_name_submitted()) {
      fit <- lm(HighCI ~ Value, data = df)
      
      # Extract the coefficients and other information
      coef_summary <- summary(fit)
      coefficients <- coef_summary$coefficients
      
      # Format coefficients table
      formatted_coef <- cbind(
        Coefficient = rownames(coefficients),
        Estimate = coefficients[, 1],
        `Std. Error` = coefficients[, 2],
        `t value` = coefficients[, 3],
        `Pr(>|t|)` = coefficients[, 4]
      )
      
      # Additional regression information
      r_squared <- coef_summary$r.squared
      f_statistic <- coef_summary$fstatistic
      
      # Create a well-formatted output
      output_text <- paste(
        "Regression Coefficients:\n",
        knitr::kable(formatted_coef, align = "c", digits = 3),
        sprintf("\n\nR-squared: %.3f", r_squared),
        sprintf("\nF-statistic: %.2f on %d and %d DF, p-value: %.3e", 
                f_statistic[1], f_statistic[2], f_statistic[3], coef_summary$coefficients[2, 4])
      )
      
      cat(output_text)
    }
  })
  
  # Render welcome text
  output$welcomeText <- renderText({
    # Check if the username is submitted before rendering welcome text
    req(user_name_submitted())
    paste("Welcome, ", input$userName, "!")
  })
}

# Run the application
shinyApp(ui = ui, server = server)