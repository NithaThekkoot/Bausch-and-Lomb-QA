public with sharing class Product_Complaint_Reminder {

/*
* 
* Extension for the VisualForce section that gets displayed on the Product Case pages
* If there is a product for the case, the message is blank. Else, message displays.
* 
* Author              |Author-Email                    |Date        |Comment
* --------------------|------------------------------- |------------|----------------------------------------------------
* Craig Stanton       |craig.stanton@bausch.com        |26-Oct-2011 |Initial release 
*
*/
    public Case objectCase {get;set;}   
    public Id CurrentPageId;
    public String message {get;set;}
    public List <Product_Complaint_Product__c> products {get; set;}
    
        
    public Product_Complaint_Reminder(ApexPages.StandardController controller) {
        objectCase = new Case();        
        CurrentPageId = ApexPages.CurrentPage().getParameters().get('Id'); 
               
        products = [select id from Product_Complaint_Product__c where Case__c =:CurrentPageId];
        
        if(products.size() == 0) {
            //system.debug('****************** NO PRODUCTS! ********************');
            message = 'REMEMBER TO ADD A PRODUCT!';
        }
        
        else {
            //system.debug('****************** MORE THAN 1 PRODUCT!! *********************');
            message = '';
        }                  
    }
}