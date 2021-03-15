#!/bin/bash
# script to purge adrci logs.

source ~/.profile
v_master_log="${ORACLE_BASE}/admin/logs/purge_adrci_`hostname -s`.log"

date;df -g /u01 >> ${v_master_log}

get_adrci_home()
{
export ORACLE_SID=${v_instance}
v_adrci_home=`$ORACLE_HOME/bin/sqlplus -s "/ as sysdba" <<EOF
set feedback off
set echo off
set termout off
set timi off
set pagesize 0
select substr(value ,
instr(value,'diag')
,length(value))
from v\\$diag_info
where name='ADR Home';
exit
EOF`
}

purge_adrci_incident()
{
v_inc_age=7200
echo "`date` : Purging incident - DBName : ${db_name} : Instance Name : ${v_instance} | DB home path : ${v_adrci_home} : Purge older than (mins) : ${v_inc_age}" >> ${v_master_log}
adrci exec="set home ${v_adrci_home};purge -age ${v_inc_age} -type incident"
#adrci exec="set home ${v_adrci_home}"
}


for db_name in $(srvctl config database)
do
  v_instance=$(srvctl status database -d ${db_name}|grep -i instance|grep -i running|grep -i `hostname -s`|awk '{ print $2 }')
  get_adrci_home
  purge_adrci_incident
done

date;df -g /u01 >> ${v_master_log}

exit
