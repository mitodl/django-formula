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

{% set post_install_states = salt.pillar.get('django:states:post_install', []) %}
{% if post_install_states %}
include:
  {% for post_install_state in post_install_states %}
  - {{ post_install_state }}
  {% endfor %}
{% endif %}
