set :app, "mynsu"
#set :db, "localhost"
set :web, "http://i-lab.nsu.ru/social_network/"
set :deploy_to, "/home/ochirov/project/social_network/trunk"
set :repository,  "svn://i-lab.nsu.ru/social_network/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "http://i-lab.nsu.ru/social_network"
role :web, "http://i-lab.nsu.ru/social_network"
role :db,  "localhost", :primary => true
namespace :passenger do
  desc "Restart Application"
    task :restart, :roles => :web do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

desc "Restart BackgroundFu daemon"
   task :restart_background_fu do
       run "RAILS_ENV=production ruby /script/daemons stop"
       run "RAILS_ENV=production ruby /script/daemons start"
end

namespace :deploy do
 
   desc "Run this after every successful deployment" 
    task :after_default do
       restart_background_fu
    end
end


after :deploy, "passenger:restart"