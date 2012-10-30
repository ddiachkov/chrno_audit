# encoding: utf-8
require 'active_support/core_ext/hash'

module ChrnoAudit

  autoload :DirtySecret, "chrno_audit/dirty_secret"
  autoload :ARExtension, "chrno_audit/ar_extension"
  autoload :VERSION,     "chrno_audit/version"
  autoload :ModelNotFound, "chrno_audit/errors"

  mattr_accessor :models
  @@models = {}

  mattr_accessor :default_context
  @@default_context = { ip: -> { request.remote_addr }}

  mattr_accessor :default_layout
  @@default_layout = :application

  # Available keys:
  # :index
  # :model
  # :history
  mattr_accessor :layouts
  @@layouts = ActiveSupport::OrderedHash.new

  # добавлено взамен ChrnoAudit.config.serializer в файле с AuditRecord
  # зачем этот атрибут?
  mattr_accessor :serializer

  # Вызывается в инициализаторе
  def self.setup
    yield self
  end

  class Engine < Rails::Engine
    config.chrno_audit = ChrnoAudit
    engine_name 'chrno_audit'

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
