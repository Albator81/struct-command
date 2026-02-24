# 1️⃣ Create directory for personal scripts

mkdir -p ~/.local/bin

# 2️⃣ Create the struct script

cat > ~/.local/bin/struct << 'EOF'
#!/bin/bash

# struct - Display directory file structure and contents with optional excludes and filters

# Prerequisites: Bash shell, optional $EDITOR for editing excludes

SCRIPT_FILE="${HOME}/.struct_exclude"
touch "$SCRIPT_FILE"

# Ensure default excludes

grep -qxF ".git/" "$SCRIPT_FILE" || echo ".git/" >> "$SCRIPT_FILE"

EXCLUDE=() FILTERS=() EDIT=0 SHOW_HELP=0 SHOW_EXCLUDES=0 SAVE_EXCLUDE=0 ADD_EXCLUDE=() LIST_ONLY=0 HEADER_FORMAT="# $file"

# Parse command-line arguments

while [[ $# -gt 0 ]]; do
case $1 in
-edit)
EDIT=1
shift
;;
-h|--help)
SHOW_HELP=1
shift
;;
-e|--exclude)
shift
[[ -n "$1" ]] && ADD_EXCLUDE+=("$1")
shift
;;
--save-exclude)
SAVE_EXCLUDE=1
shift
;;
--show-excludes)
SHOW_EXCLUDES=1
shift
;;
-f|--filter)
shift
[[ -n "$1" ]] && FILTERS+=("$1")
shift
;;
-l|--list-only)
LIST_ONLY=1
shift
;;
--header)
shift
[[ -n "$1" ]] && HEADER_FORMAT="$1"
shift
;;
*)
echo "Unknown option: $1"
exit 1
;;
esac
done

# Warn user if header format does not include $file

if [[ "$HEADER_FORMAT" != *'$file'* ]]; then
echo "Warning: header format does not include $file, filename will not appear" >&2
fi

# Show help text

if [[ $SHOW_HELP -eq 1 ]]; then
cat <<HELP
struct - Show project structure with content

Usage:
struct                     Show all files and content (excluding saved excludes)
struct -edit                Edit the struct exclude file
struct -e <path|file>      Temporarily exclude path or file
struct --save-exclude       Permanently save the added excludes
struct --show-excludes      Show saved excludes
struct -f <pattern>         Only list files matching pattern (supports multiple -f options, e.g., *.py) (supports multiple -f options, e.g., *.py)
struct -l, --list-only      Only list matching files without displaying contents
struct --header     Customize file header (use $file to include filename, e.g., "# $file")
struct -h, --help           Show this help
HELP
exit 0
fi

# Edit the exclude file

if [[ $EDIT -eq 1 ]]; then
${EDITOR:-nano} "$SCRIPT_FILE"
exit 0
fi

# Show saved excludes

if [[ $SHOW_EXCLUDES -eq 1 ]]; then
echo "Saved excludes in $SCRIPT_FILE:"
cat "$SCRIPT_FILE"
exit 0
fi

# Merge saved excludes

if [[ -f "$SCRIPT_FILE" ]]; then
while IFS= read -r line; do
[[ -n "$line" ]] && EXCLUDE+=("$line")
done < "$SCRIPT_FILE"
fi

# Add temporary excludes

for ex in "${ADD_EXCLUDE[@]}"; do
EXCLUDE+=("$ex")
done

# Save excludes permanently if requested

if [[ $SAVE_EXCLUDE -eq 1 ]]; then
for ex in "${ADD_EXCLUDE[@]}"; do
grep -qxF "$ex" "$SCRIPT_FILE" || echo "$ex" >> "$SCRIPT_FILE"
done
fi

# Build find exclude parameters

FIND_EXCLUDE=()
for ex in "${EXCLUDE[@]}"; do
FIND_EXCLUDE+=( -not -path "*$ex*" )
done

# Use multiple filters or default to '*' if none

if [[ ${#FILTERS[@]} -eq 0 ]]; then
FILTERS=("*")
fi

# Execute find command safely handling filenames with spaces

for pattern in "${FILTERS[@]}"; do
if [[ $LIST_ONLY -eq 1 ]]; then
find . -type f -name "$pattern" "${FIND_EXCLUDE[@]}" -print0 | while IFS= read -r -d '' file; do
echo "$file"
done
else
find . -type f -name "$pattern" "${FIND_EXCLUDE[@]}" -print0 | while IFS= read -r -d '' file; do
header="${HEADER_FORMAT//$file/$file}"
echo "$header"
cat "$file"
done
fi
done
EOF

# 3️⃣ Make the script executable

chmod +x ~/.local/bin/struct

# 4️⃣ Add alias and PATH to .bashrc if not already present

grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# 5️⃣ Reload .bashrc

source ~/.bashrc
