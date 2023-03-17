#!/bin/bash
#if it`s already created clear it
echo "" > url_bash | > url_uniq | > url_amount | > url_link
awk '/" 4[0-9][0-9] / { print $7 }'  $1 > url_bash
cat url_bash |sort | uniq -c | sort -nr > url_link
awk '{print $1}' url_link > url_amount
SUM=$(awk '{ sum += $1 } END { print sum;exit }' url_amount)
awk  -v s=$SUM 'BEGIN{ ans = $s} {print $2 " - " $1 " -  "$1*100/s  "%"  }'   url_link | head -n 10 | nl -s"."

# awk '/" 4[0-9][0-9] / { print $7 }' $1 | sort | uniq -c | sort -nr | 
#   awk '{ sum += $1 } END { for(i=1;i<=10;i++) printf "%d - %s - %d - %.2f%%\n", i, $2, $1, $1/sum*100 }' sum=$(awk '{ sum += $1 } END { print sum }' )