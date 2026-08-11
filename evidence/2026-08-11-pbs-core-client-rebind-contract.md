# pbs-core rebuilt-service client-rebind contract

Date: 2026-08-11
Status: recovery design input; no live client configuration changed

If VM260 `pbs-core` is rebuilt after boot-disk loss while its datastore remains
intact, the rebuilt PBS service may have a replacement self-signed TLS identity
and replacement client-token secrets. Publication of the associated pbs-cp
custody evidence does not deploy either change.

`hv-cp` owns the resulting PVE client realization only after a separate,
approved execution packet identifies the affected storage clients, their known
starting fingerprint/token binding, the target replacement binding, validation,
and rollback. The affected current client identities are the dedicated Lore,
Katra, and Matrix PBS client identities recorded by `pbs-cp`; token values are
not retained here.

No routine pull, restart, storage rescan, or VM reconstruction may silently
alter a PVE client's PBS token or TLS fingerprint. The pre-rebind stop condition
is an unambiguous surviving datastore plus a confirmed-unavailable former VM260
service identity. This is a recovery-rebind contract, not authorization to
rebuild VM260 or to modify a storage client.
