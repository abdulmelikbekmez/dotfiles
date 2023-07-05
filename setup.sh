install_neovim ()
{
    if command -v nvim.appimage >/dev/null 2>&1; then
        echo "Neovim yuklu"
    else
        echo "Neovim bulunamadi... Yukleniyor."
        wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
        chmod +x nvim.appimage
        sudo ln -s $PWD/nvim.appimage /usr/local/bin/
        echo "Neovim yuklendi."
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
    . ~/.bashrc

    cargo install fd-find
    cargo install ripgrep

    if command -v node >/dev/null 2>&1; then
        echo "Nodejs zaten yuklu"
    else
        cargo install fnm
        . ~/.bashrc
        fnm install 18.16.1
        . ~/.bashrc
    fi
}


setup()
{ 
    if ! command -v stow >/dev/null 2>&1; then
        echo "Stow bulunamadi.."
        sudo apt install stow
        echo "stow yuklendi.."
    fi
    rm ~/.bashrc
    stow */
}


install_neovim
install_rust_and_dependencies
setup
