#!/usr/bin/env python3
"""Read-only Linux optical topology capture. Output contains private identifiers.

Run as root for complete open-handle evidence; redirect into private evidence.
Never opens media, resets devices, changes drivers, or mounts filesystems.
"""
import json
import os
from pathlib import Path
import re
import socket
import subprocess


def read(path):
    try:
        return Path(path).read_text().strip()
    except OSError:
        return None


def command(argv):
    p = subprocess.run(argv, text=True, capture_output=True, check=False)
    return {"rc": p.returncode, "stdout": p.stdout, "stderr": p.stderr}


def pci_info(address):
    root = Path('/sys/bus/pci/devices') / address
    group = root / 'iommu_group'
    return {
        'address': address, 'vendor': read(root / 'vendor'),
        'device': read(root / 'device'), 'class': read(root / 'class'),
        'driver': (root / 'driver').resolve().name if (root / 'driver').exists() else None,
        'iommu_group': group.resolve().name if group.exists() else None,
        'group_members': sorted(p.name for p in (group / 'devices').glob('*')),
        'reset_available': (root / 'reset').exists(),
        'reset_method': read(root / 'reset_method'),
        'blocks': sorted(p.name for p in Path('/sys/class/block').glob('*')
                         if str(root.resolve()) + '/' in str(p.resolve())),
    }


def main():
    devices = []
    for block in sorted(Path('/sys/class/block').glob('sr*')):
        device = (block / 'device').resolve()
        addresses = re.findall(r'(?<=/)[0-9a-f]{4}:[0-9a-f]{2}:[0-9a-f]{2}\.[0-7](?=/)', str(device) + '/')
        generic = sorted(p.name for p in (device / 'scsi_generic').glob('*'))
        paths = [str(p) for kind in ('by-id', 'by-path')
                 for p in Path('/dev/disk', kind).glob('*')
                 if p.resolve() == Path('/dev', block.name)]
        devices.append({
            'block': '/dev/' + block.name, 'generic': ['/dev/' + p for p in generic],
            'sysfs': str(device), 'vendor': read(device / 'vendor'),
            'model': read(device / 'model'), 'revision': read(device / 'rev'),
            'links': paths,
            'udev': command(['udevadm', 'info', '--query=property', '--name=/dev/' + block.name]),
            'pci': [pci_info(a) for a in addresses],
            'handles': command(['fuser', '/dev/' + block.name] + ['/dev/' + p for p in generic]),
        })
    usb = []
    for d in sorted(Path('/sys/bus/usb/devices').glob('*')):
        if not (d / 'idVendor').exists():
            continue
        usb.append({k: read(d / k) for k in ('idVendor', 'idProduct', 'manufacturer', 'product', 'serial', 'busnum', 'devnum')} |
                   {'port': d.name, 'sysfs': str(d.resolve())})
    print(json.dumps({
        'hostname': socket.gethostname(), 'euid': os.geteuid(),
        'optical': devices, 'usb': usb,
        'block_inventory': command(['lsblk', '--json', '-o', 'NAME,TYPE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS']),
        'mounts': command(['findmnt', '--json', '-o', 'SOURCE,TARGET,FSTYPE,OPTIONS']),
        'pci_inventory': command(['lspci', '-Dnnk']),
        'processes': command(['ps', '-eo', 'pid,uid,comm']),
    }, indent=2))


if __name__ == '__main__':
    main()
