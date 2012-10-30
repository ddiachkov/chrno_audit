class ChrnoAuditController < ChrnoAudit::ApplicationController
  before_filter :find_model, only: [ :model, :history ]
  after_filter {
    self.class.layout :layout
  }

  def index
  end

  def model
  end

  def history
    attr_name = params[:attr_name]
    attr_value = params[:value]

    unless attr_name.in? @model.attribute_names
      raise ChrnoAudit::AttributeNotFound.new attr_name
    end

    @objects = @model.where attr_name => attr_value

    if @objects.size.zero?
      raise ActiveRecord::RecordNotFound.new I18n.t("chrno_audit.record_not_found",
                                                    model_name: @model_name,
                                                    attr_name: attr_name,
                                                    attr_value: attr_value)
    end

    order = "ASC" unless params[:order].tap{ |o| o.try("upcase!") } == "DESC"

    @logs = ChrnoAudit::AuditRecord.for_objects( *(@objects) ) \
      .order( "audit_log.created_at #{order}" ) \
      .includes( :initiator )
  end

  private

  def find_model
    @model = ChrnoAudit.models[ params[:model_name].camelize ]
    if @model.nil?
      raise ChrnoAudit::ModelNotFound.new params[:model_name]
    end
  end

  def layout
    if ChrnoAudit.layouts[action_name]
      ChrnoAudit.layouts[action_name].to_s
    else
      ChrnoAudit.default_layout.to_s
    end
  end
end
