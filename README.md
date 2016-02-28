# Update program without official repo via http(s)

# atom-update
Simple script for update or install atom (https://atom.io/)

This script will check if you have installed atom and which version is installed.
It will also download information about last release from atom github repository.

If you will confirm installation or update then it will download a package from official site (via HTTPS with enabled certificate control) and install it.

The script can handle debian based and Red Hat based distribution.

Requriements:
* curl

Usage:
`./atom-update.sh`

Supported OS:
* Debian-based
* RedHat-based

# gitkraken-update

Simple script for update or install gitkraken (http://gitkraken.com).

This script will only download and install the latest version of gitkraken.

Requriements:
* curl

Usage:
`./gitkraken-update.sh`

Supported OS:
* Debian-based
