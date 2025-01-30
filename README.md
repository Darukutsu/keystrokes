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
- bc

X11:

- [xdotool](https://github.com/jordansissel/xdotool)

Wayland:

- [ydotool](https://github.com/ReimuNotMoe/ydotool)
- [slurp](https://github.com/emersion/slurp) (for getting current mouse position)

## Installation

```
curl https://raw.githubusercontent.com/Darukutsu/keystrokes/refs/heads/env-access/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

This tool directly uses `/dev/input/event...`, so using `pkexec` we're getting root permissions.
You can use sudo, doas too.

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

OPTIONS TO USE WITH PLAY
  -d, --delay NUMBER         set replay time in ms (default 12ms)
  -m, --mirror               mirror replay timing exactly as it was recorded
  -n, --nplay NUMBER         set number of replays

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
