#!/bin/bash

set -euxo pipefail

# Loop through the .fmu files
for f in *.fmu; do
    
    echo $f

    # Unzip the file
    unzip -q $f -d unzipped

    rm -rf unzipped/binaries/*

    # Run the dockcross command
    ./dockcross cmake -Bbuild -DFMI_INTERFACE_HEADER_FILES_DIRECTORY=/work/unzipped/sources/include -DRUNTIME_DEPENDENCIES_LEVEL=none -Hunzipped/sources

    ./dockcross cmake --build build -v
    ./dockcross cmake --build build --target install -v

    rm $f

    cd unzipped && zip -r ../$f * && cd ..
done


