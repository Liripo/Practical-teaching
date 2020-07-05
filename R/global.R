library(tidyverse)
library(shiny)
library(shinydashboardPlus)
library(shinydashboard)
library(shinyWidgets)
library(echarts4r)
library(echarts4r.maps)
library(shinycssloaders)
#library(firebase) #邮箱登录这些，暂时不用
library(shinymanager)
library(keyring)
#library(thematic) #一键改主题，没必要
library(showtext)
library(glue)
library(shinyAce)
#library(reactlog) #响应图调试
#-------------------------
#covid_data <- nCov2019::get_nCov2019(lang = "en")
chinese <- covid_data[]
global <- covid_data$global
global_map <- function(data){
  cns <- countrycode::codelist$country.name.en
  cns <- data.frame(countrys = cns)
  cns <- cns %>% left_join(data,by = c("countrys" = "name"))
  cns %>% 
    e_charts(countrys) %>% 
    e_map(confirm) %>% 
    e_visual_map(confirm)
}
#加入字体，需要时可以加入谷歌字体或则字体放入本地
#加入未来荧黑字体，可商用
font_paths("./tff/")
#css图片加载动画这些
#options(spinner.color="#0dc5c1") #设置全局颜色
#激活log
#options(shiny.reactlog = TRUE)
# 一旦 Shiny 应用关闭，展示响应图
#shiny::reactlogShow()
ggcor <- function(){
  value <- read_lines("./data/ggcor.R")
  value <- paste0(value[1:length(value)],collapse = "\n")
}