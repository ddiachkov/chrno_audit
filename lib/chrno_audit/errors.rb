module ChrnoAudit
  class Error < StandardError; end

  class ModelNotFound < Error
    def initialize(model_name = nil, message = nil)
      @message = message
      @model_name = model_name
      @default_message = I18n.t("chrno_audit.model_not_found", model_name: @model_name.camelize)
    end

    def to_s
      @message || @default_message
    end
  end
end
