---
stand: r8t
updated: 2026-08-06
---

# r8t Tractor Migration (Nextcloud → Disk)

## Database

- **DB**: `tractor-tractordb-r8t` on PostgreSQL master
- **User**: `http-api`
- **Schema**: `tractor_disk`

## Tables

- `user_migrations` — per-user migration status (org_id + login)
- `tasks` — individual file tasks (worker_status)

## Known Bug

`nextcloud_client.py` uses `owned_by_me = owner == self.username`. 
Workaround: login with username, not email.

## Cleanup Procedure

When migration is stuck or needs restart:

```sql
-- Order matters: delete children first
DELETE FROM tractor_disk.user_migrations WHERE ...;
DELETE FROM tractor_disk.tasks WHERE ...;
```

## Status Enum

`{listing, syncing, canceling, error, success}`
