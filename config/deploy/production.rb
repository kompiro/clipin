
set :user, "deployer"

role :web, *%w[
  clipin.me
]
role :app, *%w[
  clipin.me
]
role :db, *%w[
  clipin.me
],:primary => true
