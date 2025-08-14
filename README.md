# Easy-Setup

Easy-Setup é um script para macOS que permite instalar e remover suas ferramentas de desenvolvimento e aplicativos favoritos de forma rápida e interativa. Ele automatiza a instalação de Homebrew, Bash 5, Zsh, Oh My Zsh, GUI apps e ferramentas de CLI, incluindo Fathom.

## Features

- Instalação automática de Homebrew e Bash 5
- Menu interativo usando [gum](https://github.com/charmbracelet/gum)
- Instalação de GUI Apps: Docker, VS Code, Ghostty, DBeaver, VLC, Arc Browser, Fathom, entre outros
- Instalação de ferramentas CLI: Zsh, Oh My Zsh, pnpm, asdf, htop, bat, fzf, jq
- Remoção de pacotes selecionados
- Separação por categorias (GUI apps, CLI dev tools)

## Instalação

```bash
# Clone o repositório
git clone <repo-url> $HOME/easy-setup
cd $HOME/easy-setup

# Execute o bootstrap
/opt/homebrew/bin/bash ./easy-setup.sh install
```

> Caso o Bash 5 ainda não esteja instalado, o script vai instalá-lo via Homebrew e instruir como rodar com o novo Bash.

## Uso

### Menu interativo de instalação

```bash
/opt/homebrew/bin/bash ./easy-setup.sh
```

### Remover pacotes

```bash
/opt/homebrew/bin/bash ./easy-setup.sh remove
```

### Instalação manual

Você pode chamar funções específicas diretamente dentro do script, por exemplo:

```bash
./easy-setup.sh  # abre menu interativo
install_bash5    # instala Bash 5
install_homebrew # instala Homebrew
```

## Categorias

- **GUI Apps:** Docker, VS Code, Ghostty, DBeaver, VLC, Arc Browser, Fathom, Rectangle, Raycast, AltTab, iTerm2, Postman, Insomnia, TablePlus, Brave, Firefox Dev Edition, 1Password
- **CLI Dev Tools:** Zsh, Oh My Zsh, pnpm, asdf, htop, bat, fzf, jq

## Contribuição

Pull requests são bem-vindos! Para bugs ou sugestões, abra uma issue.

## Licença

MIT License
