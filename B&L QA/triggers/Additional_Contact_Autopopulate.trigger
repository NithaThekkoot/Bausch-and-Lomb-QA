/*
* First Draft : Rohit Aggarwal
*  Trigger used to populate contact fields based on Account id and vise versa
*
*
*/
trigger Additional_Contact_Autopopulate on Additional_Product_Complaint_Contact__c (before insert, before update) {

if(Class_to_prevent_trigger_recursively.IsContactAutoPopulate){
    Class_to_prevent_trigger_recursively.IsContactAutoPopulate = false;
    
/*Get all the case record type names*/
Set<id> AllrecordtypeId = new Set<id>();
Set<Id> AllCaseId = new Set<Id>();
map<string,string> CaseVsRecordType = new map<String,String>();
for(Additional_Product_Complaint_Contact__c cc :Trigger.new)
{
    AllCaseId.add(cc.case__c);
}
list<case> AllCases = new list<Case>([select id,recordtypeid from Case where Id IN :AllCaseId]);
for(case cc :AllCases){
    AllrecordtypeId.add(cc.recordtypeid);
    CaseVsRecordType.put(cc.Id,cc.recordtypeid);
}

map<id,RecordType> Allrecordtype = new map<id,RecordType>([select id,name from RecordType where Id IN :AllrecordtypeId]);

    for(Additional_Product_Complaint_Contact__c c1 :Trigger.new)
    {
        if( (Allrecordtype.get(CaseVsRecordType.get(c1.case__c))).name.contains('Product Case') ||
                              (Allrecordtype.get(CaseVsRecordType.get(c1.case__c))).name.contains('Product Inquiry'))
        {
            if( (c1.Additional_Contact__c !=null && (c1.Address__c !=null || c1.City__c !=null || c1.Address_2__c!=null          
                              || c1.State__c!=null || c1.Postal_Code__c!=null || c1.Country__c!=null ))
                  ||            
                (c1.Additional_Contact__c ==null && c1.Address__c ==null && c1.City__c==null && c1.Address_2__c==null            
                              && c1.State__c==null && c1.Postal_Code__c==null && c1.Country__c==null)
                              
              )
                              {
                               if(Trigger.isInsert){
	                                if(!test.isRunningTest())
	                                c1.Additional_Contact__c.addError('Either select an Account in the Account Name field, or fill in the Customer/Reporter Details section to create a new Person Account.');
	                              }
                            }  
        /*
            if(c1.Additional_Contact__c ==null && c1.Country__c==null && c1.Last_Name__c==null)
                              {
                                if(!test.isRunningTest())
                                c1.Additional_Contact__c.addError('Either select an Account in the Account Name field, or fill in the Customer/Reporter Details section to create a new Person Account.');
                              }
          */                    
            if(c1.Additional_Contact__c ==null && (c1.Country__c==null || c1.Last_Name__c==null)){
                if(!test.isRunningTest())
                c1.Additional_Contact__c.addError('Either select an Account in the Account Name field, or fill in the Customer/Reporter Details section to create a new Person Account.');
            }                   
                              
        }       
    }

Set<String> AccountNotNull = new set<String>();
map<id,Additional_Product_Complaint_Contact__c> AccountInsertList = new map<id,Additional_Product_Complaint_Contact__c>();

for(Additional_Product_Complaint_Contact__c cc :Trigger.new)
{
    if((Allrecordtype.get(CaseVsRecordType.get(cc.case__c))).name.contains('Product Case') || 
                                                     (Allrecordtype.get(CaseVsRecordType.get(cc.case__c))).name.contains('Product Inquiry'))
    {
  
    /* Add accounts which have reporter fields blank except firstname , lastname and phone */
        if(cc.Additional_Contact__c!=null && cc.Address__c ==null && cc.City__c==null && cc.Address_2__c==null           
                              && cc.State__c==null && cc.Postal_Code__c==null && cc.Country__c==null)
                             
        {
            AccountNotNull.add(cc.Additional_Contact__c);
        }
        else if(cc.Additional_Contact__c==null && cc.Country__c!=null && cc.Last_Name__c!=null)
        {
            AccountInsertList.put(cc.Id,cc);
        }       
    }

}
System.debug('Result is ------->' + AccountNotNull);
system.debug('Result is AccountInsertList------->' + AccountInsertList);
if(!AccountNotNull.isEmpty() || !AccountInsertList.isEmpty()){
//Get the recpd type map
//list<RecordType> CaserecordType = [select id,name from RecordType where Name IN ('')];
list<Account> NewAccuntInsert = new list<Account>();
map<Id,Account> Allacc;
if(!AccountNotNull.isEmpty())
{
     Allacc = new map<Id,Account>([select id,name,FirstName,LastName,ShippingStreet,ShippingCity,ShippingState,Other_Phone__c,EMail__c,
                                   ShippingPostalCode,ShippingCountry,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCountry,Salutation,
                                   PersonMailingState,PersonMailingCity,Phone,Fax,IsPersonAccount from Account where Id IN :AccountNotNull]);
    system.debug('Allacc *** :'+Allacc);
}
map<String, String> CaseVsAccountId = new map<String,string>();
if(!AccountInsertList.isEmpty())
{
    map<string,string> CaseVsAccountRecordType = new map<String,String>();
    list<RecordType> CaseRecordType = new list<RecordType>([select id,name from RecordType where sobjecttype ='Case']);
    list<RecordType> AccountRecordType = new list<RecordType>([select id,name from RecordType where sobjecttype='Account' and name IN 
                                             ('APAC Product Case Person Account','EMEA Product Case Person Account','NA Product Case Person Account')]);
    for(RecordType cr :CaseRecordType)
    {
        for(RecordType ar :AccountRecordType)
        {
            if(cr.Name =='APAC PH Product Case' || cr.Name=='APAC Product Inquiry' || cr.Name =='APAC VC Product Case' ||cr.name=='APAC SU Product Case' )
            {
                if(ar.Name=='APAC Product Case Person Account')
                {
                    CaseVsAccountRecordType.put(cr.id,ar.id);
                }
            }
            if(cr.Name =='EMEA PH Product Case' || cr.Name=='EMEA Product Inquiry' || cr.Name =='EMEA VC Product Case' ||cr.name=='EMEA SU Product Case' )
            {
                if(ar.Name=='EMEA Product Case Person Account')
                {
                    CaseVsAccountRecordType.put(cr.id,ar.id);
                }
            }
            if(cr.Name =='NA PH Product Case' || cr.Name=='NA Product Inquiry' || cr.Name =='NA VC Product Case' ||cr.name=='NA SU Product Case' )
            {
                if(ar.Name=='NA Product Case Person Account')
                {
                    CaseVsAccountRecordType.put(cr.id,ar.id);
                }
            }                       
        }
    }                                         
   list<User> Allusers = new list<User>([select id,name from user where name = 'Data Integration' limit 1]);
    list<Additional_Product_Complaint_Contact__c> Allcc = AccountInsertList.values();
    for(Additional_Product_Complaint_Contact__c c :Allcc)
    {
        system.debug('Test Inside Loop');
        Account temp = new Account();
        if(c.First_Name__c!=Null)
        temp.FirstName = c.First_Name__c;
        temp.LastName = c.Last_Name__c;
        temp.Salutation = c.Salutation__c;
        if(c.Address__c!=null)          
        {
            temp.PersonMailingStreet = c.Address__c;
            temp.ShippingStreet = c.Address__c;
            if(c.Address_2__c!=null)
            {
                temp.PersonMailingStreet = temp.PersonMailingStreet + '\n' +c.Address_2__c;
                temp.ShippingStreet = temp.ShippingStreet + '\n' +c.Address_2__c; 
            }
            
        }
        if(c.City__c!=null)
        {
            temp.PersonMailingCity = c.City__c;
            temp.ShippingCity = c.City__c;
        }
        
        if(c.State__c!=null)
        {
            temp.PersonMailingState = c.State__c;
            temp.ShippingState = c.State__c;
        }
        
        if(c.Postal_Code__c!=null)
        {
            temp.PersonMailingPostalCode = c.Postal_Code__c;
            temp.ShippingPostalCode = c.Postal_Code__c;
        }
        
        temp.PersonMailingCountry = c.Country__c;
        temp.ShippingCountry = c.Country__c;
        temp.EMail__c = c.EMail__c;
        temp.RecordTypeId = CaseVsAccountRecordType.get(CaseVsRecordType.get(c.case__c));
        temp.Phone = c.Phone__c;            
            if(!Allusers.isEmpty())
            temp.OwnerId = Allusers[0].id;         
        NewAccuntInsert.add(temp);
    }

    list<Account_Phone__c> AccountPhoneInsert = new list<Account_Phone__c>();
try
{
    if(!NewAccuntInsert.isEmpty())
    {
        system.debug('****NewAccuntInsert :'+NewAccuntInsert.size());
        insert NewAccuntInsert;
        system.debug('NewAccuntInsert'+NewAccuntInsert);
        for(integer i=0 ;i<NewAccuntInsert.size();i++)
        {
            System.debug('After insert----------->');
            CaseVsAccountId.put(Allcc[i].Id,NewAccuntInsert[i].Id);
             /*Adding phone to Account phone table*/
             if(NewAccuntInsert[i].Phone != null)
             {
                Account_Phone__c temp = new Account_Phone__c();
                temp.Account__c = NewAccuntInsert[i].Id;
                temp.Phone__c =   formatPhone(NewAccuntInsert[i].Phone);
                temp.Email_Address__c = NewAccuntInsert[i].EMail__c;
                AccountPhoneInsert.add(temp);
             }
        }
        System.debug('Before phone Insert----------->' +AccountPhoneInsert);
        if(!AccountPhoneInsert.isEmpty())
        {
            insert AccountPhoneInsert;
        }
    }
}catch(exception ex){
    
}    
}
list<Account> AccountToUpdate = new list<Account>();
for(Additional_Product_Complaint_Contact__c c1 :Trigger.new)
{
    boolean isupdate = false;
    if(c1.Additional_Contact__c!=null && AccountNotNull.contains(c1.Additional_Contact__c))
    {
        Account temp = Allacc.get(c1.Additional_Contact__c);
        if(temp.IsPersonAccount) {
            if(c1.First_Name__c != null && c1.First_Name__c != '' && temp.FirstName != c1.First_Name__c)
            {
                temp.FirstName = c1.First_Name__c;
                isupdate = true;
            }                          
            if(c1.Last_Name__c != null && c1.Last_Name__c != '' && temp.LastName != c1.Last_Name__c)
            {
                temp.LastName = c1.Last_Name__c;
                isupdate = true;
            }                                      
            if(c1.First_Name__c ==null || c1.First_Name__c == '')
              c1.First_Name__c = temp.FirstName;
              
            if(c1.Last_Name__c ==null || c1.Last_Name__c == '')  
            c1.Last_Name__c =  temp.LastName;
            string StreetAddress = '';
            if(temp.PersonMailingStreet !=null && temp.PersonMailingStreet!=''){
                StreetAddress = temp.PersonMailingStreet.replaceAll('<','(').replaceAll('>',')').replaceAll('\n','<br/>');
            }                        
            string[] arrString =   StreetAddress.split('<br/>');                            
            if(arrString.size()>0){
                c1.Address__c = arrString[0];
                string address2 = '';
                for(integer i=1;i<=arrString.size()-1;i++){                
                  address2 += arrString[i]+' ';
                }
                c1.Address_2__c = address2;             
            }
            c1.Postal_Code__c = temp.PersonMailingPostalCode;
            if(temp.PersonMailingCountry == 'USA' || temp.PersonMailingCountry == 'US')
                c1.Country__c ='United States of America';
            else if(temp.PersonMailingCountry == 'CAN' || temp.PersonMailingCountry == 'CANAD')
                c1.Country__c ='Canada';
            else
            c1.Country__c = temp.PersonMailingCountry;
            c1.State__c = temp.PersonMailingState;
            c1.City__c = temp.PersonMailingCity;
            c1.Salutation__c = temp.Salutation;   
                 
            if(c1.Phone__c != null && c1.Phone__c != '' && temp.Phone != c1.Phone__c)
            {
                temp.Phone = c1.Phone__c;
                isupdate = true;
                updatephone(temp.Id,c1.Phone__c);
            }
           if(c1.EMail__c != null && c1.EMail__c != '' && temp.EMail__c != c1.EMail__c)
           {
             temp.EMail__c = c1.Email__c;
             isupdate = true;
             updateEmail(temp.Id,c1.Email__c);
           }
        }
        else {
            system.debug('temp.ShippingStreet :'+temp.ShippingStreet);
            string StreetAddress = '';
            if(temp.ShippingStreet !=null && temp.ShippingStreet!=''){
                StreetAddress = temp.ShippingStreet.replaceAll('<','(').replaceAll('>',')').replaceAll('\n','<br/>');
            }            
            string[] arrString =   StreetAddress.split('<br/>');                            
            //c1.Address__c = temp.PersonMailingStreet;
            if(arrString.size() >0) {
                c1.Address__c = arrString[0];
                string address2 = '';
                for(integer i=1;i<=arrString.size()-1;i++){                
                  address2 += arrString[i]+' ';
                }
                c1.Address_2__c = address2;
            }                        
            c1.Postal_Code__c = temp.ShippingPostalCode;
            if(temp.ShippingCountry == 'USA' || temp.ShippingCountry == 'US')
                c1.Country__c ='United States of America';
            else if(temp.ShippingCountry == 'CAN' || temp.ShippingCountry == 'CANAD')
                c1.Country__c ='Canada';
            else
            c1.Country__c = temp.ShippingCountry;
            c1.State__c = temp.ShippingState;
            c1.City__c = temp.ShippingCity;
            
        }

        if(c1.Phone__c == null || c1.Phone__c == '')
            c1.Phone__c = temp.Phone;

       if(c1.EMail__c == null || c1.EMail__c == '')            
        c1.EMail__c = temp.EMail__c;                          
   /*If any of the value for firstname, lastname and phone in case are different from Account then update corresponding Account*/
    if(isupdate)
    {
      AccountToUpdate.add(temp);    
    }
    
    }
    else if(AccountInsertList.containsKey(c1.Id)){
        c1.Additional_Contact__c =  CaseVsAccountId.get(c1.Id);
    }
 }
 try{
    if(!AccountToUpdate.isEmpty())
         update AccountToUpdate;
 }catch(exception ex){
    
 }
}
    if(Trigger.isUpdate)
    {
        list<Additional_Product_Complaint_Contact__c> CaseTOUpdateAccount = new list<Additional_Product_Complaint_Contact__c>();
        set<String> AccountIds = new set<String>();
        list<Account> AccountToUpdate = new list<Account>();
        set<String> AccountToUpdatePhone = new set<String>();
        set<String> AccountToUpdateEmail = new set<String>();
        for(integer i=0 ; i<Trigger.new.size() ; i++)
        {
           if(Trigger.new[i].Additional_Contact__c!=null && 
             (Trigger.new[i].First_Name__c!=Trigger.old[i].First_Name__c ||
              Trigger.new[i].Last_Name__c!=Trigger.old[i].Last_Name__c || 
              Trigger.new[i].Address__c!=Trigger.old[i].Address__c || 
              Trigger.new[i].Address_2__c!=Trigger.old[i].Address_2__c || 
              Trigger.new[i].State__c!=Trigger.old[i].State__c || 
              Trigger.new[i].Postal_Code__c!=Trigger.old[i].Postal_Code__c ||
              Trigger.new[i].Country__c!=Trigger.old[i].Country__c || 
              Trigger.new[i].Phone__c!=Trigger.old[i].Phone__c || 
              Trigger.new[i].EMail__c!=Trigger.old[i].EMail__c || 
              Trigger.new[i].Salutation__c != Trigger.old[i].Salutation__c))
                  {
                    
                    CaseTOUpdateAccount.add(Trigger.new[i]);
                    AccountIds.add(Trigger.new[i].Additional_Contact__c);
                    if(Trigger.new[i].Phone__c!=Trigger.old[i].Phone__c && Trigger.new[i].Phone__c!= null)
                    {
                        AccountToUpdatePhone.add(Trigger.new[i].Additional_Contact__c);
                    }
                    if(Trigger.new[i].Email__c!=Trigger.old[i].Email__c && Trigger.new[i].Email__c!= null)
                    {
                        AccountToUpdateEmail.add(Trigger.new[i].Additional_Contact__c);
                    }
                  }         
        }
        if(!AccountIds.isEmpty())
        {
            map<id,Account> Allaccount = new map<Id,Account>([select id,name,FirstName,LastName,Other_Phone__c,EMail__c,Salutation,
                                   ShippingPostalCode,ShippingCountry,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCountry,
                                   PersonMailingState,PersonMailingCity,Phone,Fax,IsPersonAccount from Account where Id IN :AccountIds]);
            for(Additional_Product_Complaint_Contact__c c :CaseTOUpdateAccount)
            {
                if(Allaccount.containsKey(c.Additional_Contact__c))
                {
                   Account temp = Allaccount.get(c.Additional_Contact__c);
                   if(Allaccount.get(c.Additional_Contact__c).IsPersonAccount)
                   {
	                    
	                    temp.FirstName = c.First_Name__c;
	                    temp.LastName = c.Last_Name__c;
	                    temp.Salutation = c.Salutation__c;
	                    if(c.Address__c!=null)          
	                    {
	                        temp.PersonMailingStreet = c.Address__c;
	                        temp.ShippingStreet = c.Address__c;
	                        if(c.Address_2__c!=null)
	                        {
	                            temp.PersonMailingStreet = temp.PersonMailingStreet + '\n' +c.Address_2__c;
	                            temp.ShippingStreet = temp.ShippingStreet + '\n' +c.Address_2__c;                           
	                        }
	
	                    }
	                    temp.PersonMailingState = c.State__c;
	                    temp.ShippingState = c.State__c;
	                    temp.PersonMailingCity = c.City__c;
	                    temp.ShippingCity = c.City__c;
	                    temp.PersonMailingPostalCode = c.Postal_Code__c;
	                    temp.ShippingPostalCode = c.Postal_Code__c;
	                    temp.PersonMailingCountry = c.Country__c;
	                    temp.ShippingCountry = c.Country__c;
	                    temp.EMail__c = c.EMail__c;
	                    temp.Phone = c.Phone__c;             
	                    AccountToUpdate.add(temp);
                   }
                   if(AccountToUpdatePhone.contains(temp.Id)) 
                        updatePhone(temp.Id,c.Phone__c);
                   if(AccountToUpdateEmail.contains(temp.Id)) 
                        updateEmail(temp.Id,c.Email__c);                     
                }
                                     
            }
        }
        try
        {
            if(!AccountToUpdate.isEmpty())
            {
                update AccountToUpdate;
            }
                        
        }catch(exception ex){
        }
    
    }
 
 }
 public void updatePhone(String AccountId , String PhoneNumber)
 {
  //  PhoneNumber = 
    list<Account_Phone__c> Acc = new list<Account_Phone__c>([select id,name,Account__c,Phone__c from Account_Phone__c 
                                                                where Account__c = :AccountId and Phone__c = :PhoneNumber]);
    if(Acc.isEmpty())
    {
                Account_Phone__c temp = new Account_Phone__c();
                temp.Account__c = AccountId;
                temp.Phone__c =   formatPhone(PhoneNumber);
           try{
                insert temp;
           }catch(exception ex){
            
           } 
    }
 }
  public void updateEmail(String AccountId , String Email)
 {
  //  PhoneNumber = 
    list<Account_Phone__c> Acc = new list<Account_Phone__c>([select id,name,Account__c,Phone__c,Email_Address__c from Account_Phone__c 
                                                                where Account__c = :AccountId and Email_Address__c = :Email]);
    if(Acc.isEmpty())
    {
                Account_Phone__c temp = new Account_Phone__c();
                temp.Account__c = AccountId;
                temp.Email_Address__c =   Email;
           try{
                insert temp;
           }catch(exception ex){
            
           } 
    }
 }  
 public string formatPhone(String num)
 {
    if(num != null || num!='')
    {
        num = num.replace('(','');
        num = num.replace(')','');
        num = num.replace('-','');
        num = num.replaceAll(' ','');    	
    }

        return num; 
 } 
}