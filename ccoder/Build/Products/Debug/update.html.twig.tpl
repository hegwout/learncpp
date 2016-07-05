{% extends 'OroUIBundle:actions:update.html.twig' %}

{% oro_title_set({params : {"%name%": form.vars.value.id|default('N/A') } }) %}

{% block navButtons %}
    {{BigParanthesesLeft}} UI.cancelButton(path('{{EntityLower}}_index')) {{BigParanthesesRight}}
    {% set html = UI.saveAndCloseButton() %}
    {% if form.vars.value.id or resource_granted('{{EntityLower}}_update') %}
        {% set html = html ~ UI.saveAndStayButton() %}
    {% endif %}
    {{BigParanthesesLeft}} UI.dropdownSaveButton({'html': html}){{BigParanthesesRight}}
{% endblock %}

{% block pageHeader %}
    {% if form.vars.value.id %}
        {% set breadcrumbs = {
        'entity':      form.vars.value,
        'indexPath':   path('{{EntityLower}}_index'),
        'indexLabel': 'appcoachs_{{BundleLower}}.{{EntityLower}}.{{EntityLower}}_title.label'|trans,
        'entityTitle': form.vars.value.id|default('N/A')
        }
        %}
    {% else %}
        {% set breadcrumbs = {
        'entity':      form.vars.value,
        'indexPath':   path('billing_index'),
        'indexLabel': 'appcoachs_{{BundleLower}}.{{EntityLower}}.{{EntityLower}}_title.label'|trans,
        'entityTitle': 'appcoachs_{{BundleLower}}.{{EntityLower}}.edit.label'|trans
        }
        %}
    {% endif %}
    {{BigParanthesesLeft}} parent() {{BigParanthesesRight}}
{% endblock pageHeader %}

{% block content_data %} 

    
    {% set id = '{{EntityLower}}-log' %}

    {% set title = 'oro.ui.edit_entity'|trans({'%{{EntityLower}}%': 'appcoachs_{{BundleLower}}.{{EntityLower}}.entity.label'|trans}) %}


    {% set basicInformation = [] %}
    {% set basicInformation = basicInformation|merge([{{#ONE_RESULT}}{{#FIELD_SECTION}}
    form_row(form.{{EntityField}}      ),{{/FIELD_SECTION}}{{/ONE_RESULT}}
    ]) %}
    
    {% set basicInformation = [{'data': basicInformation}] %}


    {% set dataBlocks = [{
    'title': 'Basic Information',
    'class': 'active',
    'subblocks': basicInformation
    }] %}

    {% set data = {
    'formErrors': form_errors(form)? form_errors(form) : null,
    'dataBlocks': dataBlocks
    } %}
    
    {{BigParanthesesLeft}} parent() {{BigParanthesesRight}}

{% endblock content_data %}