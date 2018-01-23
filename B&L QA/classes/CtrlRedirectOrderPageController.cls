public class CtrlRedirectOrderPageController {
 
    public CtrlRedirectOrderPageController(ApexPages.StandardController controller) {
        this.controller = controller;
    }
 
    public PageReference getRedir() {
        Order_Header__c o = [Select Name From Order_Header__c Where Id = :ApexPages.currentPage().getParameters().get('id')];
        PageReference newPage;
        newPage = Page.CtrlOrderTracking_Search;
        String sName = o.Name;
        newPage.getParameters().put('bu', sName.substring(0,5));
        newPage.getParameters().put('orderNo', sName.substring(6,sName.length()));
        return newPage.setRedirect(true);
     }
 
    private final ApexPages.StandardController controller;
 }