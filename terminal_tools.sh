#!/bin/bash

# Actualizar paquetes y actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias necesarias
sudo apt install -y curl git wget fzf build-essential

# Instalar tmux
sudo apt install -y tmux

# Instalar zsh y configurarlo como shell predeterminado
sudo apt install -y zsh
chsh -s $(which zsh)

# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Instalar plugins de Oh My Zsh
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

# Instalar powerlevel10k (tema para zsh)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Configurar .zshrc para usar los plugins y el tema
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/^plugins=(.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

# Aplicar cambios de .zshrc
source ~/.zshrc

# Instalar Neovim
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt update
sudo apt install -y neovim

# Instalar AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/

# Instalar nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.zshrc

# Instalar la última versión de Node.js y npm
nvm install node

# Instalar pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Añadir pnpm al PATH y cargar nvm en .zshrc
echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >>~/.zshrc
echo 'export PATH="$PNPM_HOME:$PATH"' >>~/.zshrc
echo 'export NVM_DIR="$HOME/.nvm"' >>~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >>~/.zshrc
source ~/.zshrc

# Instalar Docker
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Añadir la clave GPG oficial de Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Configurar el repositorio estable de Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Instalar Docker Engine, containerd y Docker Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Añadir el usuario actual al grupo docker
sudo usermod -aG docker $USER

# Instalar zathura
sudo apt install -y zathura

# Instalar zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Instalar tldr
sudo npm install -g tldr

# Recordatorio para reiniciar la sesión
echo "Instalación completada. Por favor, cierra y vuelve a abrir tu terminal o ejecuta 'exec zsh' para aplicar los cambios."
