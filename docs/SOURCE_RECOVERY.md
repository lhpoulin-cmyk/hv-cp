# Recovered Katra source: provenance and disposition

## Origin

The recovered source remains unchanged on `hv-katra` at:

```text
/home/louis/katra-handoff/workspace/infrastructure/workspace/hv-katra-pve92-autoinstall
```

At discovery it was an untracked directory inside a dirty and diverged
`infrastructure` checkout. It was not an independent Git repository.

## Safe adoption rule

The project adopts only the *method* in sanitized form. Do not copy or execute
the source `answer.toml` or generated first-boot hook: they contain
credential-derived configuration and node-specific hardware selectors. Do not
commit firmware binaries, archives, USB marker blobs, or downloaded firmware
tools to this active repository.

## Verified inventory

The following hashes were read from the source on 2026-07-26. They establish
provenance without importing the original material.

| Source item | SHA-256 | Disposition |
| --- | --- | --- |
| `README-FIRST.md` | `5391240c189281d6db7bfa811dba41ea0726c6b26c9d81940eb8c7a92e4786d2` | Method summarized here. |
| `BUILD_NOTES.md` | `11c552cd846b1704dae47fcd9312637c6aa6663f8c36377c2addf6f2c5fa7fcf` | Historical context; not copied as current authority. |
| `spartan-docs.include` | `c00ef6a18d069103c0d6b298c8d4b6357b29c8958d2bf7f1319a4053ab937d6a` | Informational source manifest. |
| `first-boot-hv-katra.template.sh` | `f7cd4647fd84cf33b8d08337dcf93d50b59625a9cc358413c004ead62e5f3f33` | Sanitized post-install contract replaces it. |
| `first-boot-hv-katra.sh` | `96dccf5c14c895b62c65e05587cd119a9df080278cf3617ed79ec169d1085043` | Generated, credential-bearing; excluded. |
| `hv-katra-present.txt.BIN` | `aaafb8ae03d91aeb785d095d282ff70af7bae419628ddaed1132eb4eed390e01` | Raw USB marker blob; excluded. |
| `hv-katra-spartan-docs.tar.gz` | `17b44f6a711a423edf738203a951fb4060e07985246ed1fb4d9db9532ea5487a` | Raw archive; excluded. |
| `firmware-analysis/OEM_1.21A_IFR_REPORT.md` | `23b537aeebbe767b3c4987548d0d3391871807f7b5f9199f582cf0ca16422aa7` | Platform-specific source evidence; retained on Katra pending separate preservation scope. |
| `firmware-analysis/RETAIL_1.40C_IFR_REPORT.md` | `0a1103029be6a22c96ba9f72b95a8db08090c7c9ee56f34bd4204edd43e09d16` | Platform-specific source evidence; retained on Katra pending separate preservation scope. |
| firmware executables and ZIP files | Recorded in the private source inventory | Binary tools; excluded. |

The source `answer.toml` was verified during the read-only inventory but is
intentionally not reproduced here because it contains a password-derived
field.


operator has increased in skill in git and this is a remediation effort
