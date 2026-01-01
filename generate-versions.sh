#!/bin/bash

# Script to generate a versions dump of installed Homebrew packages
# Usage: ./generate-versions.sh

OUTPUT_FILE="VERSIONS.md"
BREWFILE="Brewfile"

echo "# Installed Package Versions Dump" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Extract package names from Brewfile (including full paths for tapped packages)
BREW_PACKAGES=$(grep -E '^brew "' "$BREWFILE" | sed 's/brew "\([^"]*\)"/\1/' | sort -u)
CASK_PACKAGES=$(grep -E '^cask "' "$BREWFILE" | sed 's/cask "\([^"]*\)"/\1/' | sort -u)

echo "## Homebrew Formulas (CLI Tools)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Package | Installed Version |" >> "$OUTPUT_FILE"
echo "|---------|-------------------|" >> "$OUTPUT_FILE"

for pkg_full in $BREW_PACKAGES; do
    # Extract just the package name (last part after /)
    if [[ "$pkg_full" == *"/"* ]]; then
        pkg_name=$(echo "$pkg_full" | awk -F'/' '{print $NF}')
    else
        pkg_name="$pkg_full"
    fi
    
    # Check if package is installed (try both full name and short name)
    installed=false
    if brew list "$pkg_full" &>/dev/null 2>&1; then
        installed=true
        check_name="$pkg_full"
    elif brew list "$pkg_name" &>/dev/null 2>&1; then
        installed=true
        check_name="$pkg_name"
    fi
    
    if [ "$installed" = true ]; then
        version=$(brew info --json=v2 "$check_name" 2>/dev/null | jq -r '.formulae[0].installed[0].version // "unknown"' 2>/dev/null)
        if [ "$version" != "null" ] && [ "$version" != "" ] && [ "$version" != "unknown" ]; then
            echo "| $pkg_full | $version |" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "## Homebrew Casks (GUI Applications)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Package | Installed Version |" >> "$OUTPUT_FILE"
echo "|---------|-------------------|" >> "$OUTPUT_FILE"

for cask in $CASK_PACKAGES; do
    # Check if cask is installed
    if brew list --cask "$cask" &>/dev/null; then
        version=$(brew info --cask --json=v2 "$cask" 2>/dev/null | jq -r '.casks[0].installed // "unknown"' 2>/dev/null)
        if [ "$version" != "null" ] && [ "$version" != "" ]; then
            echo "| $cask | $version |" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "## Notes" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "- Packages listed in Brewfile but not shown above are not currently installed" >> "$OUTPUT_FILE"
echo "- Run \`brew bundle install\` to install missing packages" >> "$OUTPUT_FILE"

echo "Versions dump generated successfully in $OUTPUT_FILE"

