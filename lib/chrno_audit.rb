# encoding: utf-8
if !defined?( Rails ) || Rails.version.to_i >= 4
  # В четвёртых рельсах обзерверы вынесены в джем
  gem "rails-observers", "~> 0.1.1"
  require "rails-observers"

  # Хак для eager load: по умолчанию класс ActiveRecord::Observer грузится ПОСЛЕ
  # того грузятся модели из app/models при eager_load = true, что приводит к ошибке
  # если рядом с моделями лежат обзервере. Поэтому грузим определение класса сразу.
  require "rails/observers/activerecord/active_record"
end

require "chrno_audit/version"

module ChrnoAudit
  require "active_support/configurable"
  include ActiveSupport::Configurable
end

# Автоматически грузим всё из app, т.к. может оказаться, что мы запускаемся не в рельсах
Dir.glob( File.join( File.expand_path( "../../app/models", __FILE__ ), "**", "*.rb" )).each do |file|
  require file
end

ActiveSupport.on_load( :action_controller ) do
  require "chrno_audit/action_controller_concern"
  include ChrnoAudit::ActionControllerConcern
end

ActiveSupport.on_load( :active_record ) do
  require "chrno_audit/active_record_concern"
  include ChrnoAudit::ActiveRecordConcern
end

# Rails Engine
require "chrno_audit/engine" if defined?( Rails ) && defined?( Rails::Engine )