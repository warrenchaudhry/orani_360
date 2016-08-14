module ResultsHelper

  def diff_duration(x,y)
    diff = x - y
    "+#{Time.at(diff).utc.strftime("%H:%M:%S")}"
  end
end
