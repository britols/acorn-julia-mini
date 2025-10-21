#!/bin/bash

# Start time
echo "Starting job at $(date)"

# Create logs directory if it doesn't exist
mkdir -p logs

# Run scripts with Julia project environment
julia run_acorn.jl \
--if_lim_name vivienne_2023_paper \
--exclude_external_zones 1 \
--include_new_hvdc 0 \
--save_name nyiso_only 2>&1 | tee logs/run_$(date +%Y%m%d_%H%M%S).log

# End time
echo "Ending job at $(date)"

exit 0
