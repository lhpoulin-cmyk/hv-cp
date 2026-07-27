# Implementation packet: hv-matrix hv-cp checkout

Purpose: clone standalone hv-cp to /home/louis/hv-cp on Matrix.
Authority: operator, 2026-07-27.
Excluded: services, credentials, notifications, network, storage, cluster, Ceph, guests.
Validation: clean main checkout. Rollback: remove only that checkout.
