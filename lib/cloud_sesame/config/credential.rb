module CloudSesame
  module Config
    class Credential < ::AbstractObject
      accept :access_key_id, as: [:access_key]
      accept :secret_access_key, as: [:secret_key]
    end
  end
end
