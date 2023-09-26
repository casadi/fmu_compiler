#!/bin/bash

set -euxo pipefail

# Run the Docker command
docker run -u developer:$(id -g) --rm -v "$(pwd)":/local ghcr.io/casadi/openmodelica:latest bash -c "cp -R /usr/include/omc/c/fmi /local/omc_fmi"

pwd
ls
ls omc_fmi

# Loop through the .fmu files
for f in *.mo; do

    docker run -u developer:$(id -g) --rm -v "$(pwd)":/local ghcr.io/casadi/openmodelica:latest bash -c "python generate_fmu.py $f"
    
    f_fmu="${f%.mo}.fmu"
    
    echo $f_fmu

    # Unzip the file
    unzip -q $f_fmu -d unzipped

    rm -rf unzipped/binaries/*
    
    # Run the dockcross command
    ./dockcross cmake -Bbuild -DFMI_INTERFACE_HEADER_FILES_DIRECTORY=/work/omc_fmi -DRUNTIME_DEPENDENCIES_LEVEL=none -Hunzipped/sources

    ./dockcross cmake --build build -v
    ./dockcross cmake --build build --target install -v

    ls unzipped

    zip -r $f_fmu unzipped/
done


