#!/bin/bash
#
# Ubuntu Car Hacking Workstation Setup
#
# Install useful apps for Car Hacking


set -e

# Setup Tools Directory
TOOL_DIR=~/CarHacking-Tools
mkdir -p $TOOL_DIR
cd $TOOL_DIR || exit
# Clean All
sudo rm -fr ./*


# Add user to dialout so USB-to-Serial Works-ish.
sudo usermod -a -G dialout "$USER"


# Update System
printf "Updating system"
printf "\\n"
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y


# Base Package Install (Packages Listed Invidually For Easy Customazation/Trobule Shooting.)
printf "Instaling base packages"
printf "\\n"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y  \
ant \
arduino \
arduino-core \
autoconf \
blueman \
bluetooth \
bluez \
bluez-test-scripts \
bluez-tools \
btscanner \
build-essential \
can-utils \
cpp \
cython3 \
cryptsetup \
curl \
g++ \
gcc \
git \
gnuradio \
gqrx-sdr \
libairspy-dev \
libavcodec-dev \
libavformat-dev \
libbluetooth-dev \
libconfig-dev \
libgps-dev \
libgtk-3-dev \
libhackrf-dev \
libnetfilter-queue1 \
libpcap-dev \
libportmidi-dev \
libpython3-dev \
librtlsdr-dev \
libsdl2-dev \
libsdl2-image-dev \
libsdl2-mixer-dev \
libsdl2-ttf-dev \
libsqlite3-dev \
libswscale-dev \
libtool \
libuhd-dev \
libusb-1.0 \
maven \
netbeans \
python \
python-bluez \
python-dbus \
python-dev \
python-dev \
python-pip \
python-serial \
python-wxtools \
python3-numpy \
python3-pip \
python3-psutil \
python3-zmq \
python3-pyqt5 \
ruby \
ruby-dev \
software-properties-common \
sqlite \
tree \
tshark \
ubertooth \
unzip \
wget \
wireshark 

#
# Updating Python Pip
#
python -m pip uninstall pip  # this might need sudonpm audit 
sudo apt install --reinstall python-pip


#
# Adding required PPA
#
printf "Updating PPAs"
printf "\\n"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - 


#
# Installing tools
#
printf "Instaling Tools"
printf "\\n"

# NodeJS
sudo apt-get install -y nodejs

# Bettercap
# Read The Docs: http://www.bettercap.org
wget https://github.com/bettercap/bettercap/releases/download/v2.19/bettercap_linux_amd64_2.19.zip 
unzip ./bettercap_linux_amd64_2.19.zip bettercap
sudo mv ./bettercap /usr/bin/
rm -fr ./bettercap*

# Bettercap UI
#git clone https://github.com/bettercap/ui.git ./bettercap-ui
#cd ./bettercap-ui || exit
#make build
#sudo make install
#cd .. || exit
#rm -fr ./bettercap-ui || exit

# Updating bettercap
sudo bettercap -eval "caplets.update; q"

# Universal radio Hacker
sudo pip3 install urh

# Bluelog
# Read The Docs: https://github.com/MS3FGX/Bluelog
git clone https://github.com/MS3FGX/Bluelog.git ./Bluelog
cd ./Bluelog || exit
sudo make install
cd .. || exit

# BlueHydra
# Read The Docs: https://github.com/pwnieexpress/blue_hydra
git clone https://github.com/pwnieexpress/blue_hydra ./blue_hydra
cd ./blue_hydra || exit
sudo apt-get install -y ruby-dev bundler
sudo bundle install
cd .. || exit

# Can-Utils:
# Read The Docs: https://github.com/linux-can/can-utils
# More Reading: https://discuss.cantact.io/t/using-can-utils/24
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y  can-utils

# Canbus-utils
# Read The Docs Here: https://github.com/digitalbond/canbus-utils
# More Reading:  http://www.digitalbond.com/blog/2015/03/05/tool-release-digital-bond-canbus-utils/
git clone https://github.com/digitalbond/canbus-utils
cd canbus-utils || exit
npm install
cd .. || exit

# Cantact-App
# Read The Docs Here: https://github.com/linklayer/cantact-app/
mkdir -p cantact-app
cd cantact-app || exit
wget https://github.com/linklayer/cantact-app/releases/download/v0.3.0-alpha/cantact-v0.3.0-alpha.zip
unzip cantact-v0.3.0-alpha.zip
rm cantact-v0.3.0-alpha.zip
cd .. || exit

# Caringcaribou
# Read The Docs Here: https://github.com/CaringCaribou/caringcaribou
pip install --user python-can
git clone https://github.com/CaringCaribou/caringcaribou

# c0f
# Read the Docs Here: https://github.com/zombieCraig/c0f
sudo gem install c0f

# ICSim
# Read The Docs Here: https://github.com/zombieCraig/ICSim
# Quick Start:  ./setup_vcan.sh &&  ./icsim vcan0 && ./controls vcan0
git clone https://github.com/zombieCraig/ICSim.git

# KatyOBD
# Read The Docs Here:
git clone https://github.com/YangChuan80/KatyOBD
#Fix Typo in KatyOBD
cd KatyOBD || exit
sed -i 's/tkinter/Tkinter/g' KatyOBD.py
cd .. || exit

# socketcand
# Read The Docs Here: https://dschanoeh.github.io/Kayak/tutorial.html
git clone http://github.com/dschanoeh/socketcand.git
cd socketcand || exit
autoconf
./configure
make clean
make
sudo make install
cd ../.. || exit

# Kayak
# Read The Docs Here: https://dschanoeh.github.io/Kayak/
git clone git://github.com/dschanoeh/Kayak
cd Kayak || exit
mvn clean package
cd .. || exit

# OBD-Monitor
# Read The Docs Here : https://github.com/dchad/OBD-Monitor
git clone https://github.com/dchad/OBD-Monitor
cd OBD-Monitor || exit
cd src || exit
make stests
make server
make ftests
cd ../.. || exit


# Python-ODB
# Read The Docs Here: https://python-obd.readthedocs.io/en/latest/
pip install --user pySerial
git clone https://github.com/brendan-w/python-OBD
cd python-OBD || exit
sudo python setup.py install
cd .. || exit


# PyOBD:
# Backup: git clone https://github.com/Pbartek/pyobd-pi.git
wget http://www.obdtester.com/download/pyobd_0.9.3.tar.gz
sudo tar -xzvf pyobd_0.9.3.tar.gz
sudo rm -rf pyobd_0.9.3.tar.gz

# SavvyCAN
# Read The Docs Here: https://github.com/collin80/SavvyCAN

# Start With QT:
mkdir -p QT
cd QT || exit
cat << EOF > qt-noninteractive-install-linux.qs
function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })
    installer.setMessageBoxAutomaticAnswer("cancelInstallation", QMessageBox.Yes);
}
Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}
Controller.prototype.CredentialsPageCallback = function() {
    var widget = gui.currentPageWidget();
    widget.loginWidget.EmailLineEdit.setText("");
    widget.loginWidget.PasswordLineEdit.setText("");
    gui.clickButton(buttons.NextButton, 500);
}
Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.TargetDirectoryPageCallback = function()
{
    var widget = gui.currentPageWidget();
    if (widget != null) {
        widget.TargetDirectoryLineEdit.setText("/opt/QT");
    }
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();
    function trim(str) {
        return str.replace(/^ +/,"").replace(/ *$/,"");
    }
    var packages = trim("qt.qt5.5111.gcc_64,qt.qt5.5111.qtwebengine,qt.qt5.5111.qtwebengine.gcc_64").split(",");
    if (packages.length > 0 && packages[0] !== "") {
        widget.deselectAll();
        for (var i in packages) {
            var pkg = trim(packages[i]);
            widget.selectComponent(pkg);
        }
    }
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.ReadyForInstallationPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}
Controller.prototype.FinishedPageCallback = function() {
    var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm
    if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
        checkBoxForm.launchQtCreatorCheckBox.checked = false;
    }
    gui.clickButton(buttons.FinishButton);
}
EOF

wget https://s3.amazonaws.com/rstudio-buildtools/qt-unified-linux-x64-3.0.5-online.run
chmod +x qt-unified-linux-x64-3.0.5-online.run

echo "Installing Qt, this will take a while."
echo " - Ignore warnings about QtAccount credentials and/or XDG_RUNTIME_DIR."
echo " - Do not click on any Qt setup dialogs, it is controlled by a script."
sudo ./qt-unified-linux-x64-3.0.5-online.run --script  qt-noninteractive-install-linux.qs
cd .. || exit

# SavvyCan Install
git clone https://github.com/collin80/SavvyCAN.git
cd SavvyCAN || exit
sudo /opt/QT/5.11.1/gcc_64/bin/qmake
sudo make
sudo make install
sudo ./install
cd .. || exit


# Scantool
# Read The Docs Here: https://samhobbs.co.uk/2015/04/scantool-obdii-car-diagnostic-software-linux
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y  scantool


# UDSim
# Read The Docs Here: https://github.com/zombieCraig/UDSim
git clone https://github.com/zombieCraig/UDSim
cd UDSim/src || exit
make
cd .. || exit
cd .. || exit
