desc "This tasks removes old data from database"

namespace :tools do
  task :clean_old_data => :environment do |t, args|
    CleanOldData.perform I18n.locale
  end
end