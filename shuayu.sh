#!/bin/bash

mint(){
    echo "ironfish mint"
    cmd_mint="ironfish wallet:mint --metadata=$1 --name=$1 --amount=1000 --fee=0.00000002 --confirm"
    info=$(${cmd_mint} 2>&1)
    #echo $info
    for i in $(seq 1 10); do echo -ne ".";sleep 10;done;
    
    while true;
    do
    status=`ironfish wallet:transactions | awk 'NR==3 {print $4}'`
    if [ $status == "confirmed" ]; then
        break
    fi
    if [ $status == "expired" ]; then
        info=$(${cmd_mint} 2>&1)
        echo $info
        for i in $(seq 1 30); do echo -ne ".";sleep 10;done;
    fi
    for i in $(seq 1 3); do echo -ne ".";sleep 10;done;
    done
    echo "mint end"
}
burn(){
    echo "ironfish burn"
    cmd_burn="ironfish wallet:burn --assetId=$(ironfish wallet:balances | grep $1 | awk '{print $2}') --amount=1 --fee=0.00000002 --confirm"
    info=$(${cmd_burn} 2>&1)
    #echo $info
    for i in $(seq 1 10); do echo -ne ".";sleep 10;done;

    while true;
    do
    status=`ironfish wallet:transactions | awk 'NR==3 {print $4}'`
    if [ $status == "confirmed" ]; then
        break
    fi
    if [ $status == "expired" ]; then
        info=$(${cmd_burn} 2>&1)
        echo $info
        for i in $(seq 1 30); do echo -ne ".";sleep 10;done;
    fi
    for i in $(seq 1 3); do echo -ne ".";sleep 10;done;
    done
    echo "burn end"
}
send(){
    echo "ironfish send"
    cmd_send="ironfish wallet:send --assetId=$(ironfish wallet:balances | grep $1 | awk '{print $2}')  --fee=0.00000002 --amount=1 --to=dfc2679369551e64e3950e06a88e68466e813c63b100283520045925adbe59ca --confirm"
    info=$(${cmd_send} 2>&1)
    #echo $info

    while true;
    do
    status=`ironfish wallet:transactions | awk 'NR==3 {print $4}'`
    if [ $status == "confirmed" ]; then
        break
    fi
    if [ $status == "expired" ]; then
        info=$(${cmd_send} 2>&1)
        echo $info
        for i in $(seq 1 30); do echo -ne ".";sleep 10;done;
    fi
    for i in $(seq 1 3); do echo -ne ".";sleep 10;done;
    done
    echo "send end"
}

nodefile=$(find . -name "node*.txt" | head -n 1)

totol=$(awk 'END {print NR}' < $nodefile)
count=0
for line in $(cat $nodefile)
do
  count=`expr $count + 1`
  nodeName=$line
  echo "$totol/$count $nodeName"
  mint $nodeName
  burn $nodeName
  send $nodeName
done
