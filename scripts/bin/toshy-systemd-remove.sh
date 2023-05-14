#!/usr/bin/env bash


# Stop, disable, and remove the systemd service unit files

# Check if the script is being run as root
if [[ $EUID -eq 0 ]]; then
    echo "This script must not be run as root"
    exit 1
fi

# Check if $USER and $HOME environment variables are not empty
if [[ -z $USER ]] || [[ -z $HOME ]]; then
    echo "\$USER and/or \$HOME environment variables are not set. We need them."
    exit 1
fi

DELAY=0.5

echo -e "\nRemoving Toshy systemd services...\n"

# systemctl "disable" automatically deletes all symlinks (might be bug)

if [ -f "$HOME/.config/systemd/user/toshy-config.service" ]; then
    if systemctl --user --quiet is-active toshy-session-monitor.service; then
        /usr/bin/systemctl --user stop toshy-session-monitor.service
    fi

    if systemctl --user --quiet is-enabled toshy-session-monitor.service; then
        /usr/bin/systemctl --user disable toshy-session-monitor.service
    fi
    rm -f "$HOME/.config/systemd/user/toshy-config.service"
fi

sleep $DELAY

if [ -f "$HOME/.config/systemd/user/toshy-session-monitor.service" ]; then
    if systemctl --user --quiet is-active toshy-config.service; then
        /usr/bin/systemctl --user stop toshy-config.service
    fi

    if systemctl --user --quiet is-enabled toshy-config.service; then
        /usr/bin/systemctl --user disable toshy-config.service
    fi
    rm -f "$HOME/.config/systemd/user/toshy-session-monitor.service"
fi

sleep $DELAY

if [ -f "$HOME/.config/autostart/Toshy_Import_Vars.desktop" ]; then
    rm -f "$HOME/.config/autostart/Toshy_Import_Vars.desktop"
fi

sleep $DELAY

/usr/bin/systemctl --user daemon-reload

sleep $DELAY

echo -e "\nFinished removing Toshy systemd services.\n"
