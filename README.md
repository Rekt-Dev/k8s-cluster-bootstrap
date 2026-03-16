# Kubernetes Cluster Bootstrap & Platform Engineering

This repository serves as the primary **Infrastructure as Code (IaC)** and **Configuration Management** hub for my standardized Kubernetes deployments. It contains the foundational blueprints for bootstrapping clusters, managing cloud-native services, and automating application lifecycles.

## 🚀 Key Components

* **Infrastructure as Code:** Terraform configurations for provider orchestration (K8s, Helm).
* **Application Packaging:** Custom Helm Charts (see `/dbapp`) for scalable microservices.
* **Automation:** Shell scripts for cluster lifecycle management and health checks.
* **Security:** (Work in Progress) Hardening manifests based on CIS Benchmarks.

## 🛠 Tech Stack
* **Orchestration:** Kubernetes (K8s)
* **Provisioning:** Terraform
* **Package Management:** Helm 3
* **Scripting:** Bash / Linux System Administration

## 📖 Usage
This repository is structured to be applied via CI/CD pipelines or manually for development/testing environments. 
