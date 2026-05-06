# Chain of Trust: Engineering a Secure Infrastructure Lifecycle 🛡️🚀

This project establishes a **Security-First gatekeeping architecture** for application deployment. It utilizes a **Continuous Verification model** where every build is treated as untrusted until it passes a 5-layer security gauntlet, ensuring only certified artifacts reach production.

---

## 🛠️ The Tech Stack
*   **Cloud Platform:** Amazon Web Services (AWS) EC2.
*   **CI/CD Engine:** GitHub Actions with a **Self-Hosted Runner** (Ubuntu 22.04 LTS).
*   **Production Server:** Gunicorn (WSGI HTTP Server).
*   **Orchestration:** Docker & Docker Compose V2.
*   **Development Stack:** Python 3.14 & Flask 3.1.

---

## 🛡️ Tools & Automated Commands
The pipeline is engineered to **"Shift-Left,"** catching vulnerabilities through the following automated gates:

1.  **SAST (Bandit):** `bandit -r . -f json -o bandit-report.json`.
2.  **Secret Scanning (Gitleaks):** `gitleaks detect --source . -v`.
3.  **SCA (Pip-audit):** `pip-audit -r requirements.txt`.
4.  **IaC Linting (Hadolint):** `hadolint Dockerfile`.
5.  **Image Scanning (Trivy):** `trivy image --severity HIGH,CRITICAL [IMAGE_NAME]`.

---

## 🚀 Step-by-Step: Building and Starting the Application

Follow this sequence to set up the environment and deploy the hardened infrastructure.

### **Step 1: Infrastructure Initialization (AWS EC2)**
1.  Launch an **AWS EC2** instance (Ubuntu 22.04 LTS).
2.  Configure Security Groups to allow inbound traffic on **Port 80** (HTTP) and **Port 22** (SSH).
3.  Install **Docker** and **Docker Compose V2** on the instance.

### **Step 2: Self-Hosted Runner Setup**
1.  Navigate to your GitHub Repository > Settings > Actions > Runners.
2.  Select **New self-hosted runner** and follow the commands to download and configure the runner on your EC2 instance.
3.  Install the runner as a service to ensure it persists:
    ```bash
    sudo ./svc.sh install && sudo ./svc.sh start
    ```

### **Step 3: Building the Security Gauntlet (The Sequence)**
The project is built via **GitHub Actions** in the following order:
1.  **Static Audits:** Run `Bandit`, `Gitleaks`, and `Pip-audit` to verify code and dependency integrity.
2.  **Linting:** Run `Hadolint` to ensure the Dockerfile follows security best practices.
3.  **Build:** Generate the Docker image only if all previous audits pass.
4.  **Verification:** Run `Trivy` against the final image as the ultimate gatekeeper.

### **Step 4: Starting the Application**
Once the image passes all checks, the deployment triggers automatically via the **appleboy/ssh-action**. To start or update the application manually on the server while preserving the versioned image tag:
```bash
sudo -E IMAGE_TAG=${{ github.sha }} docker-compose up -d --force-recreategit status
