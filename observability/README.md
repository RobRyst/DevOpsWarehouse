# Observability – Centralized Logging (AKS)

## Scope

This project implements **centralized logging** for the SmartInventory application running on **Azure Kubernetes Service (AKS)**.

The objective is to aggregate application and platform logs from all pods and replicas into a **single, queryable location** to support operational troubleshooting during rolling deployments and autoscaling scenarios.

---

## Implementation Overview

- **Platform:** Azure Kubernetes Service (AKS)
- **Logging solution:** AKS Container Insights → Azure Log Analytics
- **Log source:** Container stdout / stderr + Kubernetes metadata
- **Workspace:** `law-smartinv-dev`
- **AKS cluster:** `aks-smartinv-dev`
- **Resource group:** `rg-smartinv-dev`

The AKS monitoring add-on (`monitoring`) is enabled and connected to the Log Analytics workspace.  
Azure Monitor Agent (AMA) pods are running in the `kube-system` namespace and continuously forward logs from all nodes and containers.

---

## What Is Collected

- Application logs from all containers (stdout / stderr)
- Logs from all replicas across rolling deployments
- Kubernetes metadata (namespace, pod name, container name)
- Pod lifecycle context (startup, restarts, crashes)

Logs are stored in the **`ContainerLogV2`** table.

---

## Validation / Incident Walkthrough

Centralized logging was validated using a real runtime failure during deployment.

### Observed symptoms

- Backend pods (`smartinv-backend-*`) repeatedly emitted:
  - `MongoError: Invalid key`
  - Database configuration errors
- One replica entered `CrashLoopBackOff` during a rolling deployment
- Deployment rollout stalled due to `maxUnavailable: 0`

### Investigation (using centralized logging)

- Errors were identified exclusively via **Log Analytics**, without direct pod access
- Log queries revealed:
  - Authentication failures against Cosmos DB (Mongo API)
  - Misconfigured MongoDB connection string
  - Missing and later malformed database name in the connection URI

### Resolution

- Kubernetes secret was updated with the **official Cosmos MongoDB connection string**
- A valid database name (`/smartinventory`) was added to the URI
- Deployment was restarted and completed successfully
- Backend pods stabilized with logs showing:
  - `***mongodb connected`
  - No further crash loops or authentication errors

This incident demonstrates how centralized logging enables **root-cause analysis across replicas and deployments** in a production-like environment.

---

## How to Query Logs

Go to **Azure Portal → Log Analytics workspace → Logs**  
Use the queries stored in the `kql/` folder.

### Example: latest backend logs

````kusto
ContainerLogV2
| where PodName startswith "smartinv-backend"
| project TimeGenerated, PodNamespace, PodName, ContainerName, LogSource, LogMessage
| order by TimeGenerated desc
Example: database-related errors
kusto
Copy code
ContainerLogV2
| where PodName startswith "smartinv-backend"
| where LogMessage has "MongoError"
| order by TimeGenerated desc
Operational Value
Eliminates reliance on kubectl logs for multi-replica workloads

Supports troubleshooting during rolling deployments and autoscaling

Enables correlation of errors across time, pods, and replicas

Provides a foundation for:

log-based alerting

incident response

post-mortem analysis

Notes
Application correctness is secondary; real runtime errors were intentionally used to demonstrate observability.

No application code changes were required to enable logging; standard stdout logging was sufficient.

This setup reflects common enterprise AKS monitoring patterns and production debugging workflows.

livecodeserver
Copy code

---

# Observability – Metrics + Dashboard (AKS Insights)

## Scope
This project demonstrates metrics collection and dashboard visualization using **Azure Monitor / AKS Insights** (Azure-native).
Grafana is not required for the assignment; AKS Insights provides a production-grade dashboard.

## Components
- **AKS:** `aks-smartinv-dev`
- **Dashboard:** Azure Portal → AKS → **Insights**
- **Autoscaling:** HPA on `smartinv-backend` (CPU target 50%, min=2, max=6)

## Validation
A synthetic load test was executed against the backend `/burn` endpoint to drive CPU usage and trigger HPA scaling.

### Load generation (PowerShell)
```bash
kubectl run loadgen --image=busybox --restart=Never --command -- sh -c "while true; do wget -q -O- http://smartinv-backend:5000/burn >/dev/null; done"
kubectl run loadgen2 --image=busybox --restart=Never --command -- sh -c "while true; do wget -q -O- http://smartinv-backend:5000/burn >/dev/null; done"
kubectl run loadgen3 --image=busybox --restart=Never --command -- sh -c "while true; do wget -q -O- http://smartinv-backend:5000/burn >/dev/null; done"
kubectl run loadgen4 --image=busybox --restart=Never --command -- sh -c "while true; do wget -q -O- http://smartinv-backend:5000/burn >/dev/null; done"
kubectl run loadgen5 --image=busybox --restart=Never --command -- sh -c "while true; do wget -q -O- http://smartinv-backend:5000/burn >/dev/null; done"

````
