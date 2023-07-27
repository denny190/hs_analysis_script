#!/bin/bash

main_folder_path="../08_xyz_hkl_map/BB00"
output_file="./results.txt"
time=$(date '+%Y-%m-%d %H:%M:%S')
echo "$time" > $output_file

for subfolder in $(ls -d $main_folder_path/*/)
do    
    basename=$(basename "$subfolder")  
    result=$(echo "$basename" | sed 's|/| |g')  
    
    
    water_peaks_file=$(ls $subfolder/*_dinu_waterpeaks.pdb 2>/dev/null)
    wat_scale_file=$(ls $subfolder/*_dinuWat3.4_scale.pdb 2>/dev/null)

    if [ -f "$water_peaks_file" ] && [ -f "$wat_scale_file" ]
    then
        water_peaks_file_name=$(basename "$water_peaks_file")
        wat_scale_file_name=$(basename "$wat_scale_file")
        
        temp_pdb="concat_temp.pdb"
        
        grep -v END $water_peaks_file > $temp_pdb
        grep   ATOM $wat_scale_file >> $temp_pdb
        echo "------------- $basename -------------" >> $output_file
        vmd -e HS_info.vmd -eofexit -dispdev text -args $temp_pdb $basename $output_file
        
        rm $temp_pdb
    else#
        echo "Error: Missing or multiple files found for the specified pattern in $subfolder"
    fi
done
