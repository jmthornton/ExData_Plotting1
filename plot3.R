# Declare libraries used
if(!require(sqldf))
  install.packages("sqldf")

if(!require(lubridate))
  install.packages("lubridate")

require(sqldf)
require(lubridate)

# Download the data if it does not exist
if(!file.exists("household_power_consumption.zip"))
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip")

# Unzip the data to a file if it has not already been done
if(!file.exists("household_power_consumption.txt"))
  unzip("household_power_consumption.zip", "household_power_consumption.txt")

# Read the subset of rows from the data file corresponding to the dates 2007-02-02 and 2007-02-01
# and clean up all open connections to avoid a warning message
df <- read.csv.sql("household_power_consumption.txt", header=TRUE, sep=";", sql="SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'")
closeAllConnections()

# Merge the Date and Time variables to create a new Timestamp variable
df$Timestamp <- dmy_hms(paste(df$Date, df$Time))

# Create a PNG graphics device with a transparent background
png("plot3.png", bg = "transparent")

# Plot the three Sub Metering variables vs Time
with(df, { 
  plot(Sub_metering_1 ~ Timestamp, col = "black", ylab = "Energy sub metering", xlab = "", type = "l")
  lines(Sub_metering_2 ~ Timestamp, col = "red")
  lines(Sub_metering_3 ~ Timestamp, col = "blue")
  legend("topright",lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})

# Close the graphics device
dev.off()