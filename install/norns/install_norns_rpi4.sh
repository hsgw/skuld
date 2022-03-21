cd /home/we
git clone https://github.com/monome/norns-image.git

cd ~
mkdir ~/.local/
mkdir ~/.local/share/
mkdir ~/.local/share/SuperCollider
mkdir ~/.local/share/SuperCollider/Extensions

echo '200328' >> version.txt
mkdir ~/update
mkdir ~/dust
mkdir ~/dust/data
mkdir ~/dust/audio
mkdir ~/dust/code

sudo cp -f /home/we/skuld/install/norns/files/setup.sh /home/we/norns-image
sudo cp -f /home/we/skuld/install/norns/files/norns.target /home/we/norns-image/config
sudo cp -f /home/we/skuld/install/norns/files/norns-matron.service /home/we/norns-image/config/
sudo cp -f /home/we/skuld/install/norns/files/norns-init.service /etc/systemd/system/
sudo cp -f /home/we/skuld/install/norns/files/init-norns.sh /home/we/norns-image/scripts
#sudo cp -f /home/we/skuld/install/norns/files/aliases.conf /lib/modprobe.d
sudo cp -f /home/we/skuld/install/norns/files/raspi-blacklist.conf /etc/modprobe.d
sudo cp -f /home/we/skuld/install/norns/files/asound.conf /etc
sudo cp -f /home/we/skuld/install/norns/files/alsa.conf /usr/share/alsa
sudo cp -f /home/we/skuld/install/norns/files/alsa-base.conf /etc/modprobe.d/alsa-base.conf
sudo cp -f /home/we/skuld/install/norns/files/rc.local /etc/rc.local
sudo cp -f /home/we/skuld/install/norns/files/dnsmasq.conf /etc/dnsmasq.conf

cd /home/we/norns-image
./setup.sh

cd /home/we
git clone https://github.com/fates-project/norns.git
cd /home/we/norns
git submodule update --recursive --init 

# sudo cp -f /home/we/skuld/install/norns/files/crone/wscript /home/we/norns/crone/wscript

# we need to run sclang
echo | sclang

./waf clean
./waf configure --enable-ableton-link
./waf build

cd /home/we/norns/sc && ./install.sh

#sudo cp -f /home/we/skuld/install/norns/files/norns-restart.sh /home/we/norns-restart.sh
#sudo cp -f /home/we/skuld/install/norns/files/norns-stopall.sh /home/we/norns-stopall.sh
# sudo cp -f /home/we/skuld/install/norns/files/matron4.sh /home/we/norns/matron.sh

# moved to kernel build
# sudo cp -f /home/we/skuld/install/norns/files/config4.txt /boot/config.txt
#update cmdline.txt for consoleblank=0
# sudo sed -i '1s/^/consoleblank=0 fbcon=map:1 /'  /boot/cmdline.txt

cd ~/dust/code
git clone https://github.com/monome/we.git
git clone https://github.com/tehn/awake.git
cd ~/dust/audio
mkdir tape
sudo mv /home/we/skuld/install/norns/files/common_audio.tar common_audio.tar
tar -xvf common_audio.tar
rm common_audio.tar

cd ~
wget https://github.com/monome/maiden/releases/download/v1.0.1/maiden-v1.0.1.tgz
tar -xvf maiden-v1.0.1.tgz
rm maiden-v1.0.1.tgz

#sudo apt install network-manager
#sudo cp ~/norns-linux-bits/interfaces /etc/network/interfaces
#sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant_bak.conf

sudo systemctl disable serialosc.service

# webdav
#cp -a webdav /home/we/
#sudo cp webdav/webdav.service /etc/systemd/system/
#sudo systemctl enable webdav.service
if [ -d /home/we/webdav ]; then
  sudo rm -rf /home/we/webdav
  sudo systemctl disable webdav.service
  sudo rm /etc/systemd/system/webdav.service
fi

# samba - alternate install
cd ~/skuld

if [ "$SAMBA" = "" ]; then
  sudo apt update
  sudo apt install samba samba-common-bin
  (echo "sleep"; echo "sleep") | sudo smbpasswd -s -a we
fi
sudo cp ~/skuld/install/norns/files/smb.conf /etc/samba/
sudo cp ~/skuld/install/norns/files/samba /etc/init.d/
sudo chmod 755 /etc/init.d/samba
sudo /etc/init.d/samba restart

sudo reboot
