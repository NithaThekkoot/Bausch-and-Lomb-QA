/**
 * 
 *   APAC VC webservice to accept monthly sale data from ERP.
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Balaji             |balaji.prabakaran@listertechnologies.com|22.04.2010 |First Draft
 *   Balaji             |balaji.prabakaran@listertechnologies.com|13.05.2010 |Changes to handle revenue data for lens and lenscare seperately.
 *   Balaji             |balaji.prabakaran@listertechnologies.com|14.05.2010 |To set the monthly sale reference in the store info object.
 *   Balaji             |balaji.prabakaran@listertechnologies.com|03.06.2010 |To set the legacy system name and ownerId based on the running user instead of the country code value.
 *   Balaji             |balaji.prabakaran@listertechnologies.com|14.06.2010 |To set the legacy system name and ownerId based on the country code value.
 *   Sourav             |sourav.mitra@listertechnologies.com     |19.10.2010 |To set the legacy system name and ownerId based on the country code value.
 */

Global public class ClsWSIntegrationPrimarySale {

  //A class to temporarily hold the data sent as XML.  
    public Class PrimarySale {
        public String month {get; set;}
        public String year {get; set;}
        public String recordDate {get; set;}
        public String countryCode {get; set;}
        
        public String CurrentYearStartDate {get; set;}
        public String CurrentYearEndDate {get; set;}
        public String LastYearStartDate {get; set;}
        public String LastYearEndDate {get; set;}
        
        public List<MonthlySale> lstMonthlySales {get; set;}
    }
    
    //A class to temporarily hold the data sent as XML.  
    public Class MonthlySale {
        public String UserId {get; set;}
        public String Revenue {get; set;}
        public String LYRevenue {get; set;}
        public String RevenueUSD {get; set;}
        public String LYRevenueUSD {get; set;}       

        public String DBIdatERP {get; set;}
        public String ShipToId {get; set;}
    }
        
    //Utility method to check for empty value.
    public static Double getDoubleFromString(String value){
      Double returnValue = 0;
        if(value == null || value == '' || value == ' '){
            returnValue = 0;
        }else{
            returnValue = Decimal.valueof(value);
        }
        return returnValue;
    }
    
  /**
   *  The main method. 
   *  Input Parameter
   *  requestXML - string containing the XML data
   *  Output - response string.
   */    
  public webservice static String create(String requestXML) 
    {
    
        //The delimiter to be used to concatenate Customer Number and ShipTo Number
        String strDelimiter = '_';
        //List of legacy system id of the accounts sent
        List<String> lstAccountLegacyIds = new List<String>();
        
        //XML Element representing the collection of data sent.
        ClsUtilXMLElement xmlPrimarySale = new ClsUtilXMLParser().parse(requestXML);
        
        //List of sale data sent.
        PrimarySale oPrimarySale = new PrimarySale();
        oPrimarySale.year = xmlPrimarySale.getAttrs().get('year');
        oPrimarySale.month = xmlPrimarySale.getAttrs().get('month');
        oPrimarySale.recordDate = xmlPrimarySale.getAttrs().get('recorddate');
        oPrimarySale.countryCode = xmlPrimarySale.getAttrs().get('countrycode');
        
        oPrimarySale.CurrentYearStartDate = xmlPrimarySale.getAttrs().get('CurrentYearStartDate');
        oPrimarySale.CurrentYearEndDate = xmlPrimarySale.getAttrs().get('CurrentYearEndDate');
        oPrimarySale.LastYearStartDate = xmlPrimarySale.getAttrs().get('LastYearStartDate');
        oPrimarySale.LastYearEndDate = xmlPrimarySale.getAttrs().get('LastYearEndDate');
        
        //List of data owners.
        List<String> list_Owner = new List<String>();
        
        list_Owner.add(Label.APASU_India_Data_Owner);
        list_Owner.add(Label.APASU_ANZ_Data_Owner);
        list_Owner.add(Label.APACSU_China_Data_Owner);


        
        //Map of data owners and their Ids.
        Map<String, Id> map_Owner_Id = new Map<String, Id>();
        for (User u:[Select Id, Username from User where Username in :list_Owner]){
          map_Owner_Id.put(u.Username, u.Id);
        }
            
        //Unique identifier of the legacy system.
        String legacySystemName = '';
        
            //To get the owner based on the country.
            Id idOwner = null;

        /*
        *
        * Set the legacy system name based on the country code.
        *
        */
        if (oPrimarySale.countryCode.equals('IN')){
          legacySystemName = 'ORACLEIND';
              idOwner = map_Owner_Id.get(Label.APASU_India_Data_Owner);
        }else if (oPrimarySale.countryCode.equals('AU')){
          legacySystemName = 'BPCSAUS';
              idOwner = map_Owner_Id.get(Label.APASU_ANZ_Data_Owner);
        }else if (oPrimarySale.countryCode.equals('NZ')){
          legacySystemName = 'BPCSNZL';
              idOwner = map_Owner_Id.get(Label.APASU_ANZ_Data_Owner);
        }
        else if(oPrimarySale.countryCode.equals('CH'))
        {
            legacySystemName = 'BPCSCHN';
            idOwner = map_Owner_Id.get(Label.APACSU_China_Data_Owner);
        }
        
        List<MonthlySale> lstMonthlySales = new List<MonthlySale>();
            
            //For-loop: Looping through each Customer record and assigning to temporary objects.
            for (ClsUtilXMLElement xmlMonthlySale : xmlPrimarySale.getElements()){
              MonthlySale oMonthlySale = new MonthlySale();
          oMonthlySale.UserId = xmlMonthlySale.getAttrs().get('UserId'); 
          oMonthlySale.Revenue = xmlMonthlySale.getAttrs().get('Revenue'); 
          oMonthlySale.LYRevenue = xmlMonthlySale.getAttrs().get('LYRevenue'); 
          oMonthlySale.RevenueUSD = xmlMonthlySale.getAttrs().get('RevenueUSD'); 
          oMonthlySale.LYRevenueUSD = xmlMonthlySale.getAttrs().get('LYRevenueUSD'); 

          oMonthlySale.DBIdatERP = xmlMonthlySale.getAttrs().get('DBIdatERP');
          if (xmlMonthlySale.getAttrs().containsKey('ShipToId')){
            oMonthlySale.ShipToId = xmlMonthlySale.getAttrs().get('ShipToId');
          } else{
            oMonthlySale.ShipToId = '';
          }
          lstAccountLegacyIds.add(legacySystemName+oMonthlySale.DBIdatERP+strDelimiter+oMonthlySale.ShipToId);
          lstMonthlySales.add(oMonthlySale);
            }
            oPrimarySale.lstMonthlySales = lstMonthlySales;
            
            //Map of legacy system id and corresponding account in SF
            Map<String,Id> map_AccountLegacyId_Id = new Map<String,Id>();
            
            //For-loop: populates the above map.
            for (Account oAccount:[Select Id, Legacy_System_Id__c from Account where Legacy_System_Id__c in :lstAccountLegacyIds]){
              map_AccountLegacyId_Id.put(oAccount.Legacy_System_Id__c, oAccount.Id);
            }
            
            /*
            //Map of account Id and store info.
            Map<Id, Store_Info__c> map_AccountId_StoreInfo = new Map<Id, Store_Info__c>();
            for(Store_Info__c si:[Select Id, Store__c, Account_Profile_Name__c, Primary_Sales__c from Store_Info__c where Store__c in :map_AccountLegacyId_Id.values()]){
              map_AccountId_StoreInfo.put(si.Store__c, si);
            }*/
            
            //To get the users and their legacy system ids.
            List<User> list_User = [Select Id, Legacy_System_Id__c from User Where APAC_Country__c !=''];
            Map<String,User> map_UserLegacyId_User = new Map<String,User>();
            for (User u:list_User){
              map_UserLegacyId_User.put(u.Legacy_System_Id__c, u);
            }
            
            /*
             * Code block to calculate the revenue for YTD.
             *
             */
            Double dblYear = Double.valueOf(oPrimarySale.year);
            Integer intMonth = Integer.valueOf(oPrimarySale.month);
            
            //Set of month nos less the current month.
            Set<String> set_Month = new Set<String>();
            for(Integer i=1; i<intMonth; i++){
              set_Month.add(String.valueOf(i));
            }
            
            /*
            //Map of account ID and respective sum of MTD revenue for lens and lenscare
            Map<Id, RevenueYTD> map_AccountId_Revenue = new Map<Id, RevenueYTD>();
            for(AggregateResult ar : [Select DB_Name__c, Sum(Lens_Revenue__c), Sum(Lens_LY_Revenue__c), Sum(Lenscare_Revenue__c), Sum(Lenscare_LY_Revenue__c) From Primary_Sales__c 
                                    Where DB_Name__c in :map_AccountLegacyId_Id.values() And Year__c = :dblYear  And Month__c in :set_Month
                                    Group by DB_Name__c]){
            RevenueYTD oRevenueYTD = new RevenueYTD();
            oRevenueYTD.Lens = getDoubleFromString(String.valueOf(ar.get('expr0')));
            oRevenueYTD.LensLY = getDoubleFromString(String.valueOf(ar.get('expr1')));
            oRevenueYTD.Lenscare = getDoubleFromString(String.valueOf(ar.get('expr2')));
            oRevenueYTD.LenscareLY = getDoubleFromString(String.valueOf(ar.get('expr3')));
            map_AccountId_Revenue.put((Id)ar.get('DB_Name__c'), oRevenueYTD);
        }*/

             /*
              * code block for inserting in to custom objects.
              *
              */
             //List of monthly sale records to insert/update.
            List<Primary_Sales__c> list_MonthlySale = new List<Primary_Sales__c>();
            
            //Map of monthly sale records against the unique value.
            Map<String, Primary_Sales__c> map_Unique_MonthlySale = new Map<String, Primary_Sales__c>();
            
            //For-loop: Loop through each record sent and create monthly sale .
            for (MonthlySale oMonthlySale : oPrimarySale.lstMonthlySales){
              Primary_Sales__c objPrimarySale = new Primary_Sales__c();
                
                User objExecUser = map_UserLegacyId_User.get(oMonthlySale.UserId);
                if (objExecUser != null){
                  objPrimarySale.Sales_Executive_Name__c = objExecUser.Id;
                }
                objPrimarySale.User_Id_at_ERP__c = oMonthlySale.UserId;
                System.debug('oMonthlySale.LYRevenue' + oMonthlySale.LYRevenue + 'value');
                objPrimarySale.LY_Revenue__c = getDoubleFromString(oMonthlySale.LYRevenue);
                objPrimarySale.Revenue__c = getDoubleFromString(oMonthlySale.Revenue);
                objPrimarySale.LY_Revenue_USD__c = getDoubleFromString(oMonthlySale.LYRevenueUSD);
                objPrimarySale.Revenue_USD__c = getDoubleFromString(oMonthlySale.RevenueUSD);
                objPrimarySale.Year__c = Double.valueof(oPrimarySale.year);
                objPrimarySale.Month__c = oPrimarySale.month;
                System.debug('Date time value is ------------>>>>>>>>>>>>>' + oPrimarySale.recordDate);
                objPrimarySale.Record_Date__c = datetime.valueOf(oPrimarySale.recordDate);
                objPrimarySale.Current_YR_Start_Date__c = datetime.valueOf(oPrimarySale.CurrentYearStartDate);
                objPrimarySale.Current_YR_End_Date__c = datetime.valueOf(oPrimarySale.CurrentYearEndDate);
                objPrimarySale.Last_YR_Start_Date__c = datetime.valueOf(oPrimarySale.LastYearStartDate);
                objPrimarySale.Last_YR_End_Date__c = datetime.valueOf(oPrimarySale.LastYearEndDate);
                System.debug('objPrimarySale.Record_Date__c------>>>>>>>>' + objPrimarySale.Record_Date__c);
                Id idAccount = map_AccountLegacyId_Id.get(legacySystemName+oMonthlySale.DBIdatERP+strDelimiter+oMonthlySale.ShipToId);
        

                objPrimarySale.DB_Name__c = idAccount;
                objPrimarySale.DB_Id_at_ERP__c = oMonthlySale.DBIdatERP;
                //objPrimarySale.Legacy_System_ShipTo_Id__c = oMonthlySale.ShipToId;
                /*
                if (idAccount != null){
                  Store_Info__c objStoreInfo = map_AccountId_StoreInfo.get(idAccount);
                Id idAccountProfile = objStoreInfo.Account_Profile_Name__c;
                if (idAccountProfile != null) objPrimarySale.Account_Profile_Name__c  = idAccountProfile;
                }*/
                
                //objPrimarySale.Legacy_System_Name__c = legacySystemName;
                String strUnique = oPrimarySale.countryCode + oMonthlySale.DBIdatERP + oMonthlySale.ShipToId + oPrimarySale.month + oPrimarySale.year;
                objPrimarySale.external_ID__c = strUnique;
                objPrimarySale.OwnerId = idOwner;
                map_Unique_MonthlySale.put(strUnique, objPrimarySale);
                //list_MonthlySale.add(objPrimarySale);
            }
            //Assigning the values from the map to the list.
            list_MonthlySale = map_Unique_MonthlySale.values();
            
            Database.upsertResult[] uResults = Database.upsert(list_MonthlySale, Primary_Sales__c.external_ID__c, false);
            
            /*
             * code block for creating the response string
             */ 
            Integer intRowNum = 0;
            Integer intSuccess = 0;
            Integer intFailures = 0;
            
            //XML Element to form the response string.
            ClsUtilXMLElement xmlResPriSale = new ClsUtilXMLElement('PrimarySale');
            xmlResPriSale.addAttribute('ResponseDateTime', String.valueOf(System.now()));
            
            //For-loop: Loop through each result and form the response.
            for(Database.upsertResult result:uResults) {
                MonthlySale oMonthlySale = oPrimarySale.lstMonthlySales.get(intRowNum);
                //To set the monthly sale reference to the store info object.
                Primary_Sales__c objPrimarySale = list_MonthlySale.get(intRowNum);
                //Store_Info__c objStoreInfo = map_AccountId_StoreInfo.get(objPrimarySale.Account__c);
                //if (objStoreInfo!=null) objStoreInfo.Primary_Sales__c = objPrimarySale.Id;
                
                ClsUtilXMLElement xmlResMonthlySale= new ClsUtilXMLElement('MonthlySale');
                 xmlResMonthlySale.addAttribute('Id',result.getId());
                xmlResMonthlySale.addParameter('UserId', oMonthlySale.UserId);
                xmlResMonthlySale.addParameter('DBIdatERP', oMonthlySale.DBIdatERP);
                if (result.isSuccess()) {
                    System.debug('result.getId()' + result.getId()); 
                    xmlResMonthlySale.addParameter('StatusFlag', 'SUCCESS');
                    intSuccess++;
                } else {
                    xmlResMonthlySale.addParameter('StatusFlag', 'FAILURE');
                    ClsUtilXMLElement xmlErrors = new ClsUtilXMLElement('Errors');
                    for (Database.Error oError : result.getErrors()) {
                      ClsUtilXMLElement xmlError = new ClsUtilXMLElement('Error');
                      xmlError.addParameter('errorCode', String.valueOf(oError.getStatusCode()));
                      xmlError.addParameter('message', oError.getMessage());
                      xmlErrors.addElement(xmlError);
                        System.debug(oError.getMessage() + 'oError.getMessage()');
                        System.debug(oError.getStatusCode() + 'oError.getStatusCode()');
                    }
                    xmlResMonthlySale.addElement(xmlErrors);
                    intFailures++;
                }
                intRowNum++;
                xmlResPriSale.addElement(xmlResMonthlySale);
            }
            xmlResPriSale.addParameter('TotalNoOfRecords',String.valueOf(intRowNum));
            xmlResPriSale.addParameter('TotalNoOfRecordsSuccess',String.valueOf(intSuccess));
            xmlResPriSale.addParameter('TotalNoOfRecordsFailure',String.valueOf(intFailures));
            System.debug('responseString is -->' + xmlResPriSale.toXML());
        
            /*
            //To update the list of store info objects.
            update map_AccountId_StoreInfo.values();
            */
            
        //return response   
        return xmlResPriSale.toXML();
    
    }
  
}