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
            
            console.log(component.get('v.fields'));
            
            //*************************************************// 
            //** DocuSign Template ID **// 
            DST = 'B1052C7A-EC24-42A4-A06D-2659863D21AE'; 
            
            //** Load Attachments = Yes **// 
            LA='1'; 
            //** Show send button **// 
            SSB='1'; 
            //** Show Email Subject **// 
            SES='1'; 
            CES='MIR Disclaimer'; 
            //** Show Email Message **// 
            SEM='1'; 
            CEM='By signing the attached document you hereby certify that the '+
                +'foregoing is an unsolicited request for information.'; 
            
            var urlEvent = $A.get("e.force:navigateToURL");
            
            CRL= 'Email~'+user.Email+';Role~Customer;FirstName~'+user.FirstName+';LastName~'+user.LastName+';'+
                +'SignNow~1;SignInPersonName~'+component.get('v.fields.Contact_Name__c')+','+
                +'Email~'+component.get('v.fields.Specify_Email__c')+';FirstName~'+
                +component.get('v.fields.Contact_first_name__c')+';'+
                +'LastName~'+component.get('v.fields.contact_last_name__c')+';Role~Doctor';
            
            CCTM='Customer~Sign In Person'; 
            var url = "/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID="+component.get('v.recordId')+"&RC="+RC+
                "&RSL="+RSL+"&RSRO="+RSRO+"&RROS="+RROS+"&CCRM="+CCRM+"&CCTM="+CCTM+"&CRCL="+CRCL+"&CRL="+CRL+
                "&OCO="+OCO+"&DST="+DST+"&CCNM="+CCNM+"&LA="+LA+"&CEM="+CEM+"&CES="+CES+"&SRS="+SRS+"&STB="+STB+
                "&SSB="+SSB+"&SES="+SES+"&SEM="+SEM+"&SRS="+SRS+"&SCS="+SCS+"&RES="+RES;
            
            
            urlEvent.setParams({
                "url": url
            });
            urlEvent.fire();
            
            
        });
        
        
    }
})