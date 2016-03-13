#!/bin/bash

sudo apt-add-repository ppa:git-core/ppa
sudo add-apt-repository ppa:webupd8team/sublime-text-3

sudo apt-get update

sudo apt-get -y install \
  cmake \
  faac \
  g++ \
  geany \
  geany-plugins \
  gimp \
  git \
  grive \
  libfaac-dev \
  libfaac0 \
  nautilus-data \
  nautilus-share \
  openjdk-8-jdk \
  python-pip \
  qalculate-gtk \
  sublime-text-installer \
  texlive \
  texlive-base \
  texlive-extra-utils \
  texlive-latex-extra \
  texlive-math-extra \
  texlive-pictures \
  texlive-publishers \
  texlive-science \
  ubuntu-restricted-extras \
  vlc

# install chrome
cd /tmp
sudo apt-get -y install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

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


