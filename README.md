# Keystrokes

Record you keystrokes and replay them just like in vim macro!

#### Why does this exist?

I wanted to make something that is somewhat portable across linux/unix. And easily
works under X11 and Wayland. Firstly I thought about parsing contents of x11/wayland
screenkey variants, but soon I withdrew from that thought, because of wayland inconsistencies.
Then I thought, maybe I should parse only from [showmethekey](https://github.com/AlynxZhou/showmethekey) since it's cross-protocol,
but I didn't like idea of having GTK window and use window rules to hide it etc..
In the end I discovered that showmethekey under the hood uses libinput.
And to my surprise libinput already has ability to record and replay you keystrokes.
But it's limited in a way that you can't speed it up. It's basically mirroring.

With this tool you can set delay, save recorded keystrokes to files and replay them
as many times you want.

## Table of contents

- [Dependencies](#dependencies)
- [Usage](#usage)
- [Video](#video)
- [Alternatives](#alternatives)
- [Todo](#todo)

## Dependencies

- [libinput](https://gitlab.freedesktop.org/libinput/libinput)
- [polkit](https://github.com/polkit-org/polkit)
- [python-libevdev](https://gitlab.freedesktop.org/libevdev/python-libevdev) (to be able to mirror replay)

X11:

- [xdotool](https://github.com/jordansissel/xdotool)

Wayland:

- [ydotool](https://github.com/ReimuNotMoe/ydotool)
- [slurp](https://github.com/emersion/slurp)

## Installation

**To use put:**\
[`keystrokes`](https://github.com/Darukutsu/keystrokes/blob/master/keystrokes) in `/usr/bin/keystrokes`\
[`com.github.keystrokes.policy`](https://github.com/Darukutsu/keystrokes/blob/master/com.github.keystrokes.policy) in `/usr/share/polkit-1/rules.d/com.github.keystrokes.policy`\
[`com.github.keystrokes.rules`](https://github.com/Darukutsu/keystrokes/blob/master/com.github.keystrokes.rules) in `/usr/share/polkit-1/rules.d/com.github.keystrokes.rules`

NOTE: symlinks don't work with polkit

This tool directly uses `/dev/input/event...`, so using `pkexec` we're getting root permissions.
You can use sudo, doas too.

If you encounter issues when executing your binds via keyboard such as `Refusing to render service to dead parents`, make a wrapper:

```
#!/bin/sh
pkexec keystrokes "$@"
```

## Usage

```
Usage: keystrokes [OPTION]...

Short options take same arguments as their long counterpart.
  -h, --help                 display this help and exit
  -p, --play [NAME]          play macro
  -r, --record [NAME]        record macro
  -R, --remove [NAME]        remove recorded macro
  -s, --stop-record          forcestop recording macro (usefull for scripts)
  -S, --stop-replay          forcestop playing macro (usefull for scripts)
  -v, --version              display version and exit

OPTIONS TO USE WITH RECORD
  -D, --device {NAME}        pick recording devices (either path or descriptive name,
                                                    see \`libinput list-kernel-devices\`)
                             this flag can take multiple arguments as
                             you can specify multiple devices to record at same time

  -x, --x11                  due to how pkexec works we can't read XDG_SESSION_TYPE
                             directly in script, use this flag if you're on X11.

OPTIONS TO USE WITH PLAY
  -d, --delay NUMBER         set replay time in ms (default 12ms)
  -m, --mirror               mirror replay timing exactly as it was recorded
  -n, --nplay NUMBER         set number of replays
  -x, --x11                  due to how pkexec works we can't read XDG_SESSION_TYPE
                             directly in script, use this flag if you're on X11.

  -y, --ydotool PATH         due to how pkexec works we can't read YDOTOOL_SOCKET
                             directly in script, use this flag if you're on Wayland.
                             You don't need to use this if path to your
                             YDOTOOL_SOCKET=/tmp/.ydotool_socket

[NAME] is optional, if not specified it will create files using mktemp.
You can find unnamed macros in /tmp/*.macro.
If you accidentally recorded wrong macro without specifying NAME don't worry,
Run \`macro -R\`, this will autodelete last unnamed recorded file.
```

See my dotfiles for [usage example](https://github.com/Darukutsu/dotfiles/blob/master/sxhkd/mode_macro) in sxhkd.

## Video

[video.webm](https://github.com/user-attachments/assets/f01b3884-f4c3-45fb-809d-88916d6736a6)

## Alternatives

| Name                                                                                         | Description                             | Protocol     | Language |
| :------------------------------------------------------------------------------------------- | :-------------------------------------- | :----------- | :------- |
| [atbswp](https://github.com/RMPR/atbswp)                                                     | keyboard and mouse                      | X11+Wayland? | Python   |
| [autokey](https://github.com/autokey/autokey)                                                | glorified xdotool                       | X11+Wayland? | Python   |
| libinput+python-evdev                                                                        | record & replay any `/dev/input`        | X11+Wayland  | C+Python |
| [xmacroIncludingDelayCapturing](https://github.com/Ortega-Dan/xmacroIncludingDelayCapturing) | keyboard and mouse with record delay    | X11          | C        |
| [xnee](https://xnee.wordpress.com/)                                                          | distributed keyboard and mouse solution | X11          | C        |

## Todo

- [ ] proper gamepad support?
- [x] proper mouse support?
- [ ] proper tty support?
- [x] fix potentional issues with keys which upstate wasn't recorded... e.g. my kill-sequence `keydown super+ctrl+q; keyup super` will result in pressing `CTRL+Q`

##### Warning

Currently you can record any device since we using libinput to record keystrokes, however since we haven't implemented parsing for any other device, except keyboard and mouse, you are limited to `keystrokes -p -m` option.
Also you might experience weird issues with mouse sensitivity.
