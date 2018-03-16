# STEP0 : Download and load data

URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
curr_folder = getwd()
destfile <- paste(curr_folder, "Assesment4.zip", sep = "/")

if (!file.exists(destfile))                             # Check if the file already exists
{
        download.file(URL, destfile)                    # Download data
        file <- unzip(destfile)                         # Unzip the file
} else {
        print("The folder already exists")
}

# STEP1 : Read the data downloaded
NEI <- readRDS(paste(curr_folder, "summarySCC_PM25.rds", sep="/"))                   # File 1
SCC <- readRDS(paste(curr_folder, "Source_Classification_Code.rds", sep="/"))        # File 2

#STEP2 : Aggregate the Total of Emissions by year
totalEmissions <- aggregate(Emissions ~ year, data = NEI, FUN = sum)

#STEP3 : Create plot1.png in the current R folder (working repository)
png(file = "plot1.png")

with(totalEmissions, 
     plot(year,Emissions,type="o",pch=19,xaxt = 'n',
          col = "blue", ylab="PM2.5 Emissions",
          xlab="Year",
          main="Total of PM2.5 Emissions by year", 
          xlim = c(1999,2008))
)
axis(side = 1, at = totalEmissions$year) # Labeling the x axis

dev.off()