#!/bin/bash
## insert in crontab with
## crontab -e
# 1 * * * * bash /home/USER/manga_checker.sh # every minute 1 of every hour of any day
## rememeber to chmod +x manga_checker.sh


# # # # ### on raspberry pi
# # # # 
# # # # usermod -a -G sudo,crontab,ssh $USER #### reboot for change to take effect
# # # # 

# # # # 
# # # # sudo raspi-config ######## expand root to all sd, Wait for Network at Boot, change local time  #### reboot for change to take effect
# # # # 

# # # # 
# # # # echo "dash    dash/sh boolean false" | sudo debconf-set-selections
# # # # sudo dpkg-reconfigure -f noninteractive dash
# # # # chsh -s /bin/bash # need reboot to take effect
# # # # 

# # # # 
# # # # echo -e "PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf:\$PKG_CONFIG_PATH 
# # # # export PKG_CONFIG_PATH"  >> $HOME/.bashrc
# # # # 
# # # # sudo apt-get install --reinstall -y resolvconf apt-transport-https ca-certificates
# # # # # DNS
# # # # sudo mkdir -p /etc/resolvconf/resolv.conf.d/base
# # # # echo -e "nameserver 208.67.222.222
# # # # nameserver 208.67.220.220
# # # # nameserver 8.8.8.8
# # # # nameserver 8.8.4.4" | sudo tee /etc/resolvconf/resolv.conf.d/base >> /dev/null
# # # # sudo resolvconf -u
# # # # # https://www.raspbian.org/RaspbianMirrors
# # # # sudo sed -i -e "s/raspbian.raspberrypi.org/mirrordirector.raspbian.org/" /etc/apt/sources.list
# # # # #sudo sed -i -e "s/http:\/\/raspbian.raspberrypi.org/https:\/\/raspbian.raspberrypi.org/" /etc/apt/sources.list
# # # # sudo sed -i 's/^#deb-src/deb-src/g' /etc/apt/sources.list
# # # # sudo sed -i 's/^#deb-src/deb-src/g' /etc/apt/sources.list.d/raspi.list
# # # # sudo apt-get update && sudo apt-get dist-upgrade -y
# # # # 
# # # # # mount /tmp on ram in order to reduce sd card wear
# # # # # echo "tmpfs /tmp  tmpfs defaults,noatime 0 0" | sudo tee -a /etc/fstab > /dev/null
# # # # # echo "tmpfs /var/tmp tmpfs nodev,nosuid 0 0" | sudo tee -a /etc/fstab > /dev/null # ,size=50M   #### reboot for change to take effect
# # # # 

# # # # 
# # # # pypcks="virtualenv python3-pip python3 python3-all-dev python3-dev libffi-dev libssl-dev librtmp-dev python3 python3-setuptools cython build-essential"
# # # # allgoodpcks="coreutils inotify-tools ssh ntpdate unattended-upgrades"
# # # # sudo apt-get install -y $allgoodpcks $pypcks
# # # # 
# # # # ### search last commands with up arrow key:
# # # # ### http://codeinthehole.com/tips/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
# # # # echo -e "\"\\\\e[A\": history-search-backward
# # # # \"\\\\e[B\": history-search-forward
# # # # \"\\\\e[C\": forward-char
# # # # \"\\\\e[D\": backward-char" > ~/.inputrc
# # # # 
# # # # sudo sed -i "s/^session    optional     pam_mail.so/#session    optional     pam_mail.so/g" /etc/pam.d/sshd
# # # # echo "ClientAliveInterval 30" | sudo tee -a /etc/ssh/sshd_config > /dev/null
# # # # echo "ClientAliveCountMax 5" | sudo tee -a /etc/ssh/sshd_config > /dev/null
# # # # echo "ServerAliveInterval 15" | sudo tee -a /etc/ssh/ssh_config > /dev/null
# # # # echo "ServerAliveCountMax 3" | sudo tee -a /etc/ssh/ssh_config > /dev/null
# # # # 
# # # # # to install locales
# # # # timezonex="Europe/Rome"  # example
# # # # localex1="en_US.UTF-8"
# # # # localex2="it_IT.UTF-8"   # example
# # # # echo "$timezonex" | sudo tee /etc/timezone > /dev/null
# # # # sudo dpkg-reconfigure -f noninteractive tzdata
# # # # sudo sed -i -e "s/# $localex1 UTF-8/$localex1 UTF-8/" /etc/locale.gen
# # # # sudo sed -i -e "s/# $localex2 UTF-8/$localex2 UTF-8/" /etc/locale.gen
# # # # echo "LANG=\"$localex1\"" | sudo tee /etc/default/locale > /dev/null
# # # # sudo dpkg-reconfigure --frontend=noninteractive locales 
# # # # sudo update-locale LANG=$localex1
# # # # 
# # # # 
# # # # # time server, updated every boot
# # # # # The Rasbperry Pi doesn't have a Real Time Clock, so that is why it is resetting itself to 1970 everytime you boot without Internet.
# # # # echo -e "DAEMONS=(\041hwclock ntpd)" | sudo tee -a /etc/rc.conf >> /dev/null
# # # # sudo ntpdate -u pool.ntp.org
# # # # 
# # # # sudo update-ca-certificates --fresh
# # # # 
# # # # 
# # # # echo -e "APT::Periodic::Update-Package-Lists \"1\";
# # # # APT::Periodic::Download-Upgradeable-Packages \"1\";
# # # # APT::Periodic::AutocleanInterval \"7\";
# # # # APT::Periodic::Unattended-Upgrade \"1\";" | sudo tee -a /etc/apt/apt.conf.d/10periodic > /dev/null
# # # # 
# # # # 
# # # # # http://www.cl.cam.ac.uk/~atm26/ephemeral/rpi/dwc_otg/doc/html/module%20parameters.html
# # # # sudo sed -i "s/^vm.min_free_kbytes.*$/vm.min_free_kbytes = 32768/g" /etc/sysctl.conf
# # # # 
# # # # sudo sed -i "s/smsc95xx.turbo_mode=N//g" /boot/cmdline.txt; sudo sed -i '/rootfstype/ s/$/ smsc95xx.turbo_mode=N/' /boot/cmdline.txt
# # # # sudo sed -i "/^avoid_safe_mode=.*$/d" /boot/config.txt; echo "avoid_safe_mode=1" | sudo tee -a /boot/config.txt > /dev/null
# # # # 
# # # # 
# # # # 
# # # # # Syncthing https://syncthing.net/     https://raspberrypi.local:8384
# # # # curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
# # # # echo deb http://apt.syncthing.net/ syncthing release | sudo tee /etc/apt/sources.list.d/syncthing-release.list
# # # # sudo apt-get update
# # # # sudo apt-get install --reinstall -y syncthing
# # # # 
# # # # timeout --kill-after=2 -sHUP 4m syncthing
# # # # echo -e "#\041/bin/sh
# # # # ### BEGIN INIT INFO
# # # # # Provides:          Syncthing
# # # # # Required-Start:    \$local_fs \$remote_fs \$network
# # # # # Required-Stop:     \$local_fs \$remote_fs \$network
# # # # # Default-Start:     2 3 4 5
# # # # # Default-Stop:      0 1 6
# # # # # Short-Description: Syncthing
# # # # # Description:       Syncthing is for backups
# # # # ### END INIT INFO
# # # #  
# # # # # Documentation available at
# # # # # http://refspecs.linuxfoundation.org/LSB_3.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptfunc.html
# # # # # Debian provides some extra functions though
# # # # . /lib/lsb/init-functions
# # # #  
# # # # DAEMON_NAME=\"syncthing\"
# # # # DAEMON_USER=$USER
# # # # DAEMON_PATH=\"/usr/bin/syncthing\"
# # # # DAEMON_OPTS=\"\"
# # # # DAEMON_PWD=\"\${PWD}\"
# # # # DAEMON_DESC=\$(get_lsb_header_val \$0 \"Short-Description\")
# # # # DAEMON_PID=\"/var/run/\${DAEMON_NAME}.pid\"
# # # # DAEMON_NICE=0
# # # # DAEMON_LOG='/var/log/syncthing'
# # # #  
# # # # [ -r \"/etc/default/\${DAEMON_NAME}\" ] && . \"/etc/default/\${DAEMON_NAME}\"
# # # #  
# # # # do_start() {
# # # #   local result
# # # #  
# # # #   pidofproc -p \"\${DAEMON_PID}\" \"\${DAEMON_PATH}\" > /dev/null
# # # #   if [ \$? -eq 0 ]; then
# # # #     log_warning_msg \"\${DAEMON_NAME} is already started\"
# # # #     result=0
# # # #   else
# # # #     log_daemon_msg \"Starting \${DAEMON_DESC}\" \"\${DAEMON_NAME}\"
# # # #     touch \"\${DAEMON_LOG}\"
# # # #     chown \$DAEMON_USER \"\${DAEMON_LOG}\"
# # # #     chmod u+rw \"\${DAEMON_LOG}\"
# # # #     if [ -z \"\${DAEMON_USER}\" ]; then
# # # #       start-stop-daemon --start --quiet --oknodo --background \
# # # #         --nicelevel \$DAEMON_NICE \
# # # #         --chdir \"\${DAEMON_PWD}\" \
# # # #         --pidfile \"\${DAEMON_PID}\" --make-pidfile \
# # # #         --exec \"\${DAEMON_PATH}\" -- \$DAEMON_OPTS
# # # #       result=\$?
# # # #     else
# # # #       start-stop-daemon --start --quiet --oknodo --background \
# # # #         --nicelevel \$DAEMON_NICE \
# # # #         --chdir \"\${DAEMON_PWD}\" \
# # # #         --pidfile \"\${DAEMON_PID}\" --make-pidfile \
# # # #         --chuid \"\${DAEMON_USER}\" \
# # # #         --exec \"\${DAEMON_PATH}\" -- \$DAEMON_OPTS
# # # #       result=\$?
# # # #     fi
# # # #     log_end_msg \$result
# # # #   fi
# # # #   return \$result
# # # # }
# # # #  
# # # # do_stop() {
# # # #   local result
# # # # 
# # # #   pidofproc -p \"\${DAEMON_PID}\" \"\${DAEMON_PATH}\" > /dev/null
# # # #   if [ \$? -ne 0 ]; then
# # # #     log_warning_msg \"\${DAEMON_NAME} is not started\"
# # # #     result=0
# # # #   else
# # # #     log_daemon_msg \"Stopping \${DAEMON_DESC}\" \"\${DAEMON_NAME}\"
# # # #     killproc -p \"\${DAEMON_PID}\" \"\${DAEMON_PATH}\"
# # # #     result=\$?
# # # #     log_end_msg \$result
# # # #     rm \"\${DAEMON_PID}\"
# # # #   fi
# # # #   return \$result
# # # # }
# # # #  
# # # # do_restart() {
# # # #   local result
# # # #   do_stop
# # # #   result=\$?
# # # #   if [ \$result = 0 ]; then
# # # #     do_start
# # # #     result=\$?
# # # #   fi
# # # #   return \$result
# # # # }
# # # #  
# # # # do_status() {
# # # #   local result
# # # #   status_of_proc -p \"\${DAEMON_PID}\" \"\${DAEMON_PATH}\" \"\${DAEMON_NAME}\"
# # # #   result=\$?
# # # #   return \$result
# # # # }
# # # #  
# # # # do_usage() {
# # # #   echo \$\"Usage: \$0 {start | stop | restart | status}\"
# # # #   exit 1
# # # # }
# # # #  
# # # # case \"\$1\" in
# # # # start)   do_start;   exit \$? ;;
# # # # stop)    do_stop;    exit \$? ;;
# # # # restart) do_restart; exit \$? ;;
# # # # status)  do_status;  exit \$? ;;
# # # # *)       do_usage;   exit  1 ;;
# # # # esac" | sudo tee /etc/init.d/syncthing >> /dev/null
# # # # sudo chmod +x /etc/init.d/syncthing
# # # # sudo update-rc.d syncthing defaults
# # # # sudo service syncthing start
# # # # sed -i -e "s/tls=\"false\"/tls=\"true\"/g;s/127.0.0.1/0.0.0.0/g" $HOME/.config/syncthing/config.xml  
# # # # sudo service syncthing restart
# # # #
# # # #



export PATH="$PATH:/sbin:/usr/local/sbin:/usr/bin:/usr/local/bin:/usr/sbin:/bin:/usr/local/games:/usr/games:" # not included in crontab env
source $HOME/.bashrc



# better to keep log_ and temp_ folders on an usb disk for reducing sd card wear
log_folder="path/to/your/log/folder"
temp_folder="path/to/your/temp/folder"



if [[ ! ( -d "$HOME/bin/comics_dowloander_python_en" ) ]]; then
  python3 -m virtualenv $HOME/bin/comics_dowloander_python_env --python=$(ls -1 /usr/bin/python3* | grep -P "\d$" | tail -n1) # python2 will be decommissioned on January 1, 2020
  source $HOME/bin/comics_dowloander_python_env/bin/activate
  pip install --upgrade pip
  pip install --upgrade --no-cache-dir beautifulsoup4 regex
  deactivate
fi
if [[ ! ( -d "${temp_folder}/manga_tmp" ) ]]; then
  mkdir -p "${temp_folder}/manga_tmp"   # comics-downloader folder https://github.com/Girbons/comics-downloader
  wget -O "${temp_folder}/manga_tmp/comics-downloader" "$(wget -q -O- https://github.com/Girbons/comics-downloader/releases/  | grep -P "Girbons.comics-downloader.releases.download.v.*.comics-downloader" | grep -v "\-gui" | grep -F "$(echo $(uname -m) | sed "s/armv7l/arm\"/g;s/armv6l/arm\"/g;s/x86_64/\/comics-downloader\"/g")" | head -n1 | sed "s/^.*href=\"/https:\/\/github.com/g;s/\".*$//g")"
  chmod +x "${temp_folder}/manga_tmp/comics-downloader"
else
  cd "${temp_folder}/manga_tmp"
  current_version="$(wget -q -O- https://github.com/Girbons/comics-downloader/releases/  | grep -P "Girbons.comics-downloader.releases.download.v.*.comics-downloader" | grep -v "\-gui" | grep -F "$(echo $(uname -m) | sed "s/armv7l/arm\"/g;s/armv6l/arm\"/g;s/x86_64/\/comics-downloader\"/g")" | head -n1 | sed "s/^.*\/download\///g;s/\/.*$//g")"
  installed_version="$(./comics-downloader --version | sed "s/^.* //g" | sed "s/[ \t]$//g")"
  if [[ "$installed_version" == "" ]]; then
    echo "$installed_version" >> "${temp_folder}/comics-downloader_error.txt"
  fi
  if [[ "$current_version" != "$installed_version" ]]; then
    rm -f "${temp_folder}/manga_tmp/comics-downloader"
    wget -O "${temp_folder}/manga_tmp/comics-downloader" "$(wget -q -O- https://github.com/Girbons/comics-downloader/releases/  | grep -P "Girbons.comics-downloader.releases.download.v.*.comics-downloader" | grep -v "\-gui" | grep -F "$(echo $(uname -m) | sed "s/armv7l/arm\"/g;s/armv6l/arm\"/g;s/x86_64/\/comics-downloader\"/g")" | head -n1 | sed "s/^.*href=\"/https:\/\/github.com/g;s/\".*$//g")"
    chmod +x "${temp_folder}/manga_tmp/comics-downloader"
  fi
  cd -
fi


declare -a manganames
declare -a mangapages



############################################################# MANGA LIST
######### #########

k=0
manganames[$k]="Hokuto no Ken"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-107406"

let "k=k+1"
manganames[$k]="Vagabond"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-267124"

let "k=k+1"
manganames[$k]="One Punch-Man"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-358279"



let "k=k+1"
manganames[$k]="Nausicaa of the Valley of the Wind"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-174706"

let "k=k+1"
manganames[$k]="Shuna no Tabi"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-226985"


let "k=k+1"
manganames[$k]="Ikigami"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-114471"


let "k=k+1"
manganames[$k]="Battle Angel Alita"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-90619"
let "k=k+1"
manganames[$k]="Ashen Victor"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-100254952"
let "k=k+1"
manganames[$k]="Alita Last Order" # Gunnm: Last Order
mangapages[$k]="https://mangarock.com/manga/mrs-serie-24827"
let "k=k+1"
manganames[$k]="Battle Angel Alita: Holy Night and Other Stories"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-100334155"
let "k=k+1"
manganames[$k]="Battle Angel Alita - Mars Chronicle"
mangapages[$k]="https://mangarock.com/manga/mrs-serie-90681"

######### #########
############################################################# MANGA LIST







q=0
q1=1
let "k1=k+1"
for manga in "${manganames[@]}"; do
  echo "checking $manga"
  manga_lastpdfs="${log_folder}/mangalist_$(echo "${manga}" | sed "s/ /+/g;s/://g")_lastpdfs"
  echo "$manga_lastpdfs"
  echo "${mangapages[$q]}"
  mangapage="${mangapages[$q]}"

  mangaissueslist() {
    source $HOME/bin/comics_dowloander_python_env/bin/activate  
    wget --tries=256 --timeout=256 --wait=$(( ( RANDOM % 10 )  + 1 )) --waitretry=$(( ( RANDOM % 10 )  + 1 )) --random-wait --no-dns-cache -O- -q "$mangapage" > /tmp/input.html
    python3 -B -c "import sys;import re;from bs4 import BeautifulSoup;pagex=open(\"/tmp/input.html\");pagey=pagex.read();soup=BeautifulSoup(pagey, 'html.parser');alla=soup.find_all(\"a\",text=True,href=True);[sys.stdout.write('https://mangarock.com'+line['href']+'\n') for line in alla if re.search(\"/manga/mrs-serie-.*/chapter/mrs-chapter\", line['href'])]"
    rm -f /tmp/input.html
    deactivate
  }
  export -f mangaissueslist

  mangaissuedownload() {
    cd "${temp_folder}/manga_tmp"
    j="$(cat "/tmp/manga_incrj")"
    filex=""
    o=1
    fileok=true
    while [[ "$filex" == "" ]]; do # to prevent errors
      if [[ "$o" -gt 10 ]]; then # in case of big errors
        # echo "$1" >> "${SHARED_SYNCTHING_FOLDER}/${manga}_lostchapter.txt"
        fileok=false
        break
      fi
      formatx=cbz # pdf, cbr, epub
      echo "[$j/$totalj/$q1/$k1]: downloading issue [$j] of [$totalj] on link $1 for $manga  #[$q1] (total number of mangas to download: [$k1])"
      ./comics-downloader -url="$1" -format="$formatx"
      sleep 3
      filex="$(find $PWD -mindepth 1 -type f  -name "*.$formatx" -mmin -$((6*60)) -exec ls {} \; | head -n1)"
      let "o=o+1";
    done
    if [[ "$fileok" == "true" ]]; then
      # mv "$filex" "${SHARED_SYNCTHING_FOLDER}/$manga - $(basename "${filex%.*}").$formatx" ######## this line move the pdf file to the shared synchting folder, or dropbox folder or else
      echo "$1" >> "$manga_lastpdfs"
    fi
    let "j=j+1";
    echo "$j" > "/tmp/manga_incrj"
  }
  export -f mangaissuedownload


  if [[ ! ( -f "$manga_lastpdfs" ) ]]; then
    touch "$manga_lastpdfs"
    rm -f "/tmp/manga_lastpdfs"
    mangaissueslist | sort -u | uniq > "/tmp/manga_lastpdfs"
    unset manga_link
    j=1
    echo "$j" > "/tmp/manga_incrj"
    totalj="$(cat "/tmp/manga_lastpdfs" | wc -l)"
    export totalj
    export q1
    export k1
    awk -v lin="${manga_link}" '{print lin $0;}' "/tmp/manga_lastpdfs" | xargs -l1 -I {} bash -c "manga=\"$manga\"; manga_lastpdfs=\"$manga_lastpdfs\"; temp_folder=\"$temp_folder\"; mangaissuedownload \"\$@\"" _ {}
    sleep 2
  else 
    # check if new issue
    newlist=$(mangaissueslist)
    newlines=$(diff --old-line-format="" --new-line-format="%L" --unchanged-line-format="" <(cat "$manga_lastpdfs" | sort -u | uniq ) <(echo -e "$newlist" | sort -u | uniq ))
    if [[ "$newlines" != "" ]]; then
      echo "new issue for this manga!"
      unset manga_link
      j=1
      echo "$j" > "/tmp/manga_incrj"
      totalj="$(echo -e "$newlines" | wc -l)"
      export totalj
      export q1
      export k1
      echo -e "$newlines" | awk -v lin="${manga_link}" '{print lin $0;}' | xargs -l1 -I {} bash -c "manga=\"$manga\"; manga_lastpdfs=\"$manga_lastpdfs\"; temp_folder=\"$temp_folder\"; mangaissuedownload \"\$@\"" _ {}
      sleep 2
    else
      echo "no new issue for this manga."
    fi
  fi
  echo
  echo
  let "q=q+1"
  let "q1=q+1"
done

exit 0
