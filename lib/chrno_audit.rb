# encoding: utf-8
if Rails.version.to_i >= 4
  # В четвёртых рельсах обзерверы вынесены в джем
  gem "rails-observers", "~> 0.1.1"
  require "rails-observers"

  # Хак для eager load: по умолчанию класс ActiveRecord::Observer грузится ПОСЛЕ
  # того грузятся модели из app/models при eager_load = true, что приводит к ошибке
  # если рядом с моделями лежат обзервере. Поэтому грузим определение класса сразу.
  require "rails/observers/activerecord/active_record"
end

require "active_support/configurable"
require "chrno_audit/version"

module ChrnoAudit
  include ActiveSupport::Configurable

  class Engine < Rails::Engine
    initializer "chrno_audit.initialize", :before => :load_active_support do
      require "chrno_audit/action_controller_concern"
      require "chrno_audit/active_record_concern"

      ActiveSupport.on_load( :action_controller ) do
        include ChrnoAudit::ActionControllerConcern
      end

      ActiveSupport.on_load( :active_record ) do
        include ChrnoAudit::ActiveRecordConcern
      end
    end
  end
end