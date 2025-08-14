#!/usr/bin/env bash
set -e

# ----------------------------
# Verifica se é Bash 5+
# ----------------------------
if ((BASH_VERSINFO[0] < 5)); then
  echo "⚠️ Este script precisa de Bash 5 ou superior."
  echo "   Você está usando Bash $BASH_VERSION"
  echo "   Execute com o Bash 5 instalado via Homebrew, por exemplo:"
  echo "   /opt/homebrew/bin/bash ./easy-setup.sh"
  exit 1
fi

# ----------------------------
# Configuração
# ----------------------------
SETUP_DIR="$HOME/easy-setup"
SCRIPT_NAME="easy-setup.sh"
SCRIPT_PATH="$SETUP_DIR/$SCRIPT_NAME"

# ----------------------------
# Bootstrap
# ----------------------------
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "📦 Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "✅ Homebrew já instalado"
  fi

  install_bash5
}

install_easy_setup() {
  mkdir -p "$SETUP_DIR"
  cp "$0" "$SCRIPT_PATH"
  chmod +x "$SCRIPT_PATH"
  if ! grep -q "$SETUP_DIR" ~/.zprofile; then
    echo "export PATH=\"$SETUP_DIR:\$PATH\"" >> ~/.zprofile
    echo "✅ easy-setup adicionado ao PATH. Abra um novo terminal para ativar."
  fi
  echo "🎉 Easy-setup instalado!"
}

install_bash5() {
  if ! command -v bash &>/dev/null || ((BASH_VERSINFO[0] < 5)); then
    echo "📦 Instalando Bash 5 via Homebrew..."
    brew install bash
    echo "✅ Bash 5 instalado em $(brew --prefix)/bin/bash"
    echo "⚠️ Para usar o script com Bash 5, execute:"
    echo "   $(brew --prefix)/bin/bash $0"
    exit 0
  else
    echo "✅ Bash 5 já instalado"
  fi
}

# ----------------------------
# Funções instalação/removal
# ----------------------------
install_brew_package() { brew install "$1"; }
install_cask_app() { brew install --cask "$1"; }
install_oh_my_zsh() { [ ! -d "$HOME/.oh-my-zsh" ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; }

remove_brew_package() { brew uninstall "$1" || echo "⚠️ Pacote $1 não encontrado"; }
remove_cask_app() { brew uninstall --cask "$1" || echo "⚠️ App $1 não encontrado"; }
remove_oh_my_zsh() { [ -d "$HOME/.oh-my-zsh" ] && rm -rf "$HOME/.oh-my-zsh" && echo "✅ Oh My Zsh removido"; }

# ----------------------------
# Categorias e descrições
# ----------------------------
declare -A CATEGORIES=(
  ["GUI_Apps"]="docker visual-studio-code ghostty dbeaver-community vlc arc rectangle raycast altTab iterm2 postman insomnia tableplus brave firefox-developer-edition 1password fathom"
  ["CLI_Dev_Tools"]="zsh ohmyzsh pnpm asdf htop bat fzf jq"
)

declare -A DESCRIPTIONS=(
  ["zsh"]="Shell avançado e personalizável"
  ["ohmyzsh"]="Framework para Zsh"
  ["docker"]="Docker Desktop - Rodar containers"
  ["visual-studio-code"]="VS Code - Editor de código"
  ["ghostty"]="Ghostty - Terminal minimalista"
  ["dbeaver-community"]="DBeaver Community - Cliente DB"
  ["vlc"]="VLC Media Player - Reprodutor multimídia"
  ["arc"]="Arc Browser - Browser moderno"
  ["rectangle"]="Rectangle - Gerenciamento de janelas"
  ["raycast"]="Raycast - Launcher rápido"
  ["altTab"]="AltTab - Alterna apps estilo Windows"
  ["iterm2"]="iTerm2 - Terminal avançado"
  ["postman"]="Postman - Testes de API"
  ["insomnia"]="Insomnia - Cliente leve de API"
  ["tableplus"]="TablePlus - Cliente DB elegante"
  ["brave"]="Brave - Browser focado em privacidade"
  ["firefox-developer-edition"]="Firefox Developer Edition - Browser dev frontend"
  ["1password"]="1Password - Gerenciamento de senhas"
  ["fathom"]="Fathom - Transcrição e resumo de reuniões via IA"
  ["pnpm"]="Gerenciador Node rápido"
  ["asdf"]="Gerenciador de versões de múltiplas linguagens"
  ["htop"]="Monitor de processos CLI"
  ["bat"]="Cat avançado com sintaxe colorida"
  ["fzf"]="Fuzzy finder interativo"
  ["jq"]="Manipulação de JSON"
)

get_description() {
  local key="$1"
  echo "${DESCRIPTIONS[$key]}"
}

# ----------------------------
# Menu interativo
# ----------------------------
run_menu() {
  [[ ! $(command -v gum) ]] && brew install gum

  MENU=()
  for category in "GUI_Apps" "CLI_Dev_Tools"; do
    display_name="${category//_/ }"
    MENU+=("== $display_name ==")
    for tool in ${CATEGORIES[$category]}; do
      desc=$(get_description "$tool")
      MENU+=("$tool::$tool - $desc")
    done
  done

  CHOICES=$(gum choose --no-limit --cursor-prefix "[ ] " --selected-prefix "[x] " --unselected-prefix "[ ] " "${MENU[@]}")

  for choice in $CHOICES; do
    [[ "$choice" == "=="* ]] && continue
    id="${choice%%::*}"
    case $id in
      zsh) install_brew_package zsh ;;
      ohmyzsh) install_oh_my_zsh ;;
      fathom) install_cask_app fathom ;;
      *)
        if [[ " ${CATEGORIES["GUI_Apps"]} " =~ " $id " ]]; then
          install_cask_app "$id"
        elif [[ " ${CATEGORIES["CLI_Dev_Tools"]} " =~ " $id " ]]; then
          install_brew_package "$id"
        fi
        ;;
    esac
  done

  echo "🎉 Instalação concluída!"
}

run_remove_menu() {
  [[ ! $(command -v gum) ]] && brew install gum

  MENU=()
  for category in "GUI_Apps" "CLI_Dev_Tools"; do
    display_name="${category//_/ }"
    MENU+=("== $display_name ==")
    for tool in ${CATEGORIES[$category]}; do
      desc=$(get_description "$tool")
      MENU+=("$tool::$tool - $desc")
    done
  done

  CHOICES=$(gum choose --no-limit --cursor-prefix "[ ] " --selected-prefix "[x] " --unselected-prefix "[ ] " "${MENU[@]}")

  for choice in $CHOICES; do
    [[ "$choice" == "=="* ]] && continue
    id="${choice%%::*}"
    case $id in
      zsh) remove_brew_package zsh ;;
      ohmyzsh) remove_oh_my_zsh ;;
      fathom) remove_cask_app fathom ;;
      *)
        if [[ " ${CATEGORIES["GUI_Apps"]} " =~ " $id " ]]; then
          remove_cask_app "$id"
        elif [[ " ${CATEGORIES["CLI_Dev_Tools"]} " =~ " $id " ]]; then
          remove_brew_package "$id"
        fi
        ;;
    esac
  done

  echo "🗑️ Remoção concluída!"
}

# ----------------------------
# Comandos principais
# ----------------------------
case "$1" in
  install)
    install_homebrew
    install_easy_setup
    ;;
  remove)
    run_remove_menu
    ;;
  *)
    run_menu
    ;;
esac
