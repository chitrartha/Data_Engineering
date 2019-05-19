#!/bin/bash

#Get schema.tbale name in proper format
# db_name="hk_published_src_adobe_pws_db"
# rm -f test test.new final_result
# $Beeline_URL_From_Cluster -e "use $db_name;show tables;" > test
# cat test | grep -v tab_name| grep -v "+"| cut -d"|" -f2| cut -d" " -f2 > test.new
# sed -e "s/^/$db_name./" test.new > final_result
#
# sudo su - hive
# db_name="jp_published_src_adobe_pws_db"
# hdfs dfs -ls /jp/tmp/export/$db_name.*
# hdfs dfs -chmod -R 777 /jp/tmp/export/$db_name.*


#Change to sqoop user and sqoop dictp directory.
cd distcp
#Remove the previosu files
rm -f *
#rm -v !("arguments.sh")

#Set all the vaiables.
chmod 777 arguments.sh
source ./arguments.sh

#Creation of table from user input.
# hk_published_dm_csms_db.CLIENT_OTHER_INFO
# hk_published_dm_csms_db.CUSTOMER_ADDRESS
echo "Please enter the content of $Table_number in 10 seconds"
while read -t 10 LINE
do
  echo $LINE >> $Table_number
done

tr '[:upper:]' '[:lower:]' < $Table_number > tables_tmp

kinit -kt /etc/security/keytabs/$sqoop_keytab_from $SQOOP_principal_From_Cluster

# #Delete the existing table path
# hdfs dfs -rm -R $Export_path
# hdfs dfs -mkdir -p $Export_path


#Export statement to export the data
for t in $(cat tables_tmp); do echo $t; echo "export table $t to '$Export_path$t';" >> $sql_file_for_export.sql; done
$Beeline_URL_From_Cluster -f  $sql_file_for_export.sql > $sql_file_for_export

# #Check:
# #From_cluster
for t in $(cat tables_tmp); do echo $t; echo "select count(1) from $t;" >> count_$Table_number.sql; done
$Beeline_URL_From_Cluster -f  count_$Table_number.sql > count_table_$From_cluster

chmod 777 $Table_number tables_tmp
