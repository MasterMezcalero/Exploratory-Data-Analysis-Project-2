## Downloading the data set and unzipping it into the working folder

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./")

NEI <- readRDS("summarySCC_PM25.rds")

## Reducing the data frame to the two relevant columns and then calculating the sum per year

TotalEmissions <- NEI %>%
  select(Emissions, year) %>%
  group_by(year) %>%
  summarise(Total = sum(Emissions, na.rm = TRUE))


plot(TotalEmissions, pch = 19, xlab = "Year", ylab = "Total Emissions (tons)", main = "Total Emissions (tons) in the US")
dev.copy(png, file = "plot1.png")
dev.off()