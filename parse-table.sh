#!/bin/bash

ostanID=$2
ShAmliat=$1
page=$3

input="/tmp/output-$ShAmliat-$ostanID-$page.html"
output="/tmp/$RANDOM.csv"
result="/tmp/out-$1-$2-$3.csv"
echo -n ""> $result
echo -n ""> $output
td_start=0
row=""
while IFS= read -r line
do
if [[ "$line" == *"<tr>"* ]]; then
  echo "" >> $output
    continue
fi
if [[ "$line" == *"<td"* ]]; then
  td_start=1
  continue
fi

if [[ "$line" == *"</tr>"* ]]; then
    row=$(echo "${row}"|tr '\r' ' ')
    echo  $row >> $output
    row=""
    td_start=0
    continue
fi

if [[ "$line" == *"</td>"* ]]; then
    row="$row   "
    td_start=0
    continue
fi

if [[ "$td_start" == 1 ]]; then
    if [[ "$line" == *"<a"* ||  "$line" == *"</a"* || "$line" == *"<i"* || "$line" == *"<th"* ]]; then
        continue
    fi
    
    row="$row;$line"
    continue

fi



done < "$input"

cat $output | sed '/^[[:space:]]*$/d' >> $result
rm $output