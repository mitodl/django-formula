{% from "django/map.jinja" import django with context %}
{% set app_name = django.get('app_name', 'django_app') %}

{% if django.automatic_migrations %}
migrate_database:
  module.run:
    - name: django.command
    - settings_module: {{ django.settings_module }}
    - pythonpath: /opt/{{ app_name }}
    - command: migrate
    - bin_env: {{ django.django_admin_path }}
    - runas: {{ django.user }}
    - env: {{ django.get('environment', {}) }}
{% endif %}

collect_static_assets:
  module.run:
    - name: django.collectstatic
    - settings_module: {{ django.settings_module }}
    - pythonpath: /opt/{{ app_name }}
    - bin_env: {{ django.django_admin_path }}
    - runas: {{ django.user }}
    - env: {{ django.get('environment', {}) }}

{% set post_install_states = salt.pillar.get('django:states:post_install', []) %}
{% if post_install_states %}
include:
  {% for post_install_state in post_install_states %}
  - {{ post_install_state }}
  {% endfor %}
{% endif %}
