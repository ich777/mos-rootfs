#!/bin/sh
# Set variables
DEVICE="${SMARTD_DEVICE}"
MESSAGE="${SMARTD_MESSAGE}"
FAILTYPE="${SMARTD_FAILTYPE}"

# Filter FAILTYPE, modify message if necessary and set priority
case "$FAILTYPE" in
  Temperature)
    if echo "$MESSAGE" | grep -q "high" ; then
      MESSAGE="Temperature high"
      PRIORITY="warning"
    elif echo "$MESSAGE" | grep -qi "critical"; then
      SHORTMSG="Temperature critical"
      PRIORITY="alert"
    elif echo "$MESSAGE" | grep -q "returned to normal" ; then
      MESSAGE="Temperature returned to normal"
      PRIORITY="normal"
    else
      exit 0
    fi
  ;;
  Health|SelfTest|Error)
    PRIORITY="alert"
  ;;
  *)
    PRIORITY="info"
  ;;
esac

# Send notification through MOS notify service
notify -t "$DEVICE" -m "$MESSAGE" -p "$PRIORITY" >/dev/null 2>&1
