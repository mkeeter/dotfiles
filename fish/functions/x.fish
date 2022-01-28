if string match -q -- "*hubris*" (pwd)
    cargo xtask $argv
else
    command x
end
