namespace :railsui do
  desc 'Install Rails UI (use --build for build mode, default is importmap)'
  task :install, [:build_flag] do |t, args|
    # Check if --build flag is present in ARGV
    build_flag = ARGV.include?('--build') ? '--build' : ''

    system("#{RbConfig.ruby} ./bin/rails g railsui:install #{build_flag}")

    # Exit after running to prevent rake from trying to run additional tasks
    exit(0)
  end
end
