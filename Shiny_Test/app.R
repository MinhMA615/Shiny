# Truc Minh Nguyen
# Shiny Assignment
# 11/15/2024

install.packages("shiny")
install.packages("reactable")
library(shiny)


#HW Question 1: Collaborated with Maggie Lin
#What is the difference between Hadley_1 and Hadley_2? 
#Use the functions Katia showed last Wednesday to investigate the difference.

# In Mastering Shiny, Hadley Wickham introduces 2 versions of basic shiny. 
# 
# Version 1: allows user to select dataset from datsets package, then display
# summary statistics and the dataset itself. 
# 
# Version 2: refines app by organizing the code, making it more readable and modular. 
# Wickham explains by showing the same app twice, and how to iteratively improve shiny.
# 
# Version 2 draws parallel to Katia's lecture last week on code optimization. She emphasizes
# that even with loops we want to write it in such a way that does not take up to much memory
# and run efficiently. I think we do that by first creating empty vectors, matrix, etc.
# data types, and then fill them in as we loop. 



# The exercises were reference in the Mastering-Shiny Textbook
# and the corresponding solution manual after reading through chapters 2-4.

##Exercise 2.3.5
#1a. renderPrint(summary(mtcars)) paired with verbatimTextOutput 
#since it is console output.

#1b. renderText("Good morning!") paired with textOutput 
#since it is regular text.

#1c. renderPrint(t.test(1:5, 2:6)) paired with verbatimTextOutput 
#since it is console output.

#1d. renderText(str(lm(mpg ~ wt, data = mtcars))) paired with verbatimTextOutput 
#since it is console output.

#2. Re-create the Shiny app from Section 2.3.3, 
#this time setting height to 300px and width to 700px.

ui <- fluidPage(
  plotOutput("plot", width = "700px", height = "300px")
)

server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5), res = 96, 
                            alt = "Scatterplot of 5 random numbers")
}

shinyApp(ui, server)

#3. Update the options in the call to renderDataTable() below so that the data is displayed, 
#but all other controls are suppressed 
ui <- fluidPage(
  dataTableOutput("table")
)

server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, 
                                  options = list(pageLength = 5,
                                                 ordering = FALSE, 
                                                 searching = FALSE))
}

shinyApp(ui, server)

#4. Alternatively, read up on reactable, and convert the above app to use it instead

library(reactable)
ui <- fluidPage(
  reactableOutput("table")
)

server <- function(input, output) {
  output$table <- renderReactable({
    reactable(mtcars)
  })
}

shinyApp(ui, server)

##Exercise 3.3.6

# 1A Incorrect Code:
# server1 <- function(input, output, server) {
# input$greeting <- renderText(paste0("Hello ", name))
# }

# 1A Corrected Code: changed input$greeting to output$greeting. In renderText,
# should be input$name not just name.

  server1 <- function(input, output, server) {
  output$greeting <- renderText(paste0("Hello ", input$name))
}

# 1B Incorrect Code:
# server2 <- function(input, output, server) {
#   greeting <- paste0("Hello ", input$name)
#   output$greeting <- renderText(greeting)
# }

# 1B Corrected Code: Make greeting reactive, and add () around it
  server2 <- function(input, output, server) {
  greeting <- reactive(paste0("Hello ", input$name))
  output$greeting <- renderText(greeting())
  }
  
# 1C Incorrect Code
# server3 <- function(input, output, server) {
#     output$greting <- paste0("Hello", input$name)
#   }
#   
  
# 1C Corrected Code: spelling error of greeting, missing renderText
  server3 <- function(input, output, server) {
  output$greeting <- renderText(paste0("Hello ", input$name))
  }
  
# 2 Draw reactive graph
# 2A. 

  if (!requireNamespace("DiagrammeR", quietly = TRUE)) {
    install.packages("DiagrammeR")
  }
  library(DiagrammeR)
  
  # Create the reactive map
  grViz("
  digraph reactive_map {
  graph [layout = dot, rankdir = LR]
  
  # Define node shapes
  node [shape = ellipse, style = filled, color = lightblue]
  input_a [label = 'Input: a']
  input_b [label = 'Input: b']
  input_d [label = 'Input: d']
  
  node [shape = box, style = filled, color = lightgreen]
  reactive_c [label = 'Reactive: c']
  reactive_e [label = 'Reactive: e']
  
  node [shape = oval, style = filled, color = lightcoral]
  output_f [label = 'Output: f']
  
  # Define edges (dependencies)
  input_a -> reactive_c
  input_b -> reactive_c
  reactive_c -> reactive_e
  input_d -> reactive_e
  reactive_e -> output_f
}
")
  
# In this 1st example, a and b are inputs. c and e are reactives. c depends on a and b.
# e depends on c and d. output is f and that depends on e. 
  
# 2B. 
  grViz("
  digraph reactive_map {
  graph [layout = dot, rankdir = LR]
  
  # Define node shapes
  node [shape = ellipse, style = filled, color = lightblue]
  input_x1 [label = 'Input: x1']
  input_x2 [label = 'Input: x2']
  input_x3 [label = 'Input: x3']
  input_y1 [label = 'Input: y1']
  input_y2 [label = 'Input: y2']
  
  node [shape = box, style = filled, color = lightgreen]
  reactive_x [label = 'Reactive: x']
  reactive_y [label = 'Reactive: y']
  
  node [shape = oval, style = filled, color = lightcoral]
  output_z [label = 'Output: z']
  
  # Define edges (dependencies)
  input_x1 -> reactive_x
  input_x2 -> reactive_x
  input_x3 -> reactive_x
  input_y1 -> reactive_y
  input_y2 -> reactive_y
  reactive_x -> output_z
  reactive_y -> output_z
}
")
  
# In this 2nd example, there are 2 reactives: x and y and output z that depends on both of them.
# reactive x has inputs x1, x2, and x3. reactive y has inputs y1 and y2. 
# reactives x and y make up output z. 
  
# 2C.
  grViz("
  digraph reactive_map {
  graph [layout = dot, rankdir = LR]
  
  # Define node shapes
  node [shape = ellipse, style = filled, color = lightblue]
  input_a [label = 'Input: a']
  input_b [label = 'Input: b']
  input_c [label = 'Input: c']
  input_d [label = 'Input: d']
  
  node [shape = box, style = filled, color = lightgreen]
  reactive_a [label = 'Reactive: a']
  reactive_b [label = 'Reactive: b']
  reactive_c [label = 'Reactive: c']
  reactive_d [label = 'Reactive: d']
  
  # Define edges (dependencies)
  input_a -> reactive_a
  reactive_a -> reactive_b
  input_b -> reactive_b
  reactive_b -> reactive_c
  input_c -> reactive_c
  reactive_c -> reactive_d
  input_d -> reactive_d
}
")
  
# This flow is reactive_a takes input_a and multiply it by 10. Then reactive_b takes
# reactive_a and add it to input_b. reactive_c takes reactive_b and divide by input_c
# reactive_d takes reactive_c and raise to the power of input_d. each reactive is a 
# function of the others. 
  
# 3.
  # var <- reactive(df[[input$var]])
  # range <- reactive(range(var(), na.rm = TRUE))
  
# This code will fail because we want to use col_range instead of range. var should 
# also be col_var. This is just the proper syntax. 
  
  
# Exercise 4.8 not sure what the apps are for this? 
  