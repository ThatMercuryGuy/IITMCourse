using CSV
csv_file = CSV.File("Take Home Project/final_weather_data.csv", normalizenames = true)

using DataFrames
df = DataFrame(csv_file)