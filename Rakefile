require 'bundler'
Bundler::GemHelper.install_tasks

FileList['tasks/**/*.rake'].each { |task| import task }

desc 'Default: run all specs'
task :default => 'testing:all'
