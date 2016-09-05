{% extends 'OroUIBundle:actions:view.html.twig' %}
{% import 'OroUIBundle::macros.html.twig' as UI %}
{% import 'OroDataGridBundle::macros.html.twig' as dataGrid %}
{% oro_title_set({params : {"%name%": entity.billingNo } }) %}
{% block navButtons %}
    
        {{BigParanthesesLeft}}UI.editButton({
            'path' : path('{{EntityLower}}_update', { id: entity.id }),
            'entity_label': 'oro.user.entity_label'|trans
        }){{BigParanthesesRight}} 
    
{% endblock navButtons %}

{% block pageHeader %}
    {% set breadcrumbs = {
    'entity':      entity,
    'indexPath':   path('{{EntityLower}}_index'),
    'indexLabel': 'appcoachs_{{BundleLower}}.{{EntityLower}}.{{EntityLower}}_title.label'|trans,
    'entityTitle': 'appcoachs_{{BundleLower}}.{{EntityLower}}.view.label'|trans
    } %}
    {{BigParanthesesLeft}} parent(){{BigParanthesesRight}}
{% endblock pageHeader %}

{% block stats %}
    <li>{{BigParanthesesLeft}} 'appcoachs_{{BundleLower}}.{{EntityLower}}.created_at.label'|trans {{BigParanthesesRight}}: {{BigParanthesesLeft}} entity.createdAt ? entity.createdAt|oro_format_datetime : 'N/A' }}</li>
    <li>{{BigParanthesesLeft}} 'appcoachs_{{BundleLower}}.{{EntityLower}}.updated_at.label'|trans {{BigParanthesesRight}}: {{BigParanthesesLeft}} entity.updatedAt ? entity.updatedAt|oro_format_datetime : 'N/A' }}</li>
{% endblock stats %}

{% block content_data %}

    {% set id = '{{EntityLower}}view' %}
    {% set {{EntityLower}}InformationWidget %}
        <div class="contact-widget-wrapper">
            <div class="widget-content">
                <div class="row-fluid form-horizontal">
                    <div class="responsive-block">
                    {{#ONE_RESULT}}{{#FIELD_SECTION}}
                        {{BigParanthesesLeft}} UI.renderProperty('appcoachs_{{BundleLower}}.{{EntityLower}}.owner.label'|trans, entity.{{EntityField}}){{BigParanthesesRight}}
                        {{/FIELD_SECTION}}{{/ONE_RESULT}} 
                    </div>
                </div>
            </div>
        </div>
    {% endset %}
   
    {% set dataBlocks =
        [
            {
                'title':'{{Entity}} Information',
                'class':'',
                'subblocks':[
                    {'title':'','data':[{{EntityLower}}InformationWidget]},
            ]}
        ] 
    %}
    {% set data = {'dataBlocks': dataBlocks} %}

    {{BigParanthesesLeft}} parent() {{BigParanthesesRight}}


{% endblock content_data %}