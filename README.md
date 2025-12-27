# 🏭 SmartInventory DevOps – End-to-End CI/CD & Cloud Platform

A complete DevOps pipeline and production-grade runtime platform for a fictional inventory management system (SmartInventory).
The application itself is intentionally simple; the project’s focus is DevOps practices, automation, infrastructure, and operations.

Built to demonstrate modern CI/CD, containerization, Infrastructure as Code, observability, and secure secret management.

## 📌 Project Overview

SmartInventory DevOps delivers a fully automated delivery and operations platform for a multi-tier web system consisting of:

🌐 Frontend (React)

⚙️ Backend API (ASP.NET Core)

🗄️ Database (SQL)

The project implements:

🔁 Automated CI/CD pipelines from commit to production

🐳 Containerized services for consistency across environments

🏗️ Cloud infrastructure provisioned entirely via Infrastructure as Code

🚀 Production-grade deployment strategies

📊 Observability, monitoring, and alerting

🔐 Secure handling of secrets and configuration

🚀 Tech Stack
⚙️ Application Stack

## 📱 React – Frontend web application

- ASP.NET Core – Backend REST API
- SQL Database – Persistent data storage

## 🐳 Containerization

- Docker – Container images for frontend and backend
- Docker Compose – Local development environment
- Multi-stage builds – Optimized, minimal production images

## 🔁 CI/CD

- GitHub Actions – End-to-end pipeline automation
- Automated build, test, scan, and deployment stages
- Environment separation:
- Development
- Staging
- Production

## 🏗️ Infrastructure & Cloud

- Terraform – Infrastructure as Code
- Azure – Cloud platform
- Kubernetes (AKS) – Production runtime environment

📊 Observability & Security

- Centralized logging
- Metrics & dashboards (Grafana / Application Insights)
- Health checks & status endpoints
- Azure Key Vault / Kubernetes Secrets

## ✨ Features
🔁 CI/CD Pipeline

- Automatic pipeline execution on merge to main
- Builds frontend and backend services
- Runs unit and end-to-end tests

Performs:
- Static code analysis & linting
- Dependency and security scanning (CodeQL / Trivy)
- Deploys automatically to Staging
- Deploys to Production via approval gate

## 🐳 Containerized Architecture

- Separate Dockerfiles for frontend and backend
- Multi-stage builds for reduced image size
- Docker Compose setup for local development parity
- Identical container images used across all environments

## 🏗️ Infrastructure as Code (IaC)

- Fully automated infrastructure provisioning using Terraform
- Infrastructure includes:
- Kubernetes cluster (AKS)
- Database resources
- Networking (VNet, ingress, firewall rules)
- Entire environment can be recreated from code

## 🚀 Production Deployment Strategy

- Kubernetes-based deployment
- Rolling updates with zero downtime
- Horizontal Pod Autoscaling (HPA)
- Environment-specific configuration via secrets and variables

## 📊 Observability & Monitoring

- Centralized application and infrastructure logging
- Metrics collection with dashboards
- Health-check endpoints for services
- Alerts triggered on failures or downtime
  
## 🔐 Secrets Management

- No secrets stored in source code
- Secrets managed via:
- Azure Key Vault
- Kubernetes Secrets

Covers:
- Database connection strings
- JWT signing keys
- API keys and sensitive configuration

## 🧱 Architecture

- Frontend and backend deployed as independent containers
- Backend communicates securely with database

Kubernetes manages:
- Deployment lifecycle
- Scaling
- Health monitoring
- CI/CD pipeline orchestrates build, test, scan, and deployment
- Infrastructure fully defined and versioned via Terraform (Architecture diagram included in repository documentation)

## 🧠 What I Learned
- CI/CD Automation
- Designed robust pipelines that automate build, test, security scanning, and deployment
- Implemented environment separation and approval-gated production releases
- Containerization & Deployment
- Built optimized Docker images and managed multi-service systems with Docker Compose and Kubernetes
- Learned how consistent container artifacts simplify promotion between environments
- Infrastructure as Code
- Provisioned and managed cloud infrastructure using Terraform in a reproducible, version-controlled manner
- Gained deeper understanding of networking, compute, and managed services in Azure
- Kubernetes Operations
- Worked with rolling deployments, autoscaling, health probes, and service exposure
- Learned how Kubernetes supports resilience and scalability in production systems
- Observability & Reliability
- Implemented logging, metrics, dashboards, and alerts to detect and diagnose failures
- Understood the importance of visibility for operating production systems
- Security & Secrets Management
- Applied best practices for secret handling using managed secret stores
- Ensured sensitive configuration is never exposed in code or pipelines
- DevOps Mindset
- Focused on automation, repeatability, and reliability over manual processes
- Treated infrastructure and pipelines as first-class, versioned assets

## 📄 Documentation Included

- Architecture diagram
- CI/CD pipeline breakdown
- Deployment, rollback, and troubleshooting instructions
- Screenshots of dashboards, alerts, and pipelines
- Commands for local development and testing
