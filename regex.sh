TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -regex"

#script regex -- untuk mencegah false positif
echo -e " \e[1m Script ini akan mendownload dan menambahkan regex dari repository dari blocklist.list \e[0m"
echo -e "\n"
echo -e " \e[1m ..... \e[0m"
sleep 1
echo -e "\n"

if [ "$(id -u)" != "0" ] ; then
	echo "script ini membutuhkan root access... akses root diperlukan telelbih dahulu!"
	exit 2
fi

curl -sS https://raw.githubusercontent.com/satriawandicky/pihole/master/regex.list | sudo tee -a "${PIHOLE_LOCATION}"/regex.list >/dev/null
echo -e " ${TICK} \e[32m Menambhakan regex ke daftar regex pihole... \e[0m"
sleep 0.1
echo -e " ${TICK} \e[32m menghapus kemungkinan regex yang sama... \e[0m"
mv "${PIHOLE_LOCATION}"/regex.list "${PIHOLE_LOCATION}"/regex.list.old && cat "${PIHOLE_LOCATION}"/regex.list.old | sort | uniq >> "${PIHOLE_LOCATION}"/regex.list

echo -e " [...] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/regex.list | xargs) > /dev/null
 
echo -e " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo -e " ${TICK} \e[32m Selesai... \e[0m"

echo -e " \e[1m  salam @satriawandicky \e[0m"
echo -e " \e[1m  Happy AdBlocking :)\e[0m"
echo -e "\n\n"

sudo pihole -g
sudo pihole restartdns