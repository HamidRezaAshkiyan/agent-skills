#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INSTALL_CURSOR=false
INSTALL_CLAUDE=false
INSTALL_ANTIGRAVITY=false
GLOBAL=false
TARGET_DIR="$(pwd)"

usage() {
  cat <<'EOF'
Install reusable Agent Skills and Rules into a project or globally.

Usage:
  ./install.sh [options]

Options:
  --cursor        Install skills & rules for Cursor
  --claude        Install skills for Claude Code
  --antigravity   Install skills & rules for Antigravity / .agents standard
  --all           Install for Cursor, Claude Code, and Antigravity (default)
  --global        Install into user-level directories (~/.cursor, ~/.claude, ~/.gemini/config)
  --target <dir>  Target project directory (default: current directory)
  -h, --help      Show this help message

Examples:
  ./install.sh --all --target ~/repos/my-app
  ./install.sh --cursor --claude --global
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cursor)      INSTALL_CURSOR=true; shift ;;
    --claude)      INSTALL_CLAUDE=true; shift ;;
    --antigravity|--agents) INSTALL_ANTIGRAVITY=true; shift ;;
    --all)         INSTALL_CURSOR=true; INSTALL_CLAUDE=true; INSTALL_ANTIGRAVITY=true; shift ;;
    --global)      GLOBAL=true; shift ;;
    --target)
      [[ $# -lt 2 ]] && { echo "Error: --target requires a directory argument" >&2; exit 1; }
      TARGET_DIR="$2"; shift 2 ;;
    -h|--help)     usage; exit 0 ;;
    *)             echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

if ! $INSTALL_CURSOR && ! $INSTALL_CLAUDE && ! $INSTALL_ANTIGRAVITY; then
  INSTALL_CURSOR=true
  INSTALL_CLAUDE=true
  INSTALL_ANTIGRAVITY=true
fi

copy_skills() {
  local dest="$1"
  mkdir -p "$dest"
  cp -R "$SCRIPT_DIR/skills/." "$dest/"
  echo "  -> Installed skills to $dest"
}

copy_rules() {
  local src="$1"
  local dest="$2"
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
  echo "  -> Installed rules to $dest"
}

if $GLOBAL; then
  echo "Installing globally..."
  if $INSTALL_CURSOR; then
    copy_skills "$HOME/.cursor/skills"
  fi
  if $INSTALL_CLAUDE; then
    copy_skills "$HOME/.claude/skills"
  fi
  if $INSTALL_ANTIGRAVITY; then
    copy_skills "$HOME/.gemini/config/skills"
    copy_skills "$HOME/.agents/skills"
  fi
else
  echo "Installing into project: $TARGET_DIR"
  if $INSTALL_CURSOR; then
    copy_skills "$TARGET_DIR/.cursor/skills"
    copy_rules "$SCRIPT_DIR/.cursor/rules" "$TARGET_DIR/.cursor/rules"
  fi
  if $INSTALL_CLAUDE; then
    copy_skills "$TARGET_DIR/.claude/skills"
  fi
  if $INSTALL_ANTIGRAVITY; then
    copy_skills "$TARGET_DIR/.agents/skills"
    copy_rules "$SCRIPT_DIR/.agents/rules" "$TARGET_DIR/.agents/rules"
  fi
fi

echo "Done!"
