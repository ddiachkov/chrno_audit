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
  def create_audit_record!( entity, action )
    # Ничего не делаем, если аудит данного действия отключён
    return unless entity.class.auditable_actions.include? action

    changes_to_store = get_changes( entity )

    # Ничего не делаем если модель не изменилась
    return if changes_to_store.empty? and action != :destroy

    ChrnoAudit::AuditRecord.create do |record|
      record.action    = action.to_s
      record.auditable = entity
      record.diff      = changes_to_store
      record.initiator = audit_context[ :current_user ]
      record.context   = generate_ar_context( entity, audit_context[ :controller ] )
    end
  end

  ##
  # Возвращает текущий контекст для аудита.
  # @see [ChrnoAudit::DirtySecret]
  # @return [Hash]
  #
  def audit_context
    Thread.current[ :audit_context ] || {}
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
  # Формирует контекст записи используя контекст контроллера.
  # @param [ActiveRecord::Base] entity
  # @param [ActionController::Base] controller
  # @return [Hash]
  #
  def generate_ar_context( entity, controller )
    entity.class.auditable_context.inject( {} ) do |result, (name,value)|
      begin
        result[ name.to_s ] = controller.instance_exec( &value )
      rescue Exception => e
        Rails.logger.error "Audit: can't retrieve context item: #{e}"
      end

      result
    end
  end
end
