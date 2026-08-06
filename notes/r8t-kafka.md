---
стенд: r8t
обновлено: 2026-08-06
---

# r8t Kafka

## Описание

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

## Проблемы

См. [[cases/r8t-kafka-dns-search-bug]] — расширение search-домена и конфликт с wildcard dnsmasq.
