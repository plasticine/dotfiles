# GRC colorizes nifty unix tools all over the place
if $(grc &>/dev/null) && $(brew &>/dev/null)
then
  source /usr/local/etc/grc.bashrc
fi
