---
stand: r8t
updated: 2026-08-06
---

# r8t AD / SCIM

## Active Directory

- **Host**: fs.r8t.dirs.local → 172.26.89.19
- **Base DN**: `DC=r8t,DC=dirs,DC=local`
- **LDAP**: port 389 (plain, not LDAPS)
- **DNS**: explicit dnsmasq entry before wildcard

## SCIM Configuration

- **Domain ID**: 5 (Blackbox domid, NOT org_id=6)
- **Mode**: on-premise (env var override)
- **SCIM API**: `http://passport-scim-api.passport-r8t.svc.cluster.local:8080/Domain/5/v2`
- **Token source**: `oauth.r8t.dirs.local/token` with `grant_type=client_credentials`
- **SCIM client IDs**: from post-install workflow output (`SCIM_CLIENT_ID`, `SCIM_CLIENT_SECRET`)

## ADSCIM Deployment

- Run as Kubernetes Job in `passport-r8t` namespace (Calico policy)
- Env vars: `ADSCIM_DESTINATION_SCIM_BASE_URL`, `ADSCIM_DESTINATION_SCIM_BEARER_TOKEN_VALUE`, `ADSCIM_SOURCE_LDAP_PASSWORD_VALUE`
- First run MUST be `dryRun: true`

## SAML SSO

- **Org 6** has SSO enabled (`is_sso_enabled: true`, `provisioning_enabled: false`)
- **NameID workaround**: passport-api SAML parser ignores `email` attribute → use ADFS NameID Format=Email
- **Domain mismatch**: AD user `@r8t.dirs.local` vs Yandex `@internal.r8t.dirs.local` → ADFS custom transform rule

## Pitfalls

- `domainId` is integer (5), not UUID from `ydir.domains`
- SCIM token from `APIGW360_CLIENT_ID` → 403; use `SCIM_CLIENT_ID`
- Cloud-style SCIM URL resolves to 77.88.21.80 (public IP) → use on-premise mode
- ADFS `email` attribute ignored by passport-api parser → NameID=Email workaround
