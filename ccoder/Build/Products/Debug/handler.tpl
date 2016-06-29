<?php
namespace Appcoachs\{{Bundle}}Bundle\Form\Handler;

use Psr\Log\LoggerInterface;
use Symfony\Component\Form\FormInterface;
use Symfony\Component\Form\FormFactory;
use Symfony\Component\HttpFoundation\Request;
use Doctrine\Common\Persistence\ObjectManager;
use Oro\Bundle\EntityBundle\Tools\EntityRoutingHelper;
use Appcoachs\{{Bundle}}Bundle\Entity\{{Entity}};
use Symfony\Component\Validator\Constraints\Valid;

class {{Entity}}Handler
{

    /** @var FormInterface */
    protected $form;

    /** @var string */
    protected $formName;

    /** @var string */
    protected $formType;

    /** @var Request */
    protected $request;

    /** @var ObjectManager */
    protected $manager;

    /** @var EntityRoutingHelper */
    protected $entityRoutingHelper;

    /** @var FormFactory */
    protected $formFactory;

    protected $session;

    /** @var LoggerInterface */
    protected $logger;

    protected $translator;

    /**
     * @param string                 $formName
     * @param string                 $formType
     * @param Request                $request
     * @param ObjectManager          $manager
     * @param EntityRoutingHelper    $entityRoutingHelper
     * @param FormFactory            $formFactory
     */
    public function __construct(
        $formName,
        $formType,
        Request $request,
        ObjectManager $manager,
        EntityRoutingHelper $entityRoutingHelper,
        FormFactory $formFactory,
        $session,
        LoggerInterface $logger,
        $translator,
        $kernel )
    {
        $this->formName            = $formName;
        $this->formType            = $formType;
        $this->request             = $request;
        $this->manager             = $manager;
        $this->entityRoutingHelper = $entityRoutingHelper;
        $this->formFactory         = $formFactory;
        $this->session             = $session;
        $this->logger              = $logger;
        $this->translator          = $translator;
        $this->kernel              = $kernel;
    }

    /**
     * Process form
     *
     * @param  {{Entity}} ${{EntityLower}}
     *
     * @return bool  True on successful processing, false otherwise
     */
    public function process({{Entity}} ${{EntityLower}})
    {

        $options = ['om' => 'default'];


        $this->form = $this->formFactory->createNamed($this->formName, $this->formType, ${{EntityLower}}, $options);
        $this->form->setData(${{EntityLower}});

        if (in_array($this->request->getMethod(), array('POST', 'PUT'))) {
            $this->form->submit($this->request);
            if ($this->form->isValid() ) {
                $result = $this->onSuccess(${{EntityLower}});
                return $result;
            }
        }

        return false;
    }

     
    /**
     * "Success" form handler
     *
     * @param {{Entity}} ${{EntityLower}}
     */
    public function onSuccess({{Entity}} ${{EntityLower}})
    {
        try{
            $id = ${{EntityLower}}->getId();
            $attachment = ${{EntityLower}}->getAttachment();
            if($attachment){
                $emptyFile = $attachment->isEmptyFile();
                if($emptyFile){
                    ${{EntityLower}}->setAttachment(null);
                }
            }

            $this->manager->persist(${{EntityLower}});
            $this->manager->flush();

        }catch(\Exception $e){
            $this->logger->error(sprintf('${{Entity}} error: %s',$e->getMessage()),
                ['exception' => $e]);
            $this->session->getFlashBag()->add(
                'error',
                'Data insert error,please try again!'
            );
            return false;
        }
        return true;
    }

     
    /**
     * Get form, that build into handler, via handler service
     *
     * @return FormInterface
     */
    public function getForm()
    {
        return $this->form;
    }
}