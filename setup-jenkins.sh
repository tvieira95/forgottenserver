#!/usr/bin/env bash
set -Eeuo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=== Instalando Jenkins ===${NC}"

# ── 1. Java 17 ───────────────────────────────────────────────────
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre

# ── 2. Repo Jenkins ─────────────────────────────────────────────
sudo mkdir -p /etc/apt/keyrings
wget -O- https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/jenkins.gpg
sudo chmod a+r /etc/apt/keyrings/jenkins.gpg
echo "deb [signed-by=/etc/apt/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" | \
    sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# ── 3. Instalar Jenkins ─────────────────────────────────────────
sudo apt update
sudo apt install -y jenkins

# ── 4. Iniciar serviço ──────────────────────────────────────────
sudo systemctl enable jenkins
sudo systemctl start jenkins

# ── 5. Aguardar Jenkins subir ────────────────────────────────────
echo -e "${YELLOW}Aguardando Jenkins inicializar...${NC}"
for i in $(seq 1 30); do
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 2>/dev/null | grep -q "200\|403"; then
        break
    fi
    sleep 2
done

# ── 6. Capturar senha inicial ───────────────────────────────────
INITIAL_PASS=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "N/A")

# ── 7. Detectar IP ──────────────────────────────────────────────
SERVER_IP=$(hostname -I | awk '{print $1}')

# ── 8. Salvar credenciais ───────────────────────────────────────
CRED_FILE="$(pwd)/jenkins-credentials.txt"
cat > "$CRED_FILE" <<EOF
========================================
  JENKINS - Credenciais
========================================
URL:       http://${SERVER_IP}:8080
Usuário:   admin
Senha:     ${INITIAL_PASS}
========================================
Credenciais padrão do pipeline TFS:
User:      TFS
Password:  TFS123DEPLOY
========================================
EOF

# ── 9. Mostrar no terminal ──────────────────────────────────────
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Jenkins instalado com sucesso!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${CYAN}URL:${NC}       http://${SERVER_IP}:8080"
echo -e "${CYAN}Usuário:${NC}   admin"
echo -e "${CYAN}Senha:${NC}     ${INITIAL_PASS}"
echo -e "${GREEN}========================================${NC}"
echo -e "${CYAN}Credenciais salvas em:${NC} ${CRED_FILE}"
echo ""
echo -e "${YELLOW}Próximos passos:${NC}"
echo "  1. Acesse http://${SERVER_IP}:8080 no navegador"
echo "  2. Instale os plugins sugeridos"
echo "  3. Crie um Pipeline apontando para este repositório"
