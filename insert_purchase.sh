#!/bin/bash

today=$(date +"%d-%m-%Y")
cont="y"

read -p "Enter the date of the purchase [$today]: " daybought 
daybought="${daybought:-$today}" 

read -p "Enter the shops name []: " shopname

while [ "$cont" = "y" ]
do

product=$(cat items.tsv | cut -f1-4 | fzf | cut -f1)
while [ -z $product ]
do
	nvim items.tsv
	product=$(cat items.tsv | cut -f1-4 | fzf | cut -f1)
done

read -p "Units [UT/kg/l]: " units
units=${units:-ut}

read -p "Quantity bought: " quantity
quantity=${quantity:-0}

read -p "Currency [eur]: " currency
currency=${currency:-eur}

read -p "Paid: " paid
paid=${paid:-0}

read -p "Description: " description

row="$product\t$quantity\t$units\t$daybought\t$paid\t$currency\t$shopname\t$description"
echo -e $row
echo -e $row  >> temporal_purchase.tsv

read -p "Do you want to continue adding more items [y/n]?" cont

done

read -p "Do you want to merge [y/n]?" merge

case $merge in
	y)
		cat temporal_purchase.tsv >> purchases.tsv
		rm temporal_purchase.tsv
		;;
	n)
		exit 1
		;;
esac
