{% from "django/map.jinja" import django with context %}

django_service_running:
  service.running:
    - name: {{ django.service }}
    - enable: True
