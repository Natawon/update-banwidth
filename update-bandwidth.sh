#!/bin/bash

# ./updat-bandwidth.sh <interface>
NIC=$1

vn_value=$(vnstat -ru 1 -tr 5 -i $NIC) || exit 3 # We collect bandwidth for 2 second
rx_value=$(echo "$vn_value"|grep rx|awk {'print $2'} | bc)
rx_unit=$(echo "$vn_value"|grep rx|awk {'print $3'}|cut -d. -f1)
tx_value=$(echo "$vn_value"|grep tx|awk {'print $2'} | bc)
tx_unit=$(echo "$vn_value"|grep tx|awk {'print $3'}|cut -d. -f1)

#echo "$vn_value"|grep rx|awk {'print $3'}|cut -d. -f1
#echo "$vn_value"|grep rx|awk {'print $2'}
#echo "$vn_value"|grep tx|awk {'print $2'}| bc
#echo "$vn_value"|grep tx|awk {'print $3'}|cut -d. -f1

x=1024
y=1000000

rx_total=$(echo $rx_value $x | awk '{printf $1*$2}')
#echo $z;

rx_totals=$(echo $rx_value $y | awk '{printf $1*$2}')
#echo $zz;

tx_total=$(echo $tx_value $x | awk '{printf $1*$2}')
#echo $p;

tx_totals=$(echo $tx_value $y | awk '{printf $1*$2}')
#echo $pp;




# Exit if its using byte
echo $vn_value|grep 'iB'&&echo "##### Please configure /etc/vnstat.conf to display in bit #####"&&exit

#recalculate rx_value and tx_value, depending on the unit in rx_unit and tx_unit
#first for rx
if [ $rx_unit == "Mbit/s" ]
    then  rx_value_recal=$((rx_total))
elif [ $rx_unit == "Gbit/s" ]
    then  rx_value_recal=$((rx_totals))
 else rx_value_recal=$((rx_value))
fi


#...then also for tx
if [ $tx_unit == "Mbit/s"  ]
    then tx_value_recal=$((tx_total))
elif [ $tx_unit == "Gbit/s" ]
    then tx_value_recal=$((tx_totals))
else tx_value_recal=$((tx_value))
fi


status="$rx_value_recal $tx_value_recal"

#echo "Current Bandwidth:" $vn_value
#echo "NIC $NIC - rx: $rx_value_recal Kbps - tx: $tx_value_recal Kbps"
#echo '{"server_name":"th-live-17.open-cdn.com","bandwidth_rx":"'$rx_value_recal'","bandwidth_tx":"'$tx_value_recal'"}'

#curl -k -X POST -H "Content-Type: application/json" -d '{"server_name":"setlive-stream-cdn.open-cdn.com","bandwidth_rx":"'$rx_value_recal'","bandwidth_tx":"'$tx_value_recal'"}' http://elearning.set.or.th:8001/api/site/bandwidths/current

curl -k -X POST -H "Content-Type: application/json" -d '{"server_name":"setlive-stream2-cdn.open-cdn.com","bandwidth_rx":"'$rx_value_recal'","bandwidth_tx":"'$tx_value_recal'"}' https://lms.elearning.set.or.th/api/site/bandwidths/current


# {
#    "id":"4",
#    "server_name":"http:\/\/th-live-14.open-cdn.com\/",
#    "bandwidth_rx":"200",
#    "bandwidth_tx":"200",
#    "datetime":"2017-09-03 15:55:51"
# }

