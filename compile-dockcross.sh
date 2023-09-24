#!/bin/bash

# Get the argument
arg=$1

# Print the argument
echo $arg

# Create the directory
mkdir -p omc_fmi

# Run the Docker command
docker run --rm -v "$(pwd)":/local ghcr.io/casadi/ci-doc:latest bash -c "cp -R /usr/include/omc/c/fmi/* /local/omc_fmi"

# Loop through the .fmu files
for f in *.fmu; do
    # Unzip the file
    unzip -q $f -d unzipped
    
    # Run the dockcross command
    ./dockcross cmake -Bbuild build-dir -DFMI_INTERFACE_HEADER_FILES_DIRECTORY=$(pwd)/omc_fmi -Hunzipped/sources
    
    # Remove the unzipped directory
    rm -rf unzipped
done

