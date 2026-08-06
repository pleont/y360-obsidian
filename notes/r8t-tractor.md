---
стенд: r8t
обновлено: 2026-08-06
---

# r8t Tractor — миграция Nextcloud → Disk

## База данных

- **БД**: `tractor-tractordb-r8t` на мастере PostgreSQL
- **Пользователь**: `http-api`
- **Схема**: `tractor_disk`

## Таблицы

- `user_migrations` — статус миграции по пользователям (org_id + login)
- `tasks` — отдельные задачи по файлам (worker_status)

## Известный баг

`nextcloud_client.py`: `owned_by_me = owner == self.username`. Обход: логиниться по username, не email.

## Очистка при зависшей миграции

```sql
-- Порядок важен: сначала дочерние записи
DELETE FROM tractor_disk.user_migrations WHERE ...;
DELETE FROM tractor_disk.tasks WHERE ...;
```

## Статусы миграции

`{listing, syncing, canceling, error, success}`
