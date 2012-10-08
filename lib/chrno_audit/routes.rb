module ChrnoAudit
  module RouteHelpers
    def chrno_audit_for(*resources)
      options = resources.extract_options!

      options[:action] ||= "history"
      resources.map!(&:to_sym)

      resources.each do |resource|
        as = ( options[:as] || "#{resource.to_s.singularize}_#{options[:action]}" ).to_sym
        get "#{resource}/:id/#{options[:action]}" => "#{resource}##{options[:action]}", as: as
      end
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, ChrnoAudit::RouteHelpers)
