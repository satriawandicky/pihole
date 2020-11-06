TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -b -q"

#script blacklist -- untuk mencegah false positif
echo " \e[1m Script ini akan mendownload dan menambahkan domain dari repository dari blocklist.txt \e[0m"
echo "\n"
echo " \e[1m ..... \e[0m"
sleep 1
echo "\n"
if [ "$(id -u)" != "0" ] ; then
	echo "script ini membutuhkan root access... akses root diperlukan telelbih dahulu!"
	exit 2
fi
#undo blacklist old
GRAVITY_UNDO_BLACKLIST="pihole -blacklist -d"
mv "${PIHOLE_LOCATION}"/blacklist.txt "${PIHOLE_LOCATION}"/blacklist.txt.old && cat "${PIHOLE_LOCATION}"/blacklist.txt.old | sort | uniq > "${PIHOLE_LOCATION}"/undo-blacklist.txt
echo " [....] \e[32m undo list sebelumnya....harap tunggu \e[0m"
${GRAVITY_UNDO_BLACKLIST} $(cat /etc/pihole/undo-blacklist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo blacklist... \e[0m"
echo " \e[1m .................................. \e[0m"
sleep 0.1
# add new bloclist
curl -sS https://raw.githubusercontent.com/satriawandicky/pihole/master/blacklist.txt | sudo tee -a "${PIHOLE_LOCATION}"/blacklist.txt > /dev/null
echo " ${TICK} \e[32m Menambhakan domain ke daftar blacklist pihole... \e[0m"
sleep 0.1
echo " ${TICK} \e[32m menghapus kemungkinan domain yang sama... \e[0m"
mv "${PIHOLE_LOCATION}"/blacklist.txt "${PIHOLE_LOCATION}"/blacklist.txt.old && cat "${PIHOLE_LOCATION}"/blacklist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/blacklist.txt
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/blacklist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m Selesai... \e[0m"
echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n\n"
sudo pihole -g
sudo pihole restartdns
