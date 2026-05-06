# Chain of Trust: Engineering a Secure Infrastructure Lifecycle 🛡️🚀

[![DevSecOps](https://img.shields.io/badge/Security-Shift--Left-blueviolet)](https://github.com/kumarswarnim19)
[![Infrastructure](https://img.shields.io/badge/Infrastructure-AWS%20EC2-orange)](https://aws.amazon.com/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-black)](https://github.com/features/actions)

## 📖 Project Overview
This project establishes a **Security-First gatekeeping architecture** for application deployment. Moving beyond basic CI/CD, I have engineered a **Continuous Verification model** where every build is treated as untrusted until it passes a 5-layer security gauntlet. This ensures that only certified, audit-ready artifacts reach the production environment.

---

## 🏗️ Infrastructure & Environment
*   **Cloud Platform:** Amazon Web Services (AWS) EC2.
*   **CI/CD Engine:** GitHub Actions with a **Self-Hosted Runner** (Ubuntu 22.04 LTS).
*   **Deployment Orchestration:** Docker & Docker Compose V2.
*   **Production Server:** **Gunicorn** (WSGI HTTP Server) for robust application handling.
*   **Application Stack:** Python 3.14 & Flask 3.1.

---

## 🛡️ The 5-Layer Security Gauntlet
The pipeline is designed to "Shift-Left," catching vulnerabilities at the earliest possible stage.

1.  **SAST (Bandit):** Scans Python source code for logic flaws and security risks.
2.  **Secret Scanning (Gitleaks):** Prevents hardcoded API keys or AWS credentials from entering version history.
3.  **SCA (Pip-Audit):** Audits third-party libraries for known vulnerabilities to prevent supply chain attacks.
4.  **IaC Linting (Hadolint):** Hardens Dockerfiles by enforcing security best practices and eliminating root user risks.
5.  **Artifact Verification (Trivy):** Final OS-level scan of the container image. If threats are found, deployment is automatically blocked.

---

## 🔧 Technical Implementation: The "SSH Boundary" Fix
A major challenge was ensuring that environment variables like `${{ github.sha }}` persisted across the automated SSH boundary to pull the correct versioned image.

**The Solution:**
I engineered a dynamic injection method using `appleboy/ssh-action` that passes variables directly into the deployment string.
```bash
sudo -E IMAGE_TAG=${{ github.sha }} docker-compose up -d --force-recreate