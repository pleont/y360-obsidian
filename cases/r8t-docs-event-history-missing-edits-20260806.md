---
stand: r8t
date: 2026-08-06
status: open
support_ticket: created
---

# Docs Event History — отсутствуют действия редактирования

## Симптом
На странице `support.r8t.dirs.local/n/documents/1130000000000180/%2Fdisk%2FНовый.docx/events` не отображаются действия по редактированию документа.

## Цепочка вызова
```
browser → support.r8t.dirs.local/n/documents/.../events
  → magic-front → duffman
    → cloud-api-intapi GET /v1/disk/support/event-history/search
      ?user_id=1130000000000180
      &text=%2Fdisk%2FНовый.docx
      &limit=10&offset=0&limit_per_group=10
```

## Что возвращает API
5 событий, все fs-*:
- `fs-store` (09:07) — первоначальная загрузка
- `fs-set-public` (09:07)
- `fs-set-public-settings` ×3 (09:07, 09:27, 09:28)

## Что не попало в историю
Три WOPI-сессии редактирования (09:07-09:08, 09:23-09:24, 09:31):
- docs-support: `docs_session_started`, `docs_user_joined`, `docs_snapshot`, `docs_user_left`
- Снапшоты с версиями: `7bfbab84...`, `685704aa...`, `b6b450da...`

## Корень
WOPI-сессия не вызывает PutFile → Disk API `store` не выполняется → `fs-store` событие не создаётся → `event-history/search` не содержит записей о редактировании.

docs-support отправляет события в Kafka AUDIT_LOG, но cloud-api `event-history/search` их не агрегирует.

## Требование
По ПМИ действия по редактированию документа должны отображаться в Истории изменений.
