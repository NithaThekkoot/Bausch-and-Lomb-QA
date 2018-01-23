Global public class PrimarySaleGlobal {

    public Class PrimarySale {
        public String month {get; set;}
        public String year {get; set;}
        public String recordDate {get; set;}
        public String countryCode {get; set;}
        
        public String CurrentYearStartDate {get; set;}
        public String CurrentYearEndDate {get; set;}
        public String LastYearStartDate {get; set;}
        public String LastYearEndDate {get; set;}
        
        public List<MonthlySale> MonthlySaleObj {get; set;}
    }
    
    public Class MonthlySale {
        public String UserId {get; set;}
        public String Revenue {get; set;}
        public String LYRevenue {get; set;}
        public String RevenueUSD {get; set;}
        public String LYRevenueUSD {get; set;}
        
        public String DBIdatERP {get; set;}
        
    }

    public webservice static String create(String requestXML) {
    
    try{
    
        //String requestXML1 = '<PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 11 </UserId><Revenue></Revenue><LYRevenue> </LYRevenue></MonthlySale></PrimarySale>';
        //String requestXML2 = '<PrimarySale year="2009" month="1" recorddate="01-09-2009 10:"><MonthlySale><UserId> userid 1 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 2 </UserId><Revenue>200</Revenue><LYRevenue>2000</LYRevenue></MonthlySale></PrimarySale>';
        //String requestXML3 = '<PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 3 </UserId><Revenue>300</Revenue><LYRevenue>3000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 4 </UserId><Revenue>400</Revenue><LYRevenue>4000</LYRevenue></MonthlySale></PrimarySale>';
        //String requestXML4 = '<PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId>john</UserId><Revenue>300</Revenue><LYRevenue>3000</LYRevenue></MonthlySale><MonthlySale><UserId>david</UserId><Revenue>400</Revenue><LYRevenue>4000</LYRevenue></MonthlySale></PrimarySale>';
        //String requestXML5 = '<?xml version="1.0"?><PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 1 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 1 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale></PrimarySale>';
        //String requestXML6 = '<PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 1 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 1</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 3</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 4</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 5</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 6</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 7</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 8</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 9</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 10</UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale></PrimarySale>';
        //String requestXML7 = '<PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 1 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale><MonthlySale><UserId> userid 1 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale></PrimarySale>';
        
        //String requestXML8 = '<?xml version="1.0"?><PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 1 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue></MonthlySale></PrimarySale>';
        
        String requestXML2 = '<PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 1 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD></MonthlySale><MonthlySale><UserId> userid 2 </UserId><Revenue>200</Revenue><LYRevenue>2000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD></MonthlySale></PrimarySale>';
        String requestXML3 = '<PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 10 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD><DBIdatERP>100</DBIdatERP><CurrentYearStartDate>2009-01-01 10:20:12</CurrentYearStartDate><CurrentYearEndDate>2009-01-01 10:20:12</CurrentYearEndDate><LastYearStartDate>2009-01-01 10:20:12</LastYearStartDate><LastYearEndDate>2009-01-01 10:20:12</LastYearEndDate></MonthlySale><MonthlySale><UserId> userid 20 </UserId><Revenue>200</Revenue><LYRevenue>2000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD><DBIdatERP>200</DBIdatERP><CurrentYearStartDate>2009-01-01 10:20:12</CurrentYearStartDate><CurrentYearEndDate>2009-01-01 10:20:12</CurrentYearEndDate><LastYearStartDate>2009-01-01 10:20:12</LastYearStartDate><LastYearEndDate>2009-01-01 10:20:12</LastYearEndDate></MonthlySale></PrimarySale>';
        String requestXML4 = '<PrimarySale year="2009" month="1" recorddate="2009-01-01 10:20:12" CurrentYearStartDate="2009-01-01 10:20:12" CurrentYearEndDate="2009-01-01 10:20:12" LastYearStartDate="2009-01-01 10:20:12" LastYearEndDate="2009-01-01 10:20:12"><MonthlySale><UserId> userid 22 </UserId><Revenue>100</Revenue><LYRevenue>1000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD><DBIdatERP>100</DBIdatERP></MonthlySale><MonthlySale><UserId> userid 33 </UserId><Revenue>200</Revenue><LYRevenue>2000</LYRevenue><RevenueUSD>100</RevenueUSD><LYRevenueUSD>1000</LYRevenueUSD><DBIdatERP>200</DBIdatERP></MonthlySale></PrimarySale>';
        
        System.debug('Request XML is --->' + requestXML);
        
        PrimarySale primarySaleOb = null;
        MonthlySale monthlySaleOb = null;
        List<MonthlySale> monthlySaleList = null; 
        
        XmlStreamReader reader = new XmlStreamReader(requestXML);
        
        while(reader.hasNext()) {
        
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
        
                    if (reader.getLocalName() == 'PrimarySale' ) {
                        primarySaleOb = new PrimarySale();
                        monthlySaleList = new List<MonthlySale>();
                        
                        primarySaleOb.year = reader.getAttributeValue(null, 'year');
                        primarySaleOb.month = reader.getAttributeValue(null, 'month');
                        primarySaleOb.recordDate = reader.getAttributeValue(null, 'recorddate');
                        primarySaleOb.countryCode = reader.getAttributeValue(null, 'countrycode');
                        
                        primarySaleOb.CurrentYearStartDate  = reader.getAttributeValue(null, 'CurrentYearStartDate');
                        primarySaleOb.CurrentYearEndDate  = reader.getAttributeValue(null, 'CurrentYearEndDate');
                        primarySaleOb.LastYearStartDate  = reader.getAttributeValue(null, 'LastYearStartDate');
                        primarySaleOb.LastYearEndDate  = reader.getAttributeValue(null, 'LastYearEndDate');
                        
                        
                        
                    }
                    if (reader.getLocalName() == 'MonthlySale' ) {
                        monthlySaleOb = new MonthlySale();
                        parseMonth(reader, monthlySaleOb);
                    }
            }   
                
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
        
                if (reader.getLocalName() == 'MonthlySale') {
                
                    monthlySaleList.add(monthlySaleOb);
                    
                }
                if (reader.getLocalName() == 'PrimarySale') {           
                    primarySaleOb.MonthlySaleObj = monthlySaleList;
                                   
                }       
            } 
        
                reader.next();
        }
        
        //List of data owners.
        List<String> list_Owner = new List<String>();
        list_Owner.add(Label.APASU_India_Data_Owner);
        list_Owner.add(Label.APASU_ANZ_Data_Owner);
        
        //Map of data owners and their Ids.
        Map<String, Id> map_Owner_Id = new Map<String, Id>();
        for (User u:[Select Id, Username from User where Username in :list_Owner]){
            map_Owner_Id.put(u.Username, u.Id);
        }
        
        //to get the owner based on the country.
        Id idOwner = null;
        if (primarySaleOb.countryCode=='IN'){
            idOwner = map_Owner_Id.get(Label.APASU_India_Data_Owner);
        }else if (primarySaleOb.countryCode=='AU' || primarySaleOb.countryCode=='NZ'){
            idOwner = map_Owner_Id.get(Label.APASU_ANZ_Data_Owner);
        }

        System.debug('Owner is ' + idOwner);
            
        // Getting Id for recordType "INDSU Primary Sale"
		Id idRecordType = [SELECT Id FROM RecordType WHERE Name = 'INDSU Primary Sale' AND SObjectType='Primary_Sales__c'].Id;
            
        
        //code block for inserting in to custom objects.
        
        List<Primary_Sales__c> customPrimarySaleList = new List<Primary_Sales__c>();
        Primary_Sales__c customPrimarySaleToInsert = null;
        List<MonthlySale> monthlySaleTempList = null;
        
        for(MonthlySale monthlySaleTemp : monthlySaleList){
        
            customPrimarySaleToInsert = new Primary_Sales__c();
            
            customPrimarySaleToInsert.User_Id_at_ERP__c = monthlySaleTemp.UserId;
            System.debug('monthlySaleTemp.LYRevenue' + monthlySaleTemp.LYRevenue + 'value');
            
            if(monthlySaleTemp.LYRevenue == null || monthlySaleTemp.LYRevenue == '' || monthlySaleTemp.LYRevenue == ' '){
                customPrimarySaleToInsert.LY_Revenue__c = 0;
            }else{
                customPrimarySaleToInsert.LY_Revenue__c = Decimal.valueof(monthlySaleTemp.LYRevenue);
            }

            if(monthlySaleTemp.Revenue == null || monthlySaleTemp.Revenue == '' || monthlySaleTemp.Revenue == ' ') {
                customPrimarySaleToInsert.Revenue__c = 0;
            }else{
                customPrimarySaleToInsert.Revenue__c = Decimal.valueof(monthlySaleTemp.Revenue);
            }
            
            
            if(monthlySaleTemp.LYRevenueUSD == null || monthlySaleTemp.LYRevenueUSD == '' || monthlySaleTemp.LYRevenueUSD == ' '){
                customPrimarySaleToInsert.LY_Revenue_USD__c = 0;
            }else{
                customPrimarySaleToInsert.LY_Revenue_USD__c = Decimal.valueof(monthlySaleTemp.LYRevenueUSD);
            }

            if(monthlySaleTemp.RevenueUSD == null || monthlySaleTemp.RevenueUSD == '' || monthlySaleTemp.RevenueUSD == ' ') {
                customPrimarySaleToInsert.Revenue_USD__c = 0;
            }else{
                customPrimarySaleToInsert.Revenue_USD__c = Decimal.valueof(monthlySaleTemp.RevenueUSD);
            }
            //check the line below - added double.valueof
            customPrimarySaleToInsert.Year__c = Double.valueof(primarySaleOb.year);
            customPrimarySaleToInsert.Month__c = primarySaleOb.month;
            System.debug('Date time value is ------------>>>>>>>>>>>>>' + primarySaleOb.recordDate);
            
            //check the line below - from datetime changed to date
            customPrimarySaleToInsert.Record_Date__c = datetime.valueOf(primarySaleOb.recordDate);
            
            customPrimarySaleToInsert.Current_YR_Start_Date__c = datetime.valueOf(primarySaleOb.CurrentYearStartDate);
            customPrimarySaleToInsert.Current_YR_End_Date__c = datetime.valueOf(primarySaleOb.CurrentYearEndDate);
            customPrimarySaleToInsert.Last_YR_Start_Date__c = datetime.valueOf(primarySaleOb.LastYearStartDate);
            customPrimarySaleToInsert.Last_YR_End_Date__c = datetime.valueOf(primarySaleOb.LastYearEndDate);
            
            System.debug('customPrimarySaleToInsert.Record_Date__c------>>>>>>>>' + customPrimarySaleToInsert.Record_Date__c);
            customPrimarySaleToInsert.external_ID__c = monthlySaleTemp.UserId + monthlySaleTemp.DBIdatERP + primarySaleOb.month + primarySaleOb.year;
            
            customPrimarySaleToInsert.DB_Id_at_ERP__c = monthlySaleTemp.DBIdatERP;
            customPrimarySaleToInsert.OwnerId = idOwner;
            customPrimarySaleToInsert.RecordTypeId = idRecordType;
            
            customPrimarySaleList.add(customPrimarySaleToInsert);
        }
        
        Database.upsertResult[] uResults = Database.upsert(customPrimarySaleList, Primary_Sales__c.external_ID__c, false);
        
        
        // code block for creating the response string 
        Integer count = 0;
        Integer successCount = 0;
        Integer failureCount = 0;
        
        String responseString = '<PrimarySale ResponseDateTime="' + System.now() + '">';
        
        for(Database.upsertResult result:uResults) {
            if (result.isSuccess()) {
            
                System.debug('result.getId()' + result.getId()); 
                Primary_Sales__c primarySaleObj = customPrimarySaleList.get(count);
                responseString = responseString + '<MonthlySale id="'+result.getId()+'" ><UserId>'+ primarySaleObj.User_Id_at_ERP__c + '</UserId><DBIdatERP>' + primarySaleObj.DB_Id_at_ERP__c +'</DBIdatERP><StatusFlag>SUCCESS</StatusFlag></MonthlySale>';
                successCount++;
            } else {
                
                Primary_Sales__c primarySaleObj = customPrimarySaleList.get(count);
                responseString = responseString + '<MonthlySale id="" ><UserId>'+ primarySaleObj.User_Id_at_ERP__c + '</UserId><DBIdatERP>' + primarySaleObj.DB_Id_at_ERP__c +'</DBIdatERP><StatusFlag>FAILURE</StatusFlag>';
                responseString = responseString + '<Errors>';
                for (Database.Error errorObj : result.getErrors()) {
                
                    responseString = responseString + '<Error><errorCode>' + errorObj.getStatusCode() + '</errorCode><message>' + errorObj.getMessage() + '</message></Error>';
                    System.debug(errorObj.getMessage() + 'errorObj.getMessage()');
                    System.debug(errorObj.getStatusCode() + 'errorObj.getStatusCode()');
                
                }
                responseString = responseString + '</Errors></MonthlySale>';
                failureCount++;
            }
            
            count++;
        }
        responseString = responseString + '<TotalNoOfRecords>' + count + '</TotalNoOfRecords>' + '<TotalNoOfRecordsSuccess>' + successCount +  '</TotalNoOfRecordsSuccess>' + '<TotalNoOfRecordsFailure>' +failureCount+  '</TotalNoOfRecordsFailure></PrimarySale>';
        System.debug('responseString is -->' + responseString);
        
        return responseString;
        
    } catch(Exception e){
        String exceptionString = '<PrimarySale><message>' + e.getMessage() + '</message></PrimarySale>';
        System.debug('exceptionString is -->' + exceptionString);
        return exceptionString;
    }   
        
    }
  
    
    public static void parseMonth(XmlStreamReader reader, MonthlySale monthlySaleOb){

        String localName = '';
        while(reader.hasNext()) {
        
        if (true) {
                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if(reader.getLocalName() == 'MonthlySale')
                    break;
                } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                   if (localName == 'UserId') { 
                       monthlySaleOb.UserId = reader.getText(); 
                       
                   } else if (localName == 'Revenue') { 
                       monthlySaleOb.Revenue = reader.getText(); 
                       System.debug('monthlySaleOb.Revenue' + reader.getText());
                   } else if (localName == 'LYRevenue') { 
                       monthlySaleOb.LYRevenue = reader.getText(); 
                       System.debug('monthlySaleOb.LYRevenue' + reader.getText());
                   } else if (localName == 'RevenueUSD') { 
                       monthlySaleOb.RevenueUSD = reader.getText(); 
                       //System.debug('monthlySaleOb.LYRevenue' + reader.getText());
                   }  else if (localName == 'LYRevenueUSD') { 
                       monthlySaleOb.LYRevenueUSD = reader.getText(); 
                       //System.debug('monthlySaleOb.LYRevenue' + reader.getText());
                   }  else if (localName == 'DBIdatERP') { 
                       monthlySaleOb.DBIdatERP = reader.getText(); 
                       System.debug('monthlySaleOb.DBIdatERP' + reader.getText());
                   } 
                   
                   
                   System.debug(reader.getLocalName()  + ' ==' + reader.getText());
                } else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                   localName = reader.getLocalName();
                   System.debug('Local Name is ' + localName);
                }
            
            
        } 
            reader.next();
        }
     
    }
    
}