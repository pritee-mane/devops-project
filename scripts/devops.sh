#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  scripts/devops.sh — Master DevOps Command Toolkit
#  Usage: bash scripts/devops.sh
#  Or:    chmod +x scripts/devops.sh && ./scripts/devops.sh
# ═══════════════════════════════════════════════════════════════

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

APP_NAME="devops-project"
IMAGE_NAME="devops-project:latest"
K8S_DIR="kubernetes"

# ── Helper functions ──────────────────────────────────────────
log()     { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; }
heading() { echo -e "\n${BOLD}${CYAN}$1${NC}"; echo "$(printf '─%.0s' {1..50})"; }

confirm() {
  read -p "$(echo -e "${YELLOW}⚠ $1 [y/N]:${NC} ")" choice
  [[ "$choice" =~ ^[Yy]$ ]]
}

# ── Main menu ─────────────────────────────────────────────────
show_menu() {
  clear
  echo -e "${BOLD}${BLUE}"
  echo "  ██████╗ ███████╗██╗   ██╗ ██████╗ ██████╗ ███████╗"
  echo "  ██╔══██╗██╔════╝██║   ██║██╔═══██╗██╔══██╗██╔════╝"
  echo "  ██║  ██║█████╗  ██║   ██║██║   ██║██████╔╝███████╗"
  echo "  ██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██╔═══╝ ╚════██║"
  echo "  ██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║     ███████║"
  echo "  ╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝     ╚══════╝"
  echo -e "${NC}"
  echo -e "  ${BOLD}DevOps Command Toolkit${NC} — $APP_NAME\n"

  echo -e "  ${CYAN}DOCKER${NC}"
  echo "  1)  Build Docker image"
  echo "  2)  Run container"
  echo "  3)  Stop & remove container"
  echo "  4)  View container logs"
  echo "  5)  Open shell in container"
  echo "  6)  List containers & images"
  echo "  7)  Push image to Docker Hub"

  echo -e "\n  ${CYAN}DOCKER COMPOSE${NC}"
  echo "  8)  Start all services (compose up)"
  echo "  9)  Stop all services (compose down)"
  echo "  10) Rebuild & restart everything"
  echo "  11) View compose logs"

  echo -e "\n  ${CYAN}KUBERNETES${NC}"
  echo "  12) Deploy to Kubernetes"
  echo "  13) Get pods status"
  echo "  14) Scale deployment"
  echo "  15) Rollback deployment"
  echo "  16) Port-forward (local access)"
  echo "  17) Delete all K8s resources"

  echo -e "\n  ${CYAN}CI/CD${NC}"
  echo "  18) Trigger GitHub Actions pipeline"
  echo "  19) View recent pipeline runs"
  echo "  20) Git add, commit & push"

  echo -e "\n  ${CYAN}CLOUD${NC}"
  echo "  21) AWS: show current identity"
  echo "  22) AWS: list EC2 instances"
  echo "  23) AWS: login to ECR"

  echo -e "\n  ${CYAN}UTILITIES${NC}"
  echo "  24) Run app locally (no Docker)"
  echo "  25) Run tests"
  echo "  26) Clean up Docker (free disk space)"
  echo "  0)  Exit\n"
}

# ── Docker functions ──────────────────────────────────────────
docker_build() {
  heading "Building Docker Image"
  docker build -t $IMAGE_NAME -f docker/Dockerfile . && log "Image built: $IMAGE_NAME"
}

docker_run() {
  heading "Running Container"
  docker run -d --name $APP_NAME -p 3000:3000 -e NODE_ENV=production $IMAGE_NAME
  log "Container started → http://localhost:3000"
}

docker_stop() {
  heading "Stopping Container"
  docker stop $APP_NAME && docker rm $APP_NAME && log "Container removed"
}

docker_logs() {
  heading "Container Logs (Ctrl+C to exit)"
  docker logs -f $APP_NAME
}

docker_shell() {
  heading "Opening Shell in Container"
  warn "Type 'exit' to leave the container shell"
  docker exec -it $APP_NAME sh
}

docker_list() {
  heading "Running Containers"
  docker ps
  echo ""
  heading "All Images"
  docker images
}

docker_push() {
  heading "Push Image to Docker Hub"
  read -p "Enter your Docker Hub username: " username
  docker tag $IMAGE_NAME $username/$APP_NAME:latest
  docker push $username/$APP_NAME:latest
  log "Pushed to Docker Hub: $username/$APP_NAME:latest"
}

# ── Compose functions ─────────────────────────────────────────
compose_up() {
  heading "Starting All Services"
  docker compose up -d && log "All services started"
  docker compose ps
}

compose_down() {
  heading "Stopping All Services"
  docker compose down && log "All services stopped"
}

compose_rebuild() {
  heading "Rebuilding & Restarting"
  docker compose down
  docker compose build
  docker compose up -d
  log "Rebuild complete"
}

compose_logs() {
  heading "Compose Logs (Ctrl+C to exit)"
  docker compose logs -f
}

# ── Kubernetes functions ──────────────────────────────────────
k8s_deploy() {
  heading "Deploying to Kubernetes"
  kubectl apply -f $K8S_DIR/ && log "Deployed to Kubernetes"
  kubectl get pods
}

k8s_pods() {
  heading "Kubernetes Pods"
  kubectl get pods -o wide
  echo ""
  kubectl get services
}

k8s_scale() {
  read -p "Enter number of replicas (e.g. 3): " replicas
  kubectl scale deployment $APP_NAME --replicas=$replicas
  log "Scaled to $replicas replicas"
}

k8s_rollback() {
  confirm "Rollback $APP_NAME to previous version?" && \
  kubectl rollout undo deployment/$APP_NAME && \
  log "Rollback complete"
}

k8s_portforward() {
  log "Port-forwarding → http://localhost:8080 (Ctrl+C to stop)"
  kubectl port-forward deployment/$APP_NAME 8080:3000
}

k8s_delete() {
  confirm "Delete ALL Kubernetes resources for $APP_NAME?" && \
  kubectl delete -f $K8S_DIR/ && \
  log "All K8s resources deleted"
}

# ── CI/CD functions ───────────────────────────────────────────
cicd_trigger() {
  heading "Triggering GitHub Actions"
  gh workflow run ci-cd.yml && log "Workflow triggered"
}

cicd_status() {
  heading "Recent Pipeline Runs"
  gh run list --limit 10
}

git_push() {
  heading "Git: Add, Commit & Push"
  read -p "Enter commit message: " msg
  git add .
  git commit -m "$msg"
  git push
  log "Pushed to remote — CI/CD pipeline will start automatically"
}

# ── Cloud functions ───────────────────────────────────────────
aws_identity() {
  heading "AWS Identity"
  aws sts get-caller-identity
}

aws_ec2() {
  heading "EC2 Instances"
  aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
    --output table
}

aws_ecr_login() {
  read -p "Enter AWS region (e.g. us-east-1): " region
  read -p "Enter ECR URL: " ecr_url
  aws ecr get-login-password --region $region | \
    docker login --username AWS --password-stdin $ecr_url
  log "Logged in to ECR"
}

# ── Utility functions ─────────────────────────────────────────
run_local() {
  heading "Running App Locally"
  cd app && npm install && npm run dev
}

run_tests() {
  heading "Running Tests"
  cd app && npm test
}

docker_clean() {
  heading "Cleaning Docker Resources"
  confirm "Remove all unused Docker images, containers, and volumes?" && \
  docker system prune -af --volumes && \
  log "Cleanup complete"
}

# ── Main loop ─────────────────────────────────────────────────
while true; do
  show_menu
  read -p "$(echo -e "${BOLD}Enter choice [0-26]:${NC} ")" choice

  case $choice in
    1)  docker_build ;;
    2)  docker_run ;;
    3)  docker_stop ;;
    4)  docker_logs ;;
    5)  docker_shell ;;
    6)  docker_list ;;
    7)  docker_push ;;
    8)  compose_up ;;
    9)  compose_down ;;
    10) compose_rebuild ;;
    11) compose_logs ;;
    12) k8s_deploy ;;
    13) k8s_pods ;;
    14) k8s_scale ;;
    15) k8s_rollback ;;
    16) k8s_portforward ;;
    17) k8s_delete ;;
    18) cicd_trigger ;;
    19) cicd_status ;;
    20) git_push ;;
    21) aws_identity ;;
    22) aws_ec2 ;;
    23) aws_ecr_login ;;
    24) run_local ;;
    25) run_tests ;;
    26) docker_clean ;;
    0)  echo -e "\n${GREEN}Goodbye!${NC}\n"; exit 0 ;;
    *)  error "Invalid choice. Try again." ;;
  esac

  echo -e "\n${YELLOW}Press Enter to return to menu...${NC}"
  read
done
