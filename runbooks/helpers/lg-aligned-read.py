#!/usr/bin/env python3
"""Read exactly 16 MiB from LG /dev/sr1 with aligned O_RDONLY|O_DIRECT I/O.

Run only after physical identity verification, under an external 30s timeout.
No device writes; anonymous memory is discarded, and only byte counts emitted.
"""
import json,mmap,os,sys,time
fd=None
buf=None
out={'bytes_read':0,'requested_bytes':16777216,'open_flags':'O_RDONLY|O_DIRECT','offset':0,'started_monotonic':time.monotonic()}
try:
    fd=os.open('/dev/sr1',os.O_RDONLY|os.O_DIRECT)
    buf=mmap.mmap(-1,1048576)
    for offset in range(0,16777216,1048576):
        n=os.preadv(fd,[buf],offset)
        out['bytes_read']+=n
        if n!=1048576:
            raise RuntimeError('short read: '+str(n))
except Exception as exc:
    out['error']=str(exc)
finally:
    if buf is not None: buf.close()
    if fd is not None: os.close(fd)
out['elapsed_seconds']=time.monotonic()-out.pop('started_monotonic')
print(json.dumps(out))
sys.exit(1 if 'error' in out else 0)
