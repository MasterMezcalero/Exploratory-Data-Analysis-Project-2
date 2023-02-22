## Downloading the data set and unzipping it into the working folder

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./")

NEI <- readRDS("summarySCC_PM25.rds")

## Filtering for fips code, reducing data to relevant columns and then calculating the sums by year and type

TotalEmissions <- NEI %>%
  filter(fips == "24510") %>%
  select(Emissions, year, type) %>%
  group_by(year, type) %>%
  summarise(Total = sum(Emissions, na.rm = TRUE))


g <- ggplot(TotalEmissions, aes(x = factor(year), y = Total)) +
      facet_grid(.~type) +
      geom_bar(stat = "identity", aes(fill = type)) +
      labs(x = "Year", y = "Emissions (tons)", title = "Total Emissions (tons) in Baltimore, Maryland")

print(g)

dev.copy(png, file = "plot3.png")
dev.off()