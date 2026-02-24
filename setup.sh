# 1️⃣ Create directory for personal scripts
mkdir -p ~/.local/bin

# 2️⃣ Create the struct script
cat > ~/.local/bin/struct << 'EOF'
#!/bin/bash
# struct - show project structure with optional excludes

SCRIPT_FILE="${HOME}/.struct_exclude"
touch "$SCRIPT_FILE"

EXCLUDE=()
EDIT=0
SHOW_HELP=0
SHOW_EXCLUDES=0
SAVE_EXCLUDE=0
ADD_EXCLUDE=()

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
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ $SHOW_HELP -eq 1 ]]; then
    cat <<HELP
struct - Show project structure with content

Usage:
  struct                   Show all files and content
  struct -edit              Edit the struct exclude file
  struct -e <path|file>     Temporarily exclude path or file
  struct --save-exclude     Permanently save the added excludes
  struct --show-excludes    Show saved excludes
  struct -h, --help         Show this help
HELP
    exit 0
fi

if [[ $EDIT -eq 1 ]]; then
    ${EDITOR:-nano} "$SCRIPT_FILE"
    exit 0
fi

if [[ $SHOW_EXCLUDES -eq 1 ]]; then
    echo "Saved excludes in $SCRIPT_FILE:"
    cat "$SCRIPT_FILE"
    exit 0
fi

# merge saved excludes
if [[ -f "$SCRIPT_FILE" ]]; then
    while IFS= read -r line; do
        [[ -n "$line" ]] && EXCLUDE+=("$line")
    done < "$SCRIPT_FILE"
fi

# add temporary excludes
for ex in "${ADD_EXCLUDE[@]}"; do
    EXCLUDE+=("$ex")
done

# save excludes permanently if requested
if [[ $SAVE_EXCLUDE -eq 1 ]]; then
    for ex in "${ADD_EXCLUDE[@]}"; do
        grep -qxF "$ex" "$SCRIPT_FILE" || echo "$ex" >> "$SCRIPT_FILE"
    done
fi

# build find parameters
FIND_EXCLUDE=()
for ex in "${EXCLUDE[@]}"; do
    FIND_EXCLUDE+=( -not -path "*$ex*" )
done

# run find command
find . -type f "${FIND_EXCLUDE[@]}" -exec sh -c 'echo "=== $1 ==="; cat "$1"' _ {} \;
EOF

# 3️⃣ Make the script executable
chmod +x ~/.local/bin/struct

# 4️⃣ Add alias and PATH to .bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo "alias struct='struct'" >> ~/.bashrc

# 5️⃣ Reload .bashrc to apply changes
source ~/.bashrc
