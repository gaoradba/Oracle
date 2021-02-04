set pagesize 300
set linesize 300
set trimspool on

alter session set nls_date_format='mm-dd-yyyy hh24:mi:ss';

select a.backup_type,
       a.incremental_level,
       b.tag,
       min(b.completion_time) StartTime,
       max(b.completion_time) EndTime,
       round((max(b.completion_time)-min(b.completion_time)) * 1440 / 60,0) HoursTotal,
       sum(ROUND(b.bytes/1024/1024/1024,2)) GBytes
from   v$backup_set a,
       v$backup_piece b
where  a.set_stamp=b.set_stamp
and    a.incremental_level in (0,1)
group by b.tag,a.incremental_level,a.backup_type
order by b.tag;
