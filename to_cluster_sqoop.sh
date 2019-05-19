#!/bin/bash

cd distcp/

source ./arguments.sh

kinit -kt /etc/security/keytabs/$sqoop_keytab_to $SQOOP_principal_To_Cluster

# hdfs dfs -rm -R $Import_path
# hdfs dfs -mkdir -p $Import_path

#Copy the exported data from From cluster to To cluster
rm -f $Distcp_script
echo '#!/bin/bash' >> $Distcp_script
chmod 777 $Distcp_script
for t in $(cat tables_tmp); do echo $t; echo "hadoop --config /etc/hadoop2/conf distcp  -Dmapreduce.job.hdfs-servers.token-renewal.exclude=$From_cluster -skipcrccheck -update  hdfs://$From_cluster$Export_path$t $Import_path$t" >> $Distcp_script; done
./$Distcp_script

##################################################CREATE DATABASE START###############################################################################################
#Check if datbase exist in the To cluster
rm -f show_database_$t_$Table_number show_database_$t_$Table_number.sql
for t in $(cat tables_tmp| cut -d"." -f1| sort -u); do echo $t; echo "show databases like  '$t';" >> show_database_$t_$Table_number.sql; done
$Beeline_URL_To_Cluster -f  show_database_$t_$Table_number.sql > show_database_$t_$Table_number


rm -f database_exist database_not_exist datbase_exist_tmp datbase_not_exist_tmp
cat show_database_$t_$Table_number|cut -d"|" -f2 | grep -v database_name | grep -v + > datbase_exist_tmp

touch database_exist
touch database_not_exist
for t in $(cat tables_tmp| cut -d"." -f1); do echo $t
    if  grep  $t datbase_exist_tmp; then
        echo "$t"
    else
        echo "$t" >> database_not_exist
    fi
done
sort -u database_not_exist > datbase_not_exist_tmp
sort -u datbase_exist_tmp > database_exist

#create database if not exist in To cluster.
rm -f create_database_$Table_number.sql create_database_$Table_number
for t in $(cat datbase_not_exist_tmp); do echo $t; echo "create database $t location '$create_database_path`echo $t| rev | cut -d"/" -f2 | rev`';" >> create_database_$Table_number.sql; done

$Beeline_URL_To_Cluster -f  create_database_$Table_number.sql > create_database_$Table_number
##################################################CREATE DATABASE END###############################################################################################

##################################################EXISTING TABLES DETAILS AND ACTIONS START###############################################################################################
#Check which tables exist.
rm -f show_tables_$t_$Table_number.sql show_table_$t_$Table_number existing_tables existing_tables_tables_tmp
for t in $(cat tables_tmp); do echo $t; echo "use `echo $t|cut -d"." -f1`; show tables like '`echo $t|cut -d"." -f2`';" >> show_tables_$t_$Table_number.sql; done
$Beeline_URL_To_Cluster -f  show_tables_$t_$Table_number.sql > show_table_$t_$Table_number

cat show_table_$t_$Table_number| grep "|" |grep -v tab_name|cut -d"|" -f2 > existing_tables

#existing_tables in tables_tmp
for i in $(cat existing_tables); do echo `cat tables_tmp|grep $i` >> existing_tables_tables_tmp;done

#Description of those existin tables
rm -f describe_$Table_number.sql describe_$Table_number_to_cluster
for t in $(cat existing_tables_tables_tmp); do echo $t; echo "describe formatted $t;" >> describe_$Table_number.sql; done
$Beeline_URL_To_Cluster -f  describe_$Table_number.sql > describe_to_cluster_$Table_number

# #Drop the existing table which we will copy.
# rm -f drop_table.sql drop_table
# for t in $(cat existing_tables_tables_tmp); do echo $t; echo "drop table $t;" >> drop_table.sql; done
# $Beeline_URL_To_Cluster -f  drop_table.sql > drop_table

#remove_existing_table_data if any
rm -f remove_existing_table_data.sh
cat describe_to_cluster_$Table_number | tr -s ' ' | grep Location | cut -d"|" -f 3 > db_location
echo '#!/bin/bash' >> remove_existing_table_data.sh
chmod 777 remove_existing_table_data.sh
for t in $(cat db_location); do echo $t; echo "hdfs dfs -rm -R /`echo $t | cut -d"/" -f 4-` " >> remove_existing_table_data.sh; done
./remove_existing_table_data.sh
##################################################EXISTING TABLES DETAILS AND ACTINS END###############################################################################################

#Running the import statement
rm -f import_$Table_number.sql import_$Table_number
for t in $(cat tables_tmp); do echo $t; echo "import table $t from '$Import_path$t';" >> import_$Table_number.sql; done
$Beeline_URL_To_Cluster -f  import_$Table_number.sql > import_$Table_number

#Special import for the tables which have keyqords in their name:
#import table `jp_published_sfdc_db`.`user` from '/asia/jp/tmp/import/jp_published_sfdc_db.user';


# #Check:
# #To_cluster
#Count of the tables
rm -f count_$Table_number.sql count_to_cluster_$Table_number
for t in $(cat tables_tmp); do echo $t; echo "select count(1) from $t;" >> count_$Table_number.sql; done
$Beeline_URL_To_Cluster -f  count_$Table_number.sql > count_to_cluster_$Table_number
#TODO copied count_$Table_number_from_cluster comapre
