SmartInventory – DevOps & Observability (AKS)

This project demonstrates DevOps and Kubernetes operational competence using Azure Kubernetes Service (AKS).
Application correctness is secondary; infrastructure, deployment strategy, observability, and operational behavior are the focus.

Observability

The project implements three core observability pillars:

Centralized logging

Metrics & dashboards

Alerts for failures and downtime

All observability components use Azure-native tooling.

1. Centralized Logging (AKS → Log Analytics)
   Goal

Aggregate logs from all containers and replicas into a single, searchable location to support troubleshooting during rolling deployments and autoscaling.

Implementation

Platform: Azure Kubernetes Service (AKS)

Logging: AKS Container Insights

Workspace: law-smartinv-dev

Cluster: aks-smartinv-dev

Resource Group: rg-smartinv-dev

Log Table: ContainerLogV2

Azure Monitor Agent (AMA) runs in the kube-system namespace and forwards container stdout/stderr logs automatically.

What Is Collected

Application logs from all backend and frontend containers

Logs across all replicas

Kubernetes metadata (namespace, pod name, container name)

Pod lifecycle events (startup, restart, crash)

Verification

Centralized logging was verified during a real backend failure:

Backend pods emitted MongoError: Invalid key

One replica entered CrashLoopBackOff

Logs were visible centrally in Log Analytics without using kubectl logs

Example Diagnostic Queries
ContainerLogV2
| where PodName startswith "smartinv-backend"
| project TimeGenerated, PodName, ContainerName, LogMessage
| order by TimeGenerated desc

ContainerLogV2
| where PodName startswith "smartinv-backend"
| where LogMessage has "MongoError"
| order by TimeGenerated desc

Operational Value

Troubleshooting without pod-level access

Works with rolling deployments and autoscaling

Enables root-cause analysis across replicas

2. Metrics & Dashboards (Azure Monitor / AKS Insights)
   Goal

Provide real-time visibility into cluster and workload health using Azure-native dashboards.

Implementation

Metrics Source: AKS Insights (Azure Monitor)

Dashboards: Azure Portal → AKS → Insights

Autoscaling: Horizontal Pod Autoscaler (HPA)

HPA Configuration (Backend)

Min replicas: 2

Max replicas: 6

CPU target: 50%

Validation (Autoscaling Proof)

CPU load was generated using the backend /burn endpoint.

kubectl run loadgen --image=busybox --restart=Never --command -- sh -c "while true; do wget -q -O- http://smartinv-backend:5000/burn >/dev/null; done"

Observed Behavior

CPU utilization increased

HPA scaled backend replicas from 2 → 6

Replicas scaled down after load stopped (stabilization window)

This confirms metrics ingestion, visualization, and autoscaling behavior.

3. Alerts – Failures & Downtime
   Goal

Automatically notify operators when failures or service downtime occur.

3.1 Log-Based Alert (Failures)

A scheduled query alert monitors backend logs in Log Analytics.

Signal source: ContainerLogV2
Examples monitored:

MongoError

Unhandled

CrashLoopBackOff

ImagePullBackOff

Node.js Warning: (used to validate alert triggering)

The alert triggers when matching log entries occur within a 10-minute window.

3.2 Metric-Based Alert (Downtime)

Downtime is detected using Kubernetes metrics instead of logs.

Metric: kube_deployment_status_replicas_available

Target: smartinv-frontend

Condition: Available replicas < 1

This provides a deterministic and production-grade downtime signal.

4. Secrets Management
   Goal

Prevent hardcoding of sensitive configuration.

Implemented Secrets
Database Connection

MONGODB_URI

Stored in Kubernetes Secret: smartinv-secrets

Injected into backend container via environment variable

JWT Signing Key

SECRET_OR_KEY

Stored in Kubernetes Secret: smartinv-jwt

Injected into backend container via environment variable

No credentials are stored in source code or deployment manifests.

Summary

✔ Centralized logging with Log Analytics

✔ Metrics and dashboards with AKS Insights

✔ Autoscaling visibility with HPA

✔ Alerts for failures and downtime

✔ Secure secrets management (DB + JWT)

This setup reflects common enterprise AKS operational patterns and demonstrates real-world DevOps observability practices.
