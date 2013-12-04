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

KICAD=OFF
PIANOBAR=OFF

PS3='Select which project to build: '
options=("kicad" "pianobar" "all" "exit")
select opt in "${options[@]}"
do
    case $opt in
        "kicad")
            KICAD=ON            
            break
            ;;
        "pianobar")
            PIANOBAR=ON
            break
            ;;
        "all")
            ALL=ON
            break
            ;;
        "exit")
            echo "Exiting..."
            exit
            ;;
        *) echo "invalid_option"
            exit
            ;;
    esac
done

# Grab username of caller for later
ORIG_USER=$(who am i | awk '{print $1}')

if [ ! -d ../third-party-build ];
then
    su $ORIG_USER -m -c 'mkdir ../third-party-build'
fi

# Descend into the scripts directory
pushd ./scripts >& /dev/null

# Do we need to build Kicad?
if [ "${KICAD}" == "ON" ] || [ "${ALL}" == "ON" ]; then
    echo "Building kicad"

    # Install dependencies through the package manager first:
    ./kicad-bin-deps.sh

    # Before using bzr, need to set whoami command
    bzr whoami "Kevin DeMarco <kevin.demarco@gmail.com>"

    # -------------------------------------------------------------------------
    # Build Kicad
    # -------------------------------------------------------------------------
    apt-get build-dep kicad

    su $ORIG_USER -m -c './kicad.sh'
    ./kicad.sh install
    ldconfig

fi # End test for building Kicad

# Do we need to build Pianobar?
if [ "${PIANOBAR}" == "ON" ] || [ "${ALL}" == "ON" ]; then
    echo "Building pianobar"

    # Install dependencies through the package manager first:
    ./pianobar-bin-deps.sh

    # -------------------------------------------------------------------------
    # Build Pianobar
    # -------------------------------------------------------------------------
    su $ORIG_USER -m -c './pianobar.sh'
    ./pianobar.sh install
    ldconfig

fi # End test for building Pianobar

popd >& /dev/null # back to root directory
