

shinyServer(function(input, output) {
    
    output$rating <- DT::renderDataTable(
        DT::datatable(datResult, options = list(paging = FALSE, searching = FALSE))
    )
    
    output$odds <- DT::renderDataTable(
        DT::datatable(datOdds, options = list(paging = FALSE, searching = FALSE))
    )
    
    output$group <- DT::renderDataTable({
        tmp <- groupStageResult[group == input$group2][order(-p)]
        tmp[, probability := p]
        
        DT::datatable(tmp[, .(first, second, third, forth, probability)], options = list(paging = FALSE, searching = FALSE))
    })
    
    output$matches <- DT::renderDataTable({
        tmp <- knockoutStageResult[round == input$round][order(-p)]
        tmp[, probability := p]
        
        DT::datatable(tmp[, .(team1, team2, probability)], options = list(paging = FALSE, searching = FALSE))
    })
    
    output$ui_heatmap <- renderUI({
        d3heatmapOutput("heatmap", height = 800) 
    })    
    
    output$heatmap <- renderD3heatmap({
        d3heatmap(mat1, dendrogram = "none")
    })
    
    output$chart <- renderChart({
        p1 <- rPlot(x=list(var="code", sort="probability"), y="probability", data=datResult, type='bar')
        p1$guides(x = list(title = "", ticks = unique(datResult$code)))
        p1$addParams(dom = 'chart')
        return (p1)
    })
    
    output$teamChart <- renderChart({
        tmp0 <- teamResult %>% 
            filter(group == input$group1) %>%
            mutate(probability=pWinning, type="winning") %>%
            select(code, probability, type) %>%
            arrange(desc(probability))    
        tmp1 <- teamResult %>% 
            filter(group == input$group1) %>%
            mutate(probability=pFinalist, type="finalist") %>%
            select(code, probability, type) %>%
            arrange(desc(probability))
        tmp2 <- teamResult %>% 
            filter(group == input$group1) %>%
            mutate(probability=pSemiFinalist, type="semiFinalist") %>%
            select(code, probability, type) %>%
            arrange(desc(probability))
        tmp3 <- teamResult %>% 
            filter(group == input$group1) %>%
            mutate(probability=pQuarterFinalist, type="quarterFinalist") %>%
            select(code, probability, type) %>%
            arrange(desc(probability))
        tmp4 <- teamResult %>% 
            filter(group == input$group1) %>%
            mutate(probability=pRoundOfSixteen, type="roundOfSixteen") %>%
            select(code, probability, type) %>%
            arrange(desc(probability))
        tmp <- rbind(tmp0, tmp1, tmp2, tmp3, tmp4)
        
        p1 <- nPlot(probability ~ code, group="type", data=tmp, type = "multiBarChart")
        p1$yAxis(axisLabel="probability", tickFormat = "#! function(d) {return d3.format(',.2f')(d)} !#", width=40)
        p1$addParams(dom = 'teamChart')
        return (p1)
    })
})
