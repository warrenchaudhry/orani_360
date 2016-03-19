module Regex

  EMAIL = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  PHONE = /\A[0-9]{10}\z/

  DATE_YEAR_PARAMETER = /\A\S*date\S*\(1i\)\z/

end