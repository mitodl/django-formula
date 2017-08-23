{% from "django/map.jinja" import django with context %}

include:
  - .service

django:
  pkg.installed:
    - pkgs: {{ django.pkgs }}
    - require_in:
        - service: django_service_running
