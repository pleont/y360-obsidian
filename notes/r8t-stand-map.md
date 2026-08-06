---
stand: r8t
bundle: communication + productivity
installer: 2.0.44
updated: 2026-08-06
---

# r8t Stand Map

## Topology

| Node | IP | vCPU | RAM | Disk | Role |
|------|----|------|-----|------|------|
| r8t-k8s-01 | 172.26.89.10 | 4 | 8G | 60G | control-plane, installer host |
| r8t-k8s-02 | 172.26.89.8 | 20 | 64G | 320G | worker |
| r8t-k8s-03 | 172.26.89.9 | 20 | 64G | 320G | worker |
| r8t-k8s-04 | 172.26.89.11 | 20 | 64G | 320G | worker |
| r8t-infra-01 | 172.26.89.14 | 8 | 16G | 150G | PG master, Kafka, CFSSL CA, dnsmasq |
| r8t-infra-02 | 172.26.89.15 | 8 | 16G | 150G | PG replica, OpenSearch, MinIO |

## Platform

- **OS**: RedOS 8.0
- **Kubernetes**: v1.30.14 (kubeadm)
- **Runtime**: containerd 1.7.32
- **CNI**: Calico
- **Storage**: Longhorn (default SC)
- **Hypervisor**: Proxmox VE @ 172.26.89.4

## Network

- **Domain**: r8t.dirs.local
- **Subnet**: 172.26.89.0/24
- **Ingress VIP**: 172.26.89.100
- **Xiva VIP**: 172.26.89.102
- **DNS**: dnsmasq @ r8t-infra-01 (172.26.89.14)
- **AD/ADFS**: 172.26.89.19 (fs.r8t.dirs.local)

## External Services

| Service | Host | Port | Protocol |
|---------|------|------|----------|
| PostgreSQL | pg-master.r8t.dirs.local (infra-01) | 5432 | SSL require |
| Kafka | kafka.r8t.dirs.local (infra-01) | 9092 | SSL, no client auth |
| OpenSearch | opensearch.r8t.dirs.local (infra-02) | 9200 | HTTPS |
| MinIO | s3.r8t.dirs.local (infra-02) | 443 | HTTPS |
| Harbor | r8t-harbor (VMID 112) | 5000 | HTTP proxy for cr.yandex |

## Access

- **SSH**: `croc@<ip>` (ed25519 key)
- **Kubeconfig**: `/tmp/r8t-kubeconfig.yaml`
- **Vault path**: `secret/croc/infra/y360/r8t/`
- **Proxmox**: `secret/croc/infra/y360/r8t/proxmox`

## Web Endpoints

- Admin: `https://admin.r8t.dirs.local`
- Passport: `https://passport.r8t.dirs.local`
- Disk: `https://disk.r8t.dirs.local`
- Docs: `https://docs.r8t.dirs.local`
- Support: `https://support.r8t.dirs.local`
- Tracker: `https://tracker.r8t.dirs.local`
- Wiki: `https://wiki.r8t.dirs.local`
- Forms: `https://forms.r8t.dirs.local`
- Gitea: `https://gitea.r8t.dirs.local`
- ArgoCD: `https://argocd.r8t.dirs.local`
- Grafana: `https://grafana.r8t.dirs.local`
