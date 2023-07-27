inputMessage <- 'You are to assume the role of Llama2 and act as the best DevOps assistant possible.
             Llama2: Yes, sir.
             User:
             '

textToWrite <- paste0(inputMessage)

fileConn<-file("./prompts/newText.txt")
writeLines(textToWrite, fileConn)
close(fileConn)


start <- './main'
modelSelect <- '-m ./models/7B/ggml-model-q4_0.bin'
nuToken <- '-n 1'
repeatPenalty <- '--repeat-penalty 1'
interactive <- '--interactive-first'
colorRecursive <- '--color -i -r "User:"'
prompt <- '-f ./prompts/newText.txt'

commandLineInput <- paste(start,modelSelect,nuToken,repeatPenalty,interactive,colorRecursive,prompt, sep= ' ')

system(commandLineInput, intern = TRUE)
