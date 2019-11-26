public with sharing class ModalPageController {

    public Boolean rend {get;set;}
    public Boolean rend1 {get;set;}

    public ModalPageController(ApexPages.StandardController controller) {
        rend = false;
    }
    
    public ModalPageController() {
        rend = false;
    }

    public void commandLinkAction() {
        rend=true;
        rend1=false;
    }
    
    public void commandLinkAction1() {
        rend1=true;
        rend=false;
    }

}