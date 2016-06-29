
    {{EntityLower}}-grid:
        source:
            type: orm
            query:
                select:
                {{#ONE_RESULT}}{{#FIELD_SECTION}}
                    - {{EntityAlias}}.{{EntityField}}{{/FIELD_SECTION}}{{/ONE_RESULT}}
                    
                from:
                    - { table: %appcoachs_{{BundleLower}}.entity.class%, alias: {{EntityAlias}} }
                join:
                    inner:
                        {{#TWO_RESULT}}{{#FIELD_SECTION}}
                        - { join: {{EntityAlias}}.{{RefTableName}}, alias: {{RefTableNameAlias}} }{{/FIELD_SECTION}}{{/TWO_RESULT}}

#                where:
#                    and:
#                        - b.deletedAt is null
        columns:{{#ONE_RESULT}}{{#FIELD_SECTION}}
            {{EntityField}}:
              label: appcoachs_{{BundleLower}}.{{EntityLower}}.{{Field}}.label{{#DATETIME_SECTION}}
              frontend_type: datetime{{/DATETIME_SECTION}}{{/FIELD_SECTION}}{{/ONE_RESULT}}

        sorters:
            columns:
            {{#ONE_RESULT}}{{#FIELD_SECTION}}
                {{EntityField}}:
                    data_name: {{EntityAlias}}.{{EntityField}}{{/FIELD_SECTION}}{{/ONE_RESULT}}
            default:
                id: %oro_datagrid.extension.orm_sorter.class%::DIRECTION_DESC
        filters:
            columns:{{#ONE_RESULT}}{{#FIELD_SECTION}}
                {{EntityField}}:
                    type: {{EntityType}}
                    data_name: {{EntityAlias}}.{{EntityField}}{{/FIELD_SECTION}}{{/ONE_RESULT}}

        properties:
            id: ~
            update_link:
                type:       url
                route:      {{EntityLower}}_update
                params:     [ id ]
            delete_link:
                type:       url
                route:      {{EntityLower}}_delete
                params:     [ id ]
            view_link:
                type:       url
                route:      {{EntityLower}}_view
                params:     [ id ]
        actions:
            update:
                type:          navigate
                label:         oro.grid.action.update
                icon:          edit
                link:          update_link
                acl_resource:  {{EntityLower}}_update
            delete:
                type:          ajaxdelete
                label:         oro.grid.action.delete
                icon:          trash
                link:          delete_link
                acl_resource:  {{EntityLower}}_delete
            view:
                type:          navigate
                label:         oro.grid.action.view
                link:          view_link
                icon:          eye-open
                rowAction:     true
                acl_resource:  {{EntityLower}}_index