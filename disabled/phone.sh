#cat num.txt | sort -n | uniq | sed -e 's/^\(.\{8\}\)$/023\1/;/^.\{11\}$/{H;d;}' -e '$G'
