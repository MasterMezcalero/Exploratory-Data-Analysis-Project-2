## Downloading the data set and unzipping it into the working folder

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Filtering to all results including the word "Vehicle", then reducing the data to relevant columns

SCC_Extract <- SCC %>%
  filter(grepl('[Vv]ehicle', SCC.Level.Two)) %>%
  select(SCC, SCC.Level.Two)

## Picked inner join as it only preserves data that could be matched

CombinedData <- inner_join(NEI, SCC_Extract, by = "SCC")

## Filtering for relevant fips codes and relevant columns, then summing up emissions by year and fips

TotalEmissions <- CombinedData %>%
  filter(fips == "24510" | fips == "06037") %>%
  select(Emissions, year, fips) %>%
  group_by(year, fips) %>%
  summarise(Total = sum(Emissions, na.rm = TRUE))

## Renaming the fips codes to ensure meaningful entries in the legend

TotalEmissions$fips <- gsub("24510", "Baltimore City", TotalEmissions$fips)
TotalEmissions$fips <- gsub("06037", "Los Angeles County", TotalEmissions$fips)

g <- ggplot(TotalEmissions, aes(x = factor(year), y = Total)) +
  facet_grid(.~fips) +
  geom_bar(stat = "identity", aes(fill = fips)) +
  labs(x = "Year", y = "Emissions (tons)", title = "Total Vehicle Emissions (tons)")

print(g)

dev.copy(png, file = "plot6.png")
dev.off()