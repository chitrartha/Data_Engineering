
From_cluster="p01eaedl"
Table_number="tables.in"
Distcp_script="distcp.sh"
sql_file_for_export="export_sql"
Beeline_URL_From_Cluster="beeline -u 'jdbc:hive2://azalvedlmstdp01.p01eaedl.manulife.com:2181,azalvedlmstdp02.p01eaedl.manulife.com:2181,azalvedlmstdp03.p01eaedl.manulife.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2'"
SQOOP_principal_From_Cluster="sqoop@P01EAEDL.MANULIFE.COM"
From_cluster_node="azalvedledgdp02.p01eaedl.manulife.com"
sqoop_keytab_from="sqoop.headless.keytab"

#Other configs:
Export_path="/hk/tmp/export/"
Import_path="/asia/hk/tmp/import/"
create_database_path="/asia/hk/prod/pubalished/hive/"

SQOOP_principal_To_Cluster="sqoop@D01SAEDL.MANULIFE.COM"
sqoop_keytab_to="sqoop.headless.keytab"
To_cluster="d01saedl"
To_cluster_node="azslvedledgdd01.d01saedl.manulife.com"
Beeline_URL_To_Cluster="beeline -u 'jdbc:hive2://azslvedlmgtdd02.d01saedl.manulife.com:2181,azslvedlmgtdd01.d01saedl.manulife.com:2181,azslvedlmstdd01.d01saedl.manulife.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2'"
To_cluster_node_pass="node_pass"


# Note:
# Change/add this property if ToC0luster is PV:
# SQOOP_principal_To_Cluster="sqoop-v01eaedl@P01EAEDL.MANULIFE.COM"
# sqoop_keytab_to="sqoop-v01eaedl.keytab"
# To_cluster_node="azalvedledgv01.p01eaedl.manulife.com"
# To_cluster="v01eaedl"
# Beeline_URL_To_Cluster="beeline -u 'jdbc:hive2://azalvedlmstv01.p01eaedl.manulife.com:2181,azalvedlmstv02.p01eaedl.manulife.com:2181,azalvedlnifv01.p01eaedl.manulife.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2'"
# To_cluster_node_pass="node_pass2"

# Export_path and Import_path:
# "/vn/tmp/export/"
# "/asia/vn/tmp/import/"
# "/hk/tmp/export/"
# "/hk/tmp/import/"
#
# create_database_path:
# "/hk/dev/informatica/published/hive/"
# "/asia/sg/prod/published/hive/"
# "/asia/vn/prod/published/hive/"
