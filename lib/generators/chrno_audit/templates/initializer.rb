# encoding: utf-8
ChrnoAudit.configure do |config|
  config.default_context = { ip: -> { request.remote_addr }}
end