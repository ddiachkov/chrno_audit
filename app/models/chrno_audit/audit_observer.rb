# encoding: utf-8

##
# Обзервер записывает изменения моделей в лог.
#
class ChrnoAudit::AuditObserver < ActiveRecord::Observer
  # По умолчанию ничего не обозреваем
  def self.observed_classes
    []
  end

  ##
  # Добавляет обзервер к заданной модели.
  # @param [Class] model модель
  #
  def self.attach( model )
    self.instance.send :add_observer!, model
  end

  # Создаёт запись о создании сущности.
  def after_create( entity )
    create_audit_record! entity, :create
  end

  # Создаёт запись об изменении сущности.
  def after_update( entity )
    create_audit_record! entity, :update
  end

  # Создаёт запись об удалении сущности.
  def after_destroy( entity )
    create_audit_record! entity, :destroy
  end

  private

  ##
  # Создаёт запись в логе.
  #
  # @param [ActiveRecord::Base] entity
  # @param [#to_s] action
  #
  def create_audit_record!( entity, action, params = {} )
    # Ничего не делаем, если аудит данного действия отключён
    return unless entity.class.auditable_actions.include? action

    # Получаем изменения и контекст
    changes_to_store = get_changes( entity )
    context = get_context.with_indifferent_access

    # Ничего не делаем если модель не изменилась
    return if entity.class.auditable_options[ :ignore_empty_diff ] && changes_to_store.empty? && action != :destroy

    audit_record = ChrnoAudit::AuditRecord.new do |record|
      record.action    = action.to_s
      record.auditable = entity
      record.diff      = changes_to_store
      record.initiator = context.delete( :initiator ) || context.delete( :current_user )
      record.context   = context
    end
    
    audit_record.save! unless params[:nosave]
    audit_record
  end

  ##
  # Формирует массив изменений для заданной записи.
  # @param [ActiveRecord::Base] entity
  # @return [Hash]
  #
  def get_changes( entity )
    entity.changes.select { |field| entity.class.auditable_fields.include? field }
  end

  ##
  # Возвращает текущий контекст для аудита.
  # @return [Hash]
  #
  def get_context
    ( Thread.current[ :audit_context ].respond_to?( :call ) ? Thread.current[ :audit_context ].call : {} ).tap do |context|
      # Проверяем, что контекст это хеш
      raise "Invalid audit context: Hash expected, got: #{context.inspect}" if context && !context.is_a?( Hash )
    end
  end
end