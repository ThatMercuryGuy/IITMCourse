using CSV
csv_file = CSV.File("final_weather_data.csv", normalizenames = true)

using DataFrames
df = DataFrame(csv_file)

#One Liner to find day with Maximum Temperature
filter(row -> row.Temperature_°C_ == maximum(df.Temperature_°C_), df)

using Statistics
#Find Average Humidity
round(mean(df.Humidity_))

#Find Median Visibility
median(df.Visibility_km_)

#Find Most Commonly Observed Wind Direction (i.e. Statistical Mode)
mode(df.Wind_Direction_)