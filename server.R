

shinyServer(function(input, output){
  
#by Date
  filteredcrime <- reactive({
      crime.type.grp %>% 
    filter(rdate >= input$dateC[1] & rdate <=input$dateC[2]) 
    # %>% group_by(crime.type) %>%
    # summarise(n= n()) %>%
    na.omit()
   # print(x)
  })
  

     output$hist <- renderPlot({
       filteredcrime() %>%
        group_by(crime.type) %>%
        #  summarise(n= n()) %>%
          ggplot(crime.type.grp, aes(x = crime.type, y = NumCrimeType)) +
           geom_bar() 
            
       })
     
     #plot2
     output$regionPlot <- renderPlot({
       
       # Render a barplot 
       ggplot(londonDT  %>% filter (lsoa.name == input$region) %>% group_by(crime.type)%>% summarise(n= n()), aes(x = crime.type, y = n))+
                geom_bar(stat = "identity") 
           
     })



  
    output$londonmap <- renderLeaflet({
     # london2017 %>%
      leaflet()%>%
      addTiles() %>%
       # setView(51.509865, -0.118092, zoom = 12) %>%
         addProviderTiles(providers$Esri.WorldStreetMap)%>%
        
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Drugs'),  
                   group = "Drugs" ) %>%
                                     
        addCircleMarkers(data = london2017 %>% filter (crime.type =="Burglary"),lng=~longitude, lat=~latitude, group = "Burglary", popup = ~paste (crime.type ))%>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == "Bicycle theft"), group = "Bicycle theft") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Anti-social behaviour'), group = "Anti-social behaviour") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Vehicle crime'), group = "Vehicle crime") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Criminal damage and arson'), group = "Criminal damage and arson") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Possession of weapons'), group = "Possession of weapons") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Violence and sexual offences'), group = " Violence and sexual offences") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Public order'), group = "Public order") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Shoplifting'), group = "Shoplifting") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Theft from the person'), group = "Theft from the person") %>%
        addCircleMarkers(data = london2017 %>% filter (crime.type == 'Other Crime'), group = "Other Crime") %>%
  
    
        addLayersControl(
       baseGroups = c("Drugs", "Burglary", "Bicycle theft","Anti-social behaviour","Vehicle crime","Criminal damage and arson","Possession of weapons",
       " Violence and sexual offences","Public order","Shoplifting","Theft from the person","Other Crime"),

        # overlayGroups = c("Drugs", "Burglary", "Bicycle theft","Anti-social behaviour","Vehicle crime","Criminal damage and arson","Possession of weapons",
        #                   " Violence and sexual offences","Public order","Shoplifting","Theft from the person","Other Crime"),
        
        options = layersControlOptions(collapsed = TRUE) # popup menu
      
        )
      

    })
    
    
    #Stop and Serach Map
    
    output$londonstop <- renderLeaflet({
    londonstop2017 %>%
      leaflet()%>%
      #addPolylines()%>%
      #addTiles() %>%
      addProviderTiles(providers$Esri.WorldStreetMap)%>%
        
      addMarkers(  lng = ~longitude,
                   lat = ~latitude,
                   # fillColor = "yellow",
                   #radius =~ 15,
                   
                   popup = ~paste("Type: ",
                                  type ,
                                  "<br/>",
                                  "Gender : ",gender,
                                  "<br/>",
                                  "Outcome: ",outcome,
                                  "<br/>",
                                  # "Search reason :",object.of.search,
                    group = "Drugs"
                                  
                                  
                   ))
   
      
    })
    
    
    
    
    
    # # show histogram using googleVis
    # output$hist <- renderGvis({
    #     gvisHistogram(crime.type.grp[,input$selected, drop=FALSE])
    # }),
    
    # show data using DataTable
    output$table <- DT::renderDataTable({
        datatable(londonDT, rownames=FALSE) %>% 
            formatStyle(input$selected, background="skyblue", fontWeight='bold')
    })
    

    # )
    
    # show statistics using infoBox
    # output$maxBox <- renderInfoBox({
    #     max_value <- max(crime.type[,input$selected])
    #     max_state <- 
    #         state_stat$state.name[state_stat[,input$selected] == max_value]
    #     infoBox(max_state, max_value, icon = icon("hand-o-up"))
    # })
    # output$minBox <- renderInfoBox({
    #     min_value <- min(state_stat[,input$selected])
    #     min_state <- 
    #         state_stat$state.name[state_stat[,input$selected] == min_value]
    #     infoBox(min_state, min_value, icon = icon("hand-o-down"))
    # })
    # output$avgBox <- renderInfoBox(
    #     infoBox(paste("AVG.", input$selected),
    #             mean(state_stat[,input$selected]), 
    #             icon = icon("calculator"), fill = TRUE))
})