#!/bin/bash

parse_page () {
    bash get-file2.sh $1 $2 $3
    if [[ $? == 0 ]];then 
        bash extract-table.sh $1 $2 $3
        bash parse-table.sh $1 $2 $3
    fi
}


		
		
for ShAmliat in 140007 140006 140003 140002 140001 9813 9812 9810 9809 9808 9807 9805 9804 9803
do
    echo "get file for ostanID = $ShAmliat...page"
    # bash get-file.sh $ShAmliat $ostandID
    # if [[ $? == 0 ]];then
    # bash extract-table.sh $ShAmliat $ostandID
    # bash parse-table.sh $ShAmliat $ostandID
    rm -rf /tmp/*
    for page in {1..73}
    do
        parse_page $ShAmliat $ostandID $page &
        if [[ $(( $page % 20 )) == 0 ]]; then
            echo "wait"
            wait
            hash1=$(md5sum $(ls /tmp/out-$ShAmliat-0-* | head -1) | awk '{print $1}')
            hash2=$(md5sum $(ls /tmp/out-$ShAmliat-0-* | tail -1) | awk '{print $1}')
            echo "$hash1 $hash2"
            cat /tmp/out-$ShAmliat-$ostandID-* >> ./output2/out-$ShAmliat.csv
            rm -rf /tmp/*
            if [[ $hash1 == $hash2 ]];then
                echo "Same Hash break"
                break
            fi
        fi
    done
    wait
    # fi
done