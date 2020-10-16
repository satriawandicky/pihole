TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -w -d"

#script menghapus domain dari whitelist
echo " \e[1m Script ini akan menghapus domain dari repository dari whitelist.txt \e[0m"
echo "\n"
echo " \e[1m Semua domain merupakan list yang aman dan tidak mengandung domain iklan maupun tracking. \e[0m"
sleep 1
echo -e "\n"
if [ "$(id -u)" != "0" ] ; then
	echo "script ini membutuhkan root access... akses root diperlukan telelbih dahulu!"
	exit 2
fi

curl -sS https://raw.githubusercontent.com/satriawandicky/pihole/master/whitelist.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
echo " ${TICK} \e[32m Menambhakan domain ke daftar whitelist pihole... \e[0m"
sleep 0.1
echo " ${TICK} \e[32m menghapus kemungkinan domain yang sama... \e[0m"
mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt

echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m Selesai... \e[0m"

echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n\n"

sudo pihole restartdns