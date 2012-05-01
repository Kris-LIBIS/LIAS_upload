$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_type, :system

default_run_options[:pty] = true

set :application, "LIAS Uploader"
set :repository,  "git@github.com:Kris-LIBIS/LIAS_upload.git"
set :deploy_to, "/exlibris/LIAS_upload"
set :user, 'exlibris'

set :server_name, 'upload.lias.be'

role :web, server_name                          # Your HTTP server, Apache/etc
role :app, server_name                          # This may be the same as your `Web` server
role :db,  server_name, :primary => true # This is where Rails migrations will run

set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
namespace :deploy do

  task :install_secure_files do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
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

after "deploy:update_code", :bundle_install, "deploy:install_secure_files"
desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end
