require "rvm/capistrano"
require 'capistrano-deploytags'
set :rvm_type, :system

default_run_options[:pty] = true

set :application, "LIAS Uploader"
set :repository,  "git@github.com:Kris-LIBIS/LIAS_upload.git"

set :scm, :git
set :branch, 'master'
set :stage, 'production'

set :deploy_to, "/opt/libis/LIAS_upload"
set :user, 'exlibris'
set :use_sudo, false

set :keep_releases, 2

server 'upload.lias.be', :web, :app, :db, :primary => true

set :deploy_via, :remote_cache
set :scm_verbose, true

namespace :remote do

  task :fw_off do
    run "sudo /etc/init.d/firewall stop"
  end

  task :fw_on do
    run "sudo /etc/init.d/firewall start"
  end

  task :create_symlinks do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end

end

namespace :deploy do

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end

  task :precompile do
    run "cd #{current_path}; rake assets:precompile RAILS_ENV=production"
  end

  task :load_fixtures do
    run "cd #{current_path}; rake db:fixtures:load RAILS_ENV=production"
  end
end

before "deploy:update_code", "remote:fw_off"
after  "deploy:update_code", "remote:fw_on"

after  "deploy:update", "remote:create_symlinks", "deploy:cleanup"

after "deploy:update_code", :bundle_install, "remote:create_symlinks"

desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end

