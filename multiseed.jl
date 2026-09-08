#using Pkg
#Pkg.activate(".")

#using Dates, Printf, Plots, DelayDiffEq, Dierckx, CSV, Interpolations, QuadGK, Statistics, DataFrames, RecursiveArrayTools, TimeSeries

function multiseed(sd::Date, start_year::Int, end_year::Int, lat, lon)
    yearly_series = TimeArray[]
    for Y in start_year:end_year
        seed_date  = Date(Y, month(sd), day(sd))
        start_date = Date(Y-4, 1, 18)
        end_date   = Date(Y, 12, 30)

        sol, Rt, seed = chikungunya(
            lat, lon,
            Dates.format(start_date, "dd.mm.yyyy"),
            Dates.format(end_date,   "dd.mm.yyyy"),
            Dates.format(seed_date,  "dd.mm.yyyy"))
        # variable codes
        nWing = 64
        numb_E_1   = 1 
        numb_E_D   = 2
        numb_E_Q   = 3
        numb_L_1   = 4
        numb_t_E   = 5
        numb_P_E   = 6
        numb_t_L   = 7
        numb_P_L   = 8
        numb_t_P   = 9
        numb_P_P   = 10
        numb_A_1   = 11
        numb_A_2       = nWing + 10
        numb_I_1       = nWing + 11
        numb_I_2       = 2* nWing + 10
        numb_EIP       = 2 * nWing + 11
        numb_P_EIP_1   = 2 * nWing + 12
        numb_P_EIP_2   = 3 * nWing + 11
        numb_H_S       = 3 * nWing + 12
        numb_H_I       = 3 * nWing + 13
        numb_H_R       = 3 * nWing + 14;
        numb_D_1       = 3 * nWing + 15;
        numb_D_2       = 4 * nWing + 14;
        numb_RE        = 4 * nWing + 15;
        numb_VC_1      = 4 * nWing + 16;
        numb_VC_2      = 5 * nWing + 15;
            
        # extract time and soltion
        time = sol.t
        out  = hcat(sol.u...)
        # time to date
        dates = start_date .+ Day.(Int.(time))
        # extract the variables
        # delays and survival
        dt_tE   = out[numb_t_E, :]
        dt_PE   = out[numb_P_E, :]
        dt_tL   = out[numb_t_L, :]
        dt_PL   = out[numb_P_L, :]
        dt_tP   = out[numb_t_P, :]
        dt_PP   = out[numb_P_P, :]
        dt_EIP  = out[numb_EIP, :]

        # Recruitments
        # Egg recruitment rate 
        RE = vcat(0.0, diff(out[numb_RE, :]))
        # Adult recruitment rate 
        Aclass = out[numb_D_1:numb_D_2, :]
        sumAclass = sum(Aclass, dims=1)[1, :]
        RA = vcat(0.0, hcat(diff(sumAclass)))

        # Mosquitoes
        # susceptible
        allA = out[numb_A_1:numb_A_2, :]
        MA   = sum(allA, dims=1)[1, :]
        # infectious 
        allI = out[numb_I_1:numb_I_2, :]
        MI   = sum(allI, dims=1)[1, :]

        # Human infection class
        HI = out[numb_H_I,:]
        HR = out[numb_H_R,:]

        # incidence per day (after removing seeding)
        inc = max.(0.0, vcat(0.0, diff(HI .+ HR) .- seed[2:end]))

        # vectorial capacity
        allVC = out[numb_VC_1:numb_VC_2, :]
        VC   = sum(allVC, dims=1)[1, :]

        # Time series
        #eip_ts = TimeArray(dates, dt_EIP, ["EIP"])
        df  = hcat(dt_tE, dt_PE, dt_tL, dt_PL, dt_tP, dt_PP, dt_EIP, RE, RA, MA, MI, HI, HR, inc, Rt, VC)
        ts  = TimeArray(dates, df, ["tE", "SE", "tL", "SL", "tP", "SP", "EIP", "RE", "RA", "MA", "MI", "HI", "HR", "inc", "Rt", "VC"])

        # crop to current year only
        crop_ts = ts[Date(Y,1,1):Date(Y,12,30)]

        # save to Data frame
        push!(yearly_series, crop_ts)
    end

    # Save the file
    output_folder = "simout"
    fname = joinpath(output_folder, @sprintf("carpi_%02d_%02d.csv", Dates.day(sd), Dates.month(sd)))
    CSV.write(fname, DataFrame(vcat(yearly_series...)))

    # concatenate all years for this seed date
    return #vcat(yearly_series...)
end