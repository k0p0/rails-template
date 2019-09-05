
# prerequisites

MySQL Server | PostgreSQL Server AND Rails & Ruby & git ... installed

Ensure you have bootstrap and it's dependencies

yarn add bootstrap
yarn add jquery popper.js

# install

choose postgresql or mysql 
```bash
$ rails new myAppName -T --database=(postgresql|mysql) --webpack -m https://raw.githubusercontent.com/k0p0/rails-template/master/full.rb
$ cd myAppName
$ bundle install

# Note
comment usued gem (mysql2 / pgsql) in Gemfile according to your DBMS

install yarn
https://yarnpkg.com/lang/en/docs/install/

for production envivronment : 
change `config.serve_static_assets = false` to `true` in `config/environments/production.rb`
add a `secret_key_base` in `config/secrets.yml` (you can generate one with `bundle exec rake secret`)

# Run 
Go in your app docroot and `nohup rails server -e production &`
