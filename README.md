## Overview

This repository contains simulation code and analysis scripts used to model the **2025 autochthonous chikungunya outbreak in Carpi, Modena, Northern Italy**.

The modelling framework simulates **vector–host population dynamics**, **virus transmission**, and the **effectiveness of alternative public‑health control strategies**. These simulations support the epidemiological interpretation and operational decision‑making described in the study:

> **“Organizational response to the 2025 autochthonous Chikungunya outbreak in Modena, Northern Italy: structure, coordination, and public health interventions of the Regional Crisis Unit.”**

This work was conducted by the modelling team: **Sandeep Teger, Christina A. Cobbold, Dominic P. Brass, Bethan V. Purse, and Steven M. White**, at the **UK Centre for Ecology & Hydrology (Wallingford, United Kingdom)** and the **School of Mathematics and Statistics, University of Glasgow (United Kingdom)**.

---

## Contents

- **Simulation code** for vector–host dynamics  
- **Transmission models** for chikungunya    
- **Scripts** for generating figures and outbreak metrics  

---

## Purpose

The codebase is intended to accompany the scientific manuscript and provide a **reproducible modelling pipeline** for outbreak analysis and public‑health response evaluation.

---

## Chikungunya Outbreak Simulation

### Code Structure
- **Main code file:** `chikv_bergerac.ipynb`
- **Supporting function files:**  
  - `ChikungunyaFunSR.jl`  
  - `ErrorFun_bergerac.jl`

---

## Required Data

### Input Data Files
- `AMgam.csv`
- `Car_Tol_1.csv`
- `Fin_LSurv.csv`
- `LDgam.csv`
- `WL_re.csv`

### Climate Data
- **Climate file:** `latitude_longitude.csv`  
- **Bergerac coordinates:**  
  - Latitude: **44.87**  
  - Longitude: **0.49**

**Required climate variables:**
- Temperature (`t2m`)
- Total precipitation (`tp`)
- Evaporation from open water surfaces excluding oceans (`evaow`)

**Source:** ERA5-Land hourly data (1950–present)

---

## Population Data
Population density (per sq. km) around the outbreak site in **Bergerac, France**.

**Source:**  
[Eurostat – Population density data](https://ec.europa.eu/eurostat/statistics-explained/index.php?oldid=596753)

---

## Programming Language
- **Julia v1.10 or higher**

---

## Required Packages

The following Julia packages are needed to run the simulations:

- `Plots`
- `DelayDiffEq`
- `Dierckx`
- `CSV`
- `Interpolations`
- `QuadGK`
- `Statistics`
- `Dates`
- `DataFrames`
- `RecursiveArrayTools`
- `TimeSeries`

### Installation
You can install all required packages using Julia's package manager:

```julia
using Pkg
Pkg.add.(["Plots", "DelayDiffEq", "Dierckx", "CSV", "Interpolations", "QuadGK",
          "Statistics", "Dates", "DataFrames", "RecursiveArrayTools", "TimeSeries"])

