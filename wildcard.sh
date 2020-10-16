TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole --wild -q"

#script wildcard -- untuk mencegah false positif
echo " \e[1m Script ini akan mendownload dan menambahkan domain dari repository dari blocklist.txt \e[0m"
echo "\n"
echo " \e[1m ..... \e[0m"
sleep 1
echo "\n"

if [ "$(id -u)" != "0" ] ; then
	echo "script ini membutuhkan root access... akses root diperlukan telelbih dahulu!"
	exit 2
fi

#undo wildcard
GRAVITY_UNDO_WILD="pihole --wild -d"
mv "${PIHOLE_LOCATION}"/wildcard.txt "${PIHOLE_LOCATION}"/wildcard.txt.old && cat "${PIHOLE_LOCATION}"/wildcard.txt.old | sort | uniq > "${PIHOLE_LOCATION}"/undo-wildcard.txt
echo " [...] \e[32m undo list sebelumnya....harap tunggu \e[0m"
${GRAVITY_UNDO_WILD} $(cat /etc/pihole/undo-wildcard.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo wildcard... \e[0m"
echo " \e[1m ................... \e[0m"
sleep 0.1
curl -sS https://raw.githubusercontent.com/satriawandicky/pihole/master/wildcard.txt | sudo tee -a "${PIHOLE_LOCATION}"/wildcard.txt && sort -u "${PIHOLE_LOCATION}"/wildcard.txt > /dev/null
echo " ${TICK} \e[32m Menambahkan domain ke daftar wildcard pihole... \e[0m"
sleep 0.1
echo " ${TICK} \e[32m menghapus kemungkinan domain yang sama... \e[0m"
sleep 1

echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
echo " [...] \e[32m mengupdate list berikut.... \e[0m"
echo "\n"
sort -u /etc/pihole/wildcard.txt
echo "\n"

sleep 1

${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/wildcard.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m Selesai... \e[0m"
echo "\n"
echo "\n------------------------------------\n"
echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n------------------------------------\n"
echo "\n\n"

sudo pihole -g
sudo pihole restartdns
