---
tags: [yandex360, admin-front, bug, devices, sessions, idm360]
date: 2026-08-05
---

# 422 cross-user devices/sessions в admin-front

## Симптом
Администратор не видит список устройств/сессий других пользователей в admin-front (страница Sessions). Фронт показывает пустой список.

## Воспроизведение (r8t, org-2)
Запрос от admin-front к directory-backend через duffman:

```
GET /v13/users/{target_uid}/devices/
Headers:
  x-uid: {admin_uid}       # не совпадает с target_uid
  x-org-id: 2
  Cookie: Session_id=...
```

- **admin UID:** 1130000000000055 (autotest-owner)
- **target UID:** 1130000000000179 (другой пользователь org-2)
- **directory-backend ответ:** HTTP 422

Лог из `duffman-http.tskv`:
```
status=422 received=67 orgId=2 url=/v13/users/1130000000000179/devices/ x-uid=1130000000000055
```

Для org-6 тот же сценарий возвращает **200 OK** (работает).

## Root cause

### Цепочка вызова
1. **admin-front model `directory/get-devices.js`** — вызывает `directory service` с URL `/users/${params.user_uid}/devices/`
2. **admin-front `server/services/directory/index.js`** — сервис-хендлер добавляет заголовки:
   ```js
   headers: {
     'x-uid': user.uid,         // UID залогиненного админа
     'x-org-id': params['x-org-id'],
     'x-user-ip': ...,
     ...withOnpremSessionCookiesHeaders(params) // куки сессии
   }
   ```
3. Запрос уходит в директори-бекенд с `x-uid ≠ target_uid` (админ смотрит чужого пользователя)
4. **Directory-backend** (Python, `/app/build/yandex_directory/core/views/user_devices.py`):
   - `@requires(org_id=True, user=True)` — проверяет org+user
   - `@idm360_access(UserDevicesAccessPolicy([UserDevicesPermissionsEnum.VIEW]))` — проверяет права через IDM360
5. IDM360 не даёт права `VIEW` на ресурс `user_device` для чужого UID → **422**
6. Модель `get-devices` не обрабатывает ошибку (просто `ondone`), duffman проглатывает 422 и возвращает фронту 200 с пустым/ошибочным телом

### Почему для org-6 работает?
IDM360 для org-6 настроен иначе, либо пользователь имеет другие права на `user_device`. Требуется проверка конфигурации IDM360 для org-2.

## Затронутые файлы
- `admin-front/server/models/directory/get-devices.js` — модель, не обрабатывает ошибки
- `admin-front/server/services/directory/index.js` — сервис-хендлер, подменяет x-uid
- `/app/build/yandex_directory/core/views/user_devices.py` — вьюха devices (Python)
- `/app/build/yandex_directory/core/permission/idm360/user_devices.py` — политика доступа
- `/app/build/yandex_directory/core/permission/idm360/__init__.py` — `check_idm360_resource_access`

## Дополнительно
- IDM360 на престейбле (`ENVIRONMENT == "integration_qa"`) всегда пропускает проверку
- На on-prem IDM360 должен быть настроен и включён
- Возможно, для org-2 ресурс `user_device` в IDM360 не сконфигурирован, либо не назначена роль с `VIEW` на `user_device`