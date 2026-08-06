---
stand: r8t
updated: 2026-08-06
---

# r8t MinIO

## Deployment

- **Host**: r8t-infra-02 (172.26.89.15)
- **Endpoint**: `https://s3.r8t.dirs.local:443`
- **Protocol**: HTTPS
- **Migration**: port changed from 9000 → 443 (2026-08-05)

## Migration Event (2026-08-05)

- MinIO migrated to port 443
- Fix confirmed for Forms `SignatureDoesNotMatch` — temporal-worker creates all 7 thumbnail sizes with 200 on :443
- Product configs still need installer rerun: 13 resources across 6 namespaces carry old `:9000` endpoint
- forms-uploader PVC fsck'd on r8t-k8s-04, now healthy

## Products with Stale :9000 References

After installer rerun, verify no product still references `:9000`:
```bash
kubectl get configmap,secret -A -o yaml | grep ':9000'
```
