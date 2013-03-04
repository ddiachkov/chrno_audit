# encoding: utf-8
module ChrnoAudit

  # Расширение для ActiveRecord.
  module ARExtension
    extend ActiveSupport::Concern

    module ClassMethods
      ##
      # Макрос добавляет в модель аудит изменений.
      #
      # @param [Symbol] fields
      #   список полей для аудита (по умолчанию все поля). Можно использовать
      #   псевдо-поле :all если необходим аудит всех полей.
      #
      # @param [Hash] options параметры аудита
      #   @option options [Array] :except ([])
      #     список полей, которые необходимо игнорировать при аудите (применяется
      #     совместно с :all)
      #
      #   @option options [Array] :when ([ :create, :update, :destroy ])
      #     список действий над моделью (создание, изменение, удаление), при
      #     которых необходим аудит
      #
      #   @options options [Hash] :context (ChrnoAudit.config.default_context)
      #     блоки кода, исполняемые в контексте контроллера. Результат выполнения
      #     каждого блока сохраняется в поле context.
      #
      # @example
      #     audit :all, except: :foo, context: { ip: -> { request.remote_addr } }
      #
      def audit( *fields )
        # Если таблицы ещё нет, ничего не делаем
        unless table_exists?
          Rails.logger.warn "Audit: try to audit model [#{name}] with non-existent table"
          return
        end

        # Добавляем связь
        has_many :audit_records, as: :auditable, class_name: "ChrnoAudit::AuditRecord"

        # Добавляем обсервер
        ChrnoAudit::AuditObserver.attach( self )

        # Добавляем необходимые параметры
        cattr_accessor :auditable_fields, :auditable_actions, :auditable_context

        options = fields.extract_options!

        # Настройки по умолчанию
        options.reverse_merge! \
          :except  => [],
          :when    => [ :create, :update, :destroy ],
          :context => ChrnoAudit.config.default_context

        # Нормализуем параметры
        options[ :except ] = Array.wrap( options[ :except ] ).map( &:to_s   )
        options[ :when   ] = Array.wrap( options[ :when   ] ).map( &:to_sym )

        # Получаем список полей.
        self.auditable_fields =
          # Аудит на всех полях?
          if fields.count == 1 and fields.first == :all
            # Всегда выкидываем timestamp и id.
            column_names - %W{ id created_at updated_at } - options[ :except ]
          else
            ( fields - options[ :except ] ).map( &:to_s )
          end

        self.auditable_actions = options[ :when ]
        self.auditable_context = options[ :context ]

        # Проверки
        Rails.logger.warn "Audit: no fields to audit" if self.auditable_fields.empty?
        Rails.logger.warn "Audit: no actions to audit" if self.auditable_actions.empty?
      end
    end
  end
end
