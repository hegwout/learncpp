<?php
namespace Appcoachs\{{Bundle}}Bundle\Entity;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use Oro\Bundle\EntityConfigBundle\Metadata\Annotation\Config;
use Oro\Bundle\EntityConfigBundle\Metadata\Annotation\ConfigField;
use Oro\Bundle\OrganizationBundle\Entity\BusinessUnit;
use Oro\Bundle\UserBundle\Entity\User;


/**
* Class {{Entity}}
* @package Appcoachs\{{Bundle}}Bundle
* @ORM\Entity(repositoryClass="Appcoachs\{{Bundle}}Bundle\Entity\Repository\{{Entity}}Repository")
* @ORM\Table(name="{{TableName}}",uniqueConstraints={@ORM\UniqueConstraint(name="pk_id",columns={"id"})})
* @Config(
*      defaultValues={
*          "ownership"={
*              "owner_type"="USER",
*              "owner_field_name"="owner",
*              "owner_column_name"="owner_id",
*              "organization_field_name"="organization",
*              "organization_column_name"="organization_id"
*          },
*          "security" = {
*              "type"="ACL",
*              "group_name"=""
*          },
*          "dataaudit"={
*              "auditable"=true
*          },
*      }
* )
*/
class {{Entity}}{

    {{#ONE_RESULT}}
    {{#FIELD_SECTION}}
    /**
    * @var {{EntityFieldType}}
    * @ORM\Column(name="{{Field}}",type="{{EntityFieldType}}"{{#FieldNullSection}},nullable=TRUE{{/FieldNullSection}}){{#FieldPrimarySection}}
    * @ORM\Id
    * @ORM\GeneratedValue(strategy="AUTO"){{/FieldPrimarySection}}
    */
    private ${{EntityField}};
    {{/FIELD_SECTION}}
    {{/ONE_RESULT}}

    {{#ONE_RESULT}}
    {{#FIELD_SECTION}}
    /**
     * Set {{EntityField}}
     *
     * @param {{EntityFieldType}} ${{EntityField}}
     * @return {{Entity}}
     */
    public function set{{FieldMethodName}}(${{EntityField}})
    {
        $this->{{EntityField}} = ${{EntityField}};

        return $this;
    }
    /**
     * Get {{EntityField}}
     *
     * @return {{EntityFieldType}}
     */
    public function get{{FieldMethodName}}()
    {
        return $this->{{EntityField}};
    }
    {{/FIELD_SECTION}}
    {{/ONE_RESULT}}

   
}