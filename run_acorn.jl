# instantiate and precompile environment
using Pkg; Pkg.activate(pwd())
Pkg.instantiate(); Pkg.precompile()

# load dependencies
using YAML
using ArgParse

function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--if_lim_name"
            help = "Interface limit file"
            arg_type = String
            required = true
        "--exclude_external_zones"
            help = "Exclude external zones or not"
            arg_type = Int
            required = true
        "--include_new_hvdc"
            help = "Include new HVD or not"
            arg_type = Int
            required = true
        "--save_name"
            help = "Save subdirectory name"
            arg_type = String
            required = true
    end
    return parse_args(s)
end

# Main script
# -----------
args = parse_commandline()

if_lim_name = args["if_lim_name"]
exclude_external_zones = args["exclude_external_zones"]
include_new_hvdc = args["include_new_hvdc"]
save_name = args["save_name"]

# Read run parameters
config = YAML.load_file("config.yml")
project_dir = config["project_dir"]
run_name = config["run_name"]
busprop_name = config["busprop_name"]
genprop_name = config["genprop_name"]
branchprop_name = config["branchprop_name"]
climate_scenario_years = config["climate_scenario_years"]
sim_years = config["sim_years"]

run_dir = "$(project_dir)/runs/$(run_name)"

# Load custom functions
include("$(project_dir)/src/julia/utils.jl")
include("$(project_dir)/src/julia/acorn.jl")




# Print run parameters
println("Run parameters:")
println("  run_name: $(run_name)")
println("  Busprop file: $(busprop_name)")
println("  Genprop file: $(genprop_name)")
println("  Branchprop file: $(branchprop_name)")
println("  Sim years: $(sim_years)")
println("  Exclude external zones: $(exclude_external_zones)")
println("  Include new HVDC: $(include_new_hvdc)")
println("  Save name: $(save_name)")
flush(stdout)  # Force output to appear immediately

exclude_external_zones_bool = convert(Bool, exclude_external_zones)
include_new_hvdc_bool = convert(Bool, include_new_hvdc)

# Loop through years and run model
for sim_year in sim_years[1]:sim_years[2]
    println("Now running year $(sim_year)...")
    flush(stdout)
    # Check if run already exists
    if isfile("$(run_dir)/outputs/$(save_name)/load_shedding_$(sim_year).csv")
        println("Run already exists, skipping...")
        continue
    end

    # Run ACORN
    run_acorn(
        run_name,
        climate_scenario_years,
        sim_year,
        branchprop_name,
        busprop_name,
        if_lim_name,
        save_name;
        project_dir=project_dir,
        run_dir=run_dir,
        exclude_external_zones=exclude_external_zones_bool,
        include_new_hvdc=include_new_hvdc_bool,
    )
end
