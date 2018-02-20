
# prerequisites

MySQL Server | PostgreSQL Server AND Rails & Ruby & git ... installed

# install

```bash
$ rails new myAppName -T --database=(postgresql|mysql) -m https://raw.githubusercontent.com/k0p0/rails-template/master/full.rb
$ bundle install
$ rails assets:precompile
```

# Note
comment usued gem (mysql2 / pgsql) in Gemfile according to your DBMS

for production envivronment : 
change config.serve_static_assets = false to true in config/environments/production.rb
add a secret_key_base in config/secrets.yml (you can generate one with `bundle exec rake secret`
