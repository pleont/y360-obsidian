---
stand: r8t
updated: 2026-08-06
---

# r8t Kafka

## Deployment

- **Host**: r8t-infra-01 (172.26.89.14)
- **Version**: 3.5.2
- **Mode**: KRaft (no ZooKeeper)
- **Bootstrap**: `kafka.r8t.dirs.local:9092`
- **Protocol**: SSL
- **Client auth**: none (`ssl.client.auth=none`)
- **Authorizer**: StandardAuthorizer
- **Heap**: `-Xmx1G`

## Key Topics

- `yandex360.r8t.docs.support` — docs-support sessions and snapshots
- `AUDIT_LOG` — audit events from all services

## Diagnostics

```bash
# List topics
kubectl exec -n infra deploy/infra-operator-kafka-controller -- \
  kafka-topics.sh --bootstrap-server kafka.r8t.dirs.local:9092 \
  --command-config /opt/kafka/config/client-ssl.properties --list

# Check consumer groups
kubectl exec -n infra deploy/infra-operator-kafka-controller -- \
  kafka-consumer-groups.sh --bootstrap-server kafka.r8t.dirs.local:9092 \
  --command-config /opt/kafka/config/client-ssl.properties --list
```

## DNS Pitfall

dnsmasq wildcard on r8t-infra-01 catches `kafka.r8t.dirs.local` → resolves to ingress VIP (172.26.89.100) instead of infra-01 IP. Explicit `address=/kafka.r8t.dirs.local/172.26.89.14` must be before the wildcard line.

Search-domain expansion: `kafka.r8t.dirs.local` from pods with `search r8t.dirs.local` → becomes `kafka.r8t.dirs.local.r8t.dirs.local` → wildcard to VIP. Fixed by kubelet `resolvConf` without stand domain.
