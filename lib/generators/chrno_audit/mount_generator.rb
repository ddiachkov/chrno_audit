# encoding: utf-8
require "rails/generators"
require "rails/generators/migration"
require "active_record"

# Генератор создаёт миграцию и файл инициализации
module ChrnoAudit
  class MountGenerator < Rails::Generators::Base
    source_root File.expand_path( "../templates", __FILE__ )
    desc "Mounts engine and copies views/stylesheets"

    class_option :views,   :desc => "Copy views",       :type => :boolean, :default => true
    class_option :styles,  :desc => "Copy stylesheets", :type => :boolean, :default => true
    class_option :locales, :desc => "Copy locales",     :type => :boolean, :default => true

    def make_locale
      if options.locales?
        copy_file "../../../../config/locales/en.yml", "config/locales/chrno_audit.en.yml"
      end
    end

    def make_views
      if options.views?
        %W( history index model ).each do |name|
          copy_file File.expand_path("../../../../app/views/chrno_audit/#{name}.html.erb", __FILE__), "app/views/chrno_audit/#{name}.html.erb"
        end
      end
    end

    def copy_assets
      if options.styles?
        copy_file "chrno_audit.css.sass", "app/assets/stylesheets/chrno_audit.css.sass"
      end
    end

    def make_routes
      route "mount ChrnoAudit::Engine => \"/chrno_audit\""
    end

    def show_readme
      readme "VIEWS_README"
    end
  end
end
