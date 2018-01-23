/**
     *   The following Trigger Assign Case to different user if the category is matched.
     *
     *   Author             |Author-Email                        |   Date      |   Comment
     *   -------------------|------------------------------------|------------- |--------------------------------------------------
     *   Sanjib Mahanta       |Sanjib.Mahanta@bausch.com          | 31/08/2011  |  Final Version
     */


    trigger TrgCaseAssignment on Case (after insert) {
            
        
        if (Trigger.isAfter && Trigger.isInsert){
                Id caseId = Trigger.new[0].Id;                
                List<Case> listCase = new List<Case>();
                Map<Id,Case> mapCase = new Map<Id,Case>();
                listCase = [select OwnerId,Id,Category__c,RecordTypeId,Corrective_Action__c,Status from Case where Id =:caseId];
                RecordType recordType=[SELECT Id, Name FROM RecordType where Id =:listCase[0].RecordTypeId];
                if (recordType.name == 'INDSU CS Case'){      
                List<Account> listAccount = new List<Account>();
                List<AccountTeamMember> listMember = new List<AccountTeamMember>(); 
                
                List<User> listUser = new List<User>();
                List<User> list_ObjUser = new List<User>();
                List<User> adminUser = new List<User>();
                
                listAccount = [select Id, Name FROM Account where Account.Id=:Trigger.new[0].AccountId]; 
                User contryCon = [select Id,Name,User_Role__c from User where User_Role__c like '%INDSU Account Owner%' and IsActive = true limit 1];               
               // adminUser =[select Id,Name,User_Role__c from User where User_Role__c like '%INDSU Sales Administrator%' and IsActive = true];
                
                if(listAccount.size()>0)
                listMember = [select Id,UserId,TeamMemberRole from AccountTeamMember where AccountTeamMember.AccountId=:listAccount[0].Id]; 
                System.debug('Team Member : '+listMember);                   
                if( listMember.size()>0){      
                listUser = [select Id,FirstName,UserRoleId,ProfileId, Profile__c, User_Role__c from User where Id =: listMember[0].UserId];
                 
                    String Id = UserInfo.getProfileId();
                    Set<Id> set_Users = ClsSingleMultiUtility.getParents(listUser[0].UserRoleId);
                    System.debug('Testiiiiii'+set_Users);
                
                    list_ObjUser = [SELECT Id, Name,User_Role__c 
                                    FROM User WHERE UserRoleId IN : set_Users 
                                    AND Profile.Name LIKE '%Manager%' AND User_Role__c like '%INDSU%'  
                                    AND IsActive = true order by User_Role__c];
                       
                List<Case> updateCase = new List<Case>();
                for(Case cse : listCase){
                
                if (cse.Category__c !='Commercial Complaint' ){
                    
                   // if (cse.Category__c =='Commercial Complaint' && cse.Corrective_Action__c == null ){
                      
                      //---Section to Execute Case assignment Rule------------                      
                      //Fetching the assignment rules on case

                        AssignmentRule AR = new AssignmentRule();
                        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

                        //Creating the DMLOptions for "Assign using active assignment rules" checkbox

                        Database.DMLOptions dmlOpts = new Database.DMLOptions();
                        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;                      
                        cse.setOptions(dmlOpts);
                        mapCase.put(cse.Id,cse);
                      }
                      // (cse.Category__c =='Commercial Complaint' ){
                      else{
                            system.debug('Inside Commercial Complaint');
                            
                               for (User u :list_ObjUser){                                    
                                    String roleName = u.User_Role__c;  
                                    if(roleName.contains('Area Sales Manager') || roleName.contains('Area Sales&Service Manager')){                            
                                        cse.OwnerId =u.Id; 
                                        mapCase.put(cse.Id,cse);
                                        break;                                        
                                    }else if (roleName.contains('Regional Manager')){
                                        cse.OwnerId =u.Id;
                                        mapCase.put(cse.Id,cse);
                                        break;                                        
                                    }else if (roleName.contains('National Sales Manager')){
                                        cse.OwnerId =u.Id; 
                                        mapCase.put(cse.Id,cse);  
                                        break;  
                                    }
                                    
                                }
                        }
                       //Commented by Sanjib as per the requirement dated 10-May-12
                        /*else if(cse.Category__c == 'Medical Complaint' && cse.Corrective_Action__c ==null){
                                    cse.status = 'Closed';
                                     updateCase.add(cse);
                                     break;
                        }else if(cse.Category__c == 'Merchandising Complaint' && cse.Corrective_Action__c == null){            
                                    cse.Status = 'Closed';
                                    updateCase.add(cse);
                                    break;
                        }else if(cse.Corrective_Action__c == 'Account Contact' && cse.Category__c == 'Commercial Complaint'){
                                cse.OwnerId = contryCon.Id;
                                updateCase.add(cse);
                                break;
                        }
                        else if(cse.Corrective_Action__c == 'Account Contact'){
                                    cse.OwnerId = contryCon.Id;
                                    updateCase.add(cse);
                                    break;
                        }*/
                        // Comment END
                        }System.debug('List of Case to Be Updated: '+mapCase);
                         if(mapCase.containsKey(caseId)){
                         updateCase.add(mapCase.values());
                         
                         //updateCase.addAll(setCase);
                         System.debug('List of Case to Be Updated: '+updateCase);
                         update updateCase;
                         }
                }else{
                return;
                }/*else{
                listCase[0].OwnerId = contryCon.Id;
                System.debug('List of Case to Be Updated: '+listCase);
                update listCase;                
                } */                  
            }else return;
                    
        }
    }