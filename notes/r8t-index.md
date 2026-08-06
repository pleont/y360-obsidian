---
stand: r8t
bundle: communication + productivity
installer: 2.0.44
updated: 2026-08-06
---

# r8t — индекс

## Описание стенда

- [[r8t-stand-map]] — топология, платформа, сеть, сервисы, доступ
- [[r8t-dns]] — dnsmasq, правила редактирования
- [[r8t-kafka]] — конфигурация Kafka, топики, диагностика
- [[r8t-ad-scim]] — Active Directory, SCIM, SAML SSO
- [[r8t-minio]] — MinIO S3
- [[r8t-loki]] — Loki, PVC

## Миграция и сервисы

- [[r8t-tractor]] — Tractor Nextcloud → Disk, схема БД

## Инциденты и проблемы

- [[cases/r8t-docs-event-history-missing-edits-20260806]] — Docs Event History: отсутствуют действия редактирования
- [[cases/r8t-kafka-dns-search-bug]] — Kafka DNS: расширение search-домена
- [[cases/r8t-scim-pitfalls]] — SCIM: domainId, токены, Cloud URL
- [[cases/r8t-loki-pvc-overflow]] — Loki: переполнение PVC
- [[cases/r8t-minio-port-migration]] — MinIO: миграция порта 9000→443
- [[cases/r8t-tractor-nextcloud-bug]] — Tractor: баг `owned_by_me`
