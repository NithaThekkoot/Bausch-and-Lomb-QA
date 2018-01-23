/**
*  @Class Name:    AccountProfileCntrl
*  @Description:   This class is the data provider for Account_Profile_Information_vf pdf page
*  @Company:       Standav
*  CreatedDate:    09/Jan/2018
*
*  Modification Log
*  -----------------------------------------------------------
*  Developer             Modification Date           Comments
*  -----------------------------------------------------------
*  Aman Sawhney          10/Jan/2018                  Original Version
*/
public with sharing class AccountProfileCntrl {
    
    /* variables for the account and its related list
information on the vf page named Account_Profile_Information_vf*/
    
    public Account_Profile__c accountProfile{get;set;}
    public Account accountInfo{get;set;}
    public List<contact> allContactList{get;set;}
    public List<contact> keyDecisionMakerList{get;set;}
    public List<BL_Product__c> blPrductList{get;set;}
    public List<AccountTeamMember> accountTeamList{get;set;}
    public List<BL_Sales_History__c> salesHistoryList{get;set;}
    public List<Account_Customer_Group__c> customerGroupList{get;set;}
    public List<Opportunity> opportunityList{get;set;}
    
    
    //constructor initialization
    public AccountProfileCntrl(ApexPages.StandardController controller) {
        
        //target account profile
        accountProfile = (Account_Profile__c)controller.getRecord();
        
        accountProfile  = [select Id,Account__c,RecordType.Name from Account_Profile__c where Id=:accountProfile.Id];
        
        //if the account entry on this account profile is filled
        if(accountProfile.Account__c !=null){
            
            //fetch the account info
            accountInfo = [select Id,Name,BillingCity,BillingStreet,BillingState from Account where Id=:accountProfile.Account__c];
            
            //fetch all the related list of account
            allContactList = [select Id,Name,External__c,Key_Decision_Maker__c,Contact_Role__c,Contact_Title__c,Sphere_of_Influence__c  
                              from Contact where AccountId=:accountProfile.Account__c];
            
            //fetch BL Product for family retina or cataract
            String productFamily = accountProfile.RecordType.Name;
            
            blPrductList = [select Id,Name,Type__c,Price__c,Equipment_Age__c,Annual_Volume__c from BL_Product__c where Account_Profile__c=:accountProfile.Id
                            AND Product_Family__c=:productFamily];
            
            
            accountTeamList = [select Id,TeamMemberRole,User.Name,AccountAccessLevel,CaseAccessLevel,ContactAccessLevel,OpportunityAccessLevel
                               from AccountTeamMember where AccountId=:accountProfile.Account__c];
            
            
            customerGroupList= [select Id,Name,Customer_Group__c,Customer_Group_Type__c from Account_Customer_Group__c where Account__c=:accountProfile.Account__c];
            
            salesHistoryList= [select Id,Sales_Date__c,Sales_Type__c,Total_Sales__c from BL_Sales_History__c where Account_Profile__c=:accountProfile.Id];
            
            opportunityList = [select Id,Name,StageName,Amount,CloseDate from Opportunity where AccountId=:accountProfile.Account__c];
            
            //fill key decision maker list
            keyDecisionMakerList = new List<contact>();
            for(contact c: allContactList){
                
                if(c.Key_Decision_Maker__c){
                    
                    keyDecisionMakerList.add(c);
                    
                }
            }
        }
    }
}