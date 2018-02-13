{% from "django/map.jinja" import django with context %}

{% set config_states = salt.pillar.get('django:states:config', []) %}
{% if config_states %}
include:
  {% for config_state in config_states %}
  - {{ config_state }}
  {% endfor %}
{% endif %}
