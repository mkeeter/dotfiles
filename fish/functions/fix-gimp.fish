function fix-gimp
    brew services stop dbus
    sleep 2
    mkdir -p ~/Library/LaunchAgents
    cp $(brew --prefix dbus)/lib/Library/LaunchAgents/org.freedesktop.dbus-session.plist ~/Library/LaunchAgents
    launchctl load -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist
end
