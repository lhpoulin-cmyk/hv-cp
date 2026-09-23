#!/usr/bin/env python3
"""Read-only hypervisor inventory; JSON contains private hardware identifiers.

Stream as root over SSH. No package updates, writes, mounts, guest actions,
SMART tests, pool import/scrub, driver changes, credential/config dumps.
Individual commands are bounded; missing optional tools are UNKNOWN.
"""
import datetime,json,os,pathlib,shutil,socket,subprocess,sys
out={'host':socket.gethostname(),'euid':os.geteuid(),'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'commands':{}}
if len(sys.argv)!=2 or out['host']!=sys.argv[1]: raise SystemExit('Host identity mismatch')
def run(key,argv,timeout=25):
 if not shutil.which(argv[0]):
  out['commands'][key]={'argv':argv,'status':'UNKNOWN: tool absent'};return None
 try:
  p=subprocess.run(argv,capture_output=True,text=True,timeout=timeout)
  r={'argv':argv,'rc':p.returncode,'stdout':p.stdout,'stderr':p.stderr}
 except subprocess.TimeoutExpired as e:
  r={'argv':argv,'status':'UNKNOWN: timeout','stdout':(e.stdout or b'').decode(errors='replace') if isinstance(e.stdout,bytes) else e.stdout,'stderr':(e.stderr or b'').decode(errors='replace') if isinstance(e.stderr,bytes) else e.stderr}
 out['commands'][key]=r;return r
commands={
'identity':['hostnamectl'],'time':['date','--iso-8601=seconds'],'boot':['uptime','-s'],'uptime':['uptime'],
'kernel':['uname','-a'],'pve_version':['pveversion','--verbose'],'nodes':['pvesh','get','/nodes','--output-format','json'],
'vms':['pvesh','get','/nodes/'+out['host']+'/qemu','--output-format','json'],
'containers':['pvesh','get','/nodes/'+out['host']+'/lxc','--output-format','json'],
'vm_list':['qm','list'],'ct_list':['pct','list'],
'cpu':['lscpu','--json'],'memory':['free','-b'],'dmi':['dmidecode','--type','0,1,2,3,4,16,17,39'],
'pci':['lspci','-Dnnk'],'pci_tree':['lspci','-tv'],'usb':['lsusb'],'usb_tree':['lsusb','-t'],
'block':['lsblk','--json','--bytes','-o','NAME,PATH,TYPE,SIZE,MODEL,SERIAL,TRAN,FSTYPE,FSVER,LABEL,UUID,MOUNTPOINTS'],
'mounts':['findmnt','--json','-o','SOURCE,TARGET,FSTYPE,OPTIONS'],'space':['df','-hT'],
'pools':['zpool','status','-P'],'pool_capacity':['zpool','list','-Hp','-o','name,size,alloc,free,health'],
'datasets':['zfs','list','-Hp','-o','name,used,avail,refer,mountpoint'],'boot_config':['proxmox-boot-tool','status'],
'efi':['efibootmgr','-v'],'addresses':['ip','-j','address'],'links':['ip','-j','-d','link'],
'routes':['ip','-j','route','show','table','all'],'bridges':['bridge','-j','link'],
'vlans':['bridge','-j','vlan','show'],'listeners':['ss','-lntup'],
'cluster':['pvecm','status'],'node_status':['pvesh','get','/nodes/'+out['host']+'/status','--output-format','json'],
'failed':['systemctl','--failed','--no-pager'],'services':['systemctl','list-units','--type=service','--state=running','--no-pager'],
'timers':['systemctl','list-timers','--all','--no-pager'],'pve_firewall':['pve-firewall','status'],
'kernel_warnings':['journalctl','-k','-b','-p','warning','--no-pager','-n','250'],
'kernel_hardware':['journalctl','-k','-b','--no-pager','-n','2000'],
'sensors':['sensors','-j'],'packages':['dpkg-query','-W','-f=${binary:Package}\t${Version}\n'],
'cached_updates':['apt','list','--upgradable'],'tasks':['pvesh','get','/nodes/'+out['host']+'/tasks','--limit','30','--output-format','json']}
for key,argv in commands.items():run(key,argv)
# Only hardware/resource/config keys, never passwords, cloud-init, hooks or args.
allowed=('name','hostname','memory','cores','sockets','cpu','machine','bios','ostype','onboot','startup','boot','scsihw','agent','numa','balloon','unprivileged','rootfs','swap','features','lock','protection')
configs={}
for kind,key in [('qemu','vms'),('lxc','containers')]:
 r=out['commands'][key]
 if r.get('rc')!=0:continue
 for vm in json.loads(r['stdout']):
  vmid=str(vm['vmid']);argv=['pvesh','get','/nodes/'+out['host']+'/'+kind+'/'+vmid+'/config','--output-format','json']
  try:
   p=subprocess.run(argv,capture_output=True,text=True,timeout=15)
   cfg=json.loads(p.stdout) if p.returncode==0 else {}
   configs[kind+'/'+vmid]={'argv':argv,'rc':p.returncode,'config':{k:v for k,v in cfg.items() if k in allowed or any(k.startswith(prefix) and k[len(prefix):].isdigit() for prefix in ['hostpci','usb','net','scsi','sata','ide','virtio','mp','unused'])}}
  except Exception as e:configs[kind+'/'+vmid]={'status':'UNKNOWN','error':str(e)}
out['guest_configs']=configs
out['pci_sysfs']=[]
for p in pathlib.Path('/sys/bus/pci/devices').iterdir():
 def read(n):
  try:return (p/n).read_text().strip()
  except OSError:return None
 c=read('class')
 if c and c.startswith(('0x03','0x04','0x01','0x02')):
  group=p/'iommu_group';out['pci_sysfs'].append({'address':p.name,'class':c,'vendor':read('vendor'),'device':read('device'),'driver':(p/'driver').resolve().name if (p/'driver').exists() else None,'iommu_group':group.resolve().name if group.exists() else None,'group_members':[x.name for x in (group/'devices').glob('*')]})
# SMART health/identity only, no self-tests; skip spinning up standby disks.
r=out['commands']['block']
if r.get('rc')==0:
 for disk in json.loads(r['stdout']).get('blockdevices',[]):
  if disk['type']=='disk' and disk.get('model') and disk.get('tran')!='usb':
   run('smart_'+disk['name'],['smartctl','-n','standby','-i','-H','-A',disk['path']],15)
if pathlib.Path('/etc/pve/ceph.conf').exists():run('ceph',['ceph','-s','--format','json'],15)
out['ended_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
print(json.dumps(out,indent=2))
