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

using NearestNeighbors
data = Matrix(df[:, [:Dew_Point, :Humidity, :Pressure, :Temperature, :Visibility]])'
kdtree = KDTree(data)

# Create test record
using StaticArrays
test_point = @SVector[13.0, 60.0, 1018.0, 20.0, 1.0]
idxs, dists = knn(kdtree, test_point, 3)

output = similar(df, 0)
for i in idxs
    push!(output, (df[i, :]))
end

println(output)

using Clustering

# Extract numerical features
features = Matrix(df[:, [:Dew_Point, :Humidity, :Pressure, :Temperature, :Visibility]])'

# Find initial centroids from Jan 1 and Jan 2, 2015
initial_indices = findall(x -> x in ["01-Jan-2015", "02-Jan-2015"], df.Date)
initial_centroids = features[:, initial_indices]

# Perform K-means clustering with k=2
result = kmeans!(features, initial_centroids, maxiter=0)

# Add cluster assignments to original DataFrame
df_clustered = copy(df)
df_clustered.Cluster = assignments(result)

# Get cluster statistics
cluster_sizes = counts(result)
cluster_centers = result.centers

function showCluster(df_clustered, date)
    # Select single row
    df_clustered[df_clustered.Date .== "04-Jan-2015", :][!, ["Date", "Cluster"]]
end

using LinearAlgebra
function distanceBetweenRows(init_date, final_date)
    # Get the DataFrameRow objects directly
    row_1 = df[df.Date .== init_date, :][1, :]
    row_2 = df[df.Date .== final_date, :][1, :]

    # Calculate distance using only numerical columns
    numerical_cols = [:Dew_Point, :Humidity, :Pressure, :Temperature, :Visibility]
    distance = norm([row_2[col] - row_1[col] for col in numerical_cols])

    println("Distance: $(round(distance, digits=2))")
end

distanceBetweenRows("01-Jan-2015", "12-Jan-2016")
