@isTest
private class GenericCRUDTester {
    
    ///////////////////////insert testing/////////////////////////////////////
    
    @isTest 
    static void insertTestPositive() {
        Test.startTest();
        system.debug('2-->'+Limits.getLimitQueries());
        List<Contact> contacts = test_helperMethods.prepareContacts(1, false);
        GenericCrudCntrl.DMLOutputWrapper real=GenericCrudCntrl.InsertSObjects(contacts)[0];
        System.assertNotEquals(null, real.sObjID);
        Test.stopTest();    
        
    }
    
    @isTest 
    static void insertTestNegative() {
        Test.startTest();
        List<Contact> contacts = test_helperMethods.prepareContacts(1, false);
        contacts[0].LastName=null;
        GenericCrudCntrl.DMLOutputWrapper real=GenericCrudCntrl.InsertSObjects(contacts)[0];
        System.assertEquals(null, real.sObjID);
        Test.stopTest();
        
    }
    
    @isTest 
    static void insertTestBulk() {
        Test.startTest();
        List<Contact> contacts;
        
        /////////////////////all good values//////////////////////////////////////////
        
        contacts= test_helperMethods.prepareContacts(250, false);
        
        List<GenericCrudCntrl.DMLOutputWrapper> realList=GenericCrudCntrl.InsertSObjects(contacts);
        
        for (GenericCrudCntrl.DMLOutputWrapper wrapper:realList){
            System.assertNotEquals(null, wrapper.sObjID);
        }
        
        /////////////////////some bad values//////////////////////////////////////////
        
        contacts= test_helperMethods.prepareContacts(250, false);
        Contact contactfalliable = test_helperMethods.prepareContacts(1, false)[0];
        contactfalliable.LastName=null;
        contacts.add(contactfalliable);
        realList.clear();
        realList=GenericCrudCntrl.InsertSObjects(contacts);
        
        for(Integer i=0;i<realList.size()-1;i++){
            GenericCrudCntrl.DMLOutputWrapper wrapper=realList[i];
            System.assertNotEquals(null, wrapper.sObjID);
        }
        System.assertEquals(null, realList[realList.size()-1].sObjID);
        Test.stopTest();
    }
    
    ///////////////////////update testing/////////////////////////////////////
    
    @isTest 
    static void updateTestPositive() {
        Test.startTest();
        List<Contact> contacts = test_helperMethods.prepareContacts(1, true);
        contacts[0].FirstName='amanChanged';
        contacts[0].LastName='sawhneyChanged';
        
        GenericCrudCntrl.DMLOutputWrapper real=GenericCrudCntrl.UpdateSObjects(contacts)[0];
        
        System.assertEquals(TRUE, real.success);
        Test.stopTest();
        
    }
    
    @isTest 
    static void updateTestNegative() {
        Test.startTest();
        List<Contact> contacts = test_helperMethods.prepareContacts(1, false);
        GenericCrudCntrl.DMLOutputWrapper real=GenericCrudCntrl.UpdateSObjects(contacts)[0];
        System.assertEquals(FALSE, real.success);
        Test.stopTest();
        
    }
    
    @isTest 
    static void updateTestBulk() {
        Test.startTest();
        List<Contact> contacts;
        
        /////////////////////all good values//////////////////////////////////////////
        contacts= test_helperMethods.prepareContacts(250, true);
        for(Contact contactObj : contacts){
            contactObj.Firstname='newName';
            contactObj.LastName='newSurname';
        }
        List<GenericCrudCntrl.DMLOutputWrapper> realList=GenericCrudCntrl.UpdateSObjects(contacts);
        
        for (GenericCrudCntrl.DMLOutputWrapper wrapper:realList){
            System.assertNotEquals(null, wrapper.sObjID);
        }
        
        /////////////////////some bad values//////////////////////////////////////////
        
        for(Contact contactObj : contacts){
            contactObj.Firstname='newName';
            contactObj.LastName='newSurname';
        }
        Contact falliableContact=test_helperMethods.prepareContacts(1, false)[0];
        contacts.add(falliableContact);
        
        realList=GenericCrudCntrl.UpdateSObjects(contacts);
        
        for (Integer i=0;i<realList.size()-1;i++){
            System.assertNotEquals(null, realList[i].sObjID);
        }
        System.assertEquals(null, realList[realList.size()-1].sObjID);
        Test.stopTest();
        
    }
    
    ///////////////////////read testing/////////////////////////////////////
    
    @isTest 
    static void readTestPositive() {
        Test.startTest();
        List<Contact> contacts = test_helperMethods.prepareContacts(1, true);
        String query='select Id from Contact';
        GenericCrudCntrl.OutputWrapper realResponse = GenericCrudCntrl.ReadSObjects(query);
        System.assertEquals(TRUE, realResponse.success);
        Test.stopTest();
        
    }
    
    @isTest 
    static void readTestNegative() {
        Test.startTest();
        List<Contact> contacts = test_helperMethods.prepareContacts(1, true);
        String query='select Id from Contact8';
        GenericCrudCntrl.OutputWrapper realResponse = GenericCrudCntrl.ReadSObjects(query);
        System.assertEquals(FALSE, realResponse.success);
        Test.stopTest();
        
    }
    
    @isTest 
    static void readTestBulk() {
        Test.startTest();
        List<Contact> contacts = test_helperMethods.prepareContacts(250, true);
        String query='select Id from Contact';
        GenericCrudCntrl.OutputWrapper realResponse = GenericCrudCntrl.ReadSObjects(query);
        System.assertEquals(TRUE, realResponse.success);
        Test.stopTest();
        
    }
    
    ///////////////////////delete testing/////////////////////////////////////
    
    @isTest 
    static void deleteTestPositive() {
        Test.startTest();
        List<Contact> contacts = test_helperMethods.prepareContacts(1, true);
        GenericCrudCntrl.DMLOutputWrapper real=GenericCrudCntrl.DeleteSObjects(contacts)[0];
        System.assertEquals(TRUE, real.success);
        Test.stopTest();
        
    }
    
    @isTest 
    static void deleteTestNegative() {
        Test.startTest();
        List<Contact> contacts = test_helperMethods.prepareContacts(1, true);
        
        List<GenericCrudCntrl.DMLOutputWrapper> real = GenericCrudCntrl.DeleteSObjects(contacts);
        System.assertEquals(TRUE, real[0].success);
        
        real = GenericCrudCntrl.DeleteSObjects(contacts);
        System.assertEquals(FALSE, real[0].success);
        Test.stopTest();
    }
    
     @isTest 
    static void getCurrentUserTest() {
        Test.startTest();
        	GenericCrudCntrl.getCurrentUser();
        Test.stopTest();        
    }
    
    
    @isTest 
    static void deleteTestBulk() {
        Test.startTest();
        ///////////all good values//////////////////////////
        List<Contact> contacts= test_helperMethods.prepareContacts(250, true);
        List<GenericCrudCntrl.DMLOutputWrapper> real=GenericCrudCntrl.DeleteSObjects(contacts);
        for(Integer i=0;i<real.size();i++){
            System.assertEquals(TRUE, real[i].success);
        }
        
        ///////////////bad values////////////////////////
        real=GenericCrudCntrl.DeleteSObjects(contacts);
        for(Integer i=0;i<real.size()-1;i++){
            System.assertEquals(FALSE, real[i].success);
        }
        Test.stopTest();
    }
    
    @isTest 
    static void testHelperMethods() {
        Profile userProfile = [Select Id from Profile where Name = 'System Administrator'];
        Test.startTest();
        ///////////all good values//////////////////////////
        List<Contact> contacts= test_helperMethods.prepareContacts(250, true);
        List<User> users = test_helperMethods.prepareStandardUsers(userProfile.Id,10,true);
        List<GenericCrudCntrl.DMLOutputWrapper> real=GenericCrudCntrl.DeleteSObjects(contacts);
        for(Integer i=0;i<real.size();i++){
            System.assertEquals(TRUE, real[i].success);
        }
        
        ///////////////bad values////////////////////////
        real=GenericCrudCntrl.DeleteSObjects(contacts);
        for(Integer i=0;i<real.size()-1;i++){
            System.assertEquals(FALSE, real[i].success);
        }
        Test.stopTest();
    }
   
}