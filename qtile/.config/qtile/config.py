# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
import socket

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile import hook

# MULTI-SYSTEM CHECKS
# these values should reflect the requirements of each system
os_hostname = socket.gethostname()
autostart = ""
# Desktop Computer (2024-01-20)
if os_hostname == "bessie":
    autostart_script = "bessie_autostart.sh"
    network_interface = "enp7s0"
    network_icon = "󰈀"
    interface_font = "JetBrainsMono Nerd Font"

# Framework Laptop (2024-01-20)
elif os_hostname == "jugoplastika":
    autostart_script = "jugoplastika_autostart.sh"
    network_icon = "󰖩"
    network_interface = "wlan0"
    interface_font = "JetBrainsMono Nerd Font"
# default
else:
    autostart_script = "autostart.sh"
    network_interface = "wlan0"
    network_icon = "󰈀"
    interface_font = "JetBrains Mono"

# AUTOSTART
@hook.subscribe.startup_once
def autostart():
    # MULTI-SYSTEM
    script = os.path.expanduser("~/.config/qtile/"+autostart_script)
    subprocess.run([script])

mod = "mod4"
terminal = "kitty"
rofi_launcher = "rofi -combi-modi 'window,drun' -font 'Iosevka Nerd Font Mono 16' -show combi -width 30 -location 6"
rofi_emoji = "rofi -modi emoji -font 'Iosevka Nerd Font Mono 16' -show emoji -width 30 -location 6"
rofi_calc = "rofi -modi calc -font 'Iosevka Nerd Font Mono 16' -show calc -no-show-match -no-sort -width 30 -location 6"
rofi_shortcuts = "bash /home/darko/bin/rofishort.sh"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.swap_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.swap_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod], "i", lazy.layout.grow(), desc="Grow window size"),
    Key([mod], "m", lazy.layout.shrink(), desc="Shrink window size"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "o", lazy.layout.maximize(), desc="Maximise window"),
    Key([mod, "shift"], "space", lazy.layout.flip(), desc="Flip the monad"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Added by Darko
    Key([mod], "e", lazy.spawn(rofi_launcher), desc="Spawn ROFI"),
    Key([mod, "shift"], "Period", lazy.spawn(rofi_emoji), desc="Emoji Picker"),
    Key([mod, "shift"], "c", lazy.spawn(rofi_calc), desc="Calculator"),
    Key([mod, "shift"], "s", lazy.spawn(rofi_shortcuts), desc="Shortcutcs runner"),
    Key([mod, "shift"], "v", lazy.spawn("pavucontrol"), desc="PulseAudio Volume Control"),
    Key([mod], "a", lazy.screen.toggle_group(), desc="Toggle between groups"),

    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -3%")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +3%")),

    # BACKLIGHT
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5"))
]


# Clamp groups to specified screen - got it from https://github.com/michael-oti/dotfiles/blob/main/.config/qtile/config.py
def go_to_group(qtile, group_name, screen):
    qtile.focus_screen(screen)
    qtile.groups_map[group_name].cmd_toscreen(toggle=False)


workspaces = [
    {"name": "1"},
    {"name": "2"},
    {"name": "3", "spawn": "spotify", "matches": [Match(wm_class="spotify")]},
    {"name": "4"},
    {"name": "5"},
    {"name": "6"},
    {"name": "7"},
    {"name": "8"},
    {"name": "9"},
    {"name": "0"},
]

# This is used to be able to clamp down to screens
groups = [
    # Screen affinity here is used to make
    # sure the groups startup on the right screens
    Group(name="1", screen_affinity=0),
    Group(name="2", screen_affinity=0),
    Group(name="3", screen_affinity=0),
    Group(name="4", screen_affinity=0),
    Group(name="5", screen_affinity=0),
    Group(name="6", screen_affinity=0),
    Group(name="7", screen_affinity=0),
    Group(name="8", screen_affinity=1),
    Group(name="9", screen_affinity=1),
    Group(name="0", screen_affinity=1),
]

def go_to_group(name: str):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.groups_map[name].toscreen()
            return

        if name in '1234567':
            qtile.focus_screen(0)
            qtile.groups_map[name].toscreen()
        else:
            qtile.focus_screen(1)
            qtile.groups_map[name].toscreen()

    return _inner

for i in groups:
    keys.append(Key([mod], i.name, lazy.function(go_to_group(i.name))))

def go_to_group_and_move_window(name: str):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.current_window.togroup(name, switch_group=True)
            return

        if name in "1234567":
            qtile.current_window.togroup(name, switch_group=False)
            qtile.focus_screen(0)
            qtile.groups_map[name].toscreen()
        else:
            qtile.current_window.togroup(name, switch_group=False)
            qtile.focus_screen(1)
            qtile.groups_map[name].toscreen()

    return _inner

for i in groups:
    keys.append(Key([mod, "shift"], i.name, lazy.function(go_to_group_and_move_window(i.name))))

layouts = [
    layout.MonadTall(
        margin=5,
        ),
    layout.MonadWide(
        margin=5,
        ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# MULTI-SYSTEM
widget_defaults = dict(
    font=interface_font,
    fontsize=18,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(highlight_method='block', block_highlight_text_color='#EBAC00', this_current_screen_border='#1D3E71'),
                widget.Prompt(),
                widget.WindowName(
                    background = "#1D3E71",
                    foreground = "#EBAC00",
                    scroll = True,
                    ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Sep(foreground='#EBAC00', padding=32, linewidth=5), # SPACER
                widget.Systray(),
                widget.Sep(foreground='#EBAC00', padding=32), # SPACER
                # MULTI-SYSTEM
                widget.Net(
                    interface=network_interface,
                    format = network_icon+' {down:6.2f}{down_suffix:<2}↓↑{up:6.2f}{up_suffix:<2}'
                    ),
                widget.NetGraph(type='box', border_color='#181', graph_color='#181'),
                widget.Sep(foreground='#EBAC00', padding=32), # SPACER
                widget.Memory(
                    format = ' {MemPercent}%'
                    ),
                widget.Sep(foreground='#EBAC00', padding=32), # SPACER
                widget.CPU(
                    format = '󰻠 {load_percent}%'
                    ),
                widget.CPUGraph(),
                widget.Sep(foreground='#EBAC00', padding=32), # SPACER
                widget.PulseVolume(
                    fmt = "🔈 {}",
                    ),
                widget.Sep(foreground='#EBAC00', padding=32), # SPACER
                widget.Wttr(
                    scroll=True,
                    scroll_interval = 0.04,
                    format="%l: %t",
                    width = 100,
                    location = {
                        'Maple Valley, WA': 'Maple Valley',
                        'Subotica, Serbia': 'Subotica'
                        },
                    update_interval = 30,
                    ),
                widget.Sep(foreground='#EBAC00', padding=32), # SPACER
                widget.Clock(format="%Y-%m-%d %I:%M %p", foreground='#EBAC00'),
            ],
            28,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="pavucontrol"),  # PulseAudio Volume Control
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
