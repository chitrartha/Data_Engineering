#!/bin/bash

#Copy the files from From_Cluster to To_cluster
cd /home/hdsuser/horton/distcp/

rm -f *

sudo cp /home/sqoop/distcp/arguments.sh .
sudo chmod 777 /home/hdsuser/horton/distcp/arguments.sh
source ./arguments.sh

sudo chmod 777 /home/sqoop/distcp/tables_tmp /home/sqoop/distcp/$Table_number /home/sqoop/distcp/count_table_$From_cluster
sudo cp /home/sqoop/distcp/tables_tmp /home/sqoop/distcp/$Table_number /home/sqoop/distcp/count_table_$From_cluster /home/hdsuser/horton/distcp/

echo -e "\n`ts` Installing expect"
rpm -q expect || yum install -y expect
sleep 2

cat <<'EOF' > to_clusterpass.exp
#!/usr/bin/expect
set From_cluster [lindex $argv 0];
set To_cluster_node [lindex $argv 1];
set Table_number [lindex $argv 2];
set To_cluster_node_pass [lindex $argv 3]
spawn scp /home/hdsuser/horton/distcp/arguments.sh /home/hdsuser/horton/distcp/tables_tmp /home/hdsuser/horton/distcp/$Table_number /home/hdsuser/horton/distcp/count_table_$From_cluster hdsuser@$To_cluster_node:/home/hdsuser/horton/distcp/
expect {
   -re ".*es.*o.*" {
   exp_send "yes\r"
   exp_continue
  }
  -re ".*password:" {
    exp_send "$To_cluster_node_pass\r"
  }
}
interact
EOF

sudo chmod 777 tables_tmp $Table_number count_table_$From_cluster to_clusterpass.exp

/usr/bin/expect to_clusterpass.exp $From_cluster $To_cluster_node $Table_number $To_cluster_node_pass
