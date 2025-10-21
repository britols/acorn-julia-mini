# acorn-julia-mini

This project runs the same model as [acorn-julia](https://github.com/srikrishnan-lab/acorn-julia), but includes less features, namely the load modeling and climate data tools.

## Installation

You need a Gurobi license to run the model. Save your `gurobi.lic` license in your home directory this way julia will link it automatically during the package installation.

- Open `julia` in the project directory
- Enter in the package mode `[` 
- Activate the project and install packages listed in `Project.toml`
```julia
]
activate .
instantiate
```

## Set up config.yml

Before running the model, make sure your `run_name` in runs/run_name has an input folder.

You must have the same files as in runs/test_run/inputs. If you're running for a different climate scenario, then change `climate_scenario_years` accordingly.

acorn-julia will solve the model for each year within the `sim_years` range, including the last year. 

## Run the model

Mac/Linux:
```
chmod +x run_acorn.sh
./run_acorn.sh 
```
The only thing `run_acorn.sh` does is calling `julia run_acorn.jl` with specific arguments.

## To do

Don't really need `climate_scenario_years`, but I haven't changed because `acorn.jl` uses it to read some of the inputs. Should be a quick fix to remove it.