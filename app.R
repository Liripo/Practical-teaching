#-------------
#ui
#-------------
ui <- dashboardPagePlus(
  skin = "blue",
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
      menuItem("File",tabName = "file",icon = icon("file")),
      menuItem("R",tabName = "r",icon = icon("feather-alt")),
      menuItem("pi",tabName = "pi",icon = icon("crow"))
    )
  ),
  #-------------
  body = dashboardBody(
    tabItems(
      tabItem(
        "search",
        fluidRow(
          h1("点击搜索按钮一下",
            a(href = "https://github.com/welai/glow-sans","by(未来荧黑字体)")),
          shinyWidgets::searchInput(inputId = "search",btnSearch = icon("search"),
                                  width = "30%"),
        ),
        fluidRow(
          DT::DTOutput("search_out"),
        ),
        fluidRow(
          echarts4rOutput("global_map") %>% withSpinner(),
        )
      ),
      tabItem(
        "file",
        fluidRow(
          h1("file input"),
          fileInput("file_input",label = "")
        ),
        fluidRow(
          boxPlus(
            title = "file download",
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
      ),
      tabItem("r",
        h1("ggcor-teaching",class = "btn btn-primary"),
        fluidRow(
          column(6,
            aceEditor("r-or", mode = "r", 
              value = ggcor(),height = "400pt",
              fontSize = 20,theme = "xcode")
          ),
          column(6,
            gradientBox(
              plotOutput("ggcor")
            )
          )
        ),
        fluidRow(
          actionButton("eval", "Run"),
        )
      ),
      tabItem("pi",
        tabsetPanel(
          tabPanel(title = "说明",
            withMathJax(includeMarkdown("./rmd/蒙特卡洛计算Π.md"))  
          ),
          tabPanel(title = "run",
              fluidRow(
                column(6,sliderInput("run_number", "Number of sample:",
                  min = 100, max = 10000, value = 1000)),
                column(6,actionButton("run",label = "Run"))
              ),
              fluidRow(column(6,
                imageOutput("run1",height = "300px")),
              column(6,
                imageOutput("run2",height = "300px"))
            )
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
    Sys.sleep(5)
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
  #--------------------
  observe({
    comletes <- c("text","static","rlang")
    updateAceEditor(session, "r-or", autoComplete = "live",
      autoCompleters = comletes)
  })
  ror <- aceAutocomplete("r-or")
  observe(
    ror$resume()
  )
  output$ggcor <- renderPlot({
    req(input$eval)
    input$eval
    eval(parse(text = isolate(input$`r-or`)))
  })
  #------------------
  observeEvent(input$run,{
    pidata <- reactive({n <- pi_data(input$run_number)})
    output$run1 <- renderImage({
      a <- make_run1(pidata());
      path <- a %>% fs::path();
      list(src = path)},deleteFile = F)
    output$run2 <- renderImage({b <- make_run2(pidata());
    path <- b %>% fs::path()
    list(src = path)},deleteFile = F)
  })
  #--------验证之后才能进入
  #res_auth <- secure_server(
  #  check_credentials = check_credentials("database.sqlite",passphrase = key_get("liripo")))
}
#验证后登录
#ui <- secure_app(ui,enable_admin = T)
#------------------------------
ui <- shinyUI(fluidPage(
  tags$link(rel = "stylesheet",href = "mycss.css"),
  ui %>% div(class = "font")
))

shinyApp(ui, server)
