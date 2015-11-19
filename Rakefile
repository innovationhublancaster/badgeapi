require "bundler/gem_tasks"

desc "Open an pry/irb session preloaded with badgeapi"
task :console do
  irb = "pry"
  # Check if pry installed
  begin
    gem "pry"
  rescue Gem::LoadError
    irb = "irb"
  end
  puts "Loading badgeapi gem with #{irb}"

  exec "#{irb} -I lib -r badgeapi.rb"
end
