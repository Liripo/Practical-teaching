piinputUI <- function(id = "pi"){
  id <- id
  tabItem(id,
    tabsetPanel(
      tabPanel(title = "说明",
        withMathJax(includeMarkdown("./rmd/蒙特卡洛计算Π.md"))  
      ),
      tabPanel(title = "run",
        fluidPage(
          fluidRow(
            column(6,sliderInput("run_number", "Number of sample:",
            min = 100, max = 10000, value = 1000)),
            column(6,actionButton("run",label = "Run"))
          ),
          fluidRow(
            uiOutput("run1")
          ),
          fluidRow(
            uiOutput("run2")
          )
        )
      )
    )
  )
}



pi_data <- function(n){
  x0 <- 0
  y0 <- 0
  x <- runif(n)
  y <- runif(n)
  distances <- sqrt((x-x0)^2+(y-y0)^2)
  point <- ifelse(distances <= 1, "inside", "outside")
  id <- 1:n
  pi_predict <- cumsum(point == "inside")/id * 4
  data <- data.frame(id, x, y, distances, point, pi_predict)
}

make_run1 <- function(data){
  ggplot(data) + 
    geom_rect(aes(xmin = 0,xmax = 1,ymin = 0, ymax = 1),color = "black",alpha = 0) +
    ggforce::geom_arc0(aes(x0 = 0, y0 = 0,r = 1,
      start = 0,end = pi/2)) +coord_fixed() +
    geom_point(data = data1000,aes(x,y,color = point,group = id)) +
    transition_reveal(along = id) +
    labs(title = "frame:{frame} of {nframes}")
  anim2 <-animate(anim, nframes = 100, fps = 10,
    width = 550, height = 540, res = 90,
    renderer = gifski_renderer(loop = T))
}

make_run2 <- function(pi_data){
  anim <- ggplot(pi_data,aes(id ,pi_predict)) +
    geom_line() +
    geom_point(aes(group = seq_along(id)),color = "red",size = 1)+
    transition_reveal(id)+
    geom_hline(yintercept = pi)
  anim2 <-animate(anim, nframes = 100, fps = 10,
    width = 550, height = 540, res = 90,
    renderer = gifski_renderer(loop = T))
}