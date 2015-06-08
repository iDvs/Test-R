## This part of code downloads and unzips the data

uRl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" # Set the data url
temp <- tempfile()                                                                           # used as name for temporary files 
download.file(uRl,temp)                                                                      # download file to temp file 
d  <- read.csv(unzip(temp),sep=";", dec=".",encoding = "unknown")                            # unzip and read mesured data
unlink(temp)                                                                                 # unlik temporary file 

## Manipulate mesured data to setup analytic data
library("dplyr", lib.loc="~/R/win-library/3.1")                                              # using the "dplyr" (must be installed to R) package to manipulate data 
d1 <- d %>% 
    select(Sub_metering_1,Sub_metering_2,Sub_metering_3, Global_active_power, Voltage, Global_reactive_power, Date, Time) %>%  # Selecting needed rows
    mutate(Date=as.Date(Date,format="%d/%m/%Y"), Time = as.character(Time)) %>%             # Converting Date to POSXlt
    filter(("2007-02-01"<=Date)&(Date<="2007-02-02")) %>%                                   # Filter data by Date
    mutate(Sub_metering_1=as.character(Sub_metering_1)) %>%
    mutate(Sub_metering_2=as.character(Sub_metering_2)) %>%
    mutate(Sub_metering_3=as.character(Sub_metering_3)) %>%
    mutate(Voltage = as.character(Voltage)) %>%
    mutate(Global_active_power = as.character(Global_active_power)) %>%
    mutate(Global_active_power = as.numeric(Global_active_power,rm.na=TRUE)) %>%
    mutate(Global_reactive_power = as.character(Global_reactive_power)) %>%
    mutate(Global_reactive_power = as.numeric(Global_reactive_power,rm.na=TRUE)) %>%
    mutate(Sub_metering_1=as.numeric(Sub_metering_1,rm.na=TRUE),Date_Time=paste(Date,Time)) %>%
    mutate(Sub_metering_2=as.numeric(Sub_metering_2,rm.na=TRUE)) %>%
    mutate(Sub_metering_3=as.numeric(Sub_metering_3,rm.na=TRUE))
rm(d)                                                                                       # Removing mesured data from global environment (memory)

d1$Date_Time<-strptime(d1$Date_Time,"%Y-%m-%d %H:%M:%S",tz="UTC")                           # Convert Date_Time data from character to POSIXlt


png( file ="plot4.png",width = 480,height = 480)                                            # Setup png settings

Sys.setlocale("LC_TIME", "eng")                                                             # Setup Local time to english (for not english OS )


# Making plot4 (4 graphics on same plot) 

par(mfcol=c(2,2))                                                                           # setup quantity of columns and order for plot 
plot(d1$Date_Time,d1$Global_active_power,type="l",ylab="Global Active Power",xlab="", )     
plot(d1$Date_Time,d1$Sub_metering_1,type="l",ylab="Energy sub-metering",xlab="" )
lines(d1$Date_Time,d1$Sub_metering_2, col="red")
lines(d1$Date_Time,d1$Sub_metering_3, col="blue1")
legend("topright",                                                                         # places a legend at the appropriate 
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),                              # puts text in the legend 
       lty=c(1,1,1),                                                                       # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5,2.5),col=c("black","red","blue1"),bty="n")                            # gives the legend lines the correct color and width, gives the legend area without border

plot(d1$Date_Time,d1$Voltage, type="l",ylab="Voltage",xlab="datetime" )
plot(d1$Date_Time,d1$Global_reactive_power, type="l",ylab="Global_reactive_power",xlab="datetime" )
dev.off()