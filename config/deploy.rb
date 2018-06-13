# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "proxy"
# set :repo_url, "git@example.com:me/my_repo.git"
set :repo_url, 'https://github.com/programrails/proxy.git'

set :passenger_restart_with_touch, true

set :deploy_to, '/home/deploy/proxy'

append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :keep_releases, 5

namespace :deploy do

  desc 'Fix assets'
  task :fix_absent_manifest_bug do
    on roles(:web) do
      within release_path do
        execute :mkdir, '-p', 'assets_manifest_backup'
        execute :mkdir, '-p', release_path.join('public', 'assets')
        execute :touch, release_path.join('public', 'assets', 'manifest-fix.temp')
      end
    end
  end  

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end 

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
      # invoke 'delayed_job:restart'
    end
  end



  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup' 
  after :updating, 'deploy:fix_absent_manifest_bug' 

end
