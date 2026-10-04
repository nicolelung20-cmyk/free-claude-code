#!/usr/bin/env bash
set -euo pipefail

# Cloud bootstrap for Free Claude Code. Controlled by FCC_INSTALL_AGENTS.
# Supported values: claude,codex,hermes (comma-separated).
agents="${FCC_INSTALL_AGENTS:-claude,codex,hermes}"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.opencode/bin:$HOME/.local/share/mise/shims:$PATH"

install_agent() {
  local name="$1" url="$2"
  case ",$agents," in
    *,"$name",*)
      echo "[fcc-bootstrap] installing $name"
      curl -fsSL "$url" | bash
      ;;
  esac
}

command -v curl >/dev/null 2>&1 || { echo "[fcc-bootstrap] curl is required" >&2; exit 1; }
install_agent claude "https://claude.ai/install.sh"
install_agent codex "https://chatgpt.com/codex/install.sh"
install_agent hermes "https://hermes-agent.nousresearch.com/install.sh"

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.opencode/bin:$HOME/.local/share/mise/shims:$PATH"

for bin in claude codex hermes; do
  case ",$agents," in
    *,"$bin",*)
      if command -v "$bin" >/dev/null 2>&1; then
        echo "[fcc-bootstrap] $bin: $(command -v "$bin")"
      else
        echo "[fcc-bootstrap] WARNING: $bin was not installed" >&2
      fi
      ;;
  esac
done
