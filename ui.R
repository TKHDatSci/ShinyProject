library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = "London Crime Analysis"),
    dashboardSidebar(
        
        sidebarUserPanel("NYC DSA",
                         image = "police.png"), #"https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
        sidebarMenu(
            menuItem("Crime Map", tabName = "map", icon = icon("map")),
            menuItem("Stop and Search Map", tabName = "map2", icon = icon("map")),
            menuItem("Data", tabName = "data", icon = icon("database")),
            
          
            #dateRangeInput("dateC",label = 'Date range input: yyyy-mm-dd',start = minCrimeD, end = maxCrimeD)

            dateInput(
              'Start_Date',
              label = "starting on:",
              value = minCrimeD
            ), ## added comma
            dateInput(
              'End_Date',
              label = "Ending on:",
              value = maxCrimeD
        ),
        
        selectInput( 'region', "Choose Region", selected = "Camden,", choices = region)

        )
      
        # 
        # selectizeInput("selected",
        #                "Select Item to Display",
        #                choice),
        # 
       
        
        #outcome
        # selectInput("ovar", # choose the crime type
        #             label = "Choose an outcome to display on the map.",
        #             # choices = c("Burglary", "Anti-social Behaviour",
        #             #             "Drugs", "Other Crime","Robbery"),
        #             choices =  outcome.type$last.outcome.category,
        #             selected = "Under Investigation")

        
        
    ),
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            tabItem(tabName = "map",
                    # fluidRow(infoBoxOutput("maxBox"),
                    #          infoBoxOutput("minBox"),
                    #          infoBoxOutput("avgBox")),
                    #crime
                    # selectInput("cvar", # choose the crime type
                    #             label = "Choose a Crime Type to display on the map.",
                    #             # choices = c("Burglary", "Anti-social Behaviour",
                    #             #             "Drugs", "Other Crime","Robbery"),
                    #             choices =  crime.type$crime.type,
                    #             selected = "Robbery"),
                    #-----
                    fluidRow(box(leafletOutput("londonmap"), height = 300),
                             box(plotOutput("hist"), height = 300),
                             box(plotOutput("regionPlot"), height = 300, width = 12)
                             
                             )
                    
                    
                    ),
                   
            
            
            tabItem(tabName = "map2",
                    fluidPage(box(leafletOutput("londonstop"), height = 300))),
           
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12)))
        )
    )
))