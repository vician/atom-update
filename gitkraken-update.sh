#!/bin/bash

### Constants ###
#DEB
FILE_DEB="/tmp/gitkraken.deb"
URL_DEB="http://release.gitkraken.com/linux/gitkraken-amd64.deb"

### Variables ###
DIST=""
if [ -f /etc/debian_version ]; then
    DIST="DEB"
else
  echo "Cannot confirm that you use DEB-based distro."
  exit 1
fi

URL_NAME="URL_$DIST"
URL=${!URL_NAME}

FILE_NAME="FILE_$DIST"
FILE=${!FILE_NAME}

which gitkraken 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
  echo "WARNING: gitkraken isn't installed. Do you want to install it (from official repository)?"
else
  echo "Do you want to udpate to the remote version (from official repository)?"
fi

read -p "Continue (y/n)?" choice
case "$choice" in
  y|Y ) ;;
  n|N ) exit 0;;
  * ) echo "Invalid answer."; 0;
esac

TEMP=$(mktemp /tmp/output.XXXXXXXXXX) || { echo "Failed to create temp file"; exit 1; }

wget -O $TEMP $URL

mv $TEMP $FILE
if [ $DIST == "DEB" ]; then
  sudo dpkg -i $FILE
fi

rm $FILE
