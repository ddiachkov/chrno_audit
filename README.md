# Описание
__chrno_audit__ -- простейшая реализация аудита для ActiveRecord.

TODO: better readme

## Пример использования:
    rails g chrno_audit:install
    rake db:migrate
    ...
    class Page < ActiveRecord::Base
      audit :all
    end