# encoding: utf-8
require "active_support/configurable"

module ChrnoAudit
  autoload :DirtySecret, "chrno_audit/dirty_secret"
  autoload :ARExtension, "chrno_audit/ar_extension"
  autoload :VERSION,     "chrno_audit/version"

  include ActiveSupport::Configurable

  class Engine < Rails::Engine
    initializer "chrno_audit.initialize" do
      ActiveSupport.on_load( :action_controller ) do
        Rails.logger.debug "--> load chrno_audit dirty secret"
        include ChrnoAudit::DirtySecret
      end

      ActiveSupport.on_load( :active_record ) do
        Rails.logger.debug "--> load chrno_audit"
        include ChrnoAudit::ARExtension
      end
    end
  end
end

