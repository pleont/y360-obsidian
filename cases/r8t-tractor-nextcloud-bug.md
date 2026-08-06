---
стенд: r8t
дата: 2026-08-06
статус: known-bug
---

# Tractor — баг `owned_by_me` в nextcloud_client.py

## Симптом

Миграция Nextcloud → Disk зависает: файлы не переносятся, статус не меняется.

## Причина

В `nextcloud_client.py`:
```python
owned_by_me = owner == self.username
```

Сравнение по username, а не по email. При логине через email условие всегда ложно → миграция не стартует.

## Обход

Логиниться по username (не email).

## Очистка зависшей миграции

```sql
-- Порядок важен: сначала дочерние записи
DELETE FROM tractor_disk.user_migrations WHERE ...;
DELETE FROM tractor_disk.tasks WHERE ...;
```
