root = "#{File.expand_path(File.dirname(__FILE__))}/.."

bind 'unix:///tmp/puma.sock'
pidfile "#{root}/tmp/pid"
state_path "#{root}/tmp/state"
activate_control_app
