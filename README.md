# struct-command

**struct** is a custom shell utility designed to display the complete file structure of a directory along with the contents of each file, while giving you control over what to include or exclude. Useful for prompt dumping, code reviews, and project inspection.

# Setup `struct` Command

Run one of the following commands to install and configure the `struct` command for Bash:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/Albator81/struct-command/main/setup.sh)
```

```bash
bash <(wget -qO- https://raw.githubusercontent.com/Albator81/struct-command/main/setup.sh)
```

Or for Zsh users, run:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/Albator81/struct-command/main/setupZsh.sh)
```

```bash
bash <(wget -qO- https://raw.githubusercontent.com/Albator81/struct-command/main/setupZsh.sh)
```

This single block sets up:

* The `struct` script
* Executable permissions
* `.bashrc` or `.zshrc` PATH updates
* Initial `.struct_exclude` file

> **Note:** After installation, run `source ~/.bashrc` (for Bash) or `source ~/.zshrc` (for Zsh) to immediately start using `struct`. Alternatively, restart your terminal.

After this, you can immediately run:

```bash
struct -h
struct -edit
struct -e node_modules -e dist --save-exclude
struct --show-excludes
```
