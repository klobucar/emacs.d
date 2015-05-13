# Installation

Clone my emacs.d git repo:

    git clone git@github.com:klobucar/emacs.d.git

Steps to get your emacs.d setup working on OS X (this guide assumes you are using homebrew):

Install cask:

    brew install cask

Install emacs:

    brew install emacs --with-gnutls, --with-librsvg, --with-cocoa
    
If you haven't installed go yet:

    brew install go
    
Create your go code directory:

    mkdir $HOME/go
    
add the following commands to your .*rc:

    export GOPATH=$HOME/go
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOBIN
    
Install gocode and all go tools:

    go get -u github.com/nsf/gocode
    go get -u golang.org/x/tools/cmd/...
    
Now create a symbolic link from your cask installation to your home directory

    ln -s /usr/local/Cellar/cask/<CASK_VERSION> ~/.cask

If you are used to standard emacs keybindings, you may want to comment these lines in your ~/.emacs.d/init.el

    ;; cua mode
    ;; (cua-mode t)
    ;; (setq cua-auto-tabify-rectangles nil
    ;;      cua-keep-region-after-copy t)
    ;; (transient-mark-mode 1)
