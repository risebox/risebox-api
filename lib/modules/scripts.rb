module Scripts
	def self.reset_all_meaning_limits
    self.all_metrics_for_code('PH').update_all(meaning_min: 3,  meaning_max: 10)
    self.all_metrics_for_code('WTEMP').update_all(meaning_min: 5,  meaning_max: 50)
    self.all_metrics_for_code('WVOL').update_all(meaning_min: 20, meaning_max: 250)
    self.all_metrics_for_code('ATEMP').update_all(meaning_min: 5,  meaning_max: 50)
    self.all_metrics_for_code('AHUM').update_all(meaning_min: 10,  meaning_max: 100)
    self.all_metrics_for_code('UCYC').update_all(meaning_min: 100,  meaning_max: nil)
    self.all_metrics_for_code('LCYC').update_all(meaning_min: 100,  meaning_max: nil)
  end

private

  def self.all_metrics_for_code code
    Risebox::Core::MetricStatus.joins(:metric).where("metrics.code = ?", code).all
  end
end