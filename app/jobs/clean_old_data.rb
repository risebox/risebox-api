class CleanOldData < JobBase
  acts_as_scalable

  @queue  = :send_emails

  def self.do_perform
    puts "START removing old data"
    #Remove Old Measures
    Risebox::Core::Measure.where('taken_at < ?', 100.hours.ago).delete_all  #Between 6 and 7 days

    #Remove Old Logs
    Risebox::Core::LogEntry.where('created_at < ?', 12.hours.ago).delete_all

    puts "DONE removing old data"
  end
end