# -----------------------------------------------------------------------------
# zsh-autosuggestions
# -----------------------------------------------------------------------------

# zsh-autosuggestions in konsole with the dracula theme are not displayed
# because the default foreground color is more or less the same as the
# background color. Therefore we set it to a nicer color.
#
# The number was determined by runing spectrum_ls and selecting a color we
# like.
#
# The TERMINAL_EMULATOR environment variable was set by determine-term in
# zprofile.
if [ "$TERMINAL_EMULATOR" = "konsole" ] || [ "$TERMINAL_EMULATOR" = "yakuake" ]
then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=239"
fi


