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

## Filtering for relevant fips code, then rest as in the previous plot codes

TotalEmissions <- CombinedData %>%
  filter(fips == "24510") %>%
  select(Emissions, year) %>%
  group_by(year) %>%
  summarise(Total = sum(Emissions, na.rm = TRUE))

g <- ggplot(TotalEmissions, aes(x = factor(year), y = Total)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Emissions (tons)", title = "Total Vehicle Emissions (tons)")

print(g)

dev.copy(png, file = "plot5.png")
dev.off()