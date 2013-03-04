# chrno_audit

Простейшая реализация аудита для ActiveRecord.

## Установка

Добавьте в Gemfile:

```ruby
gem "chrno_audit"
```

и запустите `bundle install`. Затем нужно будет сгенерировать необходимые для работы файлы и создать таблицы в БД:

```console
rails g chrno_audit:install
rake db:migrate
```

Помните, что необходимо перезапустить приложение, если оно уже запущено.

## Пример использования

### Модель

После установки джема в моделях становится доступен метод `audit( *params )`, подключающий модель к системе аудита. В качестве параметров методу audit можно передавать список полей для аудита (по умолчанию все), например:

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

Можно указать список действий для аудита (create, update, destroy):

```ruby
class Page < ActiveRecord::Base
  audit :all, :when => [ :create ]
end
```

### Контроллер

После установки джема в контроллерах становятся доступны следующие методы:
  * `audit_context( proc_or_symbol = nil, &block )`: задаёт контекст аудита;
  * `create_audit_record!( context = {}, initiator = nil )`: создаёт запись в логе для текущего экшена;

Cохраняем в контексте текущего пользователя и его IP:

```ruby
class ApplicationController < ActionController::Base
  audit_context -> {{ ip: request.remote_addr, current_user: current_user }}
end
```

_NB:_ блок исполняется в контексте контроллера и обязан возврашать хеш!

Используем метод для генерации контекста:

```ruby
class ApplicationController < ActionController::Base
  audit_context :generate_context

  def generate_context
    { ip: request.remote_addr }
  end
end

class MyController < ApplicationController
  def generate_context
    super.merge { foo: "bar" }
  end
end
```

Генерируем запись в аудит-логе:

```ruby
...
def some_action
  create_audit_record!({ foo: "bar" }, current_user )
end
...
```

В качестве `auditable_type` будет использовано имя контроллера, а в качестве `action` — имя экшена ("some_action").