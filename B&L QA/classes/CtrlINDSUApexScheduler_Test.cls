@isTest
private class CtrlINDSUApexScheduler_Test {

    static testMethod void myUnitTest() {
        CtrlINDSUApexScheduler scheduler = new CtrlINDSUApexScheduler();
       
            //system.abortJob('INDSU Populate Call Summary');
            scheduler.populateCallSummary();
        
    }
}