#!/usr/bin/env python
"""This is a sample script for testing dap functionality.

Start debug session with ":Debugpy program".
"""

import sys
from subprocess import call, run

from pynotifier import Notification

args = { 'up': True }

try:
    output = run('light', check=True, capture_output=True)
    value = float(output.stdout.split(b"\n")[0])
    if len(output.stderr) > 0:
        print('N/A')
        sys.exit()
except FileNotFoundError:
    print('light not available')
    sys.exit()

if value > 10:
    r = -1
    inc = 10
else:
    r = 0
    inc = 1

if args['up']:
    if value > 9.5:
        r = -1
        inc = 10
    value = min(round(value, r) + inc, 100)
elif args['down']:
    value = max(round(value, r) - inc, 1)

call(f'light -S {value}', shell=True)

value = "{:.0f} %".format(value)
if args['--notify']:
    Notification(
        title='brightness-control',
        description="Brightness: " + value,
        icon_path='N/A',
        duration=2,
        urgency='normal'
    ).send()
else:
    print(value)
