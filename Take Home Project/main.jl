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
using StatsBase
mode(df.Wind_Direction_Compass_)

#To Find the highest average temperature per group
for i in groupby(df, :Weather_Condition)
    println("$(i.Weather_Condition[1]): $(round(mean(i.Temperature_°C_), digits = 2))")
end

#Answer is clearly Widespread Dust: 39.48

