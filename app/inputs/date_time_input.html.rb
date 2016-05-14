class DateTimeInput < SimpleForm::Inputs::DateTimeInput

  # Add/override default options
  default_prompt_options = {minute: 'Min', second: 'Sec'}
  %i(year month day hour).each { |d| default_prompt_options[d] = d.to_s.titleize }
  self.default_options.reverse_merge! ampm: true, prompt: default_prompt_options, minute_step: 15, date_separator: '', datetime_separator: '', time_separator: ''

  def initialize(*args)
    super(*args)

    # default birth_date & deceased_date options
    @options.reverse_merge!(past_date: 135) if [:birth_date, :deceased_date, :date_deceased].include?(@attribute_name)

    # past_date and future_date options:
    # value can be an `integer` (number of years) or `true` (defaults to
    # 130 years)
    # if past_or_future_date = @options[:past_date] || @options[:future_date]
    #   this_year = Date.today.year
    #   number_of_years = past_or_future_date.is_a?(TrueClass) ? 135 : past_or_future_date
    #   number_of_years *= -1 if @options[:past_date]
    #   end_year = this_year + number_of_years
    #
    #   @options.except!(:past_date, :future_date).reverse_merge!(start_year: this_year, end_year: end_year)
    # end
  end

end