library(shiny)
library(ggplot2)
library(DT)
library(thematic)
data("diamonds")

thematic_shiny(font = "auto")

ui <- fluidPage(
    theme = bs_theme(version = 5,
                   bootswatch = "minty"),
    titlePanel("Explorations des Diamants"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),
        radioButtons(inputId = "Couleur",
                     label = "Colorier les points en rose ?",
                     choices = c("Oui","Non"),
                     selected = "Oui",
                     inline = TRUE),
        actionButton(inputId = "boutton",
                     label = "Afficher une notification"),
        
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

server <- function(input, output) {

    output$distPlot <- renderPlot({
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

shinyApp(ui = ui, server = server)
