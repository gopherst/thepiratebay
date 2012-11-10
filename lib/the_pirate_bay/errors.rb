module ThePirateBay

  # Generic ThePirateBay exception class.
  class ThePirateBayError < StandardError
  end

  # Raised when a connection to the api can't be established.
  class ConnectionNotEstablished < StandardError
  end

  # Raised when the record was not found given an id or set of ids.
  class RecordNotFound < StandardError
  end

  # Raised when unknown attributes are supplied via mass assignment.
  class UnknownAttributeError < NoMethodError
  end
end