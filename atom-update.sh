#!/bin/bash

### Constants ###
#RPM
FILE_RPM="/tmp/atom.rpm"
URL_RPM="https://atom.io/download/rpm"
#DEB
FILE_DEB="/tmp/atom.deb"
URL_DEB="https://atom.io/download/rpm"

### Variables ###
DIST=""
if [ -f /etc/debian_version ]; then
    DIST="DEB"
elif [ -f /etc/redhat-release ]; then
    DIST="RPM"
else
  echo "Cannot confirm that you use RPM-based or DEB-based distro."
  exit 1
fi

URL_NAME="URL_$DIST"
URL=${!URL_NAME}

FILE_NAME="FILE_$DIST"
FILE=${!FILE_NAME}

which atom 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
  echo "WARNING: atom isn't installed. Do you want to install it (from official repository)?"
  #@TODO
else
  # Detect current installed version
  rpm -qa  | grep "^atom-" 1>/dev/null 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Warning cannot detect version of your installed atom."
  else
    VERSION_INSTALLED="`rpm -qa  | grep "^atom-" | awk -F- '{print $2}'`"
    echo "Local version:  v$VERSION_INSTALLED"
    curl --silent -i https://api.github.com/repos/atom/atom/releases 2>/dev/null | grep tag_name | head -n 1 1>/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
      echo "WARNING: Cannot detect remote last atom version."
    else
      VERSION_REMOTE=`curl --silent -i https://api.github.com/repos/atom/atom/releases | grep tag_name | head -n 1 | awk -F\" '{print $4}'`
      echo "Remote version: $VERSION_REMOTE"
    fi
  fi
  echo "Do you want to udpate to the remote version (from official repository)?"
fi

read -p "Continue (y/n)?" choice
case "$choice" in
  y|Y ) ;;
  n|N ) exit 0;;
  * ) echo "Invalid ansewer."; 0;
esac

TEMP=$(mktemp /tmp/output.XXXXXXXXXX) || { echo "Failed to create temp file"; exit 1; }

wget -O $TEMP $URL

mv $TEMP $FILE
if [ $DIST == "RPM" ]; then
  sudo dnf install $FILE
elif [ $DIST == "DEB" ]; then
  sudo dpkg -i $FILE
fi

rm $FILE
