#!/usr/bin/env python3
import json
import subprocess
import sys

COLOR_NORMAL = '#ffffa'
COLOR_DEGRADED = '#abafb3'

def truncate(s, length=30):
    ellipsis = "..."
    return (s[:(length - len(ellipsis))].strip() + ellipsis) if len(s) > length else s

def get_current_music_title(shorten=True):
    title = subprocess.getoutput('playerctl metadata title')
    if 'No player' in title:
        return ""
    artist = subprocess.getoutput('playerctl metadata artist')
    if shorten:
        title = truncate(title) 
        artist = truncate(artist)
    return f"{title} - {artist}"

def get_current_status():
    return subprocess.getoutput('playerctl status') == "Playing"

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()


def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()


if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ''

        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','
        j = json.loads(line)

        playing = get_current_status()

        music_title = get_current_music_title()
        # this is where the magic happens
        # https://i3wm.org/docs/i3bar-protocol.html

        res = {
            'full_text': '%s' % music_title,
            'name': 'music_title',
        }

        if not playing:
            res['color'] = COLOR_DEGRADED

        j.insert(0, res)

        print_line(prefix+json.dumps(j))
