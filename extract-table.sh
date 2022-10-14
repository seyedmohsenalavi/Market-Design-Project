#!/bin/bash
ostanID=$2
ShAmliat=$1
page=$3
input="/tmp/input-$ShAmliat-$ostanID-$page.html"
output="/tmp/output-$ShAmliat-$ostanID-$page.html"
start=0
echo -n "" > $output
while IFS= read -r line
do
    if [[ $start == 1 ]]; then
        echo $line | grep "</table>" > /dev/null 
        if [[ $? == 0 ]]; then
            echo "table for $ShAmliat $ostanID and page $page extracted"
            exit 0
        fi
        echo $line >> $output
    else
        echo $line | grep "table table-striped table-bordered table-hover" > /dev/null
        if [[ $? == 0 ]]; then
            start=1
        fi
    fi
  #echo "$line"
done < "$input"