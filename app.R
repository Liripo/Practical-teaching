#-------------
#ui
#-------------
ui <- dashboardPagePlus(
  skin = "yellow-light",
  enable_preloader = T,#加载
  loading_duration = 1,
  header = dashboardHeaderPlus(
    #添加标题隐藏后显示图片
    title = tagList(tags$span("Practical-teaching",class = "logo-lg"),
      tags$img(src = "ShinyDashboardPlus_FINAL.svg"))
  ),
  #---------
  sidebar = dashboardSidebar(
    sidebarMenu(
      menuItem("Search",tabName = "search",icon = icon("search")),
      menuItem("File",tabName = "file",icon = icon("file"))
    )
  ),
  #-------------
  body = dashboardBody(
    tabItems(
      tabItem(
        "search",
        fluidRow(
          shinyWidgets::searchInput(inputId = "search",btnSearch = icon("search"),
                                  width = "30%"),
        ),
        fluidRow(
          DT::DTOutput("search_out"),
        ),
        fluidRow(
          echarts4rOutput("global_map")
        )
      ),
      tabItem(
        "file",
        fluidRow(
          fileInput("file_input",label = "File input")
        ),
        fluidRow(
          boxPlus(
            title = "file input and down",
            closable = TRUE, 
            enable_label = TRUE,
            label_text = 1,
            label_status = "danger",
            status = "warning",
            solidHeader = FALSE, 
            collapsible = TRUE,
            tableOutput("file_out"),
            downloadBttn("down_out")
          )
        )
      )
    )
  ),
)
#------------------------------
#server
#------------------------------
server <- function(input, output, session) {
  #查看searchInput源代码发现其id是加上_search
  #---------
  #表达式reactive
  #---------
  observeEvent(input$search_search,{
    data <- reactive({
      global %>% 
       filter(name == input$search)
    })
  #----------------
  #output
  #---------------
  output$search_out <- DT::renderDataTable({
      DT::datatable(global,style = "bootstrap4")
    })
  })
  output$global_map <- renderEcharts4r({
    global_map(data = global)
  })
  output$file_out <- renderTable({
    req(input$file_input)
    cat(str(input$file_input),"\n")
    data.table::fread(input$file_input$datapath)
  })
  output$down_out <- downloadHandler(
    filename = function() {
      paste('data-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      write.csv(mtcars, con)
    }
  )
  #--------验证之后才能进入
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials,
      passphrase = key_get("liripo")))
}
#验证后登录
ui <- secure_app(ui)
#------------------------------
shinyApp(ui, server)