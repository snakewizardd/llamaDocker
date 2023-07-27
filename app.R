llamaGenerator <- function(inputTopic, inputDescription){

textToWrite <- paste0('Contraint: Keep your response under 200 characters
                      Topic: ',inputTopic,' 
                      Description: ',inputDescription, '
                      Bot: ')

fileConn<-file("./prompts/newText.txt")
writeLines(textToWrite, fileConn)
close(fileConn)

llamaOutput <- system("./main -m ./models/7B/ggml-model-q4_0.bin -n 1024 --repeat-penalty 1.0 -f ./prompts/newText.txt", intern = TRUE)
#system("./main -m ./models/7B/ggml-model-q4_0.bin -n 1024 --repeat-penalty 1.0 -f ./prompts/newText.txt", intern = TRUE)

library(data.table)

response <- llamaOutput[which(llamaOutput %like% 'Bot: '):length(llamaOutput)]

return(response)

}

library(shiny)

ui <- fluidPage(
  
  includeCSS('www/styles.css'),
  h3('Llama2 Generator'),
  textInput('inputForm','Topic'),
  textInput('inputForm2','Description'),
  actionButton('Submit','Submit'),
  verbatimTextOutput('outputLlama')
)

server <- function(input,output,session){
  

  gen <- eventReactive(input$Submit,{
    
    
      
      return(llamaGenerator(input$inputForm, input$inputForm2))
    
    
    
  })

output$outputLlama <- renderText({
  
  gen() 
  
})
}
  
shinyApp(ui,server)