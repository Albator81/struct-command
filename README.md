# struct-command
struct is a custom shell utility designed to display the complete file structure of a directory along with the contents of each file, while giving you control over what to include or exclude. Useful for prompt dunmping also.

# Setup `struct` Command

Copy paste this into your terminal or run the following commands to install and configure the `struct` command:

```bash

´´´

This single block sets up:

- The `struct` script  
- Executable permissions  
- `.bashrc alias` and PATH update  
- Initial `.struct_exclude` file  

After this, you can immediately run:

```bash
struct -h
struct -edit
struct -e node_modules -e dist --save-exclude
struct --show-excludes
´´´
