run 'pgrep spring | xargs kill -9'

# GEMFILE
########################################
run 'rm Gemfile'
file 'Gemfile', <<-RUBY
source 'https://rubygems.org'
ruby '#{RUBY_VERSION}'

gem 'devise'
gem 'figaro'
gem 'jbuilder', '~> 2.0'
gem 'pg'
gem 'mysql2' 
gem 'puma'
gem 'rails', '#{Rails.version}'
gem 'redis'

gem 'autoprefixer-rails'
gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'font-awesome-sass'
gem 'jquery-rails'
gem 'jquery-fileupload-rails'
gem 'sass-rails'
gem 'simple_form'
gem 'uglifier'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
RUBY

# Ruby version
########################################
file '.ruby-version', RUBY_VERSION

# Procfile
########################################
file 'Procfile', <<-YAML
web: bundle exec puma -C config/puma.rb
YAML

# Spring conf file
########################################
inject_into_file 'config/spring.rb', before: ').each { |path| Spring.watch(path) }' do
  '  config/application.yml\n'
end

# Assets
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
run 'curl -L https://github.com/k0p0/rails-stylesheets/archive/master.zip > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/rails-stylesheets-master app/assets/stylesheets'

run 'curl -L https://raw.githubusercontent.com/k0p0/rails-template/master/logo.png > app/assets/images/logo.png'
run 'curl -L https://raw.githubusercontent.com/k0p0/rails-template/master/profil.png > app/assets/images/profil.png'
run 'curl -L https://raw.githubusercontent.com/k0p0/rails-template/master/home.jpg > app/assets/images/home.jpg'

run 'rm app/assets/javascripts/application.js'
file 'app/assets/javascripts/application.js', <<-JS
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .
JS

# Dev environment
########################################
gsub_file('config/environments/development.rb', /config\.assets\.debug.*/, 'config.assets.debug = false')

# Layout
########################################
run 'rm app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.erb', <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <title>MY COMPANY</title>
    <%= csrf_meta_tags %>
    <%= action_cable_meta_tag %>
    <%= stylesheet_link_tag 'application', media: 'all' %>
  </head>
  <body>
    <%= render 'shared/navbar' %>
    <%= render 'shared/flashes' %>
    <div class="container">
      <div class="row">
          <%= yield %>
      </div>
    </div>
    <%= javascript_include_tag 'application' %>
    <%= render 'shared/footer' %>
  </body>
</html>
HTML

file 'app/views/shared/_flashes.html.erb', <<-HTML
<% if notice %>
  <div class="alert alert-info alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= notice %>
  </div>
<% end %>
<% if alert %>
  <div class="alert alert-warning alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= alert %>
  </div>
<% end %>
HTML

file 'app/views/shared/_navbar.html.erb', <<-HTML
<div class="navbar-classic">
  <!-- Logo -->
  <%= link_to root_path, class: "navbar-classic-brand" do %>
    <%= image_tag "logo.png" %>
  <% end %>

  <!-- Right Navigation -->
  <div class="navbar-classic-right hidden-xs hidden-sm">

    <% if user_signed_in? %>

      <!-- Links when logged in -->
      <%= link_to "Host", "#", class: "navbar-classic-item navbar-classic-link" %>
      <%= link_to "Trips", "#", class: "navbar-classic-item navbar-classic-link" %>
      <%= link_to "Messages", "#", class: "navbar-classic-item navbar-classic-link" %>

      <!-- Avatar with dropdown menu -->
      <div class="navbar-classic-item">
        <div class="dropdown">
          <%= image_tag "profil.png", class: "avatar dropdown-toggle", id: "navbar-classic-menu", "data-toggle" => "dropdown" %>
          <ul class="dropdown-menu dropdown-menu-right navbar-classic-dropdown-menu">
            <li>
              <%= link_to "#" do %>
                <i class="fa fa-user"></i> <%= t(".profile", default: "Profile") %>
              <% end %>
            </li>
            <li>
              <%= link_to "#" do %>
                <i class="fa fa-home"></i>  <%= t(".profile", default: "Home") %>
              <% end %>
            </li>
            <li>
              <%= link_to destroy_user_session_path, method: :delete do %>
                <i class="fa fa-sign-out"></i>  <%= t(".sign_out", default: "Log out") %>
              <% end %>
            </li>
          </ul>
        </div>
      </div>
    <% else %>
      <!-- Login link (when logged out) -->
      <%= link_to t(".sign_in", default: "Login"), new_user_session_path, class: "navbar-classic-item navbar-classic-link" %>
    <% end %>
  </div>

  <!-- Dropdown list appearing on mobile only -->
  <div class="navbar-classic-item hidden-md hidden-lg">
    <div class="dropdown">
      <i class="fa fa-bars dropdown-toggle" data-toggle="dropdown"></i>
      <ul class="dropdown-menu dropdown-menu-right navbar-classic-dropdown-menu">
        <li><a href="#">Some mobile link</a></li>
        <li><a href="#">Other one</a></li>
        <li><a href="#">Other one</a></li>
      </ul>
    </div>
  </div>
</div>
HTML

file 'app/views/shared/_footer.html.erb', <<-HTML
<div class="footer">
  <div class="footer-links">
    <ul class="list-inline text-center">
      <li> <%= Date.today.year %>  <a href="#"><i class="fa fa-copyright"></i>  My Company</a></li>
      <li>  |  </li>
      <li> <a href="#"><i class="fa fa-bank"></i>  Legal terms</a> </li>
      <li>  |  </li>
      <li> <a href="#"><i class="fa fa-lock"></i>  Access</a> </li>
      <li>  |  </li>
      <li> <a href="tel:+33000000000"><i class="fa fa-phone"></i>  +33000000000</a> </li>
      <li>  |  </li>
      <li> <a href="mailto:contact@abc.xyz"><i class="fa fa-envelope-o"></i>  contact@abc.xyz</a> </li>
      <li>  |  </li>
      <li> <a href="#"><i class="fa fa-github"></i></a> </li>
      <li> <a href="#"><i class="fa fa-linkedin"></i></a> </li>
      <li> <a href="#"><i class="fa fa-facebook"></i></a> </li>
      <li> <a href="#"><i class="fa fa-twitter"></i></a> </li>
    </ul>
  </div>
</div>
HTML
 
file 'app/views/pages/home.html.erb', <<-HTML
<div class="banner" style="background-image: linear-gradient(-225deg, rgba(0,101,168,0.6) 0%, rgba(0,36,61,0.6) 50%), url('https://picsum.photos/200/300/?random');">
  <div class="banner-content">
    <h1>My Company</h1>
    <p>Welcome on our web site</p>
    <a class="btn btn-primary btn-lg">Start now</a> 
  </div>
</div>
HTML


# Generators
########################################
generators = <<-RUBY
config.generators do |generate|
      generate.assets false
      generate.helper false
    end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Generators: db + simple form + pages controller
  ########################################
  rake 'db:drop db:create db:migrate'
  generate('simple_form:install', '--bootstrap')
  generate(:controller, 'pages', 'home', '--skip-routes')

  # Routes
  ########################################
  route "root to: 'pages#home'"

  # Git ignore
  ########################################
  run 'rm .gitignore'
  file '.gitignore', <<-TXT
.bundle
log/*.log
tmp/**/*
tmp/*
*.swp
.DS_Store
public/assets
TXT
  
  # Devise install + user
  ########################################
  generate('devise:install')
  generate('devise', 'User')

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<-RUBY
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
end
RUBY

  # migrate + devise views
  ########################################
  rake 'db:migrate'
  generate('devise:views')

  # Pages Controller
  ########################################
  run 'rm app/controllers/pages_controller.rb'
  file 'app/controllers/pages_controller.rb', <<-RUBY
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end
end
RUBY

  # Environments
  ########################################
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

  # Figaro
  ########################################
  run 'bundle binstubs figaro'
  run 'figaro install'

  # Git
  ########################################
  git :init
  git add: '.'
  git commit: "-m 'Initial commit with devise template'"
end
