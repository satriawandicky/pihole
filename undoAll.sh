TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UNDO_BLOCKLIST="pihole -b -d"
GRAVITY_UNDO_REGEX="pihole --regex -d"
GRAVITY_UNDO_WILD="pihole --wild -d"

GRAVITY_UNDO_WHITELIST="pihole -w -d"
GRAVITY_UNDO_WHITE_REGEX="pihole --white-regex -d"
GRAVITY_UNDO_WHITE_WILD="pihole --white-wild -d"

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

sleep 1
#undo blocklist
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_BLOCKLIST} $(cat /etc/pihole/blocklist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo blacklist...... \e[0m"
sleep 1
#undo regex blocklist
echo " [...] \e[32m Pi-hole gravity memperbarui txt....harap tunggu \e[0m"
${GRAVITY_UNDO_REGEX} $(cat /etc/pihole/regex.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo regex blocklist... \e[0m"
sleep 1
#undo wildcard blocklist
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_WILD} $(cat /etc/pihole/wildcard.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo wildcard blocklist... \e[0m"
sleep 1
# undo whitelist
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_WHITELIST} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo whitelist...... \e[0m"
sleep 1
# undo regex whitelist
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_WHITE_REGEX} $(cat /etc/pihole/white-regex.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo regex whitelist...... \e[0m"
sleep 1
# undo wildcard whitelist
echo " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UNDO_WHITE_WILD} $(cat /etc/pihole/white-wild.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo wildcard whitelist...... \e[0m"

sudo pihole -g
sudo pihole restartdns

echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n\n"