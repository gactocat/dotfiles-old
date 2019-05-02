FPATH="${HOME}/.zshrc-load:${FPATH}"

autoload -Uz zshrc-base && zshrc-base
autoload -Uz zshrc-zplug && zshrc-zplug
autoload -Uz zshrc-prompt && zshrc-prompt
autoload -Uz zshrc-alias && zshrc-alias