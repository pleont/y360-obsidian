---
stand: r8t
updated: 2026-08-06
---

# r8t DNS (dnsmasq)

## Configuration

- **Host**: r8t-infra-01 (172.26.89.14)
- **Type**: dnsmasq (managed via Ansible)
- **Zone**: r8t.dirs.local
- **Config**: `/etc/dnsmasq.conf`

## Critical Rule: Order Matters

dnsmasq processes `address=/...` directives **sequentially**. The wildcard catch-all must be LAST:

```
# Explicit records FIRST
address=/kafka.r8t.dirs.local/172.26.89.14
address=/pg-master.r8t.dirs.local/172.26.89.14
address=/opensearch.r8t.dirs.local/172.26.89.15
address=/s3.r8t.dirs.local/172.26.89.15
address=/fs.r8t.dirs.local/172.26.89.19

# Wildcard LAST — catches everything else to ingress VIP
address=/.r8t.dirs.local/172.26.89.100
```

## Adding New Records

1. Back up: `cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak.$(date +%Y%m%d_%H%M%S)`
2. Insert before the wildcard line
3. Test: `dnsmasq --test`
4. Restart: `systemctl restart dnsmasq`
5. Verify: `nslookup <name> 127.0.0.1`

## Pitfalls

- **Wildcard captures external services**: without explicit entry, `fs.r8t.dirs.local` → 172.26.89.100 (ingress), not AD server
- **Search-domain expansion**: pod `search r8t.dirs.local` + short name → `name.r8t.dirs.local.r8t.dirs.local` → wildcard VIP
- **config**: `no-hosts` set — do not use `/etc/hosts`
