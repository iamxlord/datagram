#!/bin/bash

# === Colors and Styling ===
BOLD='\033[1m'          # Bold text
HGREEN='\033[1;32m'     # Bright green (Hacker Green)
GREEN='\033[0;32m'      # Regular Green
RED='\033[0;31m'        # Red critical
YELLOW='\033[0;33m'     # Yellow warnings
RESET='\033[0m'         # Reset

# === Configuration and Paths ===
CONFIG_DIR="$HOME/.datagram_cli"
API_KEY_FILE="$CONFIG_DIR/api_key.conf"
LOG_FILE="datagram.log" # Log file for the Datagram node's output

# === Functions ===

# --- Banner ---
MrXintro() {
    echo ""

    echo -e "${BOLD}${HGREEN}"    
    echo "███╗   ███╗ ██████╗         ██╗   ██╗"
    echo "████╗ ████║██╔══██╗       ╚██╗██╔╝"
    echo "██╔████╔██║██████╔╝        ╚███╔╝ "
    echo "██║╚██╔╝██║██╔══██╗        ██╔██╗ "
    echo "██║ ╚═╝  ██║██║    ██║██╗ ██ ╔╝██╗"
    echo "╚═╝        ╚═╝ ╚═╝   ╚═╝╚═╝  ╚═╝  ╚═╝"
    echo "                    Github: github.com/iamxlord"
    echo -e "                 Twitter: @iamxlord${RESET}"
    echo ""
}

# --- Check Dependencies ---
check_dependencies() {
    echo -e "${HGREEN}Checking system dependencies...${RESET}"
    if ! command -v wget &> /dev/null; then
        echo -e "${RED}ERROR: 'wget' is not installed. Please install it to continue.${RESET}"
        echo -e "${YELLOW}On Debian/Ubuntu: sudo apt install wget${RESET}"
        echo -e "${YELLOW}On Fedora/RHEL: sudo dnf install wget${RESET}"
        echo -e "${YELLOW}On Arch Linux: sudo pacman -S wget${RESET}"
        exit 1
    fi
    echo -e "${GREEN}✅ All required dependencies are installed.${RESET}"
}

# --- Download Binary If Missing ---
download_binary() {
    if [ ! -f datagram ]; then
        echo -e "${HGREEN}⬇️  Datagram CLI not found. Attempting to download...${RESET}"
        wget_output=$(wget -nv https://github.com/Datagram-Group/datagram-cli-release/releases/latest/download/datagram-cli-x86_64-linux -O datagram 2>&1)
        wget_status=$?

        if [ $wget_status -eq 0 ]; then
            chmod +x datagram
            echo -e "${GREEN}✅ Datagram CLI downloaded and made executable.${RESET}"
        else
            echo -e "${RED}❌ Failed to download Datagram CLI.${RESET}"
            echo -e "${YELLOW}Wget output:${RESET}"
            echo -e "${YELLOW}$wget_output${RESET}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ Datagram CLI binary found.${RESET}"
    fi
}

# --- Manage API Key ---
get_api_key() {
    mkdir -p "$CONFIG_DIR" # Ensure config directory exists
    if [ -f "$API_KEY_FILE" ]; then
        API_KEY=$(cat "$API_KEY_FILE")
        echo -e "${GREEN}🔑 API key retrieved from storage.${RESET}"
        read -p "Would you like to use this key or enter a new one? (u/n): " choice
        case "$choice" in
            n|N)
                read -p "🔑 Enter your NEW API key: " NEW_API_KEY
                API_KEY="$NEW_API_KEY"
                echo "$API_KEY" > "$API_KEY_FILE"
                echo -e "${GREEN}API key updated and saved.${RESET}"
                ;;
            u|U)
                echo -e "${HGREEN}Using stored API key.${RESET}"
                ;;
            *)
                echo -e "${YELLOW}Invalid choice. Using stored API key.${RESET}"
                ;;
        esac
    else
        read -p "🔑 Enter your API key: " API_KEY
        echo "$API_KEY" > "$API_KEY_FILE"
        echo -e "${GREEN}API key saved for future use.${RESET}"
    fi

    if [ -z "$API_KEY" ]; then
        echo -e "${RED}ERROR: API key cannot be empty. Exiting.${RESET}"
        exit 1
    fi
}

# --- Start Node ---
start_node() {
    MrXintro
    check_dependencies
    download_binary
    get_api_key

    echo -e "${HGREEN}🚀 Starting Datagram node...${RESET}"
    # Clear previous log before starting
    > "$LOG_FILE"
    ./datagram run -- -key "$API_KEY" > "$LOG_FILE" 2>&1 &
    local pid=$! # Get the PID of the background process
    echo -e "${HGREEN}Node process started with PID: ${pid}. Logging output to ${LOG_FILE}${RESET}"
    sleep 3 # Give it a moment to initialize

    if ps -p "$pid" > /dev/null; then
        echo -e "${GREEN}✅ Datagram node appears to be running. Check ${LOG_FILE} for details.${RESET}"
        echo -e "${HGREEN}Last 5 lines of ${LOG_FILE}:${RESET}"
        tail -n 5 "$LOG_FILE"
    else
        echo -e "${RED}❌ Failed to start Datagram node.${RESET}"
        echo -e "${RED}Check ${LOG_FILE} for errors.${RESET}"
        tail -n 10 "$LOG_FILE" # Show more log lines on failure
        exit 1
    fi
}

# --- Stop Node ---
stop_node() {
    echo -e "${HGREEN}Attempting to stop Datagram node...${RESET}"
    if pgrep -f "datagram run" > /dev/null; then
        pkill -f "datagram run"
        # Give it a moment to terminate
        sleep 2
        if ! pgrep -f "datagram run" > /dev/null; then
            echo -e "${GREEN}🛑 Datagram node stopped successfully.${RESET}"
        else
            echo -e "${RED}⚠️  Datagram node might still be running. Manual intervention may be needed.${RESET}"
        fi
    else
        echo -e "${YELLOW}⚠️  Datagram node is not running.${RESET}"
    fi
}

# --- Check Status ---
status_node() {
    echo -e "${HGREEN}Checking Datagram node status...${RESET}"
    if pgrep -f "datagram run" > /dev/null; then
        echo -e "${GREEN}✅ Datagram node is running.${RESET}"
        echo -e "${HGREEN}Last 10 lines of ${LOG_FILE}:${RESET}"
        if [ -f "$LOG_FILE" ]; then
            tail -n 10 "$LOG_FILE"
        else
            echo -e "${YELLOW}Log file ($LOG_FILE) not found.${RESET}"
        fi
    else
        echo -e "${RED}❌ Datagram node is NOT running.${RESET}"
        if [ -f "$LOG_FILE" ]; then
            echo -e "${HGREEN}Last 10 lines of ${LOG_FILE} for potential errors:${RESET}"
            tail -n 10 "$LOG_FILE"
        else
            echo -e "${YELLOW}Log file ($LOG_FILE) not found.${RESET}"
        fi
    fi
}

# --- Restart Node ---
restart_node() {
    echo -e "${HGREEN}Initiating Datagram node restart...${RESET}"
    stop_node
    sleep 3 # Give more time between stop and start
    start_node
}

# --- Help ---
show_help() {
    echo ""
    echo -e "${BOLD}Usage:${RESET} ./datagram.sh {start|stop|status|restart|help}"
    echo ""
    echo -e "${BOLD}Commands:${RESET}"
    echo "  start     Start the datagram node. Will prompt for API key if not stored."
    echo "  stop      Stop the running node."
    echo "  status    Check if node is running and show recent logs."
    echo "  restart   Stop and then start the node."
    echo "  help      Show this help message."
    echo ""
}

# === Main ===
case "$1" in
    start) start_node ;;
    stop) stop_node ;;
    status) status_node ;;
    restart) restart_node ;;
    help) show_help ;;
    *) show_help ;;
esac
