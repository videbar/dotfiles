# My Dotfiles

The configuration files and folders (dotfiles) are stored following the system
described [here](https://www.atlassian.com/git/tutorials/dotfiles) and
[here](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/).

The files are stored in a repository with its working tree in `$HOME`, in a way
that no symlinks are required. The repository can be managed using the command
`dotfiles`, which is an alias of the `git` command that handles this repository.

The `dotfiles` command allows to add new configuration files and directories:
```bash
dotfiles add <filename>
```
commit changes:
```bash
dotfiles commit
```
and perform other normal git commands:
```bash
dotfiles status
dotfiles push
```

To apply the configuration to a new system do the following:

1. Clone the repository, using ssh if you are me:
    ```bash
    git clone --bare git@github.com:videbar/dotfiles.git $HOME/.dotfiles
    ```
    or https otherwise:
    ```bash
    git clone --bare https://github.com/videbar/dotfiles.git $HOME/.dotfiles
    ```

2. Define the alias:
    ```bash
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    ```
    and change the repository configuration (this makes sure that the untracked
    files in your home directory are not showed when calling `dotfiles status`
    and similar commands):
    ```bash
    dotfiles config --local status.showUntrackedFiles no
    ```

3. Apply the changes stored in the repository:
    ```bash
    dotfiles checkout
    ```
    This will also checkout the `.bashrc` file, that contains a permanent
    alias definition.

