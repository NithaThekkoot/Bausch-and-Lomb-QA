/**
* 
*   This Controller is created for alterative to the new contact button on Account-Contact relationship to work on Salesforce 1 APP.
*   Testclass: test_New_Contact
*
*   Author            |Author-Email                                   |Date       |Comment
*   ---------------   |-----------------------------------------------|-----------|--------------------------------------------------------------------------- 
*   Hanmanthu Kottala |hanmanthu.kottala@bausch.com                   |05.12.2016 |First Draft
*   
*/
public class Ctl_contact {
  
    public pagereference getAcctname()
    {
        // Accid is get from URL, which is provided on custom buttom
        
            ID act_Id=apexpages.currentPage().getParameters().get('acctid');
      //Display account id
      system.debug('account id'+act_Id);
        return new pagereference('/003/e?retURL=%2F'+act_Id+'&accid='+act_Id);
        
    }

}