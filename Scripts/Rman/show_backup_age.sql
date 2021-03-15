set feedback off
set pagesize 0
set line 300
col DatabaseName format a34
col OldestBackup format a20
col OldestBackupInDays format 99999
col HostName format a32
col ReportDate format a18

select TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI') ReportDate,
       SYS_CONTEXT ('USERENV', 'DB_UNIQUE_NAME') DatabaseName,
       SYS_CONTEXT ('USERENV', 'SERVER_HOST') HostName,
       to_char(min(COMPLETION_TIME), 'YYYY-MM-DD') OldestBackup,
       extract(DAY FROM CAST(sysdate as timestamp) - (CAST(min(COMPLETION_TIME) AS TIMESTAMP))  )  OldestBackupInDays
from V$BACKUP_PIECE
where DELETED='NO';

exit
