# This rake task was added by annotate_rb gem.

# Can set `ANNOTATERB_SKIP_ON_DB_TASKS` to be anything to skip this
if Rails.env.development? && ENV["ANNOTATERB_SKIP_ON_DB_TASKS"].nil?
  require "annotate_rb"

  AnnotateRb::Core.load_rake_tasks
end

# namespace :annotate_rb do
#   desc "Annotate models"
#   task models: :environment do
#     require "annotate_rb"
#     # Здесь ошибка была из-за отсутствия метода, лучше заменить на system вызов:
#     system("bundle exec annotate_models")
#   end
# end

# Rake::Task["db:migrate"].enhance do
#   Rake::Task["annotate_rb:models"].invoke
# end
