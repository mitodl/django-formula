{% from "django/map.jinja" import django with context %}

include:
  - .install
  - .service

django-config:
  file.managed:
    - name: {{ django.conf_file }}
    - source: salt://django/templates/conf.jinja
    - template: jinja
    - watch_in:
      - service: django_service_running
    - require:
      - pkg: django
