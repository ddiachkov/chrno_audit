module ChrnoAudit
  module Routes
    def chrno_audit(*options)
      unless resource_scope?
        raise ArgumentError, "can't use chrno_audit outside resource(s) scope"
      end

      options = options.extract_options!

      options[:action] ||= "history"

      member do
        get options[:action]
      end
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, ChrnoAudit::Routes)
