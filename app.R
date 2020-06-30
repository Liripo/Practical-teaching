source("R/global.R")

library(shiny)
ui <- dashboardPagePlus(skin = "red",enable_preloader = T,
  header = dashboardHeaderPlus(
    title = tagList(tags$span("Practical-teaching",class = "logo-lg"),
                              tags$img(src = "ShinyDashboardPlus_FINAL.svg")),
    enable_rightsidebar = TRUE,
    rightSidebarIcon = "gears"
  ),
  sidebar = dashboardSidebar(
    sidebarMenu(
      menuItem("search",tabName = "search",icon = icon("search"))
    )
  ),
  body = dashboardBody(
    tabItems(
      tabItem(
        "search",
        shinyWidgets::searchInput(inputId = "search",btnSearch = icon("search"),
                                  width = "30%"),
        br(),
        box(width = 12,
        DT::DTOutput("search_out")
        )
      )
    )
  ),
  rightsidebar = rightSidebar()
)
#------------------------------
server <- function(input, output, session) {
  data <- reactive({
    global %>% filter(name == input$search)
  })
  output$search_out <- DT::renderDataTable({
    DT::datatable(global,style = "bootstrap4")
  })
}
#------------------------------
shinyApp(ui, server)