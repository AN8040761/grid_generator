#!/bin/bash -xv
#Shel-skript za generirane na grid tablica i detailni tablici
#razraboten pod GNU bash, version 4.3.48(1)-release

# 1-vi variant - vyvejdane na dannite 4rez izvikvane na dialogov prozorec
# neobhodimo e v bash da byde instalirana comandata dialog 4rez "sudo apt-get install dialog"
exec 3>&1

VALUES=$(dialog --ok-label "Generate" \
	  --backtitle "Axes Generator" \
	  --title "Grid and detailed tables" \
	  --form "up/down to switch fields, tab and enter to generate, 
left/right and backspace to edit" \
18 60 0 \
	"Columns (space separated)"    		1 1	""    		1 29 1005 0 \
	"Question text" 			2 1	""       	2 29 1005 0 \
	"Scale (text)" 				3 1	""	       	3 29 1005 0 \
	"Brands"    				4 1	"" 	     	4 29 1005 0 \
	"Statements"                    	5 1	""     	5 29 1005 0 \
    "Scale (type - asc/desc)"                    	6 1	""     	6 29 1005 0 \
2>&1 1>&3)

exec 3>&-

# close fd
printf "$VALUES" > fail.doc
echo "$VALUES"
readarray a < fail.doc
# ::-1 premahva "\n" ot kraq na string-a
cols=${a[0]::-1}
q_text=${a[1]::-1}
scale=${a[2]::-1}
brands=${a[3]::-1}
statements=${a[4]::-1}
scale_type=${a[5]::-1}
#krai na 1-vi variant
# 2-ri variant - vvyvejdane na dannite mejdu kavi4kite pri definiraneto na promenlivi
cols="130 140 150"
q_text="Q1. Very beautiful product."
scale="1- strongly agree 5 – strongly disagree"
scale_type="asc"
brands="Brand A
Brand B 
Brand C 
"
statements="Strongly agree
Somewhat agree
Neither
Somewhat disagree
Strongly disagree
"

truncate -s 0 fail.doc
printf "$brands" > fail.doc
readarray ba < fail.doc
num_brands="${#ba[@]}"
truncate -s 0 fail.doc
printf "$statements" > fail.doc
readarray sa < fail.doc
num_statements="${#sa[@]}"


bkpIFS="$IFS"

IFS=' ' read -r -a ca <<< "$cols"
num_cols="${#ca[@]}"

IFS="$bkpIFS"

#printf '%s\n' "${sa[@]}"
#printf '%s\n' "${ba[@]}"
#echo $num_cols
#echo $num_statements
#echo $num_brands
truncate -s 0 axes.qin
nb=$num_brands
ns=$num_statements

case "$scale_type" in


        asc)
		
		
echo "l ${q_text%%. *}" | awk '{print tolower($0)}'>> axes.qin
echo "ttl $q_text" >> axes.qin
echo "ttl  $scale" >> axes.qin

	for ((a=0;a<=nb-1;a++))
	do				
		echo -e "n01  ${ba[$a]::-1}   \t\t;col(a)=${ca[$a]};inc(1)=c${ca[$a]}" >> axes.qin
	done


echo "side" >> axes.qin
    for ((a=0;a<=ns-1;a++))
	do				
		echo -e "n01  ${sa[$a]::-1}   \t\t;ca00'$(($a+1))'" >> axes.qin
	done

echo "n25;inc=inc(1)" >> axes.qin
echo "n12Mean" >> axes.qin
echo -e "\n" >> axes.qin


echo "n25;inc=inc(1)" >> axes.qin
echo "n12Mean" >> axes.qin
echo -e "\n" >> axes.qin

for ((b=0;b<=nb-1;b++))
	do	
echo "l ${q_text%%. *}_$(($b+1))" | awk '{print tolower($0)}'>> axes.qin
echo "ttl $q_text : ${ba[$b]::-1}" >> axes.qin
    for ((a=0;a<=ns-1;a++))
	do				
        echo -e "n01  ${sa[$a]::-1}   \t\t;c${ca[$b]}'$(($a+1))'" >> axes.qin		
	done

echo -e "\n" >> axes.qin
done

            ;;
         
        desc)
		
		
echo "l ${q_text%%. *}" | awk '{print tolower($0)}'>> axes.qin
echo "ttl $q_text" >> axes.qin
echo "ttl  $scale" >> axes.qin

	for ((a=0;a<=nb-1;a++))
	do				
		echo -e "n01  ${ba[$a]::-1}   \t\t;col(a)=${ca[$a]};inc(1)=c${ca[$a]}" >> axes.qin
	done


echo "side" >> axes.qin
    for ((a=0;a<=ns-1;a++))
	do				
		echo -e "n01  ${sa[$a]::-1}   \t\t;ca00'$(($ns-$a))'" >> axes.qin
	done

echo "n25;inc=inc(1)" >> axes.qin
echo "n12Mean" >> axes.qin
echo -e "\n" >> axes.qin


echo "n25;inc=inc(1)" >> axes.qin
echo "n12Mean" >> axes.qin
echo -e "\n" >> axes.qin

for ((b=0;b<=nb-1;b++))
	do	
echo "l ${q_text%%. *}_$(($b+1))" | awk '{print tolower($0)}'>> axes.qin
echo "ttl $q_text : ${ba[$b]::-1}" >> axes.qin
    for ((a=0;a<=ns-1;a++))
	do				
        echo -e "n01  ${sa[$a]::-1}   \t\t;c${ca[$b]}'$(($ns-$a))'" >> axes.qin		
	done

echo -e "\n" >> axes.qin
done

            
            ;;
         
                 
        *)
            echo $"Pleas enter asc or dsc in scale_type"
            exit 1
 
esac

rm fail.doc

