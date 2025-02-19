library(shiny)
library(ggplot2)
library(DT)
library(bslib)
library(thematic)
library(glue)
library(dplyr)
data("diamonds")

thematic_shiny(font = "auto")

ui <- fluidPage(
    theme = bs_theme(version = 5,
                   bootswatch = "minty"),
    h3("Explorations des Diamants"),

    sidebarLayout(
        sidebarPanel(
        radioButtons(inputId = "Couleur",
                     label = "Colorier les points en rose ?",
                     choices = c("Oui","Non"),
                     selected = "Oui",
                     inline = TRUE),
        selectInput(
          inputId = "choix_couleur",
          choices = sort(unique(diamonds$color)),
          label = "Choisir une couleur à filtrer :",
          selected = NULL,
          multiple = FALSE,
          selectize = TRUE,
          width = NULL,
          size = NULL
        ),
        sliderInput(inputId = "prix",
                    label = "Prix maximum :",
                    min = 300,
                    max = 20000,
                    value = 300),
        actionButton(inputId = "boutton",
                     label = "Afficher une notification"),
        ),
        mainPanel(
           plotOutput("DiamondPlot"),
           DTOutput("DiamandsTable")
        )
    )
)

server <- function(input, output) {

    output$DiamondPlot <- renderPlot({
      diamonds |> 
      filter(price <= input$prix) |>
      filter(color == input$choix_couleur) |>
      ggplot(aes(x= carat, y = price)) +
      geom_point(color = ifelse(input$Couleur == "Oui", "pink", "black"),
                 size = 1) +
        labs(
          title = glue("prix : {input$prix} & color : {input$choix_couleur}")
        )
    })
    output$DiamandsTable <- renderDT({
      diamonds |>
        filter(price <= input$prix) |>
        filter(color == input$choix_couleur) |>
        select(carat, cut, color, clarity, depth, table, price)
    })
    observeEvent(input$boutton, { 
      showNotification(glue("prix: {input$prix} & color: {input$choix_couleur}"), 
                       type = "message") 
      })
}

shinyApp(ui = ui, server = server)
