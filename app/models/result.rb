class Result < ActiveRecord::Base
  attr_accessor :hours, :minutes, :seconds
  belongs_to :registration
  #validates_numericality_of :time_finished, greater_than_or_equal_to: 1
  validates :time_finished, :category, :gender,  presence: true
  before_validation :assign_defaults
  before_validation :generate_time_duration

  scope :male, -> { where(gender: 'Male')}
  scope :female, -> { where(gender: 'Female')}

  def default_duration
    self.hours = '00'
    self.minutes = '00'
    self.seconds = '00'
  end

  def duration_to_params
    self.hours, self.minutes, self.seconds = self.pretty_duration.split(':')
  end

  def pretty_duration
    Time.at(self[:time_finished]).utc.strftime("%H:%M:%S")
  end

  def overall_rank
    Result.where("time_finished <= ? AND category = ?", self.time_finished, self.category).count
  end

  def gender_rank
    Result.where("time_finished <= ? AND results.category = ? AND gender = ?", self.time_finished, self.category, self.gender).count
  end

  def diff_duration(x,y)
    diff = x - y
    pretty_duration(diff)
  end

  private

  def assign_defaults
    self.category = self.registration.category
    self.gender = self.registration.gender
  end

  def generate_time_duration
    h = hours.to_i
    m = minutes.to_i
    s = seconds.to_i
    self[:time_finished] = h.hours.to_i + m.minutes.to_i + s
  end


end
