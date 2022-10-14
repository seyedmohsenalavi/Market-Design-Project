#!/bin/bash
ShAmliat=559

parse_page () {
    bash get-file.sh $1 $2 $3
    if [[ $? == 0 ]];then 
        bash extract-table.sh $1 $2 $3
        bash parse-table.sh $1 $2 $3
    fi
}

# 555

		
# 560 559 557 555 554 553 552 254 253 252 251 250 249 248 247 246 245 244 243 242 241 240 239 238 237 236 235 234 233 232 231 230 229 228 227 226 225 224 223 222 221 220 219 218 217 216 215 214 213 212 211 210 209 208
ostandID=0
for ShAmliat in 552 
do
    echo "get file for ostanID = $ShAmliat...page"
    # bash get-file.sh $ShAmliat $ostandID
    # if [[ $? == 0 ]];then
    # bash extract-table.sh $ShAmliat $ostandID
    # bash parse-table.sh $ShAmliat $ostandID
    rm -rf /tmp/*
    for page in {1..450}
    do
        parse_page $ShAmliat $ostandID $page &
        if [[ $(( $page % 20 )) == 0 ]]; then
            echo "wait"
            wait
            hash1=$(md5sum $(ls /tmp/out-$ShAmliat-0-* | head -1) | awk '{print $1}')
            hash2=$(md5sum $(ls /tmp/out-$ShAmliat-0-* | tail -1) | awk '{print $1}')
            echo "$hash1 $hash2"
            cat /tmp/out-$ShAmliat-$ostandID-* >> ./output/out-$ShAmliat.csv
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