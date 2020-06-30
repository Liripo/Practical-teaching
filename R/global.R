library(tidyverse)
library(shiny)
library(shinydashboardPlus)
library(shinydashboard)
library(shinyWidgets)
covid_data <- nCov2019::get_nCov2019()
chinese <- covid_data[]
global <- covid_data$global
