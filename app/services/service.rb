module Service
  extend ActiveSupport::Concern

  ResultHttpStruct = Struct.new(:success?, :data, keyword_init: true)

  included do
    def self.call(*, **)
      new(*, **).call
    end
  end

  class << self
    def success(data = nil)
      ResultHttpStruct.new(success?: true, data: data)
    end

    def failure(error_message)
      ResultHttpStruct.new(success?: false, data: { error: error_message })
    end
  end
end
