TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -w -q"
echo -e " \e[1m script berikut merupakan referall code yang terkadang false positif detection dari pihole.  \e[0m"
read -p "apakah anda ingin memasukkan referral site kedalam whitelist (Y/N)? " -n 1 -r
echo   
if [[ $REPLY =~ ^[Yy]$ ]]
then

	echo -e " \e[1m Script ini akan mendownload dan menambahkan domain referal code ke whitelist.txt \e[0m"
	sleep 1
	echo -e "\n"

	if [ "$(id -u)" != "0" ] ; then
		echo "Script ini membutuhkan akses root... tolong masuk sebagai root ya."
		exit 2
	fi

	curl -sS https://raw.githubusercontent.com/satriawandicky/pihole/master/referral.txt | sudo tee -a "${PIHOLE_LOCATION}"/whitelist.txt >/dev/null
	echo -e " ${TICK} \e[32m Menambahkan domain ke whitelist... \e[0m"
	sleep 0.5
	echo -e " ${TICK} \e[32m Menghapus Duplikasi... \e[0m"

	mv "${PIHOLE_LOCATION}"/whitelist.txt /etc/pihole/whitelist.txt.old && cat "${PIHOLE_LOCATION}"/whitelist.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/whitelist.txt

	wait
	echo -e " [...] \e[32m menambahkan list kedalam Pi-hole gravity. Harap tunggu sebentar \e[0m"
	${GRAVITY_UPDATE_COMMAND} $(cat /etc/pihole/whitelist.txt | xargs) > /dev/null
	wait
	echo -e " ${TICK} \e[32m Pi-hole's gravity sudah terupdate \e[0m"
	echo -e " ${TICK} \e[32m Selesai. Terima kasih! \e[0m"
	echo -e "\n\n"

fi

sudo pihole restartdns

