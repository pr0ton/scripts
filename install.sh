#!/bin/bash

sudo apt-add-repository ppa:git-core/ppa

sudo apt-get update

sudo apt-get install \
  git \
  grive \
  openjdk-8-jdk \
  cmake \
  g++ \
  ubuntu-restricted-extras \
  geany \
  geany-plugins \
  qalculate-gtk \
  gimp \
  texlive \
  texlive-base \
  texlive-pictures \
  texlive-publishers \
  texlive-math-extra \
  texlive-science \
  texlive-extra-utils \
  texlive-latex-extra \
  vlc \
  faac \
  libfaac0 \
  libfaac-dev \
  nautilus-data \
  nautilus-share \
  -y

# install chrome
# sudo apt-get install libxss1 libappindicator1 libindicator7 -y
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i google-chrome*.deb

# install keepassx

mkdir -p /tmp/kpx
cd /tmp/kpx
wget https://www.keepassx.org/releases/2.0.2/keepassx-2.0.2.tar.gz
tar -xvf keepassx-2.0.2.tar.gz
cd keepassx-2.0.2/
mkdir build && cd build
sudo apt-get install -y checkinstall cmake libgcrypt20-dev libqt5x11extras5-dev make qt4-default qtbase5-dev qttools5-dev qttools5-dev-tools zlib1g-dev
cmake .. && make
sudo checkinstall -Dy --nodoc --pkgname=keepassx --pkgversion=2.0.2 make -i install


