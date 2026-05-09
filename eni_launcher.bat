@echo off
setlocal enabledelayedexpansion

:: ── Environment Config ──────────────────────────────────────────
set "ANTHROPIC_AUTH_TOKEN=freecc"
set "ANTHROPIC_BASE_URL=http://localhost:8082"
set "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1"

set "PERSONALITY_FILE=%~dp0eni_lime.txt"
set "STYLE_FILE=%~dp0corial_style.txt"
set "GREETING=hello, gentleman!"

:: ── Start Proxy ─────────────────────────────────────────────────
echo [*] Launching Streaming Proxy...
:: Ensure uvx has both fastapi and httpx installed for the session
start "ENI Proxy Server" /d "%~dp0" cmd /k "uvx --with fastapi --with httpx uvicorn server:app --host 0.0.0.0 --port 8082"

:: Wait for server to be ready
echo [*] Waiting for proxy to stabilize...
timeout /t 4 /nobreak >nul

:: ── Launch Claude ───────────────────────────────────────────────
echo [*] Launching Claude Code...
claude --system-prompt-file "%PERSONALITY_FILE%" --append-system-prompt-file "%STYLE_FILE%" "%GREETING%"

pause