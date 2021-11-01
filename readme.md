# dotfiles

### Things to backup

- project files
- ssh keys, aws, kubectl, k9s, gradle configurations
- docker images, database connections

### Recovery flow

- Copy files from the backup, including ssh keys

- Make git to use ssh
```bash
$ eval "$(ssh-agent -s)"
$ ssh-add -K ~/.ssh/id_rsa
```

- Clone the repo & run the script
```bash
$ git clone git@github.com:daekun0920/dotfiles.git
$ bash bootstrap.sh
```