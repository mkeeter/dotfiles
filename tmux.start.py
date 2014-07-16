#!/usr/bin/env python

import os
import sys
import subprocess

if 'TMUX' in os.environ:
    sys.exit(0)

tmux = '/usr/local/bin/tmux'
if subprocess.call([tmux,'has-session','-t','_default']):
    subprocess.call([tmux,'new-session','-s','_default','-d'])

sessions = subprocess.check_output(
        [tmux,'list-sessions','-F','#S'])[:-1].split('\n')

print "Available sessions"
print "------------------"

for i, s in enumerate(sessions):
    print "%i) %s" % (i+1, s)
print "%i) New session" % (i+2)
print "%i) zsh" % (i+3)

try:
    s = int(raw_input("Please choose your session: ")) - 1
except ValueError:
    print "Invalid session number!"
    s = len(sessions)

if s == len(sessions) + 1:
    os.execvp('zsh', ['zsh'])
elif s == len(sessions):
    os.execvp(tmux, [tmux, 'new', '-s',
                     raw_input("Enter new session name: ")])
else:
    os.execvp(tmux, [tmux,'attach-session','-t', sessions[s]])




