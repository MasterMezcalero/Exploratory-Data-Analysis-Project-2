## Downloading the data set and unzipping it into the working folder

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Filtering to all results including the word "combustion" and "Coal" in the relevant fields
## Then reducing the data to relevant columns

SCC_Extract <- SCC %>%
      filter(grepl('[Cc]ombustion', SCC.Level.One)) %>%
      filter(grepl('[Cc]oal', SCC.Level.Three)) %>%
      select(SCC, SCC.Level.One, SCC.Level.Three)

## Picked inner join as it only preserves data that could be joined

CombinedData <- inner_join(NEI, SCC_Extract, by = "SCC")

## Reducing data frame down to relevant columns, then grouping emissions by year

TotalEmissions <- CombinedData %>%
  select(Emissions, year) %>%
  group_by(year) %>%
  summarise(Total = sum(Emissions, na.rm = TRUE))

g <- ggplot(TotalEmissions, aes(x = factor(year), y = Total)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Emissions (tons)", title = "Total Coal Combustion Emissions (tons)")

print(g)

dev.copy(png, file = "plot4.png")
dev.off()