#!/usr/bin/env python3

# Author: Andrew Shark
# Homepage: https://gitlab.com/AndrewShark/obs-scripts
# License: GPLv3

# This script allows you to use a single shortcut for start recording, and then toggle pause recording,
# (just like in ssr), because there is no such hotkey in OBS.
# Also you can use this in Wayland session, as a workaround, because currently, there is no global hotkeys protocol.

import obsws_python as obs

cl = obs.ReqClient()
r = cl.get_record_status()
active = r.output_active
paused = r.output_paused

if not active:
    cl.start_record()
else:
    cl.toggle_record_pause()
