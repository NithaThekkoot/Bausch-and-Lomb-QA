/*
* First Draft : Kuldeep Singh
* Modified By : 
* Test Class for Trigger :enforceSingle_Crystalens_PP_Program_record 
*
*/


@isTest
Private Class Test_enforceSingle_Crystalens_PPP_record
    {

    Static TestMethod void Test_enforceSingle_Crystalens_PPP_record()
        {
             
            Account acc =new Account(name='Test123');
            insert acc;
            
            Crystalens_Premium_Partnership_Program__c cppp=new Crystalens_Premium_Partnership_Program__c(Account__c=acc.id);
            insert cppp;
            
            //Crystalens_Premium_Partnership_Program__c cpp=new Crystalens_Premium_Partnership_Program__c(Account__c=acc.id);             
            //insert cpp;            
        }
    }