namespace :seed do
  if !Rake::Task.task_defined?("seed:migrate")
    desc "Run new data migrations."
    task :migrate, [:tenant] => :environment do |t, args|
      SeedMigration::Migrator.run_migrations(ENV['MIGRATION'], args[:tenant])
    end
  end

  if !Rake::Task.task_defined?("seed:rollback")
    desc "Revert last data migration."
    task :rollback, [:tenant] => :environment do |t, args|
      steps = ENV["STEP"] || ENV["STEPS"] || 1
      SeedMigration::Migrator.rollback_migrations(filename: ENV["MIGRATION"], steps: steps, tenant: args[:tenant])
    end
  end

  namespace :migrate do
    if !Rake::Task.task_defined?("seed:migrate:status")
      desc "Display status of data migrations."
      task :status => :environment do
        SeedMigration::Migrator.display_migrations_status
      end
    end
  end
end
