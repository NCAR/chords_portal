# unicorn configuration
# based on:
# - http://bogomips.org/unicorn.git/tree/examples/unicorn.conf.rb
# - https://devcenter.heroku.com/articles/rails-unicorn
# - https://blog.heroku.com/archives/2013/2/27/unicorn_rails
# documentation:
# - http://unicorn.bogomips.org/Unicorn/Configurator.html

# turn on logs for dev or debug:
#stderr_path 'log/unicorn.stderr.log'
#stdout_path 'log/unicorn.stdout.log'

pid 'tmp/pids/unicorn.pid'

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.

# number of worker processes can be declared via 'WORKERS' ENVIRONMENT variable,
# e.g.:
# % WORKERS=4 unicorn -c config/unicorn.rb

# default to 1 worker
workers = ENV['WORKERS'] ? ENV['WORKERS'].to_i : 1

raise ArgumentError, "WORKERS must be 1 or more" if workers < 1

worker_processes workers

preload_app true

listen(ENV['CHORDS_UNICORN_SOCKET'], backlog: 64) if ENV['CHORDS_UNICORN_SOCKET']

before_fork do |server, worker|
  # disconnect from database
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = 'tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

end

after_fork do |server, worker|
  # connect to database
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
