#!/usr/bin/env bash

set -euo pipefail

MISE_BIN="$HOME/.local/bin/mise"
ZSHRC="$HOME/.zshrc"

echo "==> Installing mise"

mkdir -p "$HOME/.local/bin"

if command -v mise >/dev/null 2>&1; then
    echo "==> mise is already installed:"
    mise --version
else
    curl https://mise.run | sh
fi

# ------------------------------------------------------------
# Zsh integration
# ------------------------------------------------------------

echo "==> Configuring mise for Zsh"

MISE_ZSH_LINE='eval "$(~/.local/bin/mise activate zsh)"'

if [[ -f "$ZSHRC" ]] && grep -Fqx "$MISE_ZSH_LINE" "$ZSHRC"; then
    echo "    mise activation already exists in $ZSHRC"
else
    printf '\n%s\n' "$MISE_ZSH_LINE" >> "$ZSHRC"
    echo "    Added mise activation to $ZSHRC"
fi

# ------------------------------------------------------------
# Verify
# ------------------------------------------------------------

if [[ ! -x "$MISE_BIN" ]]; then
    echo "ERROR: mise was not installed at:"
    echo "       $MISE_BIN"
    exit 1
fi

echo
echo "==> mise installed successfully"
"$MISE_BIN" --version

echo
echo "Restart your shell or run:"
echo
echo "    exec zsh"
echo
echo "Then verify with:"
echo
echo "    mise --version"
