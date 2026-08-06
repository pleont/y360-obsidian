---
stand: r8t
date: 2026-08-06
status: resolved
---

# SCIM Pitfalls

## domainId — целое число

`domainId` в SCIM — это целое число (5), не UUID из `ydir.domains`. Это Blackbox domid, НЕ org_id (6).

## SCIM-токен

- `APIGW360_CLIENT_ID` → 403 (неправильный клиент)
- Правильный: `SCIM_CLIENT_ID` / `SCIM_CLIENT_SECRET` из вывода post-install workflow

## Cloud-style SCIM URL

SCIM URL вида `https://scim-api.passport.yandex.net` резолвится в публичный IP (77.88.21.80). В on-premise режиме использовать `http://passport-scim-api.passport-r8t.svc.cluster.local:8080`.

## ADFS email attribute ignored

Парсер SAML в passport-api игнорирует атрибут `email`. Обход: ADFS NameID Format=Email.

## SSL hostname mismatch

Ingress-сертификат `*.r8t.dirs.local` не покрывает `*.scim-api.passport.yandex.net`.
