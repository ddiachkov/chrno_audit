# encoding: utf-8
ChrnoAudit.setup do |config|
  config.default_context = { ip: -> { request.remote_addr }}
end
