/*
* Created By : VIJAY SINGH
* Test Class : TestClsProduct_AIU_GetLocalProductName
*/
trigger Product_AIU_GetLocalProductName on Product_Complaint_Product__c (before insert, before update) {        
         
         list<profile> aprofile = new list<profile>([select id,name from profile where name ='BL: Integration User' limit 1]);
         
         if(!aprofile.isEmpty())
         {          
            if(Userinfo.getProfileId() == aprofile[0].id)
            {               
                set<id> Caseids = new set<id>();
                List<string> ProductType  = new List<string>(); 
                for(Product_Complaint_Product__c PCP :Trigger.new){                                                                         
                    Caseids.add(PCP.Case__c);  
                    ProductType.add(PCP.Product_Type__c);           
                }

                Map<Id,Case> lstCase = new Map<Id,Case>([select id ,CaseNumber,Business_Unit__c,Product_Category__c,Line_of_Business__c,Contact_Type__c from Case where Id In :Caseids]);
                List<string> BUnits = new List<string>();                                        
                for(Case cs :lstCase.values()){
                    BUnits.add(cs.Business_Unit__c);                    
                }

                list<Product_Complaint_Product_Type__c> AllProdType = [select id,name,Business_Unit__c,Category__c,Local_Name__c,Global_Name__c from Product_Complaint_Product_Type__c 
                                                                where Business_Unit__c in:BUnits And Global_Name__c In :ProductType];
                
                //Create Map For Check Business Unit &&  Product Type
                Map<string,Product_Complaint_Product_Type__c> mapMatchBothCondition = new Map<string,Product_Complaint_Product_Type__c>();
                
                if(AllProdType.size() >0){
                    for(Product_Complaint_Product_Type__c PCPT :AllProdType){           
                    if(!mapMatchBothCondition.containsKey(PCPT.Business_Unit__c+PCPT.Global_Name__c)){
                            mapMatchBothCondition.put(PCPT.Business_Unit__c+PCPT.Global_Name__c , PCPT);
                        }                                                                  
                    }
                                                                                                            
                    for(Product_Complaint_Product__c PCP : trigger.new){
                        Case cs = lstCase.get(PCP.Case__c);
                        if(mapMatchBothCondition.containsKey(cs.Business_Unit__c+PCP.Product_Type__c))                  
                        PCP.Product_Description__c = mapMatchBothCondition.get(cs.Business_Unit__c+PCP.Product_Type__c).Local_Name__c;          
                    }               
               }
            }
         }                                 
}