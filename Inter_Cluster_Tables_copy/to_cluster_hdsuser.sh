#!/bin/bash

#Copy of files copied from From_Cluster
cd /home/hdsuser/horton/distcp/

source ./arguments.sh

sudo chmod 777 arguments.sh tables_tmp $Table_number count_table_$From_cluster

sudo cp arguments.sh tables_tmp $Table_number count_table_$From_cluster /home/sqoop/distcp/

rm -f /home/hdsuser/horton/distcp/*
