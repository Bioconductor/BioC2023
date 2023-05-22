
library(stringr)

#gsheet <- 'https://docs.google.com/spreadsheets/d/1tGtGffcbCRxQFjE3ej42IcWlN4FJCsuQeZvETt9g0oA/gviz/tq?tqx=out:csv&sheet=schedule_table'
#fname <- tempfile()
#download.file(url = gsheet, destfile = fname, quiet = TRUE)
#schedule <- read.csv(fname)
## For some reason there are several extra columns with just NAs.
## We can remove those columns with a vector (discard_lgl)
#discard_lgl <- vapply(schedule, function(x) all(is.na(x)), logical(1))
#schedule <- schedule[,!discard_lgl]

url <- 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTK3h9TuCu3k8xwjBGO5eviKEnv7IzxULRGG1V5K2vKkzMxUUHVLMRiwqcezO_NrBB8kX78QVXk4F7P/pub?gid=0&single=true&output=csv'
fname <- tempfile()
download.file(url = url, destfile = fname, quiet = TRUE)
schedule <- read.csv(fname)

select_cols <- c(
    'day',
    'title', 'paper', 'session_type', 'authors', 'affiliation', 'abstract',
    'time', 'twitter', 'talks'
)
x <- schedule[, select_cols, drop = FALSE]
x$presenting_author <- sub(',.*$', '', x$authors)
x$github <- ''
x$youtube <- ''
x$paper <- tolower(x$paper)
x$abstract <- gsub('"', "'", x$abstract)
x <- x[which(x$session_type != ''),]
x$twitter <- sub('^@', '', x$twitter)
x$twitter <- sub('http:.*', '', x$twitter)
schedule <- x

output_dir <- 'data/abstracts/'
message('Creating yaml files in ', output_dir)

#use "" instead of NAs
scheduleBlank <- schedule #make copy
# scheduleBlank[is.na(scheduleBlank)] <- "" 

##  datetime to character
scheduleBlank$time <- sub("^.+ (.+):00", "\\1", scheduleBlank$time)

if (!file.exists(output_dir)) {
    dir.create(output_dir)
} else {
    ## Overwrite whatever output was generated before
    unlink(output_dir, recursive = TRUE)
    dir.create(output_dir)
}


iCount = 1

while (iCount <= nrow(scheduleBlank)) {
    
    oneRow <- scheduleBlank[iCount, ]
    
    fileNameSpace <- paste(oneRow$day, "_",
                           oneRow$time, "_",
                           oneRow$session_type,"_",
                           oneRow$paper,
                           ".yaml", 
                           sep = "" )
   fileNameFinal <- gsub(" |:", '', fileNameSpace) 
    # fileNameFinal <- str_replace_all(string = fileNameSpace, 
                                     # pattern =  c(" |:"), 
                                     # replacement =   '')
    
    fileNameFinal <- sub("_.yaml$", ".yaml", fileNameFinal)
    
    iCount2 = 1
    while (iCount2 <= ncol(oneRow)) {
        
        
        oneValueName <- names(oneRow)[iCount2]
        oneValue <- paste("\"",unlist(oneRow[iCount2]),"\"", sep = "")
        
        if (oneValueName == "talks" && any(grepl("paper", oneValue))) {
            oneValue <- sub("^\"(.+)\"$", "\\1", oneValue)
        }
        
        # write to file for the first time. Create new file
        if (iCount2 == 1) {
            # create file , no append
            line <- paste0(oneValueName, ": ", oneValue)
            write.table(line, col.names = FALSE, row.names = FALSE, 
                        file = paste(output_dir, 
                                     fileNameFinal, sep = ""), 
                        append = FALSE, 
                        quote = FALSE, )
            
        } else {
            # append to existing file
            line <- paste0(oneValueName, ": ", oneValue)
            write.table(
            x = line, col.names = FALSE, row.names = FALSE,
            file = paste0(output_dir, fileNameFinal), append = TRUE, quote = FALSE
            )
        } 
        
        iCount2 <- iCount2 + 1
    }
    
    iCount <- iCount + 1
}
