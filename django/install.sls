{% from "django/map.jinja" import django with context %}
{% set app_name = django.get('app_name', 'django_app') %}
{% set app_source = django.app_source %}

create_django_app_user:
  user.present:
    - name: {{ django.user }}
    - createhome: True
    - shell: /bin/bash

django_system_dependencies:
  pkg.installed:
    - pkgs: {{ django.pkgs|json }}

create_deployment_target_directory:
  file.directory:
    - name: /opt/{{ app_name }}
    - user: {{ django.user }}
    - group: {{ django.group }}
    - recurse:
        - user
        - group
    - require:
        - user: create_django_app_user
    - require_in:
      - {{ app_source.type }}: deploy_application_source_to_destination

{% set deploy_source = {
    'git': [
        'latest',
        {'user': django.user},
        {'name': app_source.repository_url},
        {'rev': app_source.get('revision', 'master')},
        {'target': '/opt/{app}/'.format(app=app_name)},
        {'branch': app_source.get('branch')},
        {'failhard': True},
        {'require': [
            {'user': 'create_django_app_user'}
          ]
        }
    ],
    'hg': [
        'latest',
        {'user': django.user},
        {'name': app_source.repository_url},
        {'rev': app_source.get('revision', 'master')},
        {'target': '/opt/{app}/'.format(app=app_name)},
        {'failhard': True},
        {'require': [
            {'user': 'create_django_app_user'}
          ]
        }
    ],
    'archive': [
        'extracted',
        {'name': '/opt/{app}/'.format(app=app_name)},
        {'source': app_source.repository_url},
        {'failhard': True},
        {'require': [
            {'user': 'create_django_app_user'}
          ]
        }
    ]
} %}
{% set source_state = deploy_source[app_source.type] + app_source.get('state_params', []) %}

deploy_application_source_to_destination:
  {{ app_source.type }}:
    {{ source_state|yaml }}

install_python_requirements:
  pip.installed:
    - requirements: /opt/{{ app_name }}/{{ django.requirements_file }}
    - bin_env: {{ django.pip_path }}
    - require:
        - {{ app_source.type }}: deploy_application_source_to_destination

{% set setup_states = salt.pillar.get('django:states:setup', []) %}
{% if setup_states %}
include:
  {% for setup_state in setup_states %}
  - {{ setup_state }}
  {% endfor %}
{% endif %}
