# encoding: utf-8

##
# Сущность "запись лога".
#
class ChrnoAudit::AuditRecord < ActiveRecord::Base
  set_table_name "audit_log"

  # Кто изменил?
  belongs_to :initiator, polymorphic: true

  # Что изменил?
  belongs_to :auditable, polymorphic: true

  # Изменения
  serialize :diff

  # Контекст
  serialize :context

  # Возвращает записи для заданного типа сущности.
  scope :for, -> type { where( auditable_type: type ) }

  # Возвращает записи заданного типа.
  scope :with_action, -> action { where( action: action ) }
end