#author: Krzysztof Olejniczak

library(shiny)

shinyServer(function(input, output) {
  options(warn=-1)
  
  library(ggplot2)
  library(caret)
  
  df <- data.frame(read.csv('titanic.csv'))
  df <- df[complete.cases(df), ]
  df <- df[,c('Survived','Fare','Pclass','Sex','Age')]
  
  set.seed(4983)
  
  #predict chances to survive
  chTraVal <- createDataPartition(df$Survived, p = 0.5, list=FALSE, times=1)
  chTraData <- df[chTraVal,]
  chCtrl <- trainControl(method = "repeatedcv", number = 5, repeats = 10)
  chClassifier <- train(Survived ~ . , data = chTraData, method = 'rf', trControl = chCtrl, ntree = 30)
  
  #predict price
  prTraVal <- createDataPartition(df$Fare, p = 0.5, list=FALSE, times=1)
  prTraData <- df[prTraVal,]
  prCtrl <- trainControl(method = "repeatedcv", number = 5, repeats = 10)
  prClassifier <- train(Fare ~ . , data = prTraData, method = 'rf', trControl = prCtrl, ntree = 20)
  
  observeEvent(input$calculate, {
    if(input$sex == "male") {
      output$name <- renderText({paste("Mr. ", input$firstname, " ", input$lastname)})
    } else {
      output$name <- renderText({paste("Mrs. ", input$firstname, " ", input$lastname)})
    }
    
    percentResult <- round(predict(chClassifier, newdata = data.frame(Pclass = c(as.factor(input$class)), Sex = c(input$sex), Age = c(input$age), Fare = c(0)))*100,2)
    priceResult <- round(predict(prClassifier, newdata = data.frame(Pclass = c(as.factor(input$class)), Sex = c(input$sex), Age = c(input$age), Survived = c(0))),2)
    
    chances.data <- data.frame(chances <- c(0, percentResult, 0), xLabels <- c(""))
    output$chancesPlot <- renderPlot({
      print(ggplot(chances.data, aes(xLabels)) + geom_bar(aes(weight = chances)) + geom_text(aes(y = chances, label = paste(chances,"%")), vjust=-0.2) 
            + labs(x = "Chances to survive", y = "% chances") + ggtitle("Chances to survive")
            + scale_y_continuous(limits = c(0, 100))
      )}, height=300, width=300)
    output$price <- renderText({paste("Predicted price: ",priceResult,"$")})
  })
})
