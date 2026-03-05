# 🚀 DevOps Project — Complete Toolkit

A full DevOps project with Docker, Kubernetes, CI/CD pipelines, and a
command toolkit you can run directly from VS Code.

---

## 📁 Project Structure

```
devops-project/
├── .vscode/
│   ├── tasks.json          ← 30+ VS Code tasks (run with Ctrl+Shift+P)
│   └── extensions.json     ← Recommended extensions (auto-prompted)
├── .github/
│   └── workflows/
│       └── ci-cd.yml       ← GitHub Actions: Test → Build → Deploy
├── app/
│   ├── server.js           ← Simple Node.js app
│   └── package.json
├── docker/
│   ├── Dockerfile          ← Multi-stage production image
│   └── nginx.conf          ← Nginx reverse proxy config
├── kubernetes/
│   ├── deployment.yml      ← Deployment + Service + Autoscaler
│   └── config.yml          ← ConfigMap + Secrets + Namespaces
├── scripts/
│   └── devops.sh           ← Interactive menu-driven command toolkit
├── docker-compose.yml      ← App + DB + Redis + Nginx
└── README.md
```

---

## ⚡ Quick Start (3 steps)

### 1. Open in VS Code
```bash
# Clone or download this project, then:
code devops-project
```

### 2. Install recommended extensions
VS Code will ask "Install recommended extensions?" → click **Install All**

### 3. Run your first task
Press `Ctrl+Shift+P` → type **Tasks: Run Task** → pick any task from the list

---

## 🐳 Docker — How to Use

### Option A: VS Code Tasks (easiest)
`Ctrl+Shift+P` → `Tasks: Run Task` → pick a Docker task

### Option B: Interactive Script
```bash
bash scripts/devops.sh
```
Pick any option from the menu.

### Option C: Manual commands in VS Code Terminal (Ctrl+`)
```bash
# Build your image
docker build -t devops-project:latest -f docker/Dockerfile .

# Run it
docker run -d -p 3000:3000 devops-project:latest

# Visit http://localhost:3000
```

---

## 🐳 Docker Compose — Run Everything at Once

```bash
# Start app + database + redis + nginx
docker compose up -d

# Check all services are running
docker compose ps

# View logs from all services
docker compose logs -f

# Stop everything
docker compose down
```

Services started:
| Service | URL |
|---------|-----|
| App | http://localhost:3000 |
| Nginx (proxy) | http://localhost |
| PostgreSQL | localhost:5432 |
| Redis | localhost:6379 |

---

## ☸️ Kubernetes — Deploy to a Cluster

### Setup (one time)
```bash
# For local testing, install minikube:
minikube start

# For cloud, configure kubectl:
aws eks update-kubeconfig --name my-cluster   # AWS
gcloud container clusters get-credentials my-cluster  # GCP
az aks get-credentials --name my-cluster --resource-group rg  # Azure
```

### Deploy
```bash
# Deploy everything
kubectl apply -f kubernetes/

# Check status
kubectl get pods
kubectl get services

# Scale to 5 replicas
kubectl scale deployment devops-app --replicas=5

# Roll back if something breaks
kubectl rollout undo deployment/devops-app

# Access locally (without exposing publicly)
kubectl port-forward deployment/devops-app 8080:3000
# Visit http://localhost:8080
```

---

## ⚙️ CI/CD — GitHub Actions Pipeline

### What it does automatically:
1. **On every push to main** → runs tests → builds Docker image → deploys to server
2. **On pull requests** → runs tests only (no deploy)

### Setup (one time):
Go to your GitHub repo → **Settings** → **Secrets** → Add:

| Secret | Value |
|--------|-------|
| `DOCKER_USERNAME` | Your Docker Hub username |
| `DOCKER_PASSWORD` | Your Docker Hub password |
| `SSH_HOST` | Your server IP address |
| `SSH_USER` | Your server username (e.g. ubuntu) |
| `SSH_PRIVATE_KEY` | Your private SSH key (`cat ~/.ssh/id_rsa`) |

### Trigger manually:
```bash
gh workflow run ci-cd.yml          # Trigger
gh run list                        # See runs
gh run watch                       # Watch in real time
```

---

## 🖥️ VS Code Tasks — Full List

Open with: `Ctrl+Shift+P` → **Tasks: Run Task**

| Task | What it does |
|------|-------------|
| 🐳 Docker: Build Image | Build Docker image from Dockerfile |
| 🐳 Docker: Run Container | Start container on port 3000 |
| 🐳 Docker: Stop & Remove | Stop and delete the container |
| 🐳 Docker: View Logs | Follow container logs |
| 🐳 Docker: Open Shell | Debug inside the container |
| 🐳 Docker: List All | Show containers and images |
| 🐳 Docker: Push to Hub | Upload image to Docker Hub |
| 🐳 Compose: Start All | Start all services |
| 🐳 Compose: Stop All | Stop all services |
| 🐳 Compose: Rebuild | Rebuild and restart |
| ☸️ K8s: Apply All | Deploy to Kubernetes |
| ☸️ K8s: Get Pods | Check pod status |
| ☸️ K8s: Scale App | Change replica count |
| ☸️ K8s: Rollback | Undo last deployment |
| ☸️ K8s: Port Forward | Access app locally |
| ⚙️ CI/CD: Trigger | Run GitHub Actions |
| ⚙️ CI/CD: List Runs | See pipeline status |
| 📦 Git: Add Commit Push | One-step git push |
| ☁️ AWS: Identity | Confirm AWS account |
| ☁️ AWS: EC2 List | List virtual machines |
| 🔧 Dev: Run Locally | Start without Docker |
| 🔧 Dev: Run Tests | Execute test suite |
| 🔧 System: Clean Docker | Free up disk space |

---

## 🛠️ Required Tools

Install these on your machine:

```bash
# Docker
sudo apt install docker.io docker-compose-plugin    # Linux
# Or download Docker Desktop for Mac/Windows

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

# GitHub CLI
sudo apt install gh    # Linux
brew install gh        # Mac

# AWS CLI
pip install awscli

# Node.js (for running app locally)
sudo apt install nodejs npm
```

---

## 💡 Beginner Tips

- **Start with Docker Compose** — it's the easiest way to run everything
- **Use VS Code Tasks** — you don't need to memorize any commands
- **Check logs first** when something breaks: `docker compose logs -f`
- **Never commit secrets** — use `.env` files or GitHub Secrets
- **Kubernetes is optional** — learn Docker Compose first, then K8s

---

## 🆘 Common Fixes

| Problem | Fix |
|---------|-----|
| Port already in use | `docker stop $(docker ps -q)` |
| Image not found | Run the "Build Image" task first |
| Pods in CrashLoopBackOff | `kubectl logs <pod-name>` to see error |
| Permission denied on script | `chmod +x scripts/devops.sh` |
| Docker not running | Start Docker Desktop or `sudo systemctl start docker` |
