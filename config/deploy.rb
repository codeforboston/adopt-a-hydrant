require "rvm/capistrano"

set :application, "adopt-a-hydrant"
set :repository,  "git@github.com:barrywalker/adopt-a-hydrant.git"
set :scm, :git
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
set :scm_verbose, true
set :deploy_to, "/var/www/apps/#{application}"
set :user, "deploy"
set :runner, "deploy"
set :spinner, false
set :keep_releases, 2
set :use_sudo, false
set :branch, "master"
set :normalize_asset_timestamps, false
set :rvm_ruby, "ruby-1.9.3-p429"
set :default_environment, {
	'SECRET_TOKEN' => '771b3c32b85af11940861948525de6bc505c36ae23d0cd7debd815de6591f352d8bc5892f7785a1ba79c29c1b513cf1bbc90e122322db1983635e9384ea0bfa1'
}

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "ec2-107-21-253-25.compute-1.amazonaws.com"                          # Your HTTP server, Apache/etc
role :app, "ec2-107-21-253-25.compute-1.amazonaws.com"                          # This may be the same as your `Web` server
role :db,  "ec2-107-21-253-25.compute-1.amazonaws.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_path} && bundle install"
  end

end
before "deploy:restart", "bundle:install"
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
