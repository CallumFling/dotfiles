dotfile_dir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Define the platform-specific provision functions
provision_darwin()
{
    echo "Setting up for macOS"
    # Check if we have brew installed
    if test ! $(which brew); then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Update the brew lists and install from the brewfile
    brew update
    brew tap homebrew/bundle
    brew bundle

    # Move any existing .zshrc and symlink the new one
    mv $HOME/.zshrc $HOME/.zshrc.orig
    ln -s .zshrc $HOME/.zshrc

    # Update the paths to this dotfile dir. in all the files
    # https://stackoverflow.com/questions/4247068/sed-command-with-i-option-failing-on-mac-but-works-on-linux#4247319
    find . -name ".zshrc" -exec sed -i '' "s|dotdir|$dotfile_dir|g" {} \;
}

provision_linux()
{
    echo "Setting up for Linux"
    sudo apt update
    sudo apt -y install zsh
}

# Detect the platform we're currently on and begin setting it up
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   provision_linux
elif [[ "$unamestr" == 'Darwin' ]]; then
   provision_darwin
else
    echo "Unsupported operating system!"
    exit
fi