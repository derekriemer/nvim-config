#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  echo 'Usage: ./bootstrap.sh'
  echo 'Clone the speech plugin and TCP bridge into ~/code/nvim-speaks.'
  echo 'Symlink this checkout to ${XDG_CONFIG_HOME:-~/.config}/nvim.'
  echo 'Requires git, bash, and socat. Existing checkouts are left unchanged.'
  exit 0
fi
if (( $# )); then
  echo 'Usage: ./bootstrap.sh' >&2
  exit 1
fi

for tool in git socat; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing dependency: $tool. Install it with your package manager and rerun." >&2
    exit 1
  fi
done

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
config_path="$config_root/nvim"

echo "Checking Neovim config link: $config_path -> $repo_root"
# Check before cloning so a conflicting config does not leave a partial setup.
if [[ -e "$config_path" || -L "$config_path" ]]; then
  if [[ ! "$config_path" -ef "$repo_root" ]]; then
    echo "Refusing to overwrite existing config: $config_path. Move it aside and rerun." >&2
    exit 1
  fi
fi

speech_root="$HOME/code/nvim-speaks"
mkdir -p "$speech_root"

for repo in nvim-speaks nvim-speaks-tcp-bridge; do
  destination="$speech_root/$repo"
  if [[ -e "$destination" || -L "$destination" ]]; then
    if [[ ! -e "$destination/.git" ]]; then
      echo "Refusing to overwrite existing path: $destination" >&2
      exit 1
    fi
    echo "Keeping existing checkout: $destination"
  else
    git clone "https://github.com/derekriemer/$repo.git" "$destination"
  fi
done

[[ -f "$speech_root/nvim-speaks/lua/nvim-speaks/init.lua" ]] || {
  echo 'Plugin checkout is missing lua/nvim-speaks/init.lua.' >&2
  exit 1
}
[[ -f "$speech_root/nvim-speaks-tcp-bridge/speech-to-tcp" ]] || {
  echo 'TCP bridge checkout is missing speech-to-tcp.' >&2
  exit 1
}

mkdir -p "$config_root"
if [[ ! -e "$config_path" && ! -L "$config_path" ]]; then
  echo "Creating symlink: $config_path -> $repo_root"
  ln -s "$repo_root" "$config_path"
  echo "Linked $config_path -> $repo_root"
else
  echo "Config already points to this checkout: $config_path"
fi

echo 'Speech dependencies are ready. Start your speech server at 127.0.0.1:7533 before using Neovim.'
