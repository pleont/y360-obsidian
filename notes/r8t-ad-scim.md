---
стенд: r8t
обновлено: 2026-08-06
---

# r8t AD / SCIM

## Active Directory

- **Хост**: fs.r8t.dirs.local → 172.26.89.19
- **Base DN**: `DC=r8t,DC=dirs,DC=local`
- **LDAP**: порт 389 (без LDAPS)
- **DNS**: явная запись в dnsmasq до wildcard

## SCIM

- **ID домена**: 5 (Blackbox domid, НЕ org_id=6)
- **Режим**: on-premise (через переменные окружения)
- **SCIM API**: `http://passport-scim-api.passport-r8t.svc.cluster.local:8080/Domain/5/v2`
- **Токен**: `oauth.r8t.dirs.local/token` с `grant_type=client_credentials`
- **Клиенты SCIM**: из вывода post-install workflow (`SCIM_CLIENT_ID`, `SCIM_CLIENT_SECRET`)

## Развёртывание ADSCIM

- Запускается как Kubernetes Job в namespace `passport-r8t` (ограничение Calico)
- Переменные: `ADSCIM_DESTINATION_SCIM_BASE_URL`, `ADSCIM_DESTINATION_SCIM_BEARER_TOKEN_VALUE`, `ADSCIM_SOURCE_LDAP_PASSWORD_VALUE`
- Первый запуск ОБЯЗАТЕЛЬНО `dryRun: true`

## SAML SSO

- **Организация 6**: SSO включён (`is_sso_enabled: true`, `provisioning_enabled: false`)
- **Обходной путь NameID**: парсер SAML в passport-api игнорирует атрибут `email` → использовать ADFS NameID Format=Email
- **Несовпадение доменов**: пользователь AD `@r8t.dirs.local` против Яндекс `@internal.r8t.dirs.local` → кастомное правило ADFS

## Известные проблемы

- `domainId` — целое число (5), не UUID из `ydir.domains`
- SCIM-токен от `APIGW360_CLIENT_ID` → 403; использовать `SCIM_CLIENT_ID`
- Cloud-style SCIM URL резолвится в 77.88.21.80 (публичный IP) → использовать on-premise режим
- Атрибут ADFS `email` игнорируется парсером passport-api → обход через NameID=Email
