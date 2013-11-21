#!/bin/bash

# -----------------------------------------------------------------------------
# Build Kicad Project
# Includes Kicad component library and documentation
# -----------------------------------------------------------------------------

if [ ! -d ../third-party-build ];
then
    mkdir ../third-party-build
fi

if [ ! -d ../third-party-build/kicad.bzr ]; then
    echo "Downloading kicad repo..."
    
    pushd ../third-party-build >& /dev/null
    bzr checkout lp:kicad kicad.bzr
    popd >& /dev/null
fi

if [ ! -d ../third-party-build/kicad-library.bzr ]; then
    echo "Downloading kicad component library..."
    
    pushd ../third-party-build >& /dev/null
    bzr checkout lp:~kicad-lib-committers/kicad/library kicad-library.bzr
    popd >& /dev/null
fi

if [ ! -d ../third-party-build/kicad-doc.bzr ]; then
    echo "Downloading kicad documentation repo..."
    
    pushd ../third-party-build >& /dev/null
    bzr branch --stacked lp:~kicad-developers/kicad/doc kicad-doc.bzr
    popd >& /dev/null
fi

# -----------------------------------------------------------------------------
# Build Kicad
# -----------------------------------------------------------------------------
pushd ../third-party-build/kicad.bzr >& /dev/null

if [ ! -d build ];
then
    mkdir build
fi

pushd build

cmake -DKICAD_STABLE_VERSION=ON ../
make $@

popd >& /dev/null # build

popd >& /dev/null # kicad.bzr

# -----------------------------------------------------------------------------
# Build Kicad Component Library
# -----------------------------------------------------------------------------
pushd ../third-party-build/kicad-library.bzr >& /dev/null

if [ ! -d build ];
then
    mkdir build
fi

pushd build

cmake ..
make $@

popd >& /dev/null # build

popd >& /dev/null # kicad-library.bzr

# -----------------------------------------------------------------------------
# Build Kicad Documentation
# -----------------------------------------------------------------------------
pushd ../third-party-build/kicad-doc.bzr >& /dev/null

if [ ! -d build ];
then
    mkdir build
fi

pushd build

cmake ..
make $@

popd >& /dev/null # build

popd >& /dev/null # kicad-doc.bzr
