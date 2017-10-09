#!/usr/bin/env python

import os
import sys
import subprocess

if 'TMUX' in os.environ:
    sys.exit(0)

SHELL = "/usr/local/bin/fish"
if subprocess.call(['pgrep','tmux'], stdout=open('/dev/null','w')):
    os.execvp(SHELL, [os.path.basename(SHELL)])

tmux = '/usr/local/bin/tmux'
sessions = subprocess.check_output(
        [tmux,'list-sessions','-F','#S'])[:-1].split('\n')

print "Available sessions"
print "------------------"

for i, s in enumerate(sessions):
    print "%i) %s" % (i+1, s)
print "%i) New session" % (i+2)
print "%i) %s" % (i+3, os.path.basename(SHELL))

i = raw_input("Please choose your session: ")
try:
    s = int(i) - 1
except ValueError:
    if i == '':
        s = len(sessions) + 1
    else:
        print "Invalid session number!"
        s = len(sessions)

if s == len(sessions) + 1:
    os.execvp(SHELL, [os.path.basename(SHELL)])
elif s == len(sessions):
    os.execvp(tmux, [tmux, 'new', '-s',
                     raw_input("Enter new session name: ")])
else:
    os.execvp(tmux, [tmux,'attach-session','-t', sessions[s]])
