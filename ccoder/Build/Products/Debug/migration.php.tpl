<?php
namespace Appcoachs\{{Bundle}}Bundle\Migrations\Schema\V1.0;

use Doctrine\DBAL\Schema\Schema;
use Oro\Bundle\MigrationBundle\Migration\Migration;
use Oro\Bundle\MigrationBundle\Migration\QueryBag;

class Appcoachs{{Bundle}}Bundle implements Migration
{
    /**
     * @param Schema $schema
     * @param QueryBag $queries
     */
    public function up(Schema $schema, QueryBag $queries)
    {
        $this->complete{{Entity}}Table($schema,$queries);
    }
    /**
     * create {{TableName}} table
     * @param Schema $schema
     */
    private function complete{{Entity}}Table(Schema $schema,$queries)
    {
        $table = $schema->createTable('{{TableName}}');
        {{#ONE_RESULT}}{{#FIELD_SECTION}}
        $table->addColumn('{{Field}}',     '{{EntityFieldType}}', [{{#FieldLengthSection}}'length'=>{{FieldLength}},{{/FieldLengthSection}}{{#FieldPrecisionSection}}'precision' => {{FieldPrecision}},{{/FieldPrecisionSection}} {{#FieldPrimarySection}}'autoincrement' => true,{{/FieldPrimarySection}}{{#FieldNullSection}}'notnull' => false,{{/FieldNullSection}}{{#FieldDefaultSection}}'default' => {{FieldDefault}},{{/FieldDefaultSection}}]);
        {{/FIELD_SECTION}}{{/ONE_RESULT}}
        
        $table->setPrimaryKey(['id']);
        {{#TWO_RESULT}}{{#FIELD_SECTION}}
        $table->addForeignKeyConstraint('{{RefTableName}}',array('{{ColumnName}}'),array('{{RefColumnName}}'));
        {{/FIELD_SECTION}}{{/TWO_RESULT}}
        $queries->addPostQuery('ALTER TABLE {{TableName}} CHANGE COLUMN `created_at` `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ;');
        $queries->addPostQuery('ALTER TABLE {{TableName}} CHANGE COLUMN `updated_at` `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ;');
    }
}
