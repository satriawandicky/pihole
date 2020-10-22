TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UNDO_WHITE_REGEX="pihole --white-regex -d"

#script white-regex -- untuk mencegah false positif
echo " \e[1m Script ini akan menghapus domain dari repository dari wildlist.txt \e[0m"
echo "\n"
echo " \e[1m ..... \e[0m"
sleep 1
echo "\n"
if [ "$(id -u)" != "0" ] ; then
	echo "script ini membutuhkan root access... akses root diperlukan telelbih dahulu!"
	exit 2
fi
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_WHITE_REGEX} $(cat /etc/pihole/white-regex.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m Selesai... \e[0m"
echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n\n"
sudo pihole -g
sudo pihole restartdns
