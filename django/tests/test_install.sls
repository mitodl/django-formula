{% from "django/map.jinja" import django with context %}

{% for pkg in django.pkgs %}
test_{{pkg}}_is_installed:
  testinfra.package:
    - name: {{ pkg }}
    - is_installed: True
{% endfor %}
