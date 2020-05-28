#!/bin/bash

#reference : https://gist.github.com/seanf/e3be5bf745395d50e975
# wait for the dock state to change
sleep 0.5

username=dan

if [[ "$1" == "add" ]]; then
  DOCKED=1
  logger -t DOCKING "Detected condition: docked"
elif [[ "$1" == "remove" ]]; then
  DOCKED=0
  logger -t DOCKING "Detected condition: un-docked"
else
  logger -t DOCKING "Detected condition: unknown"
  echo "must supply arg1 as add or remove"
  exit 1
fi

# invoke from XSetup with NO_KDM_REBOOT otherwise you'll end up in a KDM reboot loop
NO_KDM_REBOOT=0
for p in $*; do
  case "$p" in
  "NO_KDM_REBOOT") NO_KDM_REBOOT=1 ;;
  "SWITCH_TO_LOCAL") DOCKED=0 ;;
  esac
done

function switch_to_local {
  export DISPLAY=$1
  logger -t DOCKING "Switching off Externals, Switching on eDP1"
  su $username -c '
    /usr/bin/python3 /home/dan/bin/i3_workspace_dock.py undock
    /usr/bin/xrandr \
      --output VIRTUAL1 --off \
      --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
      --output DP1 --off \
      --output DP2-1 --off \
      --output DP2-2 --off \
      --output DP2-3 --off \
      --output HDMI2 --off \
      --output HDMI1 --off \
      --output DP2 --off
    '
}

function switch_to_external {
  export DISPLAY=$1
  logger -t DOCKING "Switching on External"

  su $username -c '
    /usr/bin/xrandr \
      --output VIRTUAL1 --off \
      --output eDP1 --mode 1920x1080 --pos 0x168 --rotate normal \
      --output DP1 --off \
      --output DP2-1 --primary --mode 2560x1440 --pos 1920x0 --rotate normal \
      --output DP2-3 --off \
      --output HDMI2 --off \
      --output HDMI1 --off \
      --output DP2 --off
    #Only works if split into two commands for whatever reason
    /usr/bin/xrandr --output DP2-2 --mode 1920x1200 --pos 4480x0 --rotate normal
    sleep 2
    /usr/bin/python3 /home/dan/bin/i3_workspace_dock.py dock
    '
}

case "$DOCKED" in
  "0")
    #undocked event
    switch_to_local :0 ;;
  "1")
    #docked event
    switch_to_external :0 ;;
esac
