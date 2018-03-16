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

# STEP2 : Select all codes of the motor vehicle sources

SCCcodes <- SCC$SCC[grepl("[m|M]obile",SCC$EI.Sector)]
# STEP3 : Selecting the years and Emissions corresponding to the motor vehicle codes: 
# in Baltimore City or Los Angeles County, California.
subSCC <- subset(NEI, SCC %in% SCCcodes & (fips == "24510" | fips == "06037")
                 , select = c(year,Emissions,fips))

# STEP4 : Aggregate the Total of Emissions by year of Baltimore City and Los Angeles
emissionsBaltimoreAndLa <- aggregate(Emissions ~ year + fips, data = subSCC, FUN = sum)

# STEP5 : label the names
names(emissionsBaltimoreAndLa) <- c("Year", "County", "Emissions")

# STEP6 : Changing numeric County codes for the actual County names
emissionsBaltimoreAndLa$County<-rep(c("Los Angeles","Baltimore"),each=4)

# STEP7 : Create the plot plot6.png in the current R folder (working repository)
png(file = "plot6.png")
qplot(Year,Emissions,data=emissionsBaltimoreAndLa,color=County) + geom_line() + labs(y="PM2.5 Emissions") + labs(title = "Total of PM2.5 Emissions by year")

dev.off()
