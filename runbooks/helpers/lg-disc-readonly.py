#!/usr/bin/env python3
"""Bounded read-only LG qualification. Only /dev/sr1 and /dev/sg3 are probed.

Requires the previously verified serial as argv[1]. Emits private JSON evidence.
No files, mounts, settings, services or devices are written. dd discards 16 MiB
into /dev/null; sg_inq sends only standard SCSI INQUIRY. No package installation.
"""
import datetime
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


result = {'started_utc': now(), 'commands': [], 'metadata': {}}


def command(argv):
    started = now()
    p = subprocess.run(argv, capture_output=True, text=True)
    entry = {'argv': argv, 'started_utc': started, 'ended_utc': now(),
             'exit_code': p.returncode, 'stdout': p.stdout, 'stderr': p.stderr}
    result['commands'].append(entry)
    return entry


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


try:
    require(len(sys.argv) == 2 and sys.argv[1], 'Expected physical serial required')
    require(os.uname().nodename == 'b70-encode-matrix', 'Guest identity mismatch')
    block = Path('/sys/class/block/sr1/device').resolve(strict=True)
    generic = Path('/sys/class/scsi_generic/sg3/device').resolve(strict=True)
    result['metadata']['block_sysfs'] = str(block)
    result['metadata']['generic_sysfs'] = str(generic)
    require(block == generic, 'Block/generic target mismatch')
    require('0000:03:00.0' in block.parts, 'ASMedia topology mismatch')
    udev = command(['udevadm', 'info', '--query=property', '--name=/dev/sr1'])
    require(udev['exit_code'] == 0, 'Udev identity unavailable')
    props = dict(line.split('=', 1) for line in udev['stdout'].splitlines() if '=' in line)
    require(props.get('ID_SERIAL_SHORT') == sys.argv[1], 'Physical serial mismatch')
    require('WH16NS60' in props.get('ID_MODEL', ''), 'LG model mismatch')
    result['metadata']['identity_correlated'] = True
    require(props.get('ID_CDROM_MEDIA') == '1', 'Media not detected')
    result['metadata']['media_detected'] = True
    result['metadata']['capacity_sysfs_bytes'] = int(Path('/sys/class/block/sr1/size').read_text()) * 512
    device_number = Path('/sys/class/block/sr1/dev').read_text().strip()
    result['metadata']['mountinfo_before'] = [line for line in Path('/proc/self/mountinfo').read_text().splitlines() if line.split()[2] == device_number]
    logs = command(['journalctl', '-k', '-n', '1', '--show-cursor', '--no-pager', '--utc'])
    require(logs['exit_code'] == 0 and 'not seeing messages' not in logs['stderr'], 'Guest kernel logs inaccessible')
    cursor = re.search(r'^-- cursor: (.+)$', logs['stdout'], re.M)
    require(cursor is not None, 'Guest kernel cursor unavailable')
    for tool in ['timeout', 'dd']:
        require(shutil.which(tool) is not None, 'Required tool missing: ' + tool)
    result['metadata']['test_started_utc'] = now()
    for tool, argv in [
        ('blockdev', ['timeout', '15s', 'blockdev', '--getsize64', '/dev/sr1']),
        ('blkid', ['timeout', '15s', 'blkid', '-p', '-o', 'export', '/dev/sr1']),
        ('sg_inq', ['timeout', '15s', 'sg_inq', '--only', '/dev/sg3']),
    ]:
        if shutil.which(tool):
            command(argv)
        else:
            result['metadata'][tool] = 'UNKNOWN: optional tool absent'
    read = command(['timeout', '30s', 'dd', 'if=/dev/sr1', 'of=/dev/null', 'bs=1M', 'count=16', 'iflag=direct,fullblock'])
    byte_match = re.search(r'^(\d+) bytes', read['stderr'], re.M)
    result['metadata']['bytes_read'] = int(byte_match.group(1)) if byte_match else None
    result['metadata']['block_read_pass'] = read['exit_code'] == 0 and result['metadata']['bytes_read'] == 16777216
    result['metadata']['test_ended_utc'] = now()
    command(['journalctl', '-k', '--after-cursor=' + cursor.group(1), '--no-pager', '--utc', '-o', 'short-iso-precise'])
    result['metadata']['mountinfo_after'] = [line for line in Path('/proc/self/mountinfo').read_text().splitlines() if line.split()[2] == device_number]
except Exception as error:
    result['error'] = str(error)
result['ended_utc'] = now()
print(json.dumps(result, indent=2))
sys.exit(1 if 'error' in result else 0)
