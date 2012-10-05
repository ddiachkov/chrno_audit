# chrno_audit

Простейшая реализация аудита для ActiveRecord.

## Установка

Добавьте в Gemfile:

```ruby
gem 'chrno_audit'
```

и запустите `bundle install`. Затем нужно будет сгенерировать необходимые для работы файлы и создать таблицы в БД:

```console
rails g chrno_audit:install
rake db:migrate
```

Помните, что необходимо перезапустить приложение, если оно уже запущено.

## Пример использования:

После установки в моделях становится доступен единственный метод `audit(*params)`, подключающий модель к системе аудита. В качестве параметров методу audit можно передавать список полей для аудита (по умолчанию все), например:

```ruby
class Page < ActiveRecord::Base
  audit :text, :subject
end
```

Можно использовать псевдо-поле :all, если необходим аудит всех полей:

```ruby
class Page < ActiveRecord::Base
  audit :all
end
```

Можно указывать список полей, которые необходимо игнорировать при аудите:

```ruby
class Page < ActiveRecord::Base
  audit :all, :except => [ :author ]
end
```

Помимо действий, которые подвергаются аудиту по умолчанию (create, update, destroy) можно указать свои:

```ruby
class Page < ActiveRecord::Base
  audit :all, :when => [ :convert ]
end
```

Параметр `:context` принимает в качестве своего значения хеш следующего вида:

```ruby
{
  block_name:        block,
  another_block_name: another_block
  ...
}
```

Все блоки исполняются в контексте контроллера и результат их выполнения записывается в поле context таблицы audit_log (по умолчанию это ChrnoAudit.config.default_context). Пример использования:

```ruby
class Page < ActiveRecord::Base
  audit :all, :context => {
      ip:         -> { request.remote_addr },
      :some_value -> { "value" }
    }
end
```

