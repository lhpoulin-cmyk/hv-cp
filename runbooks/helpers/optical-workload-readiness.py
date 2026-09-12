#!/usr/bin/env python3
"""Read-only guest workload metadata; no media or credential contents collected."""
import subprocess,json,pathlib
commands={
'services':['systemctl','list-units','--type=service','--state=running','--no-pager','--plain'],
'timers':['systemctl','list-timers','--all','--no-pager'],
'jobs':['systemctl','list-jobs','--no-pager'],
'users':['who'],
'containers':['sh','-c','if command -v docker >/dev/null; then docker ps --format "{{.Names}} {{.Status}}"; else echo docker-absent; fi'],
'at':['sh','-c','if command -v atq >/dev/null; then atq; else echo at-absent; fi'],
'cron':['sh','-c','ls -la /var/spool/cron/crontabs /etc/cron.d /etc/cron.hourly 2>/dev/null'],
'gpu':['sh','-c','ls -l /dev/dri; fuser /dev/dri/* 2>&1'],
'uuid':['cat','/sys/class/dmi/id/product_uuid'],
'bootid':['cat','/proc/sys/kernel/random/boot_id'],
'media':['findmnt','--json','-o','SOURCE,TARGET,FSTYPE,OPTIONS']}
out={}
for key,argv in commands.items():
 p=subprocess.run(argv,text=True,capture_output=True);out[key]={'rc':p.returncode,'stdout':p.stdout,'stderr':p.stderr}
print(json.dumps(out))
