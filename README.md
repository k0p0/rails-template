
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
