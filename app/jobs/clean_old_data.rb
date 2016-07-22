class CleanOldData < JobBase
  acts_as_scalable

  @queue  = :send_emails

  def self.do_perform
    puts "START removing old data"
    #Remove Old Measures
    Risebox::Core::Measure.where('taken_at < ?', 1.month.ago).destroy_all

    #Remove Old Logs
    Risebox::Core::LogEntry.where('created_at < ?', 1.day.ago).destroy_all

    puts "DONE removing old data"
  end
end