#!/bin/bash
usage()
{
cat << EOF
usage: sudo $0 <linux-variant>
This script installs things!

EOF
}

#Require the script to be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script must be run as root because libraries will be installed."
    usage
    exit
fi

# Grab username of caller for later
ORIG_USER=$(who am i | awk '{print $1}')

if [ ! -d ../third-party-build ];
then
su $ORIG_USER -m -c 'mkdir ../third-party-build'
fi

# Descend into the scripts directory
pushd ./scripts >& /dev/null

# Install dependencies through the package manager first:
./kicad-bin-deps.sh

# Before using bzr, need to set whoami command
bzr whoami "Kevin DeMarco <kevin.demarco@gmail.com>"

# -----------------------------------------------------------------------------
# Build Kicad
# -----------------------------------------------------------------------------
apt-get build-dep kicad

su $ORIG_USER -m -c './kicad.sh'
./kicad.sh install
ldconfig

popd >& /dev/null # back to root directory
