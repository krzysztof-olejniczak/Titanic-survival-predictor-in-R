#author: Krzysztof Olejniczak

library(shiny)

shinyUI(fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  tags$div(class = "container",
    titlePanel("Titanic survival predictor"),
    
    fluidRow(
      column(4,tags$div(class="input",
             textInput("firstname", label = h3("Firstname"), value = ""))),
      column(4,tags$div(class="input",
             textInput("lastname", label = h3("Surname"), value = "")))
    ),
    fluidRow(
      column(4,tags$div(class="input",
             radioButtons("sex", label = h3("Sex"),
                          choices = list("male" = "male", "female" = "female"), selected = "male"))),
      column(4,tags$div(class="input",
             numericInput("age", label = h3("Age"), value = 20))),
      column(4,tags$div(class="input",
             selectInput("class", label = h3("Class"),
                         choices = list("Class 1" = 1,
                                        "Class 2" = 2,
                                        "Class 3" = 3), selected = 1)))
    ),
    fluidRow(
      column(6,
        actionButton("calculate", "Calculate ticket price and your chances to survive")
      )
    ),
    fluidRow(
      column(6,
        tags$div(class="titanicPhoto",tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/RMS_Titanic_3.jpg/1024px-RMS_Titanic_3.jpg", width = "409px", height = "301px"))
      ),
      column(1),
      column(5,
        h3(textOutput("name")),
        h3(textOutput("price")),
        plotOutput("chancesPlot")
      )
    )
  )
)
)