set :stages, %w(develop production staging)
set :default_stage, "develop"
require "capistrano/ext/multistage"

set :bundle_without,  [:development, :test, :osx]

require "bundler/capistrano"
set (:user) {"deployer"}

set :application, "clipin"
set (:deploy_to) {"/home/#{user}/apps/#{application}"}
set :deploy_via, :remote_cache
set :use_sudo, false
set (:bundle_cmd) {"/home/#{user}/.rbenv/shims/bundle"}

set :scm, "git"
set :repository, "ssh://deployer@clipin.me:5668/opt/repos/clipin"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:port] = 5668
set :normalize_asset_timestamps, false

set (:default_environment) {{
     'PATH' => "$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH",
}}

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} puma server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/puma #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
  #  sudo "ln -nfs #{current_path}/config/puma_init.sh /etc/init.d/puma"
  #  sudo "ln -nfs #{current_path}/config/puma.conf /etc/puma.conf"
  #  sudo "ln -nfs #{current_path}/config/run-puma /usr/local/bin/run-puma"
  #  run "mkdir -p #{shared_path}/config"
  #  put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
  #  puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  #task :setup_puma_config, roles: :app do
  #  sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
  #  sudo "ln -nfs #{current_path}/config/puma_init.sh /etc/init.d/puma"
  #  sudo "ln -nfs #{current_path}/config/puma.conf /etc/puma.conf"
  #  sudo "ln -nfs #{current_path}/config/run-puma /usr/local/bin/run-puma"
  #  run "mkdir -p #{shared_path}/config"
  #  puts "Now edit the config files in #{shared_path}."
  #end
  #after "deploy:setup", "deploy:setup_config"

  #task :symlink_config, roles: :app do
  #  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  #end
  #after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
