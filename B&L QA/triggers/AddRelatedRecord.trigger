trigger AddRelatedRecord on Account(after insert, after update) {
    // Call add related method from handler.
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        // call the handler method
        AccountTriggerHandler.addRelatedOpp(Trigger.New);
    }

}