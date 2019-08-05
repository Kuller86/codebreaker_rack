module CodebreakerRack
  class UserNotRegisteredException < RuntimeError
  end

  class UrlException < RuntimeError
  end

  class UrlNotFoundException < UrlException

  end
end