#!/bin/bash

#rm -f target/*
#awk -F, -f split_outcodes.awk ukpostcodes.csv
#shuf -n 200000 ukpostcodes.csv > target/pubs.csv
#paste -d "," <(paste -d " " <(shuf -r animal_names.txt) <(yes "and") <(shuf -r animal_names.txt) | head -200000) target/pubs.csv > target/named_pubs.csv

for f in target/outcode-*.csv
do
  outcode_csv=${f:15}
  awk -F, -f minmax_outcode.awk $f | {
    read -r min_lat min_lon max_lat max_lon
    echo "name,postcode,lat,lon" > target/pubs_$outcode_csv
    awk -F, -v OFS=, -v min_lat=$min_lat -v max_lat=$max_lat -v min_lon=$min_lon -v max_lon=$max_lon -f filter_pubs.awk target/named_pubs.csv >> target/pubs_$outcode_csv
  }
done
