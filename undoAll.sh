TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"

GRAVITY_UNDO_WILD="pihole --wild -d"
GRAVITY_UNDO_WHITELIST="pihole -w -d"

#script wildcard -- untuk mencegah false positif
echo " \e[1m Script ini akan menghapus semua domain dari repository setiap  \e[0m"
echo "\n"
echo " \e[1m ..... \e[0m"
sleep 1
echo "\n"
if [ "$(id -u)" != "0" ] ; then
	echo "script ini membutuhkan root access... akses root diperlukan telelbih dahulu!"
	exit 2
fi

echo " ${TICK} \e[32m Undo wildcard, whitelist, blocklist dari local list... \e[0m"


#undo wildcard
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_WILD} $(cat /etc/pihole/wildcard.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m Selesai... \e[0m"

sleep 1

#undo whitelist
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_WHITELIST} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m Selesai... \e[0m"

echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n\n"

sudo pihole -g
sudo pihole restartdns
