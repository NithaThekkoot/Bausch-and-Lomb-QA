({
    recordLoadAction : function(component, event, helper) {
        
        helper.getCurrentUserDetails(component,event,helper,function(response){
            
            var user = response;
            
            //********* Option Declarations (Do not modify )*********// 
            var RC = '';var RSL='';var RSRO='';
            var RROS='';var CCRM='';var CCTM='';
            var CCNM='';var CRCL='';var CRL='';
            var OCO='';var DST='';var LA='';
            var CEM='';var CES='';var STB='';
            var SSB='';var SES='';var SEM='';
            var SRS='';var SCS ='';var RES=''; 
            
            //*************************************************// 
            //** DocuSign Template ID **// 
            DST = '4618C403-01B3-4370-B4EB-9E0878FA57C9'; 
            
            //** Load Attachments = Yes **// 
            LA='1'; 
            //** Show send button **// 
            SSB='1'; 
            //** Show Email Subject **// 
            SES='1'; 
            CES='Consultant Invoice'; 
            //** Show Email Message **// 
            SEM='1'; 
            CEM='When Service is Complete please provide billing information in the forms Detail Grid Section.'; 
            
            CCRM='1~Customer;2~Bausch'; 
            
            //First Role should come from the send form, Second Role is Val Kolesnitchenko (MACC) as //Bausch + Lomb. 
            //This is the Custom Recipient List 
            var urlEvent = $A.get("e.force:navigateToURL");
            
            CRL= 'Email~'+component.get('v.fields.Consultant_Email__c')+
                 ';LastName~'+component.get('v.fields.Consultant_LastName__c')+
                 ';RoutingOrder~1;Role~1,Email~Valeri.Kolesnitchenko@bausch.com;'+
                 'FirstName~Valeri;LastName~Kolesnitchenko;RoutingOrder~2;'+
                 'Role~2;RecipientNote~”This Invoice is ready for your approval”';
   
            CCTM='Customer~Sign In Person'; 
            var url = "/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID="+component.get('v.recordId')+"&RC="+RC+
                "&RSL="+RSL+"&RSRO="+RSRO+"&RROS="+RROS+"&CCRM="+CCRM+"&CCTM="+CCTM+"&CRCL="+CRCL+
                "&CRL="+CRL+"&OCO="+OCO+"&DST="+DST+"&CCNM="+CCNM+"&LA="+LA+"&CEM="+CEM+"&CES="+
                CES+"&SRS="+SRS+"&STB="+STB+"&SSB="+SSB+"&SES="+SES+"&SEM="+SEM+"&SRS="+SRS+"&SCS="+
                SCS+"&RES="+RES;
            
            
            urlEvent.setParams({
                "url": url
            });
            urlEvent.fire();
            
            
        });
        
        
    }
})