#!/usr/bin/env python3
# nwg-wrapper -s /etc/nixos/home/desktop/nwg-widget.py -r 60000 -p right -mr 200
import subprocess
import os
import sys


def get_output(command):
    command += '|ansifilter -M --art-tundra'
    # command += '|sed "s/fgcolor="#000000" bgcolor="#000000"/bgcolor="#FFFFFF20" fgcolor="#998000"/g"'
    try:
        output = subprocess.check_output(
            command, shell=True).decode("utf-8").strip()
    except Exception as e:
        output = e
        sys.stderr.write("{}\n".format(e))
    return output


def main():
    time = get_output("date +'%A, %b %d, %H:%M'")
    uptime = get_output("ip -4 -c addr show enp3s0")
    print(
        f'<span size="35000" foreground="#998000">{time}</span><span size="30000" foreground="#ccc">')
    print(f'{uptime}</span>')
    uname = os.getenv("USER")
    host = get_output("uname -n")
    kernel = get_output("uname -sr")
    print(f'<span foreground="#aaa">{uname}@{host} {kernel}')
    print(get_output("niri -V"))
    print('</span>')
    try:
        print('<span font_family="monospace" foreground="#ccc">')
        print(get_output('disfetch'))
        # cow = get_output("fortune | pokemonsay")
        # # # "<" and ">" would be interpreted as parts of Pango markup
        # # # cow = cow.replace("<", "{")
        # # # cow = cow.replace(">", "}")
        # print(cow)
        print('</span>')
    except Exception as e:
        print("cow is dead: {}".format(e))

    # place your image path here
    # print('#img path=/home/piotr/Obrazy/grass.png width=430 height=70')


if __name__ == '__main__':
    main()
