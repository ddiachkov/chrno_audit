# encoding: utf-8
require "active_support/configurable"

if Rails.version.to_i >= 4
  # В четвёртых рельсах обзерверы вынесены в джем
  gem "rails-observers", "~> 0.1.1"
  require "rails-observers"
end

module ChrnoAudit
  autoload :DirtySecret, "chrno_audit/dirty_secret"
  autoload :ARExtension, "chrno_audit/ar_extension"
  autoload :VERSION,     "chrno_audit/version"

  include ActiveSupport::Configurable

  class Engine < Rails::Engine
    initializer "chrno_audit.initialize" do
      ActiveSupport.on_load( :action_controller ) do
        include ChrnoAudit::DirtySecret
      end

      ActiveSupport.on_load( :active_record ) do
        include ChrnoAudit::ARExtension
      end
    end
  end
end