/*******************************************************************************
 *  The Trigger is preventing more than one activity in a half date
 *  copyright (c) 2011 breakingpoint.com C, Ltd. 
 *  Apex Trigger    : TrgOtheroldActivity.trigger
 *  Summary         : There should be no more than one activity in a half date
 *  Refer Object    : Other_Call_Activity__c
 *  Author          : Mouse.liu(mouse.liu@ibreakingpoint.com)　       
 *  CreatedDate     : 2011/09/26
 *  Change Log      : 
 ******************************************************************************/
trigger CHNSU_TrgOtherCallActivity on Other_Call_Activity__c (before insert, before update, 
                                                              after insert, after update, 
                                                              before delete) {
                                            
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        
        List<Other_Call_Activity__c> olds = [ Select Start_Session__c, Start_Date__c, Name, 
                                              End_Session__c, End_Date__c, Activity_Type__c 
                                              From Other_Call_Activity__c o
                                              Where Start_Date__c >=: System.today() - 3
                                              And End_Date__c <=: System.today()
                                              And Id NOT IN: trigger.new
                                              And OwnerId =: UserInfo.getUserId()
                                              order by Start_Date__c, Start_Session__c];
        
        if(olds.size() == 0) {
            return;
        }
        
        for(Other_Call_Activity__c n : trigger.new) {
            for(Other_Call_Activity__c old : olds) {
                
                if(n.Start_Date__c == old.Start_Date__c && n.End_Date__c == old.End_Date__c) {
                    
                    if(old.Start_Session__c == 'AM' && old.End_Session__c == 'PM') {
                        CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                    }
                    
                    else if(old.Start_Session__c == 'PM' && old.End_Session__c == 'PM') {
                        if(n.End_Session__c == 'PM') {
                            CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                        }
                    }
                    
                    else if(old.Start_Session__c == 'AM' && old.End_Session__c == 'AM') {
                        if(n.Start_Session__c == 'AM') {
                            CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                        }
                    }   
                }
                
                else if((n.Start_Date__c > old.Start_Date__c && n.End_Date__c < old.End_Date__c) ||
                        (n.Start_Date__c < old.Start_Date__c && n.End_Date__c > old.End_Date__c)) {
                            
                    CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                }
                
                else if(n.Start_Date__c == old.End_Date__c && 
                        !(n.Start_Session__c == 'PM' &&
                        old.End_Session__c == 'AM')) {
                            
                    CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                }
                
                else if(n.End_Date__c == old.Start_Date__c &&
                        !(n.End_Session__c == 'AM' &&
                        old.Start_Session__c == 'PM')) {
                            
                    CHNSU_UtilOtherCallActivity.addError(trigger.new, old);   
                }
                
                else if(n.Start_Date__c < old.Start_Date__c && n.End_Date__c == old.End_Date__c) {
                    if(!(old.Start_Session__c == 'PM' &&
                         old.End_Session__c == 'PM' &&
                         n.End_Session__c == 'AM')) {
                            
                            CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                    }
                }
                
                else if(n.Start_Date__c > old.Start_Date__c && n.End_Date__c == old.End_Date__c) {
                    if(!(n.Start_Session__c == 'PM' &&
                         n.End_Session__c == 'PM' &&
                         old.End_Session__c == 'AM')) {
                            
                            CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                    }
                }
                
                else if(n.Start_Date__c == old.Start_Date__c && n.End_Date__c > old.End_Date__c) {
                    if(!(n.Start_Session__c == 'AM' &&
                         n.End_Session__c == 'AM' &&
                         old.End_Session__c == 'PM')) {
                            
                            CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                    }
                }
                
                else if(n.Start_Date__c == old.Start_Date__c && n.End_Date__c < old.End_Date__c) {
                    if(!(old.Start_Session__c == 'AM' &&
                         old.End_Session__c == 'AM' &&
                         n.End_Session__c == 'PM')) {
                            
                            CHNSU_UtilOtherCallActivity.addError(trigger.new, old);
                    }
                }
            }
        }
    }
    // Added by Sandeep
    map<id,RecordType> AllRec = new map<id,RecordType>([select id,name from RecordType where sObjectType='Other_Call_Activity__c']);
    // Create Event
    if(trigger.isInsert && trigger.isAfter) {
        
        List<Event> events = new List<Event>();
        
        for(Other_Call_Activity__c o : trigger.new) {

        // Added by Sandeep
            Datetime startDatetime;
            Datetime endDatetime;            
            if(AllRec.get(o.RecordTypeId).name != 'INDSU Other Call Activity')
            {
                startDatetime = CHNSU_UtilOtherCallActivity.parseDatetime(o.Start_Session__c, o.Start_Date__c, true);
                endDatetime = CHNSU_UtilOtherCallActivity.parseDatetime(o.End_Session__c, o.End_Date__c, false);                
            }
            else
            {
                startDatetime = CHNSU_UtilOtherCallActivity.parseDatetime_Ind(o.Start_Session__c, o.Start_Date__c, true);
                endDatetime = CHNSU_UtilOtherCallActivity.parseDatetime_Ind(o.End_Session__c, o.End_Date__c, false);                
            }

            
            Event e = new Event(OwnerId = o.OwnerId, Event_Type__c = o.Activity_Type__c, 
                                Description = o.Comments__c, 
                                StartDateTime = startDatetime, EndDateTime = endDatetime,
                                WhatId = o.Id, Subject = o.Start_Date__c.format() + ' ' + 
                                                         o.Start_Session__c +' - ' + 
                                                         o.End_Date__c.format() + ' ' + 
                                                         o.End_Session__c + ' ' + 
                                                         o.Activity_Type__c);
            events.add(e);
        }
        
        try{
            insert events;
        }
        catch(Exception e) {
            Trigger.new[0].addError(e.getMessage());
        }
    }
    
    // Update Event
    if(trigger.isUpdate && trigger.isAfter) {
        
        // put eventMap<Other Call Activity Id, Event>
        Set<Id> callIds = new Set<Id>();
        for(Other_Call_Activity__c o : trigger.new) {
            callIds.add(o.Id);
        }
        List<Event> events = [Select OwnerId, Event_Type__c, Description, WhatId,
                              StartDateTime, EndDateTime
                              From Event 
                              Where WhatId IN: callIds];
        
        Map<Id, Event> eventMap = new Map<Id, Event>();
        for(Event e : events) {
            eventMap.put(e.WhatId, e);
        }
        
        // Update events.
        events.clear();
        for(Other_Call_Activity__c o : trigger.new) {
            
            // Added by Sandeep
            Datetime startDatetime;
            Datetime endDatetime;
            
            if(AllRec.get(o.RecordTypeId).name != 'INDSU Other Call Activity')
            {
                startDatetime = CHNSU_UtilOtherCallActivity.parseDatetime(o.Start_Session__c, o.Start_Date__c, true);
                endDatetime = CHNSU_UtilOtherCallActivity.parseDatetime(o.End_Session__c, o.End_Date__c, false);                
            }
            else
            {
                startDatetime = CHNSU_UtilOtherCallActivity.parseDatetime_Ind(o.Start_Session__c, o.Start_Date__c, true);
                endDatetime = CHNSU_UtilOtherCallActivity.parseDatetime_Ind(o.End_Session__c, o.End_Date__c, false);                
            }

            
            Event e = eventMap.get(o.Id);
                  e.OwnerId = o.OwnerId;
                  e.Event_Type__c = o.Activity_Type__c;
                  e.Description = o.Comments__c;
                  e.StartDateTime = startDatetime;
                  e.EndDateTime = endDatetime;
                  e.Subject = o.Start_Date__c.format() + ' ' + 
                              o.Start_Session__c +' - ' + 
                              o.End_Date__c.format() + ' ' + 
                              o.End_Session__c + ' ' + 
                              o.Activity_Type__c;
            events.add(e);
        }
        
        try {
            update events;
        }
        catch(Exception e) {
            Trigger.new[0].addError(e.getMessage());
        }
    }
    
    // Delete Event once Other Call Activity is deleted.
    if(trigger.isDelete && trigger.isBefore) {
        
        // get all related events
        Set<Id> callIds = new Set<Id>();
        for(Other_Call_Activity__c o : trigger.old) {
            callIds.add(o.Id);
        }
        List<Event> events = [Select Id
                              From Event 
                              Where WhatId IN: callIds];
        try{
            delete events;
        }
        catch(Exception e) {
            Trigger.old[0].addError(e.getMessage());
        }
    }
}