APP_DIR = File.expand_path("../../..", __FILE__)
USER = ""
GROUP = ""

#worker_processes 2
worker_processes 8
working_directory APP_DIR
# user USER, GROUP

listen 3000, :tcp_nopush => true
listen "/var/run/unicorn.sock"
pid "/var/run/unicorn.pid"

timeout 60
preload_app true

stdout_path "#{APP_DIR}/log/unicorn_stdout.log"
stderr_path "#{APP_DIR}/log/unicorn_stderr.log"

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection

  #child_pid = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
  #system("echo #{Process.pid} > #{child_pid}") # リダイレクトしてファイルに書き込む
end
