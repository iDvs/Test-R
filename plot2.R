## This part of code downloads and unzips the data

uRl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" # Set the data url
temp <- tempfile()                                                                           # used as name for temporary files 
download.file(uRl,temp)                                                                      # download file to temp file 
d  <- read.csv(unzip(temp),sep=";", dec=".",encoding = "unknown")                            # unzip and read mesured data
unlink(temp)                                                                                 # unlik temporary file 

# Manipulate mesured data to setup analytic data
library("dplyr", lib.loc="~/R/win-library/3.1")                                              # using the "dplyr" (must be installed to R) package to manipulate data 
d1 <- d %>% 
    select(Global_active_power, Date, Time) %>%                                              # Selecting needed rows
    mutate(Date=as.Date(Date,format="%d/%m/%Y"), Time = as.character(Time),Global_active_power=as.character(Global_active_power)) %>%
    filter(("2007-02-01"<=Date)&(Date<="2007-02-02")) %>%                                    # Filter data by Date
    mutate(Global_active_power=as.numeric(Global_active_power,rm.na=TRUE),Date_Time=paste(Date,Time))   # Converting GAP to numeric format, and aking new rows Date_Time (class character) 
rm(d)                                                                                        # Removing mesured data from global environment (memory)

# Making Plot1 from analytic data
png( file ="plot2.png",width = 480,height = 480)                                             # Setup png settings
Sys.setlocale("LC_TIME", "eng")                                                              # Setup Local time to english (for not english OS )

# Convert Date_Time data from character to POSIXlt
# Making the plot2 (type - line, the axis Y label -Global Active Power (kilowatts) )

plot(strptime(d1[,4],"%Y-%m-%d %H:%M:%S",tz="UTC"),d1[,1],type="l",ylab="Global Active Power (kilowatts)",xlab="", )  
 

dev.off()                                                                                     # Close graphics device