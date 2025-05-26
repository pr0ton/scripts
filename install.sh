#!/bin/bash

sudo apt-get update

sudo apt-get -y install \
  cmake \
  faac \
  exfat-fuse \
  exfat-utils \
  ffmpeg \
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
# cd /tmp
# sudo apt-get -y install libxss1 libappindicator1 libindicator7
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i google-chrome-stable_current_amd64.deb

SNAP_PACKAGES="code keepassxc spotify"

for package in $SNAP_PACKAGES; do
  if ! snap list | grep -q "^$package\s"; then
    sudo snap install "$package"
  fi
done
