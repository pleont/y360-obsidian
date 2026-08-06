---
стенд: r8t
обновлено: 2026-08-06
---

# r8t Loki — переполнение PVC

## Симптомы

- Под Loki `CrashLoopBackOff`
- `infra-sync-workflow` падает на шаге loki (код выхода 20)
- Причина: PVC (20Gi) заполнен chunks + WAL

## Процедура восстановления

1. Уменьшить реплики: `kubectl scale sts -n monitoring loki --replicas=0`
2. Создать отладочный под с монтированием PVC:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: loki-cleanup
  namespace: monitoring
spec:
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: data-loki-0
  containers:
    - name: cleanup
      image: busybox
      command: ["sleep", "3600"]
      volumeMounts:
        - name: data
          mountPath: /data
```
3. `kubectl exec -n monitoring loki-cleanup -- rm -rf /data/chunks/ /data/wal/`
4. Удалить отладочный под, вернуть Loki 1 реплику
5. Проверить: `kubectl logs -n monitoring loki-0`
6. Перекат установки НЕ требуется
