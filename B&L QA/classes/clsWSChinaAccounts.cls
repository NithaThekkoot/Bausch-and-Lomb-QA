/******************************************************************************
****Web service Class to fetch the list of China SU accounts modified today****
*Test Class: clsWSChinaAccounts_Test - TO BE CREATED
*
*Author       | Email                      |Date      | Remarks
*------------------------------------------------------------------------------
*Kandarp Shah |kandarp.shah@bausch.com     |02-Dec-13 | First Draft
*Kandarp Shah |kandarp.shah@bausch.com     |21-Apr-14 | Changes as per details from Jin QI. Do not need to pass ATM
*******************************************************************************/

global public class clsWSChinaAccounts{
    public webservice static List<Account> getChinaSUAccountsModifiedToday(){
        //List<AccountTeamMember> lst_Accounts = new List<AccountTeamMember>();
        List<Account> lst_Accounts = new List<Account>();
        String strAccountOwnerCHN = Label.APACSU_China_Data_Owner;
        
        List<User> lst_CountryControllerUser = [SELECT ID from User where UserName =: strAccountOwnerCHN LIMIT 1];
        ID accountOwnerID = lst_CountryControllerUser[0].ID;
        
        System.debug('lst_CountryControllerUser : ' + lst_CountryControllerUser);        
        System.debug('lst_CountryControllerUser.size : ' + lst_CountryControllerUser[0].ID);
        
        //Fetch the list of accounts modified today and have China country controller as owner        
        /*lst_Accounts = [SELECT ID,
                        Name, Phone, Fax,
                        Legacy_System_Id__c
                        FROM Account where OwnerID =: accountOwnerID AND LastModifiedDate =: system.today()];*/
        // Modified by Neha Jain on 20th Jan, 2014 
        // Modified for LastModifieddate = LAST_N_DAYS: 1 to fetch data for the day.
        /*lst_Accounts = [SELECT User.Name, Account.Legacy_System_Id__c, Account.Name, 
                        Account.Phone, Account.Fax, Account.BillingState, Account.BillingStreet, Account.BillingCity, 
                        Account.BillingPostalCode 
                        FROM AccountTeamMember 
                        WHERE Account.OwnerID =: accountOwnerID
                        AND account.LastModifiedDate = LAST_N_DAYS: 1 ]; //=: system.today()*/
        
        lst_Accounts = [SELECT Legacy_System_Id__c, Name, 
                        Phone, Fax, BillingState, BillingStreet, 
                        BillingCity, BillingPostalCode 
                        FROM Account where OwnerID =: accountOwnerID AND LastModifiedDate = LAST_N_DAYS: 1];
        
        return lst_Accounts;         
    }
}