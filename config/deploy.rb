# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'clipin'
set :repo_url, 'git@github.com:kompiro/clipin.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }


# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :trace

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}

# Default value for default_env is {}
set :default_env, { path: "/opt/ruby/bin:/opt/rbenv/shims/:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

#set :bundle_flags, '--deployment'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  after :finished, :set_current_version do
    on roles(:app) do
      # dump current git version
      within release_path do
        execute :echo, "#{capture("cd #{repo_path} && git rev-parse --short HEAD")} > REVISION"
      end
    end
  end

end
