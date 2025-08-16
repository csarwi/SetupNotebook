# This sets energie level of the batterie so, that the laptop can be folded but still run.
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
powercfg -SetActive SCHEME_CURRENT
# TODO: Make this nicer
# NOTE: This is actually different
# NOTE: This could be better
# INFO: yeah this too