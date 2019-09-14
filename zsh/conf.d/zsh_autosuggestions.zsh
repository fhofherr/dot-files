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
# This requires the detterm utility: https://github.com/fhofherr/detterm
if [ -n "$(DETTERM_EMULATORS="konsole yakuake" detterm)" ]
then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=239"
fi


