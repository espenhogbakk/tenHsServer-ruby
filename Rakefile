require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  #t.test_files = FileList['test/*_test.rb']
  t.test_files = FileList['test/*_test.rb', 'test/ten_hs_server/*_test.rb']
end

desc "Run tests"
task :default => :test