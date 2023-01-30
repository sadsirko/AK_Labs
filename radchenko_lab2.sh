#!/bin/bash
#if it`s already created clear it
echo "" > url_bash | > url_uniq | > url_amount | > url_link
touch url_percents url_sorted res;
rm url_percents url_sorted res;
PATH_DIV="./divided/*"
mkdir "divided"

function bash_fulling(){
LINE=""
# nl add separetors ==, pattern help concat words into lines
pattern="[0-9]+=="
pattern_err="\" 4[0-9][0-9]"
let count=0
for L in $(nl -s"== " $1);
do
        if [[ $L =~ $pattern ]];then
                #check if it`s first loop
        if [[ $LINE =~ $pattern_err ]];then
                if [ $count -ne 0 ];then
                        url="${LINE#*\"[A-Z][A-Z][A-Z]* }"
                        url="${url%%\ *}"
                        #echo $url
                        #save all urls into urlbash
                        echo "$url" >> url_bash
                fi
                ((count++))
                #show progress
#               last=$(($count % 100))
#               #echo $count
#               if [ $last -eq 0 ]; then
#                       echo $(($count / 100))
#               fi
        fi
                LINE=""

        else
        #concatinations of words
                LINE+="$L "
        fi
done
}
#for bigdata
split -l 1000000 $1 ./divided/divided_log_

for f in $PATH_DIV
do
#       echo "Processing $f file..."
        bash_fulling $f
  # take action on each file. $f store current file name
#  cat "$f"
done

#echo "checkpoint urlbash done"
# to count every repeat of url
cat url_bash | sort | uniq > url_uniq
#echo "url_uniq done"
for f in $(cat url_uniq);
do
        grep -F -c $f url_bash >> url_amount
        echo $f  >> url_link
done

#echo "urls count done"
#concat amount of links and links and take top 10
paste url_amount url_link | sort -nr | head -n 10 > url_amount_link_sorted_10

# creation of amount_sorted for counting sum and %
cat url_amount | sort -nr | head -n 10 > url_amount_sorted

#SUM of top 10 urls
for i in $(cat url_amount_sorted)
do
        ((SUM += $i))
done

#count % for each uniq url
for i in $(cat url_amount_sorted)
do
        echo "$i - $(($i*100/$SUM))%" >> url_percents
done

#cut to needed form
for i in $(cat url_amount_link_sorted_10)
do
        if [ ${i:0:1} = "/" ];then
                echo "${i} -" >> url_sorted
        fi
done
paste url_sorted url_percents > res

#output
nl -s"." res
rm -rf divided
rm url_*