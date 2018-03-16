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

# STEP2 : Select all codes of the coal combustion-related sources
SCCcodes <- SCC$SCC[grepl("[C|c]oal",SCC$EI.Sector)]
# STEP3 : Selecting the years and Emissions corresponding to the coal comb... codes.
subSCC <- subset(NEI, SCC %in% SCCcodes, select = c(year,Emissions))
# STEP4 : Aggregate the Total of Emissions by year
emissionsUSACoal <- aggregate(Emissions ~ year, data = subSCC, FUN = sum)


# STEP5 : Create the plot plot4.png in the current R folder (working repository)
png(file = "plot4.png")
with(emissionsUSACoal, plot(year,Emissions,type="o",pch=19,xaxt = 'n',
                            col = "blue", ylab="PM2.5 Emissions", 
                            main="PM2.5 Emissions of Coal Combustion-related sources",
                            xlab="Year",
                            xlim = c(1999,2008))
)
axis(side = 1, at = emissionsUSACoal$year) # Labeling the x axis

dev.off()