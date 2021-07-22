#!/usr/bin/env bash

# Make out directory
OUTDIR="$(pwd)/out"
if ! [ -d "${OUTDIR}/utils" ]; then mkdir -p "${OUTDIR}/utils"; fi

# Download git submodules
if [ -z "$(ls -A "ww2ogg")" ] || [ -z "$(ls -A "revorb-nix")" ]
then
    printf "Installing submodules...\n\n"
    git submodule init &> /dev/null
    git submodule update &> /dev/null
fi

# Build ww2ogg
if ! [ -f "${OUTDIR}/utils/ww2ogg" ]
then
    printf "Building ww2ogg...\n\n"
    cd ww2ogg
    if ! make &> /dev/null; then printf "\nERROR: Failed to build ww2ogg!\n\n"; exit 1; fi
    cp "ww2ogg" "${OUTDIR}/utils"
    cp "packed_codebooks_aoTuV_603.bin" "${OUTDIR}/utils"
    cd ..
fi

# Build revorb
if ! [ -f "${OUTDIR}/utils/revorb" ]
then
    printf "Building revorb...\n\n"
    cd revorb-nix
    if ! g++ revorb.cpp -o revorb -logg -lvorbis &> /dev/null; then printf "\nERROR: Failed to build revorb!\n\n"; exit 1; fi
    cp "revorb" "${OUTDIR}/utils"
    cd ..
fi

# Build EternalAudioExtractor
printf "Building EternalAudioExtractor...\n\n"
if ! dotnet publish -c Release &> /dev/null; then printf "\nERROR: Failed to build EternalAudioExtractor!\n\n"; exit 1; fi
cp "EternalAudioExtractor/bin/Release/net5.0/linux-x64/publish/EternalAudioExtractor" "${OUTDIR}"

# Exit
printf "Done.\n"
printf "You can find the executable and its dependencies in the 'out' folder.\n"
exit 0