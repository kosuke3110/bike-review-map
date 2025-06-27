# lib/tasks/release.rake
namespace :release do
  desc "Run db:prepare and db:seed together"
  task setup: :environment do
    Rake::Task["db:prepare"].invoke
    Rake::Task["db:seed"].invoke
  end
end
