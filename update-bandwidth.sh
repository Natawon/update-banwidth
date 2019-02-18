#!/bin/bash

# ./updat-bandwidth.sh <interface>
NIC=$1

vn_value=$(vnstat -ru 1 -tr 5 -i $NIC) || exit 3 # We collect bandwidth for 2 second
rx_value=$(echo "$vn_value"|grep rx|awk {'print $2'}|cut -d. -f1)
rx_unit=$(echo "$vn_value"|grep rx|awk {'print $3'}|cut -d. -f1)
tx_value=$(echo "$vn_value"|grep tx|awk {'print $2'}|cut -d. -f1)
tx_unit=$(echo "$vn_value"|grep tx|awk {'print $3'}|cut -d. -f1)

# Exit if its using byte
echo $vn_value|grep 'iB'&&echo "##### Please configure /etc/vnstat.conf to display in bit #####"&&exit

#recalculate rx_value and tx_value, depending on the unit in rx_unit and tx_unit
#first for rx
if [ $rx_unit == "Mbit/s" ]
    then rx_value_recal=$((rx_value*1024))
    else rx_value_recal=$((rx_value))
fi


#...then also for tx
if [ $tx_unit == "Mbit/s" ]
    then tx_value_recal=$((tx_value*1024))
    else tx_value_recal=$((tx_value))
fi

status="$rx_value_recal $tx_value_recal"

#echo "Current Bandwidth:" $vn_value
#echo "NIC $NIC - rx: $rx_value_recal Kbps - tx: $tx_value_recal Kbps"
#echo '{"server_name":"th-live-17.open-cdn.com","bandwidth_rx":"'$rx_value_recal'","bandwidth_tx":"'$tx_value_recal'"}'

curl -v -H "Content-Type: application/json" --request POST -d '{"server_name":"43.229.149.12","bandwidth_rx":"'$rx_value_recal'","bandwidth_tx":"'$tx_value_recal'"}' http://test-api.deknerd.com/api/v1.0/thailivestream/bandwidth
#curl -k -X POST -H "Content-Type: application/json" -d '{"server_name":"43.229.149.12","bandwidth_rx":"'$rx_value_recal'","bandwidth_tx":"'$tx_value_recal'"}' https://socket.deknerd.com:8091/api/v1.0/thailivestream/bandwidth

# {
#    "id":"4",
#    "server_name":"http:\/\/th-live-14.open-cdn.com\/",
#    "bandwidth_rx":"200",
#    "bandwidth_tx":"200",
#    "datetime":"2017-09-03 15:55:51"
# }

