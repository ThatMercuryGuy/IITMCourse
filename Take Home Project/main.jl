using CSV
csv_file = CSV.File("final_weather_data.csv", normalizenames = true)

using DataFrames
df = DataFrame(csv_file)

#One Liner to find day with Maximum Temperature
filter(row -> row.Temperature == maximum(df.Temperature), df)

using Statistics
#Find Average Humidity
round(mean(df.Humidity))

#Find Median Visibility
median(df.Visibility)

#Find Most Commonly Observed Wind Direction (i.e. Statistical Mode)
using StatsBase
mode(df.Wind_Direction)

#To Find the highest average temperature per group
for i in groupby(df, :Weather_Condition)
    println("$(i.Weather_Condition[1]): $(round(mean(i.Temperature), digits = 2))")
end

#Answer is clearly Widespread Dust: 39.48


#=
The following is the code implementing K Nearest Neighbors Analysis
=#

using MLJ, DataFrames, CategoricalArrays


# Convert Rain_Presence to categorical
df.Rain_Presence = categorical(df.Rain_Presence)

# Create test record
test_record = DataFrame(
    Dew_Point = 13.0,
    Humidity = 60.0,
    Pressure = 1018.0,
    Temperature = 20.0,
    Visibility = 1.0
)

# Create and fit model
model = KNNClassifier(K=3)
mach = machine(model, select(df, [:Dew_Point, :Humidity, :Pressure, :Temperature, :Visibility]), df.Rain_Presence)
fit!(mach)

# Predict and get neighbors
prediction = MLJ.predict(mach, test_record)
neighbors = MLJ.neighbors(mach, test_record)