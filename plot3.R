## This part of code downloads and unzips the data

uRl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" # Set the data url
temp <- tempfile()                                                                           # used as name for temporary files 
download.file(uRl,temp)                                                                      # download file to temp file 
d  <- read.csv(unzip(temp),sep=";", dec=".",encoding = "unknown")                            # unzip and read mesured data
unlink(temp)                                                                                 # unlik temporary file 

## Manipulate mesured data to setup analytic data
library("dplyr", lib.loc="~/R/win-library/3.1")                                              # using the "dplyr" (must be installed to R) package to manipulate data 
d1 <- d %>% 
    select( Sub_metering_1,Sub_metering_2,Sub_metering_3, Date, Time) %>%                    # Selecting needed rows
    mutate( Date=as.Date(Date,format="%d/%m/%Y"), Time = as.character(Time)) %>%             # Converting Date to POSXlt
    filter(("2007-02-01"<=Date)&(Date<="2007-02-02")) %>%                                    # Filter data by Date
    mutate( Sub_metering_1=as.character(Sub_metering_1)) %>%
    mutate( Sub_metering_2=as.character(Sub_metering_2)) %>%
    mutate( Sub_metering_3=as.character(Sub_metering_3)) %>%
    mutate( Sub_metering_1=as.numeric(Sub_metering_1,rm.na=TRUE),Date_Time=paste(Date,Time)) %>% 
    mutate( Sub_metering_2=as.numeric(Sub_metering_2,rm.na=TRUE)) %>%
    mutate( Sub_metering_3=as.numeric(Sub_metering_3,rm.na=TRUE))
rm(d)                                                                                       # Removing mesured data from global environment (memory)

d1$Date_Time<-strptime(d1$Date_Time,"%Y-%m-%d %H:%M:%S",tz="UTC")                           # Convert Date_Time data from character to POSIXlt

png( file ="plot3.png",width = 480,height = 480)                                            # Setup png settings

Sys.setlocale("LC_TIME", "eng")                                                             # Setup Local time to english (for not english OS )


# Making the plot2 (type - line, the axis Y label - Energy sub-metering )

plot( d1$Date_Time, d1$Sub_metering_1,type="l",ylab="Energy sub-metering",xlab="" )
# Add lines (Sub_metering_2,Sub_metering_3 to plot)

lines( d1$Date_Time, d1$Sub_metering_2, col="red")                                   
lines( d1$Date_Time, d1$Sub_metering_3, col="blue1")
legend("topright",                                                                         # places a legend at the appropriate 
    c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),                                 # puts text in the legend 
    lty=c(1,1,1),                                                                          # gives the legend appropriate symbols (lines)
    lwd=c(2.5,2.5,2.5),col=c("black","red","blue1"))                                       # gives the legend lines the correct color and width

dev.off()                                                                                  # Close graphics device