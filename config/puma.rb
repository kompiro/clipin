root = "/home/deployer/apps/clipin/current"

bind 'unix:///tmp/puma.sock'
pidfile "#{root}/tmp/pid"
state_path "#{root}/tmp/state"
activate_control_app
