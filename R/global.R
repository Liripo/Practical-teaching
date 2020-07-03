library(tidyverse)
library(shiny)
library(shinydashboardPlus)
library(shinydashboard)
library(shinyWidgets)
library(echarts4r)
library(echarts4r.maps)
library(firebase) #邮箱登录这些，暂时不用
library(shinymanager)
#-------------------------
covid_data <- nCov2019::get_nCov2019(lang = "en")
chinese <- covid_data[]
global <- covid_data$global
global_map <- function(data){
  cns <- countrycode::codelist$country.name.en
  cns <- data.frame(countrys = cns)
  cns <- cns %>% left_join(data %>% select(1:2),by = c("countrys" = "name"))
  cns %>% 
    e_charts(countrys) %>% 
    e_map(confirm) %>% 
    e_visual_map(confirm)
}


