To simplify rendering, characters sprites are not placed directly on the
screen. Instead, they're "projected" onto render textures, and these are
placed onto puppets.

These files are the "slides" which are put in that "projector."
They should all have Dialogue.VN.Slide attached or the system won't be
able to handle them. Look at that component's docs and tooltips for more
info on its setup.
