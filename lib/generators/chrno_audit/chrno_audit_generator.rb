# encoding: utf-8

# Генератор создаёт вьюху и запись в routes.rb для определенной модели
module ChrnoAudit
  class ChrnoAuditGenerator < Rails::Generators::NamedBase
    namespace "chrno_audit"
    source_root File.expand_path( "../templates", __FILE__ )
    desc "installs view for a model"

    class_option :styles, :desc => "Copy stylesheets", :type => :boolean, :default => true
    class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true

    def make_view
      template "history.rb", "app/views/#{plural_name}/history.html.erb"
    end

    def make_route
      route("resources :#{plural_name} do chrno_audit end") if options.routes?
    end

    def copy_assets
      if options.styles?
        copy_file "chrno_audit.css.sass", "app/assets/stylesheets/shared/chrno_audit.css.sass"
      end
    end

    def show_readme
      readme "README"
    end
  end
end
