namespace :testing do

  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern    = "spec/**/*_spec.rb"
    end
  rescue LoadError
    [:spec].each do |task_symbol|
      desc 'rspec rake task not available (rspec not installed)'
      task task_symbol do
        abort 'rspec rake task is not available. Be sure to install rspec as a gem'
      end
    end
  end

  begin
    require 'cucumber/rake/task'
    Cucumber::Rake::Task.new(:features, 'run cucumber features') do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'default'
    end
  rescue LoadError
    desc 'cucumber rake task not available (cucumber not installed)'
    task :features do
      abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem'
    end
  end

  task :all => ['testing:spec', 'testing:features']
end

