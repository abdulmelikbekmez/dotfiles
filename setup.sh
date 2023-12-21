BIN_PATH="$HOME/.local/bin"

eccho ()
{
    echo ""
    echo "*********"
    echo $1
    echo "*********"
    echo ""
}

install_cargo_dep()
{
    if ! command -v $1 >/dev/null 2>&1; then
        eccho "$2 bulunamadi..."
        cargo install $2
    else
        eccho "$2 zaten yuklu"
    fi
}

install_with_apt()
{
    if ! command -v $1 >/dev/null 2>&1; then
        eccho "$1 bulunamadi..."
        sudo apt install $1
    else
        eccho "$1 zaten yuklu :)"
    fi
}

install_with_tar ()
{
    if command -v $1 >/dev/null 2>&1; then
        eccho "$1 yuklu"
    else
        eccho "$1 bulunamadi... Yukleniyor."
        wget $2
        tar -xf $3
        cd $4
        mv $1 $BIN_PATH
        cd ..
        rm -rf $3
        rm -rf $4
        eccho "$1 yuklendi."
    fi
}
install_neovim ()
{
    if command -v nvim >/dev/null 2>&1; then
        eccho "Neovim yuklu"
    else
        eccho "Neovim bulunamadi... Yukleniyor."
        wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
        tar -xf nvim-linux64.tar.gz
        mv nvim-linux64 ${HOME}
        sudo ln -s ${HOME}/nvim-linux64/bin/nvim $BIN_PATH
        eccho "Neovim yuklendi."
        rm -rf nvim-linux64.tar.gz
    fi
}

install_helix ()
{
    if command -v hx >/dev/null 2>&1; then
        eccho "Helix Yuklu"
    else
        eccho "Helix bulunamadi... Yukleniyor."
        wget https://github.com/helix-editor/helix/releases/download/23.10/helix-23.10-x86_64-linux.tar.xz
        tar -xf helix-23.10-x86_64-linux.tar.xz 
        mv helix-23.10-x86_64-linux ${HOME}/helix
        sudo ln -s ${HOME}/helix/hx $BIN_PATH
        eccho "Helix yuklendi."
        rm -rf helix-23.10-x86_64-linux.tar.xz
    fi
}

install_deb ()
{
    if command -v $1 >/dev/null 2>&1; then
        eccho "$1 zaten yuklu :)"
    else
        eccho "$1 bulunamadi... Yukleniyor"
        wget $2
        sudo dpkg -i $3
        rm $3
    fi
}

install_zip () 
{

    if command -v $1 >/dev/null 2>&1; then
        eccho "$1 zaten yuklu :)"
    else
        eccho "$1 bulunamadi... Yukleniyor"
        wget $2
        unzip $3
        chmod +x $1
        mv $1 $BIN_PATH
        rm $3
    fi
}

install_rust_and_dependencies ()
{
    if command -v cargo >/dev/null 2>&1; then
        eccho "Rust zaten yuklu"
    else
        eccho "Rust bulunamadi... Yukleniyor"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
    source "$HOME/.cargo/env"
    source ~/.bashrc

    if ! command -v cargo >/dev/null 2>&1; then
        eccho "Rust yuklu ama source lanmamis..."
        echo 'export PATH="$PATH:/home/$USER/.cargo/bin"' >> ~/.bashrc
        source ~/.bashrc
    fi


    if command -v node >/dev/null 2>&1; then
        eccho "Nodejs zaten yuklu"
    else
        install_zip fnm https://github.com/Schniz/fnm/releases/download/v1.35.0/fnm-linux.zip fnm-linux.zip
        . ~/.bashrc
        fnm install 18.16.1
        . ~/.bashrc
    fi
}

install_zellij ()
{
    if command -v zellij >/dev/null 2>&1; then
        eccho "zellij yuklu"
    else
        eccho "zellij bulunamadi... Yukleniyor."
        wget https://github.com/zellij-org/zellij/releases/download/v0.37.2/zellij-x86_64-unknown-linux-musl.tar.gz
        tar -xf zellij-x86_64-unknown-linux-musl.tar.gz
        mv zellij $BIN_PATH
        rm -rf zellij-x86_64-unknown-linux-musl.tar.gz
        eccho "zellij yuklendi."
    fi
}

install_starship ()
{
    curl -sS https://starship.rs/install.sh | sh
}

setup()
{ 
    install_with_apt stow
    # rm ~/.bashrc
    # stow */
}

if [ ! -d "$BIN_PATH" ];
then
	eccho "$BIN_PATH klasoru bulunamadi..."
    mkdir -p $BIN_PATH
else
	eccho "$BIN_PATH klasoru bulundu :)"
fi

if [[ ":$PATH:" == *":$BIN_PATH:"* ]]; then
  echo "Your path is correctly set"
else
  echo "Your path is missing ~/.local/bin, you might want to add it."
  export PATH=$PATH:~/.local/bin
fi


install_with_apt wget
install_with_apt unzip
install_rust_and_dependencies
install_deb rg https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb ripgrep_13.0.0_amd64.deb
install_with_tar fd https://github.com/sharkdp/fd/releases/download/v8.7.0/fd-v8.7.0-x86_64-unknown-linux-gnu.tar.gz fd-v8.7.0-x86_64-unknown-linux-gnu.tar.gz fd-v8.7.0-x86_64-unknown-linux-gnu
install_zellij
install_neovim
install_helix
install_starship
setup
