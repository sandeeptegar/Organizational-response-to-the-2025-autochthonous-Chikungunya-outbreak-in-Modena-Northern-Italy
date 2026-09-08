using Pkg
Pkg.activate(".")

using Dates, Printf, Plots, DelayDiffEq, Dierckx, CSV, Interpolations, QuadGK, Statistics, DataFrames, RecursiveArrayTools, TimeSeries

include("Chikv_Albopictus_Fun.jl")
include("multiseed.jl")

# read seed date from command line
seed_str = ARGS[1]
seed = Date(seed_str)

multiseed(seed, 2025, 2025, 44.79, 10.89)