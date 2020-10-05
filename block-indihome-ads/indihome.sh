# The script will create a file with all the youtube ads found in hostsearch and from the logs of the Pi-hole
# it will append the list into a file called blacklist.txt'/etc/pihole/blacklist.txt'

piholeIPV4=$(hostname -I |awk '{print $1}')
piholeIPV6=$(hostname -I |awk '{print $2}')


blackListFile='/etc/pihole/black.list'
blacklist='/etc/pihole/blacklist.txt'

# Get the list from the GitHub 
sudo curl 'https://raw.githubusercontent.com/satriawandicky/pihole/block-indihome-ads/master/iklan-indihome.list'\
>>$blacklist

sudo curl 'https://raw.githubusercontent.com/satriawandicky/pihole/block-indihome-ads/master/iklan-indihome.list'\
>>$blackListFile

wait 

# check to see if gawk is installed. if not it will install it
# memeriksa jika gawk terintasll atau belum, jika belum, script berikut akan menginstallnya
dpkg -l | grep -qw gawk || sudo apt-get install gawk -y

wait 
# remove the duplicate records in place
# menghapus duplikasi record secara langsung
gawk -i inplace '!a[$0]++' $blackListFile
wait 
gawk -i inplace '!a[$0]++' $blacklist

## adding it to the blacklist in Pihole V5 
# only 200 Domains at once with no reloading
sudo xargs -a $blacklist -L200 pihole -b -nr
# restart dns  
sudo pihole restartdns
