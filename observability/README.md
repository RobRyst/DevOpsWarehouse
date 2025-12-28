![ArchDiagram](https://github.com/user-attachments/assets/e30c74a3-911d-4b08-a01e-f701b2191c63)

Dette prosjektet demonstrerer DevOps og driftskompetanse ved å sette opp, drifte og overvåke en containerbasert applikasjon i Azure. Fokus er på Infrastructure as Code, Kubernetes drift, observability, secrets management og kostnadskontroll. Applikasjonens funksjonalitet er sekundær; operasjonell stabilitet og synlighet er hovedmålet.

Viktige komponenter

- AKS: Produksjonsmiljø med rolling deploy og autoskalering
- Cosmos DB (Mongo API): Database
- Azure Monitor / Log Analytics: Logging, metrics og alerts
- Terraform: Full IaC-provisionering
- Kubernetes Secrets: Håndtering av sensitive verdier

Beskrivelse av pipelines
Dette prosjektet bruker en manuell CI/CD-flyt (lokal build + deploy), men er strukturert slik at den enkelt kan automatiseres.

Pipeline-steg:

1. Bygg Docker-images
- Backend (Node.js)
- Frontend (React → Nginx)

2. Push images til Azure Container Registry (ACR)

3. Deploy til AKS
- kubectl apply
- Rolling update uten nedetid

4. Valider
- Health checks (/health)
- Logs i Log Analytics

Metrics i AKS Insights
Strukturen er kompatibel med GitHub Actions eller Azure DevOps Pipelines.

Hvordan drifte systemet: 

Deployment: 
kubectl apply -f Kubernetes/
kubectl rollout status deployment/smartinv-backend
kubectl rollout status deployment/smartinv-frontend

Rollback
Rull tilbake til forrige fungerende versjon:
kubectl rollout undo deployment/smartinv-backend

Sjekk status:
kubectl rollout status deployment/smartinv-backend

Feilsøking:
Sjekk pods:
kubectl get pods
kubectl describe pod <pod-navn>

Se logger:
kubectl logs -l app=smartinv-backend

Sentralisert logging:
Azure Portal → Log Analytics → Logs
ContainerLogV2
| where PodName startswith "smartinv-backend"
| order by TimeGenerated desc

Metrics og autoskalering:
kubectl get hpa
kubectl top pods

Skjermbilder (dashboards, alerts, pipelines)


Kommandoer for lokal kjøring og test:
docker compose up --build

Frontend:
http://localhost:3000

Backend:
http://localhost:5000/health

Kubernetes load-test (HPA-verifisering):
kubectl run loadgen --image=busybox --restart=Never --command -- \
sh -c "while true; do wget -q -O- http://smartinv-backend:5000/burn >/dev/null; done"

Se autoskalering:
kubectl get hpa -w
kubectl get pods

Rydd opp:
kubectl delete pod loadgen

Secrets Management
Sensitive verdier er lagret i Kubernetes Secrets og aldri hardkodet.

Secret	                     Bruk
smartinv-secrets	            Database-tilkobling (MONGODB_URI)
smartinv-jwt	               JWT-signeringsnøkkel (SECRET_OR_KEY)

Infrastructure as Code

All infrastruktur provisioneres med Terraform:

- AKS
- VNet / Subnet / NSG
- Cosmos DB
- Log Analytics
- Remote state i Azure Storage
- Miljøet kan trygt slettes og gjenopprettes.

Kostnadshåndtering
Når prosjektet ikke er i bruk:
az group delete -n rg-smartinv-dev --yes --no-wait

Alt kan gjenopprettes via Terraform på ~15–30 minutter.

Oppsummering
✔ Infrastructure as Code
✔ Kubernetes produksjonsmiljø
✔ Rolling deploy + autoskalering
✔ Observability (logs, metrics, alerts)
✔ Secrets management
✔ Kostnadsbevisst drift

Dette prosjektet representerer et realistisk DevOps-oppsett slik det brukes i praksis.
