#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir="$(cd "$(dirname "$0")" && pwd)"
oh_my_tmux_dir="$HOME/.local/share/tmux/oh-my-tmux"
tmux_config_dir="$HOME/.config/tmux"

link_config() {
  local source_file="$1"
  local target_file="$2"
  local is_regular_file=false
  [ -e "$target_file" ] && [ ! -L "$target_file" ] && is_regular_file=true
  if [ "$is_regular_file" = true ]; then
    mv "$target_file" "$target_file.bak"
    echo "backed up $target_file -> $target_file.bak"
  fi
  ln -sfn "$source_file" "$target_file"
}

if ! command -v tmux >/dev/null; then
  echo "tmux is not installed" >&2
  exit 1
fi

if [ ! -d "$oh_my_tmux_dir" ]; then
  git clone https://github.com/gpakosz/.tmux.git "$oh_my_tmux_dir"
fi

mkdir -p "$tmux_config_dir"
link_config "$oh_my_tmux_dir/.tmux.conf" "$tmux_config_dir/tmux.conf"
link_config "$dotfiles_dir/tmux.conf.local" "$tmux_config_dir/tmux.conf.local"

echo "done, start tmux or press prefix + r to reload"
