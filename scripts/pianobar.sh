#!/bin/bash

# -----------------------------------------------------------------------------
# Build pianobar
# -----------------------------------------------------------------------------

if [ ! -d ../third-party-build ];
then
    mkdir ../third-party-build
fi

if [ ! -d ../third-party-build/pianobar ]; then
    echo "Downloading pianobar repo..."
    
    pushd ../third-party-build >& /dev/null
    git clone https://github.com/PromyLOPh/pianobar.git
    popd >& /dev/null
fi

# -----------------------------------------------------------------------------
# Build pianobar
# -----------------------------------------------------------------------------
pushd ../third-party-build/pianobar >& /dev/null
make $@
popd >& /dev/null
