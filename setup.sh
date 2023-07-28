install_cargo_dep()
{
    if ! command -v $1 >/dev/null 2>&1; then
        echo "$2 bulunamadi..."
        cargo install $2
    else
        echo "$2 zaten yuklu"
    fi
}

install_with_apt()
{
    if ! command -v $1 >/dev/null 2>&1; then
        echo "$1 bulunamadi..."
        sudo apt install $1
    else
        echo "$1 zaten yuklu :)"
    fi
}
install_neovim ()
{
    if command -v nvim >/dev/null 2>&1; then
        echo "Neovim yuklu"
    else
        echo "Neovim bulunamadi... Yukleniyor."
        wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
        tar -xf nvim-linux64.tar.gz
        sudo ln -s $PWD/nvim-linux64/bin/nvim /usr/local/bin/
        echo "Neovim yuklendi."
        rm -rf nvim-linux64.tar.gz
    fi
}

install_rust_and_dependencies ()
{
    if command -v cargo >/dev/null 2>&1; then
        echo "Rust zaten yuklu"
    else
        echo "Rust bulunamadi... Yukleniyor"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
    source "$HOME/.cargo/env"
    source ~/.bashrc

    if ! command -v cargo >/dev/null 2>&1; then
        echo "Rust yuklu ama source lanmamis..."
        echo 'export PATH="$PATH:/home/$USER/.cargo/bin"' >> ~/.bashrc
        source ~/.bashrc
    fi

    install_cargo_dep fd fd-find
    install_cargo_dep rg ripgrep

    if command -v node >/dev/null 2>&1; then
        echo "Nodejs zaten yuklu"
    else
        install_cargo_dep fnm
        . ~/.bashrc
        fnm install 18.16.1
        . ~/.bashrc
    fi
}

setup()
{ 
    install_with_apt stow
    rm ~/.bashrc
    stow */
}

install_with_apt wget
install_rust_and_dependencies
setup
install_neovim
