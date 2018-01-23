/**
* 
* This is the controller for reporting the errors on the call plan 
* Author               |Author-Email                       |Date        |Comment
* ---------------------|---------------------------------- |------------|----------------------------------------------------
* Yash Agarwal         |yash.agarwal@listertechnologies.com|20.05.2010  |First Draft for CtrlCallPlanning_planDetail page
* Sourav Mitra         |sourav.mitra@listertechnologies.com|08.09.2010  |Changes to incorporate China SU
*/
public class CtrlCallPlanErrors
{
    public id idContact ;
    public Date datLastMonthEndDate;
    public Date datLastMonthStartDate;
    
    //public Id idRecordTypeCallPlanDetail;
    //public Id idRecordTypePhysicianVisit;
    public List<RecordType> list_CallPlanRecordTypes;
    public List<RecordType> list_PhysicianVisitRecordTypes;
    
    public Map<Date,Physician_Visit__c> map_ActivityDate_PhysicianVisit ;
    public List<CallPlanError> list_CallPlanError{ get; set;}
    public List<Call_Plan_Detail__c> list_callPlanDetailRecords = new List<Call_Plan_Detail__c>();
    public List<Physician_Visit__c> list_physicianVist= new List<Physician_Visit__c>();
    public class CallPlanError{
    
        public Call_Plan_Detail__c objCallPlanDetail{ get; set;}
        public String strActual { get; set;}
        public CallPlanError(){
        
            objCallPlanDetail = new Call_Plan_Detail__c();
            strActual = '';
        }
    }
    
    CallPlanError cpe = new CallPlanError();
    
    public CtrlCallPlanErrors()
    {
        String strStartDate;
        String strEndDate;
        
        //getting the record type ids
        list_CallPlanRecordTypes = [SELECT Id FROM RecordType 
                                        WHERE Name IN ('INDSU Call Plan Detail','APACSU Call Plan Detail') AND SObjectType='Call_Plan_Detail__c'];
        
        list_PhysicianVisitRecordTypes = [SELECT Id FROM RecordType 
                                        WHERE Name IN ('INDSU Sales Planned','INDSU Sales Planned') AND SObjectType='Physician_Visit__c'];    
        
        
        if(ApexPages.currentPage().getParameters().get('conId') != null)
            idContact = ApexPages.currentPage().getParameters().get('conId');
            
        if(ApexPages.currentPage().getParameters().get('start') != null)
            strStartDate = ApexPages.currentPage().getParameters().get('start');
            
        if(ApexPages.currentPage().getParameters().get('end') != null)
            strEndDate = ApexPages.currentPage().getParameters().get('end');
            
        if(idContact != null)
        {
            if(strStartDate != null && strEndDate != null){
            
                datLastMonthStartDate = date.valueOf(strStartDate);
                system.debug('Start>>' + datLastMonthStartDate);
                datLastMonthEndDate = date.valueOf(strEndDate);
                system.debug('End>>' + datLastMonthEndDate );
                system.debug('End>>' + idContact );
                list_callPlanDetailRecords = [Select Id,
                
                                                    Physician_Name__c,
                                                     Physician_Name__r.Name,
                                                    Physician_Name__r.AccountId,
                                                    Physician_Name__r.Account.name,
                                                    Call_Plan__c,
                                                    Date__c,
                                                    Call__c From Call_Plan_Detail__c where Physician_Name__c =:idContact 
                                                                                    AND Date__c >=  :datLastMonthStartDate
                                                                                    AND Date__c <= :datLastMonthEndDate
                                                                                    AND RecordTypeId IN :list_CallPlanRecordTypes
                                                                                    AND Call__c = true];
                if(list_callPlanDetailRecords.size() > 0)
                {
                    list_physicianVist = [Select Id,
                                                Activity_Date__c,
                                                Physician__c,
                                                Status__c From Physician_Visit__c Where Physician__c = :idContact
                                                                                AND Activity_Date__c >=  :datLastMonthStartDate
                                                                                AND Activity_Date__c <= :datLastMonthEndDate
                                                                                AND RecordTypeId IN :list_PhysicianVisitRecordTypes
                                                                                AND Status__c = 'Completed'];
                                                                                
                    if(list_physicianVist.size() >0)
                    {
                        map_ActivityDate_PhysicianVisit = new Map<Date,Physician_Visit__c>();  for(Physician_Visit__c phyV : list_physicianVist){ map_ActivityDate_PhysicianVisit.put(phyV.Activity_Date__c,phyV);
                        }
                        list_CallPlanError = new List<CallPlanError>();  for(Call_Plan_Detail__c cpd :list_callPlanDetailRecords){ cpe = new callPlanError(); cpe.objCallPlanDetail= cpd;
                            if(map_ActivityDate_PhysicianVisit.containsKey(cpd.Date__c)){  cpe.strActual = 'Y';
                            } else{
                                cpe.strActual = 'N';
                            }
                            list_CallPlanError.add(cpe);
                        }
                        
                    } else{
                        addErrorMessage('No visits for the given contact was met in the previous month');
                    }
                } else{
                    addErrorMessage('No planned calls exist for the given contact');
                }
                                
            } else{
                addErrorMessage('Months start/end date not known');
            }
        } else{
            addErrorMessage('No physician Id specified');
        }
        
        
    }
    
    public void addErrorMessage(String error){
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, error);
        ApexPages.addMessage(msg);
    }
}