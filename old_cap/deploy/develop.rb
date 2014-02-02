set :ssh_options, {:forward_agent => true,:port => 2222}
set :user, "vagrant"
set :bundle_cmd,"/opt/rbenv/shims/bundle"
set :default_environment, {
  'PATH' => "/opt/ruby/bin:/opt/rbenv/shims:$PATH",
}

role :web, *%w[
 localhost
]
role :app, *%w[
 localhost
]
role :db, *%w[
 localhost
],:primary => true
