# auto start startx
if [[ "$(tty)" = "/dev/tty1" ]]; then
  pgrep cwm || startx
fi
