#!/bin/bash
#web server stuff
# sudo apt-get install perl mysql-server php5 apache2 php5-mysql php5-cli libapache2-mod-php5 -y

#java stuff
# Add necessary PPAs
sudo add-apt-repository ppa:webupd8team/java

sudo apt-get update

# Install Java
sudo apt-get install oracle-java7-installer -y         

#sudo apt-get install eclipse -y

#c++
sudo apt-get install g++ -y         

#geany and co
sudo apt-get install geany -y
sudo apt-get install geany-plugins -y

#utilities
sudo apt-get install ktorrent -y    
sudo apt-get install qalculate-gtk -y  
sudo apt-get install keepassx -y 
sudo apt-get install filezilla -y
# sudo apt-get install adblock-plus
# sudo apt-get install pidgin -y
# sudo apt-get install xchm -y
# sudo apt-get install skype -y
# sudo apt-get install google-chrome-beta
# sudo apt-get install community-themes -y
# sudo apt-get install ttf-droid -y
# sudo apt-get install msttcorefonts -y
#sudo apt-get install sensors-applet -y
sudo apt-get install gimp
sudo apt-get install xchat

#other nautilus plugins
sudo apt-get install nautilus-open-terminal nautilus-data nautilus-gksu nautilus-share -y

#extra codecs and other non-free stuff
sudo apt-get install ubuntu-restricted-extras -y

# LaTeX
sudo apt-get install texlive texlive-base texlive-pictures texlive-publishers texlive-math-extra texlive-science texlive-extra-utils texlive-latex-extra  -y

sudo apt-get install vlc faac libfaac0 libfaac-dev  -y


sudo apt-get install python -y
sudo apt-get install git -y
sudo apt-get install scala -y

# Python machine learning stuff
sudo apt-get install python-dev -y
pip install numpy 
pip install scikit-learn
