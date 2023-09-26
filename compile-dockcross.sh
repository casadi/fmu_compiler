#!/bin/bash

set -euxo pipefail

# Create the directory
mkdir -p omc_fmi


# Run the Docker command
docker run -u developer:$(id -g) --rm -v "$(pwd)":/local ghcr.io/casadi/openmodelica:latest bash -c "cp -R /usr/include/omc/c/fmi /local/omc_fmi"

# Loop through the .fmu files
for f in *.mo; do

    docker run -u developer:$(id -g) --rm -v "$(pwd)":/local ghcr.io/casadi/openmodelica:latest bash -c "python generate_fmu.py $f"
    
    f_fmu="${f%.mo}.fmu"
    
    echo $f_fmu

    # Unzip the file
    unzip -q $f_fmu -d unzipped
    
    # Run the dockcross command
    ./dockcross cmake -Bbuild -DFMI_INTERFACE_HEADER_FILES_DIRECTORY=$(pwd)/omc_fmi -Hunzipped/sources
    
    # Remove the unzipped directory
    rm -rf unzipped
done


