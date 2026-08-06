---
stand: r8t
date: 2026-08-06
status: resolved
root_cause: dns search domain expansion + wildcard dnsmasq
---

# Kafka DNS — расширение search-домена

## Симптом

kafka-controller при резолве `kafka.r8t.dirs.local` получал IP ingress VIP (172.26.89.100) вместо IP infra-01 (172.26.89.14).

## Причина

Цепочка:
1. Pod имеет `search r8t.dirs.local` в `/etc/resolv.conf`
2. kafka-controller резолвит `kafka.r8t.dirs.local` → DNS добавляет search-домен → `kafka.r8t.dirs.local.r8t.dirs.local`
3. Wildcard dnsmasq `address=/.r8t.dirs.local/172.26.89.100` перехватывает → возвращает ingress VIP

## Решение

1. Явная запись в dnsmasq **до** wildcard: `address=/kafka.r8t.dirs.local/172.26.89.14`
2. Настройка kubelet `resolvConf` без домена стенда — исключает расширение search-домена для подов
