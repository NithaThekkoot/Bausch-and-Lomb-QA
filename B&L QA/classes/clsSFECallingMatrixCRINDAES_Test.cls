@isTest
private class clsSFECallingMatrixCRINDAES_Test {

    Private Call_Summary__c APACCallSummary;

    static testMethod void clsSFECallingMatrixCustomReportINDAES_Test() { 
                                    
            Call_Summary__c b = new Call_Summary__c(
                Actual_Calls__c = 10,
                Area__c = 'Test',
                Business_Day_or_not__c = true,
                Date__c = System.Today().addDays(-7),
                Total_Calls__c = 50,
                Planned_Calls__c = 10,
                RegionINDSU__c = 'West',
                Targeted_Calls__c = 20,
                Total_Customers__c = 165,
                Country__c = 'INDIA',
                //Unique__c = '0000000000000000012013-03-06:00:00:00');
                Unique__c = '000000000000000001' + String.valueOf(System.Today()));
                //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today()));
            
            System.debug('******************Inserting the test buyer record...');
            Insert b;
            
            
            ApexPages.StandardController controller = new ApexPages.StandardController(b); 
            clsSFECallingMatrixCustomReportINDAES bsExt = new clsSFECallingMatrixCustomReportINDAES(controller);
               
            bsExt.InitCurrentMonth();
            bsExt.exportToExcel();
            bsExt.SendMailToUserOnly();
            ApexPages.currentPage().getParameters().put('sMonth',bsExt.strSelectedMonth); 
            bsExt.getSelectedMonth();
            Date strDt = Date.valueOF(System.Now());            
            bsExt.getMonthStartDate('Mar',strDt); 
            bsExt.daysInMonths(1);
            bsExt.daysInMonths(2);
            bsExt.daysInMonths(3);
            bsExt.daysInMonths(4);
            bsExt.daysInMonths(5);
            bsExt.daysInMonths(6);
            bsExt.daysInMonths(7);
            bsExt.daysInMonths(8);
            bsExt.daysInMonths(9);
            bsExt.daysInMonths(10);
            bsExt.daysInMonths(11);
            bsExt.daysInMonths(12);
            bsExt.WeekStartDate('Monday');
            bsExt.WeekStartDate('Tuesday');
            bsExt.WeekStartDate('Wednesday');
            bsExt.WeekStartDate('Thursday');
            bsExt.WeekStartDate('Friday');
            bsExt.WeekStartDate('Saturday');            
            bsExt.WeekStartDate('Sunday');
            
            bsExt.WeekEndDate('Monday');
            bsExt.WeekEndDate('Tuesday');
            bsExt.WeekEndDate('Wednesday');
            bsExt.WeekEndDate('Thursday');
            bsExt.WeekEndDate('Friday');
            bsExt.WeekEndDate('Saturday');            
            bsExt.WeekEndDate('Sunday');
            
            bsExt.MonthNumber('Jan');
            bsExt.MonthNumber('Feb');
            bsExt.MonthNumber('Mar');
            bsExt.MonthNumber('Apr');
            bsExt.MonthNumber('May');
            bsExt.MonthNumber('Jun');
            bsExt.MonthNumber('Jul');
            bsExt.MonthNumber('Aug');
            bsExt.MonthNumber('Sep');
            bsExt.MonthNumber('Oct');
            bsExt.MonthNumber('Nov');
            bsExt.MonthNumber('Dec');
            
            DateTime d = datetime.now();
            bsExt.dayOfWeek=d.format('EEEE');
            bsExt.WeekStartDate = bsExt.WeekStartDate(bsExt.dayOfWeek);            
            bsExt.WeekEndDate = bsExt.WeekEndDate(bsExt.dayOfWeek); 
            
            clsSFEPlanMatrixCustomReportINDAES bsExtNew = new clsSFEPlanMatrixCustomReportINDAES(controller);
            clsSFEPlanMatrixCustomReportINDAES bsExtNew1 = new clsSFEPlanMatrixCustomReportINDAES();
                 
            ApexPages.currentPage().getParameters().put('sMonth','Mar');
                      
            bsExtNew.InitCurrentMonth();
            bsExtNew.exportToExcel();            
            Date strDte = Date.valueOF(System.Now());            
            bsExtNew.getMonthStartDate('Mar',strDte);       
            
            bsExtNew.daysInMonths(1);
            bsExtNew.daysInMonths(2);
            bsExtNew.daysInMonths(3);
            bsExtNew.daysInMonths(4);
            bsExtNew.daysInMonths(5);
            bsExtNew.daysInMonths(6);
            bsExtNew.daysInMonths(7);
            bsExtNew.daysInMonths(8);
            bsExtNew.daysInMonths(9);
            bsExtNew.daysInMonths(10);
            bsExtNew.daysInMonths(11);
            bsExtNew.daysInMonths(12);
            bsExtNew.WeekStartDate('Monday');
            bsExtNew.WeekStartDate('Tuesday');
            bsExtNew.WeekStartDate('Wednesday');
            bsExtNew.WeekStartDate('Thursday');
            bsExtNew.WeekStartDate('Friday');
            bsExtNew.WeekStartDate('Saturday');            
            bsExtNew.WeekStartDate('Sunday');
            
            bsExtNew.WeekEndDate('Monday');
            bsExtNew.WeekEndDate('Tuesday');
            bsExtNew.WeekEndDate('Wednesday');
            bsExtNew.WeekEndDate('Thursday');
            bsExtNew.WeekEndDate('Friday');
            bsExtNew.WeekEndDate('Saturday');            
            bsExtNew.WeekEndDate('Sunday');
            
            bsExtNew.MonthName('1');
            bsExtNew.MonthName('2');
            bsExtNew.MonthName('3');
            bsExtNew.MonthName('4');
            bsExtNew.MonthName('5');
            bsExtNew.MonthName('6');
            bsExtNew.MonthName('7');
            bsExtNew.MonthName('8');
            bsExtNew.MonthName('9');
            bsExtNew.MonthName('10');
            bsExtNew.MonthName('11');
            bsExtNew.MonthName('12');
            
            bsExtNew.MonthNumber('Jan');
            bsExtNew.MonthNumber('Feb');
            bsExtNew.MonthNumber('Mar');
            bsExtNew.MonthNumber('Apr');
            bsExtNew.MonthNumber('May');
            bsExtNew.MonthNumber('Jun');
            bsExtNew.MonthNumber('Jul');
            bsExtNew.MonthNumber('Aug');
            bsExtNew.MonthNumber('Sep');
            bsExtNew.MonthNumber('Oct');
            bsExtNew.MonthNumber('Nov');
            bsExtNew.MonthNumber('Dec'); 
            
            Call_Summary__c Todayb = new Call_Summary__c(
                Actual_Calls__c = 10,
                Area__c = 'Test',
                Business_Day_or_not__c = true,
                Date__c = System.Today(),
                Total_Calls__c = 50,
                Planned_Calls__c = 10,
                RegionINDSU__c = 'West',
                Targeted_Calls__c = 20,
                Total_Customers__c = 165,
                Country__c = 'INDIA',
                //Unique__c = '0000000000000000012013-03-06:00:00:00');
                Unique__c = '000000000000000001' + String.valueOf(System.Today()));
                //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today()));
            
            System.debug('******************Inserting the test buyer record...');
            Insert Todayb;
            
            ApexPages.StandardController APcontroller = new ApexPages.StandardController(Todayb);
            clsSFEDailyCallingMatrixCRINDAES bsExtDaily = new clsSFEDailyCallingMatrixCRINDAES(APcontroller);
            
            bsExtDaily.WeekStartDate = System.Today();
            bsExtDaily.WeekEndDate = System.Today();
            bsExtDaily.InitCurrentMonth();
            bsExtDaily.exportToExcel();
            ApexPages.currentPage().getParameters().put('sMonth',bsExtDaily.strSelectedMonth); 
            bsExtDaily.getSelectedMonth();
            Date strDate = Date.valueOF(System.Now());            
            bsExtDaily.getMonthStartDate('Mar',strDate); 
            bsExtDaily.daysInMonths(1);
            bsExtDaily.daysInMonths(2);
            bsExtDaily.daysInMonths(3);
            bsExtDaily.daysInMonths(4);
            bsExtDaily.daysInMonths(5);
            bsExtDaily.daysInMonths(6);
            bsExtDaily.daysInMonths(7);
            bsExtDaily.daysInMonths(8);
            bsExtDaily.daysInMonths(9);
            bsExtDaily.daysInMonths(10);
            bsExtDaily.daysInMonths(11);
            bsExtDaily.daysInMonths(12);
            bsExtDaily.WeekStartDate('Monday');
            bsExtDaily.WeekStartDate('Tuesday');
            bsExtDaily.WeekStartDate('Wednesday');
            bsExtDaily.WeekStartDate('Thursday');
            bsExtDaily.WeekStartDate('Friday');
            bsExtDaily.WeekStartDate('Saturday');            
            bsExtDaily.WeekStartDate('Sunday');
            
            bsExtDaily.WeekEndDate('Monday');
            bsExtDaily.WeekEndDate('Tuesday');
            bsExtDaily.WeekEndDate('Wednesday');
            bsExtDaily.WeekEndDate('Thursday');
            bsExtDaily.WeekEndDate('Friday');
            bsExtDaily.WeekEndDate('Saturday');            
            bsExtDaily.WeekEndDate('Sunday');
            
            bsExtDaily.MonthNumber('Jan');
            bsExtDaily.MonthNumber('Feb');
            bsExtDaily.MonthNumber('Mar');
            bsExtDaily.MonthNumber('Apr');
            bsExtDaily.MonthNumber('May');
            bsExtDaily.MonthNumber('Jun');
            bsExtDaily.MonthNumber('Jul');
            bsExtDaily.MonthNumber('Aug');
            bsExtDaily.MonthNumber('Sep');
            bsExtDaily.MonthNumber('Oct');
            bsExtDaily.MonthNumber('Nov');
            bsExtDaily.MonthNumber('Dec');
            
          //  bsExtDaily.datCustomStartDate = System.Today().addDays(-90);            
          //  bsExtDaily.datCustomEndDate = System.Today();
            bsExtDaily.WeekStartDate = System.Today().addDays(-90);
            bsExtDaily.WeekEndDate = System.Today();
            bsExtDaily.DisplayCallSummary();
            
           // bsExtDaily.datCustomStartDate = System.Today().addDays(-90);
           // bsExtDaily.datCustomEndDate = System.Today();
            bsExtDaily.exportToExcel();
            bsExtDaily.SendMailToUserOnly();
            
            // for inserting the list of accounts
            Call_Summary__c[] list_APACCallSummary = new List<Call_Summary__c>();
        
            Call_Summary__c objTest1 = new Call_Summary__c();
            objTest1.Actual_Calls__c = 10;
            objTest1.Area__c = 'Test111';
            objTest1.Business_Day_or_not__c = true;
            objTest1.Date__c = Date.valueOf('2013-01-06 00:00:00');           
            objTest1.Planned_Calls__c = 10;
            objTest1.RegionINDSU__c = 'West';
            objTest1.Targeted_Calls__c = 20;
            objTest1.Total_Customers__c = 165;
            objTest1.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest1.Unique__c = '000000000000000001' + String.valueOf(objTest1.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest1);
            
            Call_Summary__c objTest2 = new Call_Summary__c();
            objTest2.Actual_Calls__c = 10;
            objTest2.Area__c = 'Test123';
            objTest2.Business_Day_or_not__c = true;
            objTest2.Date__c = Date.valueOf('2013-02-06 00:00:00');            
            objTest2.Planned_Calls__c = 10;
            objTest2.RegionINDSU__c = 'West';
            objTest2.Targeted_Calls__c = 20;
            objTest2.Total_Customers__c = 165;
            objTest2.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest2.Unique__c = '000000000000000001' + String.valueOf(objTest2.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest2);
            
            Call_Summary__c objTest3 = new Call_Summary__c();
            objTest3.Actual_Calls__c = 10;
            objTest3.Area__c = 'Test123';
            objTest3.Business_Day_or_not__c = true;
            objTest3.Date__c = Date.valueOf('2013-03-06 00:00:00');            
            objTest3.Planned_Calls__c = 10;
            objTest3.RegionINDSU__c = 'West';
            objTest3.Targeted_Calls__c = 20;
            objTest3.Total_Customers__c = 165;
            objTest3.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest3.Unique__c = '000000000000000001' + String.valueOf(objTest3.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest3);
            
            Call_Summary__c objTest4 = new Call_Summary__c();
            objTest4.Actual_Calls__c = 10;
            objTest4.Area__c = 'Test123';
            objTest4.Business_Day_or_not__c = true;
            objTest4.Date__c = Date.valueOf('2013-04-06 00:00:00');            
            objTest4.Planned_Calls__c = 10;
            objTest4.RegionINDSU__c = 'West';
            objTest4.Targeted_Calls__c = 20;
            objTest4.Total_Customers__c = 165;
            objTest4.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest4.Unique__c = '000000000000000001' + String.valueOf(objTest4.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest4);
            
            Call_Summary__c objTest5 = new Call_Summary__c();
            objTest5.Actual_Calls__c = 10;
            objTest5.Area__c = 'Test123';
            objTest5.Business_Day_or_not__c = true;
            objTest5.Date__c = Date.valueOf('2013-05-06 00:00:00');            
            objTest5.Planned_Calls__c = 10;
            objTest5.RegionINDSU__c = 'West';
            objTest5.Targeted_Calls__c = 20;
            objTest5.Total_Customers__c = 165;
            objTest5.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest5.Unique__c = '000000000000000001' + String.valueOf(objTest5.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest5);
            
            Call_Summary__c objTest6 = new Call_Summary__c();
            objTest6.Actual_Calls__c = 10;
            objTest6.Area__c = 'Test123';
            objTest6.Business_Day_or_not__c = true;
            objTest6.Date__c = Date.valueOf('2013-06-06 00:00:00');            
            objTest6.Planned_Calls__c = 10;
            objTest6.RegionINDSU__c = 'West';
            objTest6.Targeted_Calls__c = 20;
            objTest6.Total_Customers__c = 165;
            objTest6.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest6.Unique__c = '000000000000000001' + String.valueOf(objTest6.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest6);
            
            Call_Summary__c objTest7 = new Call_Summary__c();
            objTest7.Actual_Calls__c = 10;
            objTest7.Area__c = 'Test123';
            objTest7.Business_Day_or_not__c = true;
            objTest7.Date__c = Date.valueOf('2013-07-06 00:00:00');            
            objTest7.Planned_Calls__c = 10;
            objTest7.RegionINDSU__c = 'West';
            objTest7.Targeted_Calls__c = 20;
            objTest7.Total_Customers__c = 165;
            objTest7.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest7.Unique__c = '000000000000000001' + String.valueOf(objTest7.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest7);
            
            Call_Summary__c objTest8 = new Call_Summary__c();
            objTest8.Actual_Calls__c = 10;
            objTest8.Area__c = 'Test123';
            objTest8.Business_Day_or_not__c = true;
            objTest8.Date__c = Date.valueOf('2013-08-06 00:00:00');            
            objTest8.Planned_Calls__c = 10;
            objTest8.RegionINDSU__c = 'West';
            objTest8.Targeted_Calls__c = 20;
            objTest8.Total_Customers__c = 165;
            objTest8.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest8.Unique__c = '000000000000000001' + String.valueOf(objTest8.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest8);
            
            Call_Summary__c objTest9 = new Call_Summary__c();
            objTest9.Actual_Calls__c = 10;
            objTest9.Area__c = 'Test123';
            objTest9.Business_Day_or_not__c = true;
            objTest9.Date__c = Date.valueOf('2013-09-06 00:00:00');            
            objTest9.Planned_Calls__c = 10;
            objTest9.RegionINDSU__c = 'West';
            objTest9.Targeted_Calls__c = 20;
            objTest9.Total_Customers__c = 165;
            objTest9.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest9.Unique__c = '000000000000000001' + String.valueOf(objTest9.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest9);
            
            Call_Summary__c objTest10 = new Call_Summary__c();
            objTest10.Actual_Calls__c = 10;
            objTest10.Area__c = 'Test123';
            objTest10.Business_Day_or_not__c = true;
            objTest10.Date__c = Date.valueOf('2013-10-06 00:00:00');            
            objTest10.Planned_Calls__c = 10;
            objTest10.RegionINDSU__c = 'West';
            objTest10.Targeted_Calls__c = 20;
            objTest10.Total_Customers__c = 165;
            objTest10.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest10.Unique__c = '000000000000000001' + String.valueOf(objTest10.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest10);
            
            Call_Summary__c objTest11 = new Call_Summary__c();
            objTest11.Actual_Calls__c = 10;
            objTest11.Area__c = 'Test123';
            objTest11.Business_Day_or_not__c = true;
            objTest11.Date__c = Date.valueOf('2013-11-06 00:00:00');            
            objTest11.Planned_Calls__c = 10;
            objTest11.RegionINDSU__c = 'West';
            objTest11.Targeted_Calls__c = 20;
            objTest11.Total_Customers__c = 165;
            objTest11.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest11.Unique__c = '000000000000000001' + String.valueOf(objTest11.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest11);
            
            Call_Summary__c objTest12 = new Call_Summary__c();
            objTest12.Actual_Calls__c = 10;
            objTest12.Area__c = 'Test123';
            objTest12.Business_Day_or_not__c = true;
            objTest12.Date__c = Date.valueOf('2013-12-06 00:00:00');            
            objTest12.Planned_Calls__c = 10;
            objTest12.RegionINDSU__c = 'West';
            objTest12.Targeted_Calls__c = 20;
            objTest12.Total_Customers__c = 165;
            objTest12.Country__c = 'INDIA';
            //Unique__c = '0000000000000000012013-03-06:00:00:00');
            objTest12.Unique__c = '000000000000000001' + String.valueOf(objTest12.Date__c);
            //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today())
            list_APACCallSummary.add(objTest12);
            
            insert list_APACCallSummary;

            Call_Summary__c Today2b = new Call_Summary__c(
                Actual_Calls__c = 10,
                Area__c = 'Test123',
                Business_Day_or_not__c = true,
                Date__c = Date.valueOf('2013-01-06 00:00:00'),                
                Planned_Calls__c = 10,
                RegionINDSU__c = 'West',
                Targeted_Calls__c = 20,
                Total_Customers__c = 165,
                Country__c = 'INDIA',
                //Unique__c = '0000000000000000012013-03-06:00:00:00');
                Unique__c = '000000000000000001' + String.valueOf(System.Today()));
                //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today()));
            
            System.debug('******************Inserting the test buyer record...');
            Insert Today2b;
            
            //----------------------------------------------------------------------------------
            Profile oProfileBLSSO = [SELECT Id FROM profile WHERE name = 'INDAES Sales Rep' limit 1]; 
                Map<string,UserRole> role = new Map<string,UserRole>();
                for(UserRole r:[select Id,Name from UserRole where name in ('INDAES Sales Rep(West)','INDAES Area Sales Manager(West)') ]){
                    role.put(r.Name,r);
                }
                User oUserBLSSO  = new User(alias = 'mg456', 
                                     email='mgruser456@testorg.com', 
                                     emailencodingkey='UTF-8',
                                     lastname='lastname2',
                                     languagelocalekey='en_US', 
                                     localesidkey='en_US', 
                                     profileid = oProfileBLSSO.Id, 
                                     timezonesidkey='America/Los_Angeles',
                                     username='mgruser456789@testorg.com',
                                     UserRole = role.get('INDAES Area Sales Manager(West)'));
                insert oUserBLSSO;
                
             Call_Summary__c TodayAES = new Call_Summary__c(
                Actual_Calls__c = 10,
                Area__c = 'Test123',
                Business_Day_or_not__c = true,
                Date__c = Date.valueOf('2014-01-06 00:00:00'),                
                Planned_Calls__c = 10,
                RegionINDSU__c = 'West',
                Targeted_Calls__c = 20,
                Total_Customers__c = 165,
                Country__c = 'INDIA',
                OwnerId=oUserBLSSO.Id,
                //Unique__c = '0000000000000000012013-03-06:00:00:00');
                Unique__c = '000000000000000001' + String.valueOf(System.Today()));
                //Unique__c = String.ValueOf(objUserSalesRepNew.Id) + String.valueOf(System.Today()));
            
            System.debug('******************Inserting the test buyer record...');
            Insert TodayAES;
          //----------------------------------------------------------------------------------   
            ApexPages.StandardController Monthlycontroller = new ApexPages.StandardController(Today2b);
            clsSFEMonthlyAvgCustomReportINDAES bsExtMonthly = new clsSFEMonthlyAvgCustomReportINDAES(Monthlycontroller);
            
          //  bsExtMonthly.WeekStartDate = System.Today();
          //  bsExtMonthly.WeekEndDate = System.Today();
            //bsExtMonthly.WeekStartDate = System.Today().addDays(-3);
            //bsExtMonthly.WeekEndDate = System.Today().addDays(-1); 
            bsExtMonthly.InitCurrentMonth();
            bsExtMonthly.exportToExcel(); 
            bsExtMonthly.SendMailToUserOnly();           
            bsExtMonthly.getSelectedMonth();
            Date strDateMon = Date.valueOF(System.Now());            
            bsExtMonthly.getMonthStartDate('Mar',strDateMon); 
            bsExtMonthly.daysInMonths(1);
            bsExtMonthly.daysInMonths(2);
            bsExtDaily.daysInMonths(3);
            bsExtMonthly.daysInMonths(4);
            bsExtMonthly.daysInMonths(5);
            bsExtMonthly.daysInMonths(6);
            bsExtMonthly.daysInMonths(7);
            bsExtMonthly.daysInMonths(8);
            bsExtMonthly.daysInMonths(9);
            bsExtMonthly.daysInMonths(10);
            bsExtMonthly.daysInMonths(11);
            bsExtMonthly.daysInMonths(12);
            bsExtMonthly.WeekStartDate('Monday');
            bsExtMonthly.WeekStartDate('Tuesday');
            bsExtMonthly.WeekStartDate('Wednesday');
            bsExtMonthly.WeekStartDate('Thursday');
            bsExtMonthly.WeekStartDate('Friday');
            bsExtMonthly.WeekStartDate('Saturday');            
            bsExtMonthly.WeekStartDate('Sunday');
            
            bsExtMonthly.WeekEndDate('Monday');
            bsExtMonthly.WeekEndDate('Tuesday');
            bsExtMonthly.WeekEndDate('Wednesday');
            bsExtMonthly.WeekEndDate('Thursday');
            bsExtMonthly.WeekEndDate('Friday');
            bsExtMonthly.WeekEndDate('Saturday');            
            bsExtMonthly.WeekEndDate('Sunday');
            
            bsExtMonthly.MonthNumber('Jan');
            bsExtMonthly.MonthNumber('Feb');
            bsExtMonthly.MonthNumber('Mar');
            bsExtMonthly.MonthNumber('Apr');
            bsExtMonthly.MonthNumber('May');
            bsExtMonthly.MonthNumber('Jun');
            bsExtMonthly.MonthNumber('Jul');
            bsExtMonthly.MonthNumber('Aug');
            bsExtMonthly.MonthNumber('Sep');
            bsExtMonthly.MonthNumber('Oct');
            bsExtMonthly.MonthNumber('Nov');
            bsExtMonthly.MonthNumber('Dec');
            
    }
    static testMethod void clsPhysicianVisit_AU_UpdateFutureVisits_Test() { 
         // TO DO: implement unit test
        try{
                clsPhysicianVisitUpdate.isExecute = false;
                clsPhysicianVisitUpdate.isInsert = false;
                clsPhysicianVisitUpdate.isUpdate = false;
                Profile oProfileBLSSO = [SELECT Id FROM profile WHERE name = 'INDAES Sales Rep' limit 1]; 
                Map<string,UserRole> role = new Map<string,UserRole>();
                for(UserRole r:[select Id,Name from UserRole where name in ('INDAES Sales Rep(West)','INDAES Area Sales Manager(West)') ]){
                    role.put(r.Name,r);
                }
                User oUserBLSSO  = new User(alias = 'mg456', 
                                     email='mgruser456@testorg.com', 
                                     emailencodingkey='UTF-8',
                                     lastname='lastname2',
                                     languagelocalekey='en_US', 
                                     localesidkey='en_US', 
                                     profileid = oProfileBLSSO.Id, 
                                     timezonesidkey='America/Los_Angeles',
                                     username='mgruser456789@testorg.com',
                                     UserRole = role.get('INDAES Area Sales Manager(West)'));
                insert oUserBLSSO;
                
                Profile oProfile = [SELECT Id FROM profile WHERE name = 'INDAES Sales Rep' limit 1]; 
                User oUser  = new User(alias = 'mg123', 
                                     email='mgruser123@testorg.com', 
                                     emailencodingkey='UTF-8',
                                     lastname='lastname2',
                                     languagelocalekey='en_US', 
                                     localesidkey='en_US', 
                                     profileid = oProfile.Id, 
                                     timezonesidkey='America/Los_Angeles',
                                     username='mgruser123456@testorg.com',
                                     UserRole = role.get('INDAES Sales Rep(West)'));
                insert oUser;
                Map<string,String> map_RecordType = new Map<string,String>();
                for(RecordType rt : [Select Id, Name from RecordType where Name in ('INDSU Indirect','INDSU Contact','INDSU Sales Unplanned','INDSU Sales Planned','INDSU Monthly Implantation Detail') and sObjectType in ('Physician_Visit__c','Account','Contact','Monthly_Implantation_Detail__c')])
                {
                    map_RecordType.put(rt.Name,rt.Id);
                }
                system.debug('Record Type Value : ' + map_RecordType);
                system.debug('Plenned User Role.Name : ' + oUser.UserRole.Name);
                system.debug('UnPlenned User Role.Name : ' + oUserBLSSO.UserRole.Name);
                //objUser.UserRole.Name
                //Name = 'INDSU Sales Unplanned'
                //Name  = 'INDSU Sales Planned'
                /**********Account **************/
                Account oAccount = new Account();          
                oAccount.OwnerId = oUserBLSSO.Id;            
                oAccount.Name = 'Test'; 
                oAccount.recordTypeId = map_RecordType.get('INDSU Indirect');          
                insert oAccount;
                /**********Contact **************/
                Contact oContact = new Contact();           
                oContact.AccountId = oAccount.Id;                        
                oContact.LastName = 'Test Contact';
                oContact.recordTypeId = map_RecordType.get('INDSU Contact');   
                insert oContact;
                
                    List<Physician_Visit__c> pvListPlanned = new List<Physician_Visit__c>();
                    List<Physician_Visit__c> pvListPlannedUpdate = new List<Physician_Visit__c>();
                    List<Physician_Visit__c> pvListUnPlanned = new List<Physician_Visit__c>();
                    for(Integer i=0;i<10;i++){
                        Physician_Visit__c oPhysicianVisit = new Physician_Visit__c();
                        
                        oPhysicianVisit.Activity_Date__c = System.today()-1;
                        oPhysicianVisit.Physician__c = oContact.Id;
                        oPhysicianVisit.Status__c = 'Open';
                        oPhysicianVisit.Session__c = 'AM';
                        oPhysicianVisit.Planned_Call__c = false;
                        oPhysicianVisit.OwnerId = oUserBLSSO.Id;
                        oPhysicianVisit.Start_Time__c = Datetime.Now();
                        oPhysicianVisit.End_Time__c = Datetime.Now();
                        oPhysicianVisit.Joint_Call_With_ASM__c = False;           
                        oPhysicianVisit.Last_Activity__c=null;
                        if((i/2)==0){
                            oPhysicianVisit.RecordTypeId = map_RecordType.get('INDSU Sales Unplanned');
                            pvListUnPlanned.add(oPhysicianVisit);  
                        }
                        else{
                            oPhysicianVisit.RecordTypeId = map_RecordType.get('INDSU Sales Planned');  
                            pvListPlanned.add(oPhysicianVisit);
                        }
                        
                    }
                 system.debug('Planned Physician Visit List : '+ pvListPlanned);
                 system.debug('Unplanned Physician Visit List : '+ pvListUnPlanned);
                 Test.StartTest();
                 system.runAs(oUser){   
                    insert pvListPlanned;
                 }
                 system.runAs(oUserBLSSO){   
                    insert pvListUnPlanned;
                 }                    
                clsPhysicianVisitUpdate.isExecute = false;
                clsPhysicianVisitUpdate.isInsert = false;
                clsPhysicianVisitUpdate.isUpdate = false;
                system.runAs(oUser){
                    for(Physician_Visit__c pv:pvListPlanned){
                        pv.Status__c = 'Completed';
                        pvListPlannedUpdate.add(pv);
                    }
                    
                    update pvListPlannedUpdate;
                }
                system.runAs(oUserBLSSO){                     
                    update pvListUnPlanned;
                }
                system.runAs(oUserBLSSO){                    
                    update pvListUnPlanned;
                }
                system.runAs(oUser){
                    for(Physician_Visit__c pv:pvListPlanned){
                        pv.Status__c = 'Completed';
                        pvListPlannedUpdate.add(pv);
                    }                    
                    update pvListPlannedUpdate;
                }
                Test.StopTest(); 
                Physician_Visit__c oPhysicianVisit1 = new Physician_Visit__c();             
                oPhysicianVisit1.Activity_Date__c = System.today()-1;
                oPhysicianVisit1.Physician__c = oContact.Id;
                oPhysicianVisit1.Status__c = 'Open';
                oPhysicianVisit1.Session__c = 'AM';
                oPhysicianVisit1.Planned_Call__c = false;
                oPhysicianVisit1.OwnerId = oUserBLSSO.Id;
                oPhysicianVisit1.Start_Time__c = Datetime.Now();
                oPhysicianVisit1.End_Time__c = Datetime.Now();
                oPhysicianVisit1.Joint_Call_With_ASM__c = False;           
                oPhysicianVisit1.Last_Activity__c=null;             
                oPhysicianVisit1.RecordTypeId = map_RecordType.get('INDSU Sales Unplanned');
                             
                
                system.runAs(oUser){                                                                        
                    //insert oPhysicianVisit2;
                }
                system.runAs(oUserBLSSO){   
                    insert oPhysicianVisit1;
                }
                system.runAs(oUserBLSSO){                       
                    update oPhysicianVisit1;
                }
                system.runAs(oUser){                    
                    //oPhysicianVisit2.Status__c = 'Completed';
                    //update oPhysicianVisit2;
                }
                
        }
        catch(Exception ex){
            system.debug('Exception Occurred as : ' + ex.getMessage()+'\n At Line Number : '+ ex.getLineNumber());
        }
    }
}