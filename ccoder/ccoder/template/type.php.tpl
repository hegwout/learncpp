<?php
namespace Appcoachs\{{Bundle}}Bundle\Form\Type;

use Doctrine\ORM\EntityRepository;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;
use Appcoachs\{{Bundle}}Bundle\Entity\{{Entity}};


class {{Entity}}Type extends AbstractType
{

    protected $translator;

    public function __construct(
        $translator
    )
    {

        $this->translator = $translator;
    }
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
        	{{#ONE_RESULT}}
        	{{#FIELD_SECTION}}
            ->add('{{EntityField}}','{{FieldFormType}}',array({{#FieldRequiredSection}}
                'required' => true,{{/FieldRequiredSection}}
                'label' => 'appcoachs_{{BundleLower}}.{{EntityLower}}.{{Field}}.label',
            ))
            {{/FIELD_SECTION}}
            {{/ONE_RESULT}}
            
        ;
    }

    /**
     * @param OptionsResolverInterface $resolver
     */
    public function setDefaultOptions(OptionsResolverInterface $resolver)
    {
        $resolver->setDefaults(
            [
                'data_class'        => 'Appcoachs\{{Bundle}}Bundle\Entity\{{Entity}}',
            ]
        )->setRequired(array('om'));
    }

    /**
     * @return string
     */
    public function getName()
    {
        return "appcoachs_{{BundleLower}}_{{EntityLower}}_form";
    }
}