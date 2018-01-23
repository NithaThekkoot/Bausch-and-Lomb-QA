/*
* 
* This trigger to update related Physician Visit Records whenever the service products change
* 
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* Gordon.Gao                    |Gordon.gao@ibreakingpoint.com                     |2012/8/15   |First Draft
*
*/
trigger UpdateRelatedPhyVisit on Service_Product__c (after insert,after update) 
{
    List<Id> PhyVisitId=new List<Id>();
    List<Physician_Visit__c> PhyVisit=new List<Physician_Visit__c>();
    List<Service_Product__c> ServicePro_ToUpdate=new List<Service_Product__c>();
    Map<Id,Service_Product__c> PhyVisitId_ServiceProMap=new Map<Id,Service_Product__c>();
    List<Service_Product__c> ServicePro=[select Physician_Visit__c,IsValidServiceProduct__c,
            FirstUpdate__c,RecordType.name,X1_8mm_Alcon__c,X1_8mm_AMO__c,X1_8mm_B_L__c,X1_8mm_HumanOptics__c,
            X1_8mm_Zeiss__c,X2_2mm_Alcon__c,X2_2mm_AMO__c,X2_2mm_B_L__c,X2_2mm_HumanOptics__c,
            X2_2mm_Zeiss__c,X2_8mm_Alcon__c,X2_8mm_AMO__c,X2_8mm_B_L__c,X2_8mm_HumanOptics__c,
            X2_8mm_Zeiss__c,X1_8mm_Others__c,X2_2mm_Others__c,X2_8mm_Others__c from Service_Product__c where Id in:Trigger.New];
    for(Service_Product__c SerPro:ServicePro)
    {
            if(SerPro.RecordType.name=='APACSU Engineer Service Product' || SerPro.RecordType.name=='APACSU Service Rep Product' )
            {   
               PhyVisitId.Add(SerPro.Physician_Visit__c);
               PhyVisitId_ServiceProMap.put(SerPro.Physician_Visit__c,SerPro);
            }  
    }
     if(PhyVisitId.size()>0 )
    {
        PhyVisit=[select Id,Status__c,X1_8mm_Alcon__c,X1_8mm_AMO__c,X1_8mm_B_L__c,X1_8mm_HumanOptics__c,
            X1_8mm_Zeiss__c,X2_2mm_Alcon__c,X2_2mm_AMO__c,X2_2mm_B_L__c,X2_2mm_HumanOptics__c,
            X2_2mm_Zeiss__c,X2_8mm_Alcon__c,X2_8mm_AMO__c,X2_8mm_B_L__c,X2_8mm_HumanOptics__c,
            X2_8mm_Zeiss__c,X1_8mm_Others__c,X2_2mm_Others__c,X2_8mm_Others__c,RecordType.Name from Physician_Visit__c where Id in:PhyVisitId];
    }    
    if(Trigger.isUpdate)
    {
      for(Physician_Visit__c PV:PhyVisit)
      {    
          Service_Product__c SP= PhyVisitId_ServiceProMap.get(PV.Id);
          system.debug('SP>>>>'+SP);
          if(PV.RecordType.Name=='APACSU Technical Service' && PV.Status__c=='Open' && SP.FirstUpdate__c==true && SP.IsValidServiceProduct__c==1)
          {
               PV.Status__c='Completed';  
               PV.Reporting_Time__c=datetime.now();
               system.debug('Status>>:' +PV.Status__c);     
      
          }
          if(PV.RecordType.Name=='APACSU Technical Service')
          {
              PV.X1_8mm_Alcon__c=PhyVisitId_ServiceProMap.get(PV.Id).X1_8mm_Alcon__c;
              PV.X1_8mm_AMO__c=PhyVisitId_ServiceProMap.get(PV.Id).X1_8mm_AMO__c;
              PV.X1_8mm_B_L__c=PhyVisitId_ServiceProMap.get(PV.Id).X1_8mm_B_L__c;
              PV.X1_8mm_HumanOptics__c=PhyVisitId_ServiceProMap.get(PV.Id).X1_8mm_HumanOptics__c;             
              PV.X1_8mm_Zeiss__c=PhyVisitId_ServiceProMap.get(PV.Id).X1_8mm_Zeiss__c;
              PV.X2_2mm_Alcon__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_2mm_Alcon__c;
              PV.X2_2mm_AMO__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_2mm_AMO__c;
              PV.X2_2mm_B_L__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_2mm_B_L__c;
              PV.X2_2mm_HumanOptics__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_2mm_HumanOptics__c;              
              PV.X2_2mm_Zeiss__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_2mm_Zeiss__c;
              PV.X2_8mm_Alcon__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_8mm_Alcon__c;
              PV.X2_8mm_AMO__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_8mm_AMO__c;
              PV.X2_8mm_B_L__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_8mm_B_L__c;
              PV.X2_8mm_HumanOptics__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_8mm_HumanOptics__c;
              PV.X2_8mm_Zeiss__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_8mm_Zeiss__c;
              PV.X1_8mm_Others__c=PhyVisitId_ServiceProMap.get(PV.Id).X1_8mm_Others__c;
              PV.X2_2mm_Others__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_2mm_Others__c;
              PV.X2_8mm_Others__c=PhyVisitId_ServiceProMap.get(PV.Id).X2_8mm_Others__c;
          
          
          }
          
          
          
     }
       
       
        
        
   }
   
        system.debug('*******************PhyVisit:'+PhyVisit);        
        if(PhyVisit.Size()>0)
        {
           // clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk=false;
            update PhyVisit;
        }    
       
    
    
}