# encoding: utf-8
module ChrnoAudit
  ##
  # Расширение для ActionController.
  #
  module ActionControllerConcern
    extend ActiveSupport::Concern

    module ClassMethods
      ##
      # Хелпер для установки контекста аудита.
      #
      # @param [Proc, Symbol] proc_or_symbol
      #   символ или Proc для генерации контента (также может быть задано в виде блока)
      #
      # @example
      #   audit_context -> {{ ip: request.remote_addr }}
      #
      def audit_context( proc_or_symbol = nil, &block )
        # Получаем Proc для генерации контекста
        context_generator =
          # Если задан блок -- используем его
          if block_given?
            block

          # Если указан символ, то вызываем соответствующий метод
          elsif proc_or_symbol.is_a? Symbol
            Proc.new { self.send proc_or_symbol }

          # Если указан Proc -- используем его
          elsif proc_or_symbol.is_a? Proc
            proc_or_symbol

          else
            raise ArgumentError, "Proc or Symbol expected, got: #{proc_or_symbol.inspect}"
          end

        before_filter do |controller|
          # NB: согласно документации Ruby в Thread.current хранятся per-fiber атрибуты!
          Thread.current[ :audit_context ] = Proc.new { controller.instance_exec( &context_generator ) }
        end
      end
    end

    ##
    # Хелпер для создания записи аудита из контроллера.
    # В качестве типа будет использовано имя текущего контоллера, в качестве действия -- текущий экшен.
    #
    # @param [Hash] context контекст
    # @param [ActiveRecord::Base] initiator инициатор обновления
    #
    def create_audit_record!( context = {}, initiator = nil )
      ChrnoAudit::AuditRecord.create! do |record|
        record.auditable_type = self.class.name
        record.action         = request.symbolized_path_parameters[ :action ]
        record.initiator      = initiator
        record.context        = context
      end
    end
  end
end