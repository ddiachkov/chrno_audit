# encoding: utf-8
module ChrnoAudit
  ##
  # Маленький грязный секрет. Нарушает инкапсуляцию, MVC и является причиной
  # голода в Африке. Так делать нельзя ни при каких условиях!
  #
  module DirtySecret
    extend ActiveSupport::Concern

    included do
      before_filter :store_audit_context
    end

    ##
    # Сохраняет в Thread.current необходимые для аудита данные.
    #
    def store_audit_context
      Thread.current[ :audit_context ] = {
        :current_user => self.try( :current_user ),
        :controller   => self # OMG! OMG!
      }
    end
  end
end