# encoding: utf-8

##
# Сущность "запись лога".
#
class ChrnoAudit::AuditRecord < ActiveRecord::Base
  self.table_name = "audit_log"

  # Кто изменил?
  belongs_to :initiator, polymorphic: true

  # Что изменил?
  belongs_to :auditable, polymorphic: true

  # Изменения
  serialize :diff, ChrnoAudit.serializer || Object

  # Контекст
  serialize :context, ChrnoAudit.serializer || Object

  # Возвращает записи для заданного типа сущности.
  scope :for_type, -> *types { where( auditable_type: types.map { |t| t.class.model_name } ) }

  # Возвращает записи для заданных моделей.
  scope :for_object, -> *records {
    t = self.arel_table

    # Логи для заданных записей
    conditions = records.compact.map do |record|
      t.where( t[ :auditable_type ].eq( record.class.model_name )) \
       .where( t[ :auditable_id ].eq( record.id )) \
       .project( t[ :id ] )
    end

    # Джойним результаты с помощью UNION ALL
    query = conditions.inject { |c1, c2| c1.union( :all, c2 ) }

    where( "audit_log.id IN (#{query.to_sql})" )
  }

  # Возвращает записи заданного типа.
  scope :with_action, -> action { where( action: action ) }
end
