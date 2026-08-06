---
стенд: r8t
обновлено: 2026-08-06
---

# r8t Kafka

## Развёртывание

- **Хост**: r8t-infra-01 (172.26.89.14)
- **Версия**: 3.5.2
- **Режим**: KRaft (без ZooKeeper)
- **Bootstrap**: `kafka.r8t.dirs.local:9092`
- **Протокол**: SSL
- **Аутентификация клиентов**: нет (`ssl.client.auth=none`)
- **Authorizer**: StandardAuthorizer
- **Heap**: `-Xmx1G`

## Основные топики

- `yandex360.r8t.docs.support` — сессии и снапшоты docs-support
- `AUDIT_LOG` — события аудита со всех сервисов

## Диагностика

```bash
# Список топиков
kubectl exec -n infra deploy/infra-operator-kafka-controller -- \
  kafka-topics.sh --bootstrap-server kafka.r8t.dirs.local:9092 \
  --command-config /opt/kafka/config/client-ssl.properties --list

# Список consumer groups
kubectl exec -n infra deploy/infra-operator-kafka-controller -- \
  kafka-consumer-groups.sh --bootstrap-server kafka.r8t.dirs.local:9092 \
  --command-config /opt/kafka/config/client-ssl.properties --list
```

## Особенности DNS

Wildcard dnsmasq на r8t-infra-01 перехватывает `kafka.r8t.dirs.local` → резолвится в ingress VIP (172.26.89.100) вместо IP infra-01. Явная запись `address=/kafka.r8t.dirs.local/172.26.89.14` должна быть до строки с wildcard.

Расширение search-домена: `kafka.r8t.dirs.local` из подов с `search r8t.dirs.local` → превращается в `kafka.r8t.dirs.local.r8t.dirs.local` → попадает на wildcard VIP. Исправлено через kubelet `resolvConf` без домена стенда.
