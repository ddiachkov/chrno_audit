# encoding: utf-8

require "chrno_audit/routes"

ChrnoAudit.configure do |config|
  config.default_context = { ip: -> { request.remote_addr }}
end

