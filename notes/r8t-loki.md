---
stand: r8t
updated: 2026-08-06
---

# r8t Loki PVC Full Recovery

## Symptom

- Loki pod `CrashLoopBackOff`
- `infra-sync-workflow` fails at loki step (exit code 20)
- Root cause: PVC (20Gi) filled with chunks + WAL

## Recovery Procedure

1. Scale down: `kubectl scale sts -n monitoring loki --replicas=0`
2. Create debug pod mounting the PVC:
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
4. Delete debug pod, scale Loki back to 1
5. Verify: `kubectl logs -n monitoring loki-0`
6. No installer rerun needed
