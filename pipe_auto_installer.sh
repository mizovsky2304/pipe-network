#!/bin/bash

# Color and icon definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
ICON_TELEGRAM="🚀"
ICON_INSTALL="🛠️"
ICON_LOGS="📄"
ICON_RESTART="🔄"
ICON_STOP="⏹️"
ICON_START="▶️"
ICON_EXIT="❌"
ICON_REMOVE="🗑️"
ICON_VIEW="👀"
ICON_STATUS="🚦"
ICON_STATS="🎛️"
ICON_POINTS="🔢"





# Global variables
PROJCET_NAME="PIPE CDN NETWORK"
VERSION=8
PROJ_DIR="$HOME/pipe"
REF_CODE="416cfa753154d150"



# Draw menu borders and telegram icon
draw_top_border() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════╗${RESET}"
}
draw_middle_border() {
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════════╣${RESET}"
}
draw_bottom_border() {
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════╝${RESET}"
}
print_telegram_icon() {
    echo -e "          ${MAGENTA}${ICON_DISCORD} Join us on Disord!${RESET}"
}
display_ascii() {
    echo -e "${RED}    ____                  _          ____      _            _  _         ${RESET}"    
    echo -e "${GREEN}   / ___|_ __ _   _ _ __ | |_ ___   | __ )  __| | __ _ _ __(_)(_) __ _   ${RESET}" 
    echo -e "${BLUE}  | |   | '__| | | | '_ \\| __/ _ \\  |  _ \\ / _\` |/ _\` | '__| || |/ _\` |  ${RESET}"
    echo -e "${YELLOW}  | |___| |  | |_| | |_) | || (_) | | |_) | (_| | (_| | |  | || | (_| |  ${RESET}"
    echo -e "${MAGENTA}   \\____|_|   \\__, | .__/ \\__\\___/  |____/ \\__,_|\\__,_|_|  |_|/ |\\__,_|  ${RESET}"
    echo -e "${RED}              |___/|_|                                      |__/        ${RESET}"       
}





# Display main menu
show_menu() {
    clear
    draw_top_border
    display_ascii
    draw_middle_border
    print_telegram_icon
    echo -e "    ${BLUE}Join us on Disord: ${YELLOW}https://discord.gg/uJEeSe9E${RESET}"
    draw_middle_border
    echo -e "                ${GREEN}Node Manager for ${PROJCET_NAME}${RESET}"
    echo -e "    ${YELLOW}Please choose an option:${RESET}"
    echo -e "    ${CYAN}1.${RESET} ${ICON_INSTALL}  Install Node"
    echo -e "    ${CYAN}2.${RESET} ${ICON_STATUS}  Check Node Status"
    echo -e "    ${CYAN}3.${RESET} ${ICON_STATS}  Check Node Stats"
    echo -e "    ${CYAN}4.${RESET} ${ICON_POINTS}  Check Node Points"
    echo -e "    ${CYAN}5.${RESET} ${ICON_REMOVE}   Remove Node"
    echo -e "    ${CYAN}0.${RESET} ${ICON_EXIT} Exit"
    
    draw_bottom_border
    echo -ne "${YELLOW}Enter a command number [0-5]:${RESET} "
    read choice
}


# Install node function with registration link and check
install_node() {
    echo 
    echo -e "${GREEN}🛠️  Installing node...${RESET}"
    sudo apt -q update
    cd $HOME
    

    echo
    # Create Project Folder
    if [ ! -d "$PROJ_DIR" ]; then
        mkdir -p "$PROJ_DIR"
        cd "$PROJ_DIR"
        echo -e "${CYAN}🗂️  Folder $PROJ_DIR created.${RESET}"
    else
        echo -e "${RED}🗂️  Folder $PROJ_DIR already exist.${RESET}"
    fi
    echo 
    cd "$PROJ_DIR"
      
    
    

    echo -e "${GREEN}🛡️ Open necessary ports...${RESET}"
    sudo apt update && sudo apt install ufw -y
    sudo ufw allow 8003/tcp
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    echo 


    
    echo -e "${GREEN}🛑 Stopping any process using port 8003...${RESET}"
    PID=$(lsof -ti :8003)
    if [ -n "$PID" ]; then
      echo ""
      echo -e "${YELLOW}❌ Killing process with PID: $PID ${RESET}";
      kill -9 $PID
    else
      echo -e "${YELLOW}✅ No process found using port 8003 ${RESET}"
    fi
    echo 

    
    
    echo -e "${GREEN}🛑 Stopping any DCDND service...${RESET}"
    systemctl stop dcdnd && systemctl disable dcdnd
    echo



    
    echo -e "${CYAN}⬇️   Downloading pop binary...${RESET}"
    curl -L -o pop "https://dl.pipecdn.app/v0.2.8/pop"
    chmod +x pop
    mkdir download_cache
    echo

    
    read -p "Enter the amount of RAM to share (min 4GB): " RAM
    if [ "$RAM" -lt 4 ]; then
      echo "RAM must be at least 4GB. Exiting."
      exit 1
    fi


    read -p "Enter the maximum disk space to use (min 100GB): " DISK
    if [ "$DISK" -lt 100 ]; then
      echo "Disk space must be at least 100GB. Exiting."
      exit 1
    fi


    read -p "Enter your public key [Solana Burner Wallet]: " PUBKEY
    

    echo -e "${GREEN}🔌 Signup with referral for the first time${RESET}"
    sudo ./pop --signup-by-referral-route $REF_CODE
    echo

    echo -e "${GREEN}🔌 Signup with referral for the first time${RESET}"
    sudo ./pop --ram $RAM --max-disk $DISK --cache-dir $PROJ_DIR/download_cache --pubKey $PUBKEY

    

    echo -e "${GREEN}✅ Node installed successfully. Check the logs to confirm signup.${RESET}"
    
    read -p "Press Enter to return to the menu..."
}


# View logs function
view_logs() {
    echo -e "${GREEN}📄 Viewing logs...${RESET}"
    #pm2 logs $NODE_PM2_NAME --lines 50 
    tail -n 50 $LOGFILE
    
    echo
    read -p "Press Enter to return to the menu..."
}


# Check node status
check_node_status() {
    echo -e "${GREEN}🔄 Checking node status...${RESET}"
    cd $PROJ_DIR
    ./pop --status
    
    echo -e "${GREEN}✅ Node status checked.${RESET}"
    read -p "Press Enter to return to the menu..."
}


# Check node stats
check_node_stats() {
    echo -e "${GREEN}$ICON_VIEW View node stats...${RESET}"
    cd $PROJ_DIR
    ./pop --stats

    echo -e "${GREEN}✅ Node stats viewd.${RESET}"
    read -p "Press Enter to return to the menu..."
}


# Remove node 
remove_node() {
    echo 
    echo -e "${YELLOW}🗑️  Removing node...${RESET}"
    echo
    
    cd $PROJ_DIR
    rm -rf pop && pkill pop
    
    echo
    echo -e "${GREEN}✅ Node removed.${RESET}"
    read -p "Press Enter to return to the menu..."
}


# Update node 
update_node() {
    echo 
    echo -e "${YELLOW}🗑️  Updating node...${RESET}"
    echo
    
    cd $PROJ_DIR
    rm -rf pop && pkill pop && wget https://dl.pipecdn.app/v0.2.8/pop -O pop && chmod +x pop && ./pop --refresh && ./pop --version && ./pop --status
    
    echo
    echo -e "${GREEN}✅ Node updated.${RESET}"
    
    
    
    echo
    echo
    echo
    read -p "Press Enter to return to the menu..."
}


# Check node points
check_node_points() {
    echo -e "${GREEN}$ICON_VIEW Check node points...${RESET}"
    cd $PROJ_DIR
    ./pop --points

    echo -e "${GREEN}✅ Node points checked.${RESET}"
    read -p "Press Enter to return to the menu..."
}











# Main menu loop
while true; do
    show_menu
    case $choice in
        1)
            install_node
            ;;
        2)
            check_node_status
            ;;
        3)
            check_node_stats
            ;;
        4)
            check_node_points
            ;;    
        5)
            remove_node
            ;;
        0)
            echo -e "${GREEN}❌ Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid input. Please try again.${RESET}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
