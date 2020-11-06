TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UNDO_WHITELIST="pihole -w -d"

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
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_WHITELIST} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m Selesai... \e[0m"
echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n\n"
sudo pihole -g
sudo pihole restartdns
