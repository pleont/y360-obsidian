---
стенд: r8t
обновлено: 2026-08-06
---

# r8t DNS (dnsmasq)

## Конфигурация

- **Хост**: r8t-infra-01 (172.26.89.14)
- **Тип**: dnsmasq (управляется через Ansible)
- **Зона**: r8t.dirs.local
- **Конфиг**: `/etc/dnsmasq.conf`

## Критичное правило: порядок записей

dnsmasq обрабатывает директивы `address=/...` **последовательно**. Wildcard-запись должна быть ПОСЛЕДНЕЙ:

```
# Явные записи ПЕРВЫМИ
address=/kafka.r8t.dirs.local/172.26.89.14
address=/pg-master.r8t.dirs.local/172.26.89.14
address=/opensearch.r8t.dirs.local/172.26.89.15
address=/s3.r8t.dirs.local/172.26.89.15
address=/fs.r8t.dirs.local/172.26.89.19

# Wildcard ПОСЛЕДНИМ — всё остальное на ingress VIP
address=/.r8t.dirs.local/172.26.89.100
```

## Добавление новых записей

1. Бэкап: `cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak.$(date +%Y%m%d_%H%M%S)`
2. Вставить перед строкой с wildcard
3. Проверить: `dnsmasq --test`
4. Перезапустить: `systemctl restart dnsmasq`
5. Проверить: `nslookup <имя> 127.0.0.1`

## Особенности

- **Wildcard перехватывает внешние сервисы**: без явной записи `fs.r8t.dirs.local` → 172.26.89.100 (ingress), а не сервер AD
- **Расширение search-домена**: pod `search r8t.dirs.local` + короткое имя → `имя.r8t.dirs.local.r8t.dirs.local` → wildcard VIP
- **Конфиг**: установлен `no-hosts` — не использовать `/etc/hosts`
