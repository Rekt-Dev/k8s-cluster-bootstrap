# Incident Report: Kubernetes Node Disk Pressure & Pod Eviction
**Date:** March 18, 2026
**Role:** Systems Reliability Engineer (SRE)
**Environment:** 3-Node K8s Cluster (Bare-metal/Lab)

## 1. Executive Summary
During the deployment of a high-density container (LocalStack Pro), the worker node `k8s2` entered a **DiskPressure** state. The Kubelet initiated a hard eviction policy, terminating the pod to protect node stability. This report details the root cause analysis (RCA), emergency remediation, and long-term stabilization.

## 2. Incident Diagnosis
### Symptom
* Pods stuck in `Pending` or `Failed` status.
* `kubectl describe pod` revealed: 
  > `Reason: Evicted`
  > `Message: The node was low on resource: ephemeral-storage.`

### Root Cause Analysis (RCA)
1. **Node Geometry:** The root partition (`/`) was limited to **11GB**.
2. **Kubelet Eviction Threshold:** Default K8s behavior triggers eviction when `nodefs.available < 10%`.
3. **Heavy Image Footprint:** The `localstack-pro` image (~700MB compressed, >1.5GB extracted) pushed the available storage below the **1.1GB** safety threshold.
4. **Log Bloat:** High restart counts of system components (Calico/CSI) filled `/var/log/pods`, preventing the Kubelet from reclaiming enough space.

## 3. Remediation & Recovery

### Phase 1: Emergency Disk Recovery (Worker Node)
To clear the `DiskPressure` taint, the following manual cleanup was performed on `k8s2`:
```bash
# Clear OS-level package cache
sudo apt-get clean

# Force Containerd to prune unreferenced image layers
sudo crictl rmi --prune

# Identify and zero-out runaway log files without breaking file handles
sudo find /var/log/pods -type f -name "*.log" -exec truncate -s 0 {} +
