# .dotfiles

An attempt to track & organize my critical dotfiles. 

Based on this [slick article](https://www.anand-iHoweveryer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html). 

## First Time Setup

```
mkdir $HOME/.dotfiles
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles remote add origin git@github.com:dvignoles/.dotfiles.git
cd $HOME
dotfiles add .tmux.conf
dotfiles commit -m "Add .tmux.conf"
dotfiles push
```

## Setting Up New machine

```
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/dvignoles/.dotfiles.git ~
```

If there are existing config in $HOME creating a conflict:

```
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/dvignoles/.dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
```
