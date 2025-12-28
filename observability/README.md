Dette prosjektet demonstrerer DevOps og driftskompetanse ved å sette opp, drifte og overvåke en containerbasert applikasjon i Azure. Fokus er på Infrastructure as Code, Kubernetes drift, observability, secrets management og kostnadskontroll. Applikasjonens funksjonalitet er sekundær; operasjonell stabilitet og synlighet er hovedmålet.

Viktige komponenter:

- AKS: Produksjonsmiljø med rolling deploy og autoskalering
- Cosmos DB (Mongo API): Database
- Azure Monitor / Log Analytics: Logging, metrics og alerts
- Terraform: Full IaC-provisionering
- Kubernetes Secrets: Håndtering av sensitive verdier

Beskrivelse av pipelines
Dette prosjektet bruker en manuell CI/CD-flyt (lokal build + deploy), men er strukturert slik at den enkelt kan automatiseres.

# Pipeline-steg:

## 1. Bygg Docker-images
- Backend (Node.js)
- Frontend (React → Nginx)

## 2. Push images til Azure Container Registry (ACR)

## 3. Deploy til AKS
- kubectl apply
- Rolling update uten nedetid

## 4. Valider
- Health checks (/health)
- Logs i Log Analytics

## Metrics i AKS Insights

Strukturen er kompatibel med GitHub Actions eller Azure DevOps Pipelines.

## Hvordan drifte systemet: 

### Deployment: 

kubectl apply -f Kubernetes/

kubectl rollout status deployment/smartinv-backend

kubectl rollout status deployment/smartinv-frontend

### Rollback

Rull tilbake til forrige fungerende versjon:

kubectl rollout undo deployment/smartinv-backend

### Sjekk status:

kubectl rollout status deployment/smartinv-backend

Feilsøking:

Sjekk pods:

kubectl get pods

kubectl describe pod <pod-navn>

### Se logger:

kubectl logs -l app=smartinv-backend

### Sentralisert logging:

Azure Portal → Log Analytics → Logs

ContainerLogV2

| where PodName startswith "smartinv-backend"

| order by TimeGenerated desc

### Metrics og autoskalering:

kubectl get hpa

kubectl top pods

## Skjermbilder (dashboards, alerts, pipelines)

### Architecture Diagram: 
![ArchDiagram](https://github.com/user-attachments/assets/e30c74a3-911d-4b08-a01e-f701b2191c63)

### Dashboard: 
<img width="1130" height="557" alt="image" src="https://github.com/user-attachments/assets/672a85a0-7743-4a82-9a92-bf1536d72c8c" />

### Alerts: 
<img width="1817" height="467" alt="image" src="https://github.com/user-attachments/assets/44d2424f-30de-40d0-8496-1d36a69f6298" />

### Ressursgruppe: 
<img width="1191" height="308" alt="image" src="https://github.com/user-attachments/assets/62a9ffdf-e2c9-41ac-a104-dccff889286c" />

### Docker build: 
<img width="1047" height="622" alt="image" src="https://github.com/user-attachments/assets/1a35b087-436d-4b22-b881-6078655d98e0" />
<img width="961" height="730" alt="image" src="https://github.com/user-attachments/assets/45dae7f8-2c7d-44f9-9679-dfe00635558b" />

### Kjørende pods og image: 
<img width="1255" height="188" alt="image" src="https://github.com/user-attachments/assets/ab233a5e-51c6-411b-bcba-ddc706dd0a05" />

### HPA scaling: 
<img width="776" height="140" alt="image" src="https://github.com/user-attachments/assets/ca64b6bc-08e1-40f2-ab40-49a018202f1f" />

### Kommandoer for lokal kjøring og test:

docker compose up --build

Frontend:

http://localhost:3000

Backend:

http://localhost:5000/health

### Kubernetes load-test (HPA-verifisering):

kubectl run loadgen --image=busybox --restart=Never --command -- \

sh -c "while true; do wget -q -O- http://smartinv-backend:5000/burn >/dev/null; done"

### Se autoskalering:

kubectl get hpa -w

kubectl get pods

### Rydd opp:

kubectl delete pod loadgen

## Secrets Management:

Sensitive verdier er lagret i Kubernetes Secrets og aldri hardkodet.

### Secret 

- smartinv-secrets
- smartinv-jwt

### Bruk

- Database-tilkobling (MONGODB_URI) smartinv-jwt	               
- JWT-signeringsnøkkel (SECRET_OR_KEY)

## Infrastructure as Code

### All infrastruktur provisioneres med Terraform:

- AKS
- VNet / Subnet / NSG
- Cosmos DB
- Log Analytics
- Remote state i Azure Storage
- Miljøet kan trygt slettes og gjenopprettes.

## Kostnadshåndtering
Når prosjektet ikke er i bruk:
az group delete -n rg-smartinv-dev --yes --no-wait

Alt kan gjenopprettes via Terraform på ~15–30 minutter.

## Oppsummering:

✔ Infrastructure as Code

✔ Kubernetes produksjonsmiljø

✔ Rolling deploy + autoskalering

✔ Observability (logs, metrics, alerts)

✔ Secrets management

✔ Kostnadsbevisst drift

Dette prosjektet representerer et realistisk DevOps-oppsett slik det brukes i praksis.
