/*
* First Draft : Kuldeep Singh
* Modified By : 
* Test Class  :Test_enforceSingle_Crystalens_PPP_record
*
*/

trigger enforceSingle_Crystalens_PP_Program_record on Crystalens_Premium_Partnership_Program__c (before insert,before update) {

    set<id>pp_account =new set<id>();
    for(Crystalens_Premium_Partnership_Program__c cpp:trigger.new)
     {
        pp_account.add(cpp.account__c);
        system.debug('----------pp_account'+pp_account);     
     }
        
    List<Crystalens_Premium_Partnership_Program__c> cppprogram =new List<Crystalens_Premium_Partnership_Program__c>([select id,account__c from Crystalens_Premium_Partnership_Program__c where Account__c in:pp_account]);  
       system.debug('----------cppprogram'+cppprogram);     
        map<id,id>account_map =new map<id,id>();
        for(Crystalens_Premium_Partnership_Program__c c_program:cppprogram)
            {
                account_map.put(c_program.Account__c,c_program.id);                
            }
                    

           for(Crystalens_Premium_Partnership_Program__c cppp:trigger.new)
            {
                if(account_map.containskey(cppp.Account__c))
                {
                    cppp.adderror('A Crystalens Premium Partnership Program Record already exists for this account.  Please edit the existing record for this account.');
                    System.debug('--------cppprogram----------'+cppprogram);
                }
            }  
}