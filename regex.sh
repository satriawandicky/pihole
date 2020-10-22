TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole --regex -q"

#script regex -- untuk mencegah false positif
echo " \e[1m Script ini akan mendownload dan menambahkan regex dari repository dari regex.txt \e[0m"
echo "\n"
echo " \e[1m ..... \e[0m"
sleep 1
echo "\n"
if [ "$(id -u)" != "0" ] ; then
	echo "script ini membutuhkan root access... akses root diperlukan telelbih dahulu!"
	exit 2
fi
#undo regex
GRAVITY_UNDO_REGEX="pihole --regex -d"
mv "${PIHOLE_LOCATION}"/regex.txt "${PIHOLE_LOCATION}"/regex.txt.old && cat "${PIHOLE_LOCATION}"/regex.txt.old | sort | uniq > "${PIHOLE_LOCATION}"/undo-regex.txt
echo " [....] \e[32m undo list sebelumnya....harap tunggu \e[0m"
${GRAVITY_UNDO_REGEX} $(cat /etc/pihole/undo-regex.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo regex... \e[0m"
echo " \e[1m .................................. \e[0m"
sleep 0.1
curl -sS https://raw.githubusercontent.com/satriawandicky/pihole/master/regex.txt | sudo tee -a "${PIHOLE_LOCATION}"/regex.txt >/dev/null
echo " ${TICK} \e[32m Menambhakan regex ke daftar regex pihole... \e[0m"
sleep 0.1
echo " ${TICK} \e[32m menghapus kemungkinan regex yang sama... \e[0m"
mv "${PIHOLE_LOCATION}"/regex.txt "${PIHOLE_LOCATION}"/regex.txt.old && cat "${PIHOLE_LOCATION}"/regex.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/regex.txt
echo " [...] \e[32m Pi-hole gravity memperbarui txt....harap tunggu \e[0m"
${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/regex.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m Selesai... \e[0m"
echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n\n"
sudo pihole -g
sudo pihole restartdns
