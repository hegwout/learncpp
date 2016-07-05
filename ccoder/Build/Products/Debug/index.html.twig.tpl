{% extends 'OroUIBundle:actions:index.html.twig' %}
{% import 'OroDataGridBundle::macros.html.twig' as dataGrid %}
{% set pageTitle = '{{Entity}}' %}
{% set gridName = '{{EntityLower}}-grid' %}

{% block navButtons %}
    <script type="text/javascript">
        require(['jquery','oroui/js/mediator'],function($,mediator){
            mediator.on('grid_load:complete', function () {
                $(".order_recent_change").each(function(){
                    $(this).parent("td").parent("tr").css("background-color","#9cbcf1");
                });
            });
        });
    </script>
    {% if resource_granted('{{EntityLower}}_create') %}
    <div class="btn-group" style="float:right;">
            {{BigParanthesesLeft}} UI.addButton({
                'path' : path('{{EntityLower}}_create'),
                'title' : 'appcoachs_{{BundleLower}}.{{EntityLower}}.create.label'|trans,
                'label' : 'appcoachs_{{BundleLower}}.{{EntityLower}}.create.label'|trans
            }) {{BigParanthesesRight}}
    </div>
    {% endif %}
    
   
{% endblock %}