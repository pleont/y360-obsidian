---
стенд: r8t
обновлено: 2026-08-06
---

# r8t Loki

## Описание

- **Namespace**: monitoring
- **PVC**: 20Gi (data-loki-0)
- **Тип**: StatefulSet

## Проблемы

См. [[cases/r8t-loki-pvc-overflow]] — переполнение PVC chunks + WAL → CrashLoopBackOff.
