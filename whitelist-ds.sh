TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -w -q"

#script whitelist -- untuk mencegah false positif
echo " \e[1m Script ini akan mengunduh dan menambahkan domain dari repository whitelist.txt \e[0m"
echo "\n"
echo " \e[1m Semua domain merupakan list yang aman dan tidak mengandung domain iklan maupun tracking. \e[0m"
sleep 1
echo "\n"

if [ "$(id -u)" != "0" ] ; then
	echo "script ini membutuhkan root access... akses root diperlukan terlebih dahulu!"
	exit 2
fi

# undo whitelist
GRAVITY_UNDO_WHITELIST="pihole -w -d"
mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq > "${PIHOLE_LOCATION}"/undo-whitelist.txt
echo " [....] \e[32m undo list sebelumnya....harap tunggu \e[0m"
${GRAVITY_UNDO_WHITELIST} $(cat /etc/pihole/undo-whitelist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Selesai undo whitelist... \e[0m"
echo " \e[1m .................................. \e[0m"
sleep 0.1

# add new whitelist 
curl -sS https://raw.githubusercontent.com/satriawandicky/pihole/master/whitelist.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt > /dev/null
echo " ${TICK} \e[32m Menambhakan domain ke daftar whitelist pihole... \e[0m"
sleep 0.1
echo " ${TICK} \e[32m menghapus kemungkinan domain yang sama... \e[0m"
mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt
echo " [....] \e[32m Pi-hole gravity memperbarui list....harap tunggu \e[0m"
${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
echo " ${TICK} \e[32m Pi-hole's gravity berhasil di update \e[0m"
echo " ${TICK} \e[32m ========================================\e[0m"
echo " \e[1m script berikut merupakan referall code yang terkadang false positif detection dari pihole.  \e[0m"
read -p "apakah anda ingin memasukkan referral site kedalam whitelist (y/n)? " REPLY
if [ "$REPLY" = "y" ];
then
	echo " \e[1m Script ini akan mendownload dan menambahkan domain referal code ke whitelist.txt \e[0m"
	sleep 1
	echo "\n"
	curl -sS https://raw.githubusercontent.com/satriawandicky/pihole/master/referral.txt | sudo tee -a "${PIHOLE_LOCATION}"/referral.txt >/dev/null
	echo " ${TICK} \e[32m Menambahkan domain ke whitelist... \e[0m"
	sleep 0.5
	cat "${PIHOLE_LOCATION}"/referral.txt >> "${PIHOLE_LOCATION}"/whitelist.txt
	echo " ${TICK} \e[32m Menghapus Duplikasi... \e[0m"
	mv "${PIHOLE_LOCATION}"/whitelist.txt /etc/pihole/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt
	wait
	echo " [...] \e[32m menambahkan list kedalam Pi-hole gravity. Harap tunggu sebentar \e[0m"
	${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
	wait
	echo " ${TICK} \e[32m Pi-hole's gravity sudah terupdate \e[0m"
	echo " ${TICK} \e[32m Selesai. Terima kasih! \e[0m"
	echo "\n\n"
fi
echo " \e[1m  salam @satriawandicky \e[0m"
echo " \e[1m  Happy AdBlocking :)\e[0m"
echo "\n\n"
pihole -g
sudo pihole restartdns
