({
    recordLoadAction : function(component, event, helper) {
            
        //********* Option Declarations (Do not modify )*********// 
        var RC = '';var RSL='';var RSRO='';
        var RROS='';var CCRM='';var CCTM='';
        var CCNM='';var CRCL='';var CRL='';
        var OCO='';var DST='';var LA='';
        var CEM='';var CES='';var STB='';
        var SSB='';var SES='';var SEM='';
        var SRS='';var SCS ='';var RES=''; 
        
        //*************************************************// 
        RROS='2'; 
        
        // Load Attachments = Yes 
        
        LA='1'; 
        
        // custom contact type map (maps the roles defined in the CRL) 
        
        CCTM='1~Signer;2~Signer;'; 
        
        // custom contact role map (If templates are being used, the CCRM option can be used //to map Salesforce Role names to DocuSign roles. For example: 
        //CCRM='Decision Maker~Signer 1;Executive Sponsor~Signer 2'; 
        
        CCRM='1~Customer;2~Bausch'; 
        
        //First Role should come from the send form, Second Role is Melissa Moncrief as //Bausch + Lomb. 
        //This is the Custom Recipient List 
        CRL= 'Email~'+component.get('v.fields.Consultant_Email__c')+
            ';LastName~'+component.get('v.fields.Consultant_LastName__c')+
            ';RoutingOrder~1;Role~1,Email~chuck.hess@bausch.com;FirstName~Chuck;LastName~Hess;RoutingOrder~2;Role~2;RecipientNote~”This Contract is ready for your signature”';
        var urlEvent = $A.get("e.force:navigateToURL");
        
        var url = "/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID="+component.get('v.recordId')+"&RC="+RC+
            "&RSL="+RSL+"&RSRO="+RSRO+"&RROS="+RROS+"&CCRM="+CCRM+"&CCTM="+CCTM+"&CRCL="+CRCL+
            "&CRL="+CRL+"&OCO="+OCO+"&DST="+DST+"&CCNM="+CCNM+"&LA="+LA+"&CEM="+CEM+"&CES="+
            CES+"&SRS="+SRS+"&STB="+STB+"&SSB="+SSB+"&SES="+SES+"&SEM="+SEM+"&SRS="+SRS+"&SCS="+
            SCS+"&RES="+RES;
        
        
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
        
        
    }
})