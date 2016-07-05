<?php

namespace Appcoachs\{{Bundle}}Bundle\Controller;

use Oro\Bundle\SecurityBundle\Annotation\AclAncestor;
use Appcoachs\{{Bundle}}Bundle\Entity\{{Entity}};
use Rhumsaa\Uuid\Console\Exception;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template; 
use Oro\Bundle\UserBundle\Entity\User;
use Symfony\Component\Yaml\Parser;

/**
 * Class {{Entity}}Controller
 * @package Appcoachs\{{Bundle}}Bundle\Controller
 * @Route("/{{EntityLower}}")
 */
class {{Entity}}Controller extends Controller
{
    /**
     * @Route("/index",name="{{EntityLower}}_index")
     * @AclAncestor("{{EntityLower}}_index")
     * @Template()
     */
    public function indexAction()
    {
        return array(

        );
    }

     
    /**
     * @Route("/view/{id}",name="{{EntityLower}}_view")
     * @AclAncestor("{{EntityLower}}_index")
     * @Template()
     */
    public function viewAction({{Entity}} ${{EntityLower}})
    {
        return array(
            'entity'    => ${{EntityLower}}
        );
    }

       
    /**
     * @Route("/create", name="{{EntityLower}}_create")
     * @AclAncestor("{{EntityLower}}_create")
     * @Template("Appcoachs{{Bundle}}Bundle:{{Entity}}:update.html.twig")
     */
    public function createAction(Request $request)
    {
        $formAction = $this->get('oro_entity.routing_helper')
            ->generateUrlByRequest('{{EntityLower}}_create', $request);
        ${{EntityLower}} = new {{Entity}}();
        $currentTime = new \DateTime();
        ${{EntityLower}}->setCreatedAt($currentTime);
        ${{EntityLower}}->setUpdatedAt($currentTime);
        ${{EntityLower}}->setCreator($this->getUser());
        ${{EntityLower}}->setUpdatedUser($this->getUser());

        return $this->update($request,${{EntityLower}}, $formAction);
    }

    /**
     * @Route("/update/{id}",name="{{EntityLower}}_update",requirements={"id"="\d+"})
     * @AclAncestor("{{EntityLower}}_update")
     * @Template()
     */
    public function updateAction({{Entity}} ${{EntityLower}},Request $request)
    {
         
        $formAction = $this->get('router')->generate('{{EntityLower}}_update', ['id' => ${{EntityLower}}->getId()]);
        $currentTime = new \DateTime();
        ${{EntityLower}}->setUpdatedAt($currentTime);
        ${{EntityLower}}->setUpdatedUser($this->getUser());
        return $this->update($request,${{EntityLower}}, $formAction);
    }

    /**
     * @Route("/delete/{id}",name="{{EntityLower}}_delete")
     * @AclAncestor("{{EntityLower}}_delete")
     * @Template()
     */
    public function deleteAction($id)
    {
        $manager = $this->getDoctrine()->getManager();
        ${{EntityLower}} = $manager->getRepository('Appcoachs\{{Bundle}}Bundle\Entity\{{Entity}}')->findById($id);

        if(!${{EntityLower}}){
            $data = array('successful'=>false,
                'message'=>$this->get('translator')->trans('appcoachs_{{BundleLower}}.{{EntityLower}}.not_found.message.label')
            );
            return new JsonResponse($data,200);
        }

        
        $manager->getConnection()->beginTransaction();
        try{
            $manager->remove(${{EntityLower}});
            $manager->flush();
            $manager->getConnection()->commit();
        }catch(\Exception $e){
            $manager->getConnection()->rollback();
            $data = array('successful'=>false,
                'message'=>'Data delete error,please try again!'
            );
            return new JsonResponse($data,200);
        }
        $data = array('successful'=>true,
            'message'=> $this->get('translator')->trans('appcoachs_{{BundleLower}}.{{EntityLower}}.deleted.message.label')
        );
        return new JsonResponse($data,200);

    }

     

    /**
     * @param {{Entity}} ${{EntityLower}}
     * @param $formAction
     * @return array
     */
    protected function update(Request $request,{{Entity}} ${{EntityLower}}, $formAction)
    {
        $saved = false;

        if ($this->get('appcoachs_{{BundleLower}}.form.handler.{{EntityLower}}')->process(${{EntityLower}})) {
            if (!$request->get('_widgetContainer')) {
                $this->get('session')->getFlashBag() ->add(
                    'success',
                    $this->get('translator')->trans('appcoachs_{{BundleLower}}.{{EntityLower}}.saved.message.label')
                );

                return $this->get('oro_ui.router')->redirectAfterSave(
                    ['route' => '{{EntityLower}}_update', 'parameters' => ['id' => ${{EntityLower}}->getId()]],
                    ['route' => '{{EntityLower}}_view','parameters' => ['id' => ${{EntityLower}}->getId()]],
                    ${{EntityLower}}
                );
            }
            $saved = true;
        }

        return array(
            'entity'     => ${{EntityLower}},
            'saved'      => $saved,
            'form'       => $this->get('appcoachs_contract.form.handler.{{EntityLower}}')->getForm()->createView(),
            'formAction' => $formAction
        );
    }



       
      

}