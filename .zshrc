export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="bira"
plugins=(git)
source $ZSH/oh-my-zsh.sh
alias copyconf="~/Dev/copy_configs.sh"
alias hyprconf="~/.config/hypr/hyprland.conf"
# ensure prompt substitution is enabled
setopt PROMPT_SUBST

# compute DBOX_PROMPT as you already do
if [[ -n "${DBX_CONTAINER_NAME:-}" ]]; then
  DBOX_NAME="$DBX_CONTAINER_NAME"
elif [[ -n "${CONTAINER_ID:-}" ]]; then
  DBOX_NAME="$CONTAINER_ID"
elif [[ -n "${DBX_CONTAINER_MANAGER:-}" ]]; then
  DBOX_NAME="${DBX_CONTAINER_MANAGER}@$(hostname)"
else
  DBOX_NAME=""
fi
if [[ -n "$DBOX_NAME" ]]; then
  DBOX_PROMPT="Distrobox:%F{cyan}[${DBOX_NAME}]%f "
else
  DBOX_PROMPT=""
fi

# prepend to whatever the theme sets by wrapping PROMPT with its current value
# only change PROMPT if theme set it
if [[ -n "${PROMPT-}" ]]; then
  PROMPT="$PROMPT"'${DBOX_PROMPT}'
fi
# also handle RPS1/RPROMPT if you want the label on the right prompt:
# if [[ -n "${RPROMPT-}" ]]; then RPROMPT='${DBOX_PROMPT}'"$RPROMPT"; fi

