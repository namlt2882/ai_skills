#!/bin/bash

################################################################################
# install-skills.sh
#
# A comprehensive shell script to install skills from the current directory
# into Roo Code (Claude Code), OpenCode, or OpenClaw.
#
# Usage:
#   ./install-skills.sh [options]
#
# Options:
#   -h, --help              Show this help message
#   -t, --target <system>   Target system: roocode, opencode, or openclaw
#   -a, --all               Install all available skills
#   -s, --skills <list>     Comma-separated list of skills to install
#
# Examples:
#   ./install-skills.sh                    # Interactive mode
#   ./install-skills.sh -t roocode -a      # Install all to Roo Code
#   ./install-skills.sh -t opencode -s api-design,coding-standards
#   ./install-skills.sh -t openclaw -a     # Install all to OpenClaw
################################################################################

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target paths
ROOCODE_SKILLS_DIR="$HOME/.roo/skills"
OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
OPENCODE_CONFIG_FILE="$OPENCODE_CONFIG_DIR/opencode.json"
OPENCLAW_SKILLS_DIR="$HOME/.openclaw/workspace/skills/"

# Available skills (detected from current directory)
AVAILABLE_SKILLS=()

################################################################################
# Functions
################################################################################

# Print colored message
print_color() {
    local color="$1"
    shift
    echo -e "${color}$*${NC}"
}

# Print success message
print_success() {
    print_color "$GREEN" "✓ $*"
}

# Print error message
print_error() {
    print_color "$RED" "✗ $*" >&2
}

# Print warning message
print_warning() {
    print_color "$YELLOW" "⚠ $*"
}

# Print info message
print_info() {
    print_color "$CYAN" "ℹ $*"
}

# Print header
print_header() {
    echo ""
    print_color "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$BLUE" "  $*"
    print_color "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Display help message
show_help() {
    cat << EOF
$(print_header "Skills Installation Script")

$(print_color "$CYAN" "USAGE")
    ./install-skills.sh [options]

$(print_color "$CYAN" "OPTIONS")
    -h, --help              Show this help message
    -t, --target <system>   Target system: roocode, opencode, or openclaw
    -a, --all               Install all available skills
    -s, --skills <list>     Comma-separated list of skills to install

$(print_color "$CYAN" "EXAMPLES")
    ./install-skills.sh                    # Interactive mode
    ./install-skills.sh -t roocode -a      # Install all to Roo Code
    ./install-skills.sh -t opencode -s api-design,coding-standards
    ./install-skills.sh -t openclaw -a     # Install all to OpenClaw

$(print_color "$CYAN" "TARGET SYSTEMS")
    roocode      Install skills to Roo Code (Claude Code)
                 Skills are copied to ~/.roo/skills/

    opencode     Configure skills for OpenCode
                 Skills directory path is added to ~/.config/opencode/opencode.json

    openclaw     Install skills to OpenClaw
                 Skills are copied to ~/.openclaw/skills/

$(print_color "$CYAN" "AVAILABLE SKILLS")
    The script automatically detects skill directories in the current location.
    Each skill must contain a SKILL.md file.

EOF
}

# Detect available skills in current directory
detect_skills() {
    AVAILABLE_SKILLS=()
    for dir in "$SCRIPT_DIR"/*/; do
        if [[ -d "$dir" ]]; then
            skill_name=$(basename "$dir")
            if [[ -f "$dir/SKILL.md" ]]; then
                AVAILABLE_SKILLS+=("$skill_name")
            fi
        fi
    done
}

# Display available skills
display_skills() {
    print_info "Available skills in current directory:" >&2
    echo "" >&2
    for i in "${!AVAILABLE_SKILLS[@]}"; do
        printf "  %2d. %s\n" "$((i + 1))" "${AVAILABLE_SKILLS[$i]}" >&2
    done
    echo "" >&2
}

# Check if a skill exists
skill_exists() {
    local skill="$1"
    for s in "${AVAILABLE_SKILLS[@]}"; do
        if [[ "$s" == "$skill" ]]; then
            return 0
        fi
    done
    return 1
}

# Create directory if it doesn't exist
ensure_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        print_info "Creating directory: $dir"
        mkdir -p "$dir"
        if [[ $? -eq 0 ]]; then
            print_success "Directory created: $dir"
            return 0
        else
            print_error "Failed to create directory: $dir"
            return 1
        fi
    fi
    return 0
}

# Install skills to Roo Code
install_to_roocode() {
    local skills=("$@")
    local skill_count=${#skills[@]}

    print_header "Installing to Roo Code (Claude Code)"

    # Ensure Roo Code skills directory exists
    if ! ensure_directory "$ROOCODE_SKILLS_DIR"; then
        return 1
    fi

    # Install each skill
    local success_count=0
    local failed_count=0

    for skill in "${skills[@]}"; do
        local source_dir="$SCRIPT_DIR/$skill"
        local target_dir="$ROOCODE_SKILLS_DIR/$skill"

        print_info "Installing: $skill"

        # Check if source exists
        if [[ ! -d "$source_dir" ]]; then
            print_error "Source directory not found: $source_dir"
            ((failed_count+=1))
            continue
        fi

        # Remove existing skill directory if it exists
        if [[ -d "$target_dir" ]]; then
            print_warning "Removing existing skill: $target_dir"
            rm -rf "$target_dir"
        fi

        # Copy skill directory
        if cp -r "$source_dir" "$target_dir"; then
            print_success "Installed: $skill"
            ((success_count+=1))
        else
            print_error "Failed to install: $skill"
            ((failed_count+=1))
        fi
    done

    # Summary
    echo ""
    print_header "Installation Summary"
    echo "  Total skills: $skill_count"
    print_success "  Successful: $success_count"
    if [[ $failed_count -gt 0 ]]; then
        print_error "  Failed: $failed_count"
    fi
    echo ""

    return $failed_count
}

# Install skills to OpenCode
install_to_opencode() {
    local skills=("$@")
    local skill_count=${#skills[@]}

    print_header "Configuring for OpenCode"

    # Ensure OpenCode config directory exists
    if ! ensure_directory "$OPENCODE_CONFIG_DIR"; then
        return 1
    fi

    # Validate that all requested skills exist
    for skill in "${skills[@]}"; do
        if ! skill_exists "$skill"; then
            print_error "Skill not found: $skill"
            return 1
        fi
    done

    # Create or update opencode.json
    local config_content=""
    local needs_update=false

    if [[ -f "$OPENCODE_CONFIG_FILE" ]]; then
        print_info "Reading existing configuration..."
        config_content=$(cat "$OPENCODE_CONFIG_FILE")
    fi

    # Check if skills directory is already configured
    if echo "$config_content" | grep -q "\"skillsDir\""; then
        if echo "$config_content" | grep -q "\"$SCRIPT_DIR\""; then
            print_success "Skills directory already configured: $SCRIPT_DIR"
        else
            print_warning "Updating skills directory in configuration..."
            # Replace existing skillsDir
            config_content=$(echo "$config_content" | sed "s|\"skillsDir\".*|\"skillsDir\": \"$SCRIPT_DIR\",|")
            needs_update=true
        fi
    else
        # Add skillsDir to config
        if [[ -n "$config_content" ]]; then
            # Insert skillsDir before closing brace
            config_content=$(echo "$config_content" | sed 's/}/,  "skillsDir": "'"$SCRIPT_DIR"'"/')
        else
            # Create new config
            config_content="{\n  \"skillsDir\": \"$SCRIPT_DIR\"\n}"
        fi
        needs_update=true
    fi

    # Write configuration if needed
    if [[ "$needs_update" == true ]]; then
        print_info "Writing configuration to: $OPENCODE_CONFIG_FILE"
        echo "$config_content" > "$OPENCODE_CONFIG_FILE"
        if [[ $? -eq 0 ]]; then
            print_success "Configuration updated successfully"
        else
            print_error "Failed to write configuration"
            return 1
        fi
    fi

    # Summary
    echo ""
    print_header "Configuration Summary"
    echo "  Skills directory: $SCRIPT_DIR"
    echo "  Config file: $OPENCODE_CONFIG_FILE"
    echo "  Available skills: $skill_count"
    echo ""
    print_success "OpenCode configuration complete"
    echo ""

    return 0
}

# Install skills to OpenClaw
install_to_openclaw() {
    local skills=("$@")
    local skill_count=${#skills[@]}

    print_header "Installing to OpenClaw"

    # Ensure OpenClaw skills directory exists
    if ! ensure_directory "$OPENCLAW_SKILLS_DIR"; then
        return 1
    fi

    # Install each skill
    local success_count=0
    local failed_count=0

    for skill in "${skills[@]}"; do
        local source_dir="$SCRIPT_DIR/$skill"
        local target_dir="$OPENCLAW_SKILLS_DIR/$skill"

        print_info "Installing: $skill"

        # Check if source exists
        if [[ ! -d "$source_dir" ]]; then
            print_error "Source directory not found: $source_dir"
            ((failed_count+=1))
            continue
        fi

        # Remove existing skill directory if it exists
        if [[ -d "$target_dir" ]]; then
            print_warning "Removing existing skill: $target_dir"
            rm -rf "$target_dir"
        fi

        # Copy skill directory
        if cp -r "$source_dir" "$target_dir"; then
            print_success "Installed: $skill"
            ((success_count+=1))
        else
            print_error "Failed to install: $skill"
            ((failed_count+=1))
        fi
    done

    # Summary
    echo ""
    print_header "Installation Summary"
    echo "  Total skills: $skill_count"
    print_success "  Successful: $success_count"
    if [[ $failed_count -gt 0 ]]; then
        print_error "  Failed: $failed_count"
    fi
    echo ""

    return $failed_count
}

# Interactive target selection
select_target() {
    echo "" >&2
    print_info "What platform do you want to install to?" >&2
    echo "  1. Roo Code (Claude Code) - Skills copied to ~/.roo/skills/" >&2
    echo "  2. OpenCode - Skills directory configured in ~/.config/opencode/opencode.json" >&2
    echo "  3. OpenClaw - Skills copied to ~/.openclaw/skills/" >&2
    echo "" >&2

    while true; do
        read -p "Choose platform: " choice
        case "$choice" in
            1) echo "roocode"; return ;;
            2) echo "opencode"; return ;;
            3) echo "openclaw"; return ;;
            *) print_error "Invalid choice. Please enter 1, 2, or 3." ;;
        esac
    done
}

# Interactive skill selection
select_skills() {
    local selected=()
    local all_selected=false

    echo "" >&2
    print_info "Select skills to install:" >&2
    echo "  a. Install all skills" >&2
    echo "  s. Select specific skills" >&2
    echo "" >&2

    while true; do
        read -p "Enter choice [a : All / s: Select Skill]: " choice
        case "$choice" in
            a|A) all_selected=true; break ;;
            s|S) break ;;
            *) print_error "Invalid choice. Please enter 'a' or 's'." ;;
        esac
    done

    if [[ "$all_selected" == true ]]; then
        selected=("${AVAILABLE_SKILLS[@]}")
    else
        display_skills >&2
        echo "" >&2
        print_info "Enter skill numbers (comma-separated, e.g., 1,3,5):" >&2
        read -p "> " input

        # Parse input
        IFS=',' read -ra numbers <<< "$input"
        for num in "${numbers[@]}"; do
            # Trim whitespace
            num=$(echo "$num" | xargs)
            # Validate number
            if [[ "$num" =~ ^[0-9]+$ ]] && [[ "$num" -ge 1 ]] && [[ "$num" -le "${#AVAILABLE_SKILLS[@]}" ]]; then
                selected+=("${AVAILABLE_SKILLS[$((num - 1))]}")
            else
                print_warning "Invalid number: $num (skipping)"
            fi
        done
    fi

    # Return selected skills to stdout only
    printf '%s\n' "${selected[@]}"
}

################################################################################
# Main
################################################################################

main() {
    local target=""
    local install_all=false
    local specified_skills=()
    local non_interactive=false

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -t|--target)
                target="$2"
                shift 2
                ;;
            -a|--all)
                install_all=true
                shift
                ;;
            -s|--skills)
                IFS=',' read -ra specified_skills <<< "$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use -h or --help for usage information"
                exit 1
                ;;
        esac
    done

    # Detect available skills
    detect_skills

    if [[ ${#AVAILABLE_SKILLS[@]} -eq 0 ]]; then
        print_error "No skills found in current directory"
        print_info "Each skill must be a directory containing a SKILL.md file"
        exit 1
    fi

    # Determine if non-interactive mode
    if [[ -n "$target" ]]; then
        non_interactive=true
    fi

    # Validate target
    if [[ "$non_interactive" == true ]]; then
        case "$target" in
            roocode|opencode|openclaw) ;;
            *)
                print_error "Invalid target: $target"
                print_info "Valid targets: roocode, opencode, openclaw"
                exit 1
                ;;
        esac
    fi

    # Interactive mode
    if [[ "$non_interactive" == false ]]; then
        print_header "Skills Installation Script"
        print_info "Current directory: $SCRIPT_DIR"
        display_skills

        target=$(select_target)
    fi

    # Determine skills to install
    local skills_to_install=()

    if [[ "$non_interactive" == true ]]; then
        if [[ "$install_all" == true ]]; then
            skills_to_install=("${AVAILABLE_SKILLS[@]}")
        elif [[ ${#specified_skills[@]} -gt 0 ]]; then
            for skill in "${specified_skills[@]}"; do
                if skill_exists "$skill"; then
                    skills_to_install+=("$skill")
                else
                    print_error "Skill not found: $skill"
                    exit 1
                fi
            done
        else
            print_error "No skills specified. Use -a for all or -s for specific skills"
            exit 1
        fi
    else
        # Read selected skills into array (compatible with bash 3.2+)
        skills_to_install=()
        while IFS= read -r line; do
            [[ -n "$line" ]] && skills_to_install+=("$line")
        done < <(select_skills)
    fi

    # Validate at least one skill selected
    if [[ ${#skills_to_install[@]} -eq 0 ]]; then
        print_error "No skills selected for installation"
        exit 1
    fi

    # Display selection
    echo ""
    print_info "Target system: $target"
    print_info "Skills to install: ${skills_to_install[*]}"
    echo ""

    # Confirm installation
    if [[ "$non_interactive" == false ]]; then
        read -p "Proceed with installation? [y/N]: " confirm
        if [[ ! "$confirm" =~ ^[yY]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi

    # Perform installation
    case "$target" in
        roocode)
            install_to_roocode "${skills_to_install[@]}"
            ;;
        opencode)
            install_to_opencode "${skills_to_install[@]}"
            ;;
        openclaw)
            install_to_openclaw "${skills_to_install[@]}"
            ;;
    esac

    local exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        print_success "Installation completed successfully!"
        exit 0
    else
        print_error "Installation completed with errors"
        exit 1
    fi
}

# Run main function
main "$@"
