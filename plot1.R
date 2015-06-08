## This part of code downloads and unzips the data

uRl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" # Set the data url
temp <- tempfile()                                                                           # used as name for temporary files 
download.file(uRl,temp)                                                                      # download file to temp file 
d  <- read.csv(unzip(temp),sep=";", dec=".",encoding = "unknown")                            # unzip and read mesured data
unlink(temp)                                                                                 # unlik temporary file 

# Manipulate mesured data to setup analytic data
library("dplyr", lib.loc="~/R/win-library/3.1")                                              # use the "dplyr" package to manipulate data
d1 <- d %>% 
    select(Global_active_power, Date) %>%                                                    # select rows G_A_P and Date
    mutate(Date=as.Date(Date,format="%d/%m/%Y"), Global_active_power=as.character(Global_active_power,rm.na=TRUE)) %>%  # Converting Date to POSXlt and G_A_P to character
    filter(("2007-02-01"<=Date)&(Date<="2007-02-02")) %>%                                    # Filter data by Date
    mutate(Global_active_power=as.numeric(Global_active_power,rm.na=TRUE))                   # Converting G_A_P to numeric format 
rm(d)                                                                                        # Remove mesured data from global environment (memory)


# Making Plot1 from analytic data
png( file ="plot1.png",width = 480,height = 480)                                             # Setup png settings
hist(d1$Global_active_power,col=2, main="Global Active Power", xlab="Global Active Power (kilowatts)") # Making the histogram for plot1 
dev.off()                                                                                    # Close graphics device