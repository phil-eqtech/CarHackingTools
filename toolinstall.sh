#!/bin/bash
#
# Ubuntu Car Hacking Workstation Setup
#
# Install useful apps for Car Hacking

SPACER="\033[32m---------------------------------------------------------\033[00m"
DBLSPACER="\033[32m=========================================================\033[00m"

set -e

# Setup Tools Directory
TOOL_DIR=~/CarHacking-Tools
echo -e "\n\n\033[32m1- CREATING TOOL DIRECTORY\n$DBLSPACER"
if ! [ -d $TOOL_DIR ]; then
  mkdir -p $TOOL_DIR
  echo -e "\033[32m[OK]\033[00m"
else
  echo -e "\033[33m[Exists]\033[00m"
fi
cd $TOOL_DIR || exit

# Add user to dialout so USB-to-Serial Works-ish.
echo -e "\n\n\033[32m2- SETTING USERMOD DIALOUT.\n$DBLSPACER"
sudo usermod -a -G dialout "$USER"
echo -e "\033[32m[OK]\033[00m"


# Update System
echo -e "\n\n\033[32m3- UPDATING SOURCES AND SYSTEM.\n$DBLSPACER"
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y


# Base Package Install (Packages Listed Invidually For Easy Customazation/Trobule Shooting.)
echo -e "\n\n\033[32m4- INSTALLING BASE PACKAGES.\n$DBLSPACER"
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
net-tools \
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
scantool \
software-properties-common \
sqlite \
tree \
tshark \
ubertooth \
unzip \
wget \
wireshark

#
# Adding required PPA
#
echo -e "\n\n\033[32m5- UPDATING PPA.\n$DBLSPACER\n"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo add-apt-repository ppa:openjdk-r/ppa -y
wget -q https://packagecloud.io/AtomEditor/atom/gpgkey -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main"
echo -e "\033[32m[OK]\033[00m"


#
# Installing specific applications
#
echo -e "\n\n\033[32m6- CHECKING SPECIFIC APPLICATIONS.\n$DBLSPACER\n"

# PIP + update
echo -en "\n$SPACER\n- PIP : "
if ! [ -x "$(command -v pip)" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  python -m pip uninstall pip
  echo -e "PIP : \033[32m[Installed]\033[00m"
else
	echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi
echo -e "\n- Updating PIP : "
sudo apt install --reinstall python-pip


# NodeJS
echo -en "\n$SPACER\n- NodeJS : "
if ! [ -x "$(command -v node)" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  sudo apt-get install -y nodejs
  echo -e "NodeJS : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# Bettercap
# Read The Docs: http://www.bettercap.org
echo -en "\n$SPACER\n- Bettercap : "
if ! [ -x "$(command -v bettercap)" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  if ! [ -d "/usr/local/go" ]; then
    echo -e "Gloang is missing, installing..."
    # Firt we need golang
    echo 'export GOPATH=/usr/local/go' >> ~/.bashrc
    echo 'export PATH=${PATH}:$GOROOT/bin' >> ~/.bashrc
    source ~/.bashrc
    wget `curl -s https://golang.org/dl/ | grep -E -o 'https://[a-z0-9./]{5,}go[0-9.]{3,}linux-amd64.tar.gz' | head -n 1`
    tar zxf go*.linux-amd64.tar.gz
    sudo rm -fr $GOPATH
    sudo mv go $GOPATH
    rm -f go*.linux-amd64.tar.gz
    ln -s /usr/lib/x86_64-linux-gnu/libpcap.so.1.8.1 /usr/lib/x86_64-linux-gnu/libpcap.so.1
    echo -e "Golang : \033[32m[Installed]\033[00m"
  fi

  # Then bettercap
  go get github.com/bettercap/bettercap
  cd $GOPATH/src/github.com/bettercap/bettercap
  make build && sudo make install
  echo -e "Bettercap : \033[32m[Installed]\033[00m"



  # Finally, the UI
  cd $TOOLDIR
  git clone https://github.com/bettercap/ui.git bettercap-ui
  cd bettercap-ui
  make deps
  make build
  sudo make install
  cd ..
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi


# Universal radio Hacker
echo -en "\n$SPACER\n- Universal Radio Hacker : "
if ! [ -x "$(command -v urh)" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  sudo pip3 install urh
  echo -e "Universal Radio Hacker : \033[32[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi


# Bluelog
# Read The Docs: https://github.com/MS3FGX/Bluelog
echo -en "\n$SPACER\n- BlueLog : "
if ! [ -d "Bluelog" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/MS3FGX/Bluelog.git ./Bluelog
  cd ./Bluelog || exit
  sudo make install
  cd .. || exit
  echo -e "Bluelog : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# BlueHydra
# Read The Docs: https://github.com/pwnieexpress/blue_hydra
echo -en "\n$SPACER\n- Blue Hydra : "
if ! [ -d "blue_hydra" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/pwnieexpress/blue_hydra ./blue_hydra
  cd ./blue_hydra || exit
  sudo apt-get install -y ruby-dev bundler
  sudo bundle install
  cd .. || exit
  echo -e "Blue Hydra : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# Canbus-utils
# Read The Docs Here: https://github.com/digitalbond/canbus-utils
# More Reading:  http://www.digitalbond.com/blog/2015/03/05/tool-release-digital-bond-canbus-utils/
echo -en "\n$SPACER\n- Canbus-utils : "
if ! [ -d "canbus-utils" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/digitalbond/canbus-utils
  cd canbus-utils || exit
  npm install
  cd .. || exit
  echo -e "Canbus-utils : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# Cantact-App
# Read The Docs Here: https://github.com/linklayer/cantact-app/
echo -en "\n$SPACER\n Cantact-app : "
if ! [ -d "cantact-app" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  mkdir -p cantact-app
  cd cantact-app || exit
  wget https://github.com/linklayer/cantact-app/releases/download/v0.3.0-alpha/cantact-v0.3.0-alpha.zip
  unzip cantact-v0.3.0-alpha.zip
  rm cantact-v0.3.0-alpha.zip
  cd .. || exit
  echo -e "Cantact-app : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# Caringcaribou
# Read The Docs Here: https://github.com/CaringCaribou/caringcaribou
echo -en "\n$SPACER\n- Caringcaribou : "
if ! [ -d "caringcaribou" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  pip install --user python-can
  git clone https://github.com/CaringCaribou/caringcaribou
  echo -e "Caringcaribou : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# c0f
# Read the Docs Here: https://github.com/zombieCraig/c0f
echo -en "\n$SPACER\n- c0f : "
if ! [ -x "$(command -v c0f)" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  sudo gem install c0f
  echo -e "c0f : \033[32m[OK]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# ICSim
# Read The Docs Here: https://github.com/zombieCraig/ICSim
# Quick Start:  ./setup_vcan.sh &&  ./icsim vcan0 && ./controls vcan0
echo -en "\n$SPACER\n- ICSim : "
if ! [ -d "ICSim" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/zombieCraig/ICSim.git
  echo -e "ICSim : \033[32m[OK]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# KatyOBD
# Read The Docs Here:
echo -en "\n$SPACER\n- KatyOBD : "
if ! [ -d "KatyOBD" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/YangChuan80/KatyOBD
  cd KatyOBD || exit
  sed -i 's/tkinter/Tkinter/g' KatyOBD.py
  cd .. || exit
  echo -e "KAtyOBD : \033[32m[OK]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# socketcand
# Read The Docs Here: https://dschanoeh.github.io/Kayak/tutorial.html
echo -en "\n$SPACER\n- socketcand : "
if ! [ -d "socketcand" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone http://github.com/dschanoeh/socketcand.git
  cd socketcand || exit
  autoconf
  ./configure
  make clean
  make
  sudo make install
  cd ../.. || exit
  echo -e "Socketcand : \033[32m[OK]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# Kayak
# Read The Docs Here: https://dschanoeh.github.io/Kayak/
echo -en "\n$SPACER\n- Kayak : "
if ! [ -d "Kayak" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone git://github.com/dschanoeh/Kayak
  cd Kayak || exit
  mvn clean package
  cd .. || exit
  echo -e "Kayak : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# OBD-Monitor
# Read The Docs Here : https://github.com/dchad/OBD-Monitor
echo -en "\n$SPACER\n- OBD-Monitor : "
if ! [ -d "OBD-Monitor" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/dchad/OBD-Monitor
  cd OBD-Monitor || exit
  cd src || exit
  make stests
  make server
  make ftests
  cd ../.. || exit
  echo -e "OBD-Monitor : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi


# Python-ODB
# Read The Docs Here: https://python-obd.readthedocs.io/en/latest/
echo -en "\n$SPACER\n- python-OBD : "
if ! [ -d "python-OBD" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/brendan-w/python-OBD
  cd python-OBD || exit
  sudo python setup.py install
  cd .. || exit
  echo -e "Python-OBD : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi


# SavvyCAN
# Read The Docs Here: https://github.com/collin80/SavvyCAN

# Start With QT:
echo -en "\n$SPACER\n- QT : "
if ! [ -d "QT" ]; then
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
  echo -e "Python-OBD : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# SavvyCan Install
echo -en "\n$SPACER\n- SavvyCAN : "
if ! [ -d "SavvyCAN" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/collin80/SavvyCAN.git
  cd SavvyCAN || exit
  sudo /opt/QT/5.11.1/gcc_64/bin/qmake
  sudo make
  sudo make install
  sudo ./install
  cd .. || exit
  echo -e "SavvyCAN : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# UDSim
# Read The Docs Here: https://github.com/zombieCraig/UDSim
echo -en "\n$SPACER\n- UDSim : "
if ! [ -d "UDSim" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone https://github.com/zombieCraig/UDSim
  cd UDSim/src || exit
  make
  cd .. || exit
  echo -e "UDSim : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# edb-debugger
# Read The Docs Here: https://github.com/eteran/edb-debugger
echo -en "\n$SPACER\n- edb-debugger : "
if ! [ -d "edb-debugger" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  git clone --recursive https://github.com/eteran/edb-debugger.git
  mkdir build
  cd build
  cmake -DCMAKE_INSTALL_PREFIX=/usr/local/ ..
  make
  sudo make install
  cd .. || exit
  echo -e "edb-debugger : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi

# Ghidra
# Read The Docs Here: https://github.com/eteran/edb-debugger
echo -en "\n$SPACER\n- Ghidra : "
if ! [ -d "ghidra_9.0.1" ]; then
  echo -e "\033[33m[Missing]\033[00m - starting installation :"
  sudo apt install openjdk-11-jdk -y
  wget https://ghidra-sre.org/ghidra_9.0.1_PUBLIC_20190325.zip
  unzip ghidra_9.0.1_PUBLIC_20190325.zip
  sudo ln -s $TOOL_DIR/ghidra_9.0.1/ghidraRun /usr/bin/ghidra
  rm ghidra_9.0.1_PUBLIC_20190325.zip
  echo -e "Ghidra : \033[32m[Installed]\033[00m"
else
  echo -e "\033[32m[Already installed]\033[00m - Skipping"
fi
