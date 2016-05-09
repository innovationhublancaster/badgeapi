# Console
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

# Tests
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb'] + FileList['test/*/*_test.rb']
  t.verbose = true
  t.warning = false
end

desc "Run tests"
task default: :test
