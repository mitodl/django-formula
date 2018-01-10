{% from "django/map.jinja" import django with context %}
{% set app_name = salt.pillar.get('django:app_name', 'django_app') %}

create_django_app_user:
  user.present:
    - name: {{ django.user }}
    - createhome: False

django_system_dependencies:
  pkg.installed:
    - pkgs: {{ django.pkgs }}
    - require_in:
        - service: django_service_running

{% if django.deploy_from_git %}
clone_app:
  git.latest:
    - name: {{ salt.pillar.get('django:git_repository') }}
    - target: /opt/{{ app_name }}
    - user: {{ django.user }}
{% else %}
unpack_release_archive:
  archive.extracted:
    - name: /opt
    - source: {{ salt.pillar.get('django:release_archive') }}
    - source_hash: {{ salt.pillar.get('django:release_archive_hash') }}
    - source_hash_update: True
    - user: {{ django.user }}
{% endif %}

install_python_requirements:
  pip.installed:
    - requirements: /opt/{{ app_name }}/{{ django.requirements_file }}

include:
  - {{ app_name }}.setup
