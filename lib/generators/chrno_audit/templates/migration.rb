# encoding: utf-8
class CreateAuditLog < ActiveRecord::Migration
  def change
    create_table :audit_log do |t|
      t.string   :auditable_type, :null => false
      t.integer  :auditable_id
      t.string   :initiator_type
      t.integer  :initiator_id
      t.string   :action, :null => false
      t.text     :diff
      t.text     :context
      t.datetime :created_at, :null => false
    end

    add_index :audit_log, [ :auditable_type, :auditable_id ]
    add_index :audit_log, [ :initiator_type, :initiator_id ]
    add_index :audit_log, :action
    add_index :audit_log, :created_at, :order => { :created_at => :desc }
  end
end