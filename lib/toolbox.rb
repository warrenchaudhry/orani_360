module Toolbox

  def self.age(dob, age_at=nil)
    age_at ||= Time.now.utc.to_date
    age_at.year - dob.year - ((age_at.month > dob.month || (age_at.month == dob.month && age_at.day >= dob.day)) ? 0 : 1)
  end

end