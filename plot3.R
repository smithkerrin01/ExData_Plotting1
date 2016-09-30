## Coursera Exploratory Data Analysis - Course Project 1 - Plot 3
##
## The goal of this project is to examine how household energy usage varies
## over a 2-day period in February 2007 using data from the UC Irvine Machine
## Learning Repository.

## Check to see if the required data file exists. If not, download the 
## dataset folder and unzip the file. Record the current date.
if(!file.exists("./plotdata/household_power_consumption.txt")) {
    if(!file.exists("./plotdata")){
        dir.create("plotdata")
    }
    filename <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(filename, 
        "./plotdata/exdata-data-household_power_consumption.zip", method="curl")
    unzip("./plotdata/exdata-data-household_power_consumption.zip", 
          exdir="./plotdata")
    datedownloaded <- date()
    datedownloaded
}

## Load the required data and prepare it for use in creating the plot:

## Use the read.csv.sql function in the sqldf package and filter the dataset
## using SQL select to load only those dates between 2007-02-01 and 2007-02-02.
library(sqldf)
powerconsump <- read.csv.sql("./plotdata/household_power_consumption.txt", 
                sep=";", sql = "select * from file where 
                Date='1/2/2007' or Date='2/2/2007' ")
View(powerconsump)

## Convert any missing-data question marks to NA
powerconsump[powerconsump == "?"] = NA

## Add a column that combines date and time as a Date class variable
powerconsump <- mutate(powerconsump, 
                       datetime = strptime(paste(powerconsump$Date, 
                       powerconsump$Time), "%d/%m/%Y %T"))


## Begin by setting the graphics device to png and setting the global plotting
## parameter to increase the size of the outer margin to 
## accommodate the "Plot 3" title. The default width and height parameters
## for png are both 480.
png(file="./plotdata/plot3.png")
par(oma=c(2,2,2,2))

## Create the plot with sub_metering_1 and layer on sub_metering_2 and
## sub_metering_3.
plot(powerconsump$datetime, powerconsump$Sub_metering_1, type ="l", 
     xlab="", ylab="Energy sub metering")
lines(powerconsump$datetime, powerconsump$Sub_metering_2, col="red")
lines(powerconsump$datetime, powerconsump$Sub_metering_3, col="blue")

## Add the legend to the plot and the Plot 3 title to the outer margin
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", 
            "Sub_metering_3"), lty=1, col=c("black", "red", "blue"))
mtext("Plot 3", side= 3, outer = TRUE, font=2, adj=0)

## Close the graphics device
dev.off()

