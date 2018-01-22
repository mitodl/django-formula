{% set deploy_states = salt.pillar.get('django:states:deploy', []) %}
{% if deploy_states %}
include:
  {% for deploy_state in deploy_states %}
  - {{ deploy_state }}
  {% endfor %}
{% endif %}
