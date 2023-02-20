#!/bin/bash

mint(){
    while true;
    do
    balance=`ironfish wallet:balance | grep Balance | cut -f3 -d' '`
    if [ -z $balance ] || [ $balance == "0.00000000" ]; then
        sleep 30
        echo -ne "."
    else
        echo "balance: $balance"
        break;
    fi
    done

    echo "ironfish mint"
    cmd_mint="ironfish wallet:mint --metadata=$1 --name=$1 --amount=1000 --fee=0.00000001 --confirm"
    info=$(${cmd_mint} 2>&1)
    echo $info

    for i in $(seq 1 60); do echo -ne ".";sleep 5;done;

    while true;
    do
    balance=`ironfish wallet:balances | grep $1 | awk '{print $3}'`
    status=`ironfish wallet:transactions | awk 'NR==3 {print $4}'`
    if [ -z $balance ] || [ $balance == "0.00000000" ]; then
        sleep 30
        echo -ne "."
        if [ $status == "expired" ]; then
            echo $status
            echo "mint again"
            info=$(${cmd_mint} 2>&1)
        fi
    else
        echo "balance: $balance"
        break;
    fi
    done
}
burn(){
    echo "ironfish burn"
    cmd_burn="ironfish wallet:burn --assetId=$(ironfish wallet:balances | grep $1 | awk '{print $2}') --amount=1 --fee=0.00000001 --confirm"
    info=$(${cmd_burn} 2>&1)
    echo $info
    while [[ $info =~ "error" ]];do sleep 60;info=$(${cmd_burn} 2>&1);echo $info;done
    for i in $(seq 1 60); do echo -ne ".";sleep 5;done;
}
send(){
    while true;
    do
    balance=`ironfish wallet:balances | grep $1 | awk '{print $3}'`
    if [ -z $balance ] || [ $balance == "0.00000000" ]; then
        sleep 30
        echo -ne "."
    else
        echo "balance: $balance"
        break;
    fi
    done

    echo "ironfish send"
    cmd_send="ironfish wallet:send --assetId=$(ironfish wallet:balances | grep $1 | awk '{print $2}')  --fee=0.00000001 --amount=1 --to=dfc2679369551e64e3950e06a88e68466e813c63b100283520045925adbe59ca --confirm"
    info=$(${cmd_send} 2>&1)
    echo $info

    while [[ $info =~ "Not enough" ]];do sleep 60;info=$(${cmd_send} 2>&1);echo $info;done
}

nodefile="node.txt"
dos2unix $nodefile

count=0
for line in $(cat $nodefile)
do
  count=`expr $count + 1`
  nodeName=$line
  echo "$count $nodeName"
  mint $nodeName
  burn $nodeName
  send $nodeName
  sleep 10
done
