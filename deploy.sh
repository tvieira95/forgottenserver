#!/usr/bin/env bash
set -Eeuo pipefail

SERVER_BIN="./tfs"
BUILD_BIN="build-release/tfs"
SESSION_NAME="tfs"
TAIL_SECONDS=30

# ── 1. Aguardar processo existente encerrar ──────────────────────
PID=$(pgrep -x tfs || true)
if [ -n "$PID" ]; then
    echo "[DEPLOY] Server rodando (PID $PID). Enviando SIGTERM..."
    kill -SIGTERM "$PID"
    echo "[DEPLOY] Aguardando processo $PID encerrar..."
    while kill -0 "$PID" 2>/dev/null; do
        sleep 2
    done
    echo "[DEPLOY] Processo $PID encerrado."
else
    echo "[DEPLOY] Nenhum processo tfs encontrado."
fi

# ── 2. Substituir binário ────────────────────────────────────────
cp -f "$BUILD_BIN" "$SERVER_BIN"
chmod +x "$SERVER_BIN"
ldd "$SERVER_BIN"
echo "[DEPLOY] Binário substituído com sucesso."

# ── 3. Matar sessão tmux antiga (se existir) ─────────────────────
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

# ── 4. Iniciar servidor em sessão tmux ───────────────────────────
tmux new-session -d -s "$SESSION_NAME" "./start.sh"

# ── 5. Tail do log para o console Jenkins ────────────────────────
sleep 3
LATEST_LOG=$(ls -1t logs/*.log 2>/dev/null | head -1)
if [ -n "$LATEST_LOG" ]; then
    echo "[DEPLOY] Log: $LATEST_LOG"
    echo "[DEPLOY] === Início do output do servidor ==="
    timeout "$TAIL_SECONDS" tail -f "$LATEST_LOG" || true
    echo "[DEPLOY] === Fim do output (servidor continua no tmux) ==="
else
    echo "[DEPLOY] Nenhum log encontrado. Servidor iniciado no tmux."
fi

echo "[DEPLOY] Acesse: tmux attach -t $SESSION_NAME"
