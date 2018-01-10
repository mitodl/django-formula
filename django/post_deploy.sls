{% from "django/map.jinja" import django with context %}

{% if django.automatic_migrations %}
migrate_database:
  module.run:
    django.command:
      - settings_module: {{ django.settings_file }}
      - command: migrate
        {% endif %}

collect_static_assets:
  module.run:
    django.command:
      - settings_module: {{ django.settings_file }}
      - command: collectstatic

include:
  - {{ app_name }}.post_install
