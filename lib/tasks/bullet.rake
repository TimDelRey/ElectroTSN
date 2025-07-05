namespace :bullet do
  task ci_check: :environment do
    puts 'Running tests with Bullet enabled to detect N+1 queries...'
    ENV['CI'] = 'true'
    Rake::Task['spec'].invoke
  end
end
