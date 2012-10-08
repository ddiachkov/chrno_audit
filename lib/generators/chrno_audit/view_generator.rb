# encoding: utf-8

# Генератор создаёт вьюху и запись в routes.rb для определенной модели
module ChrnoAudit
  class ViewGenerator < Rails::Generators::NamedBase
    source_root File.expand_path( "../templates", __FILE__ )
    desc "installs view for a model"

    def make_view
      template "history.rb", "app/views/#{plural_name}/history.html.erb"
    end

    def make_route
      route "chrno_audit_for :#{plural_name}"
    end

    def copy_assets
      copy_file "chrno_audit.css.sass", "app/assets/stylesheets/shared/chrno_audit.css.sass"
    end

    def show_readme
      readme "README"
    end
  end
end
