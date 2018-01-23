	var callback = {onSuccess: handleSuccessJS, onFailure: handleFailureJS};	
	//sessvars.hashObjectJS = sessvars.hashObjectJS||{};
	function queryProductsJS(){
		//sessvars.hashObjectJS = {};
		//sessvars.NoProducts = 0;
		
		//alert('Your session: ' + sforce.connection.sessionId);
		//alert('QUERY PRODUCTS');
		//readCookie();
		
		//start = new Date().getTime();
		
		//sforce.connection.sessionId = '{!$Api.Session_ID}';
		//alert('hi: ' + sforce.connection.sessionId);
		
		//var sql = "Select Id, Name, Description, Family, Strategic_Value__c from Product2 where Strategic_Value__c = 'High'";
		// or Strategic_Value__c = 'Medium')
					
					
		//Select i.Id, i.Name, i.Product_SKU__c, i.Product_SKU__r.Description, i.Product_SKU__r.Family, i.Product_SKU__r.Id, 	i.Product_SKU__r.IsActive, i.Product_SKU__r.Load_Group__c, i.Product_SKU__r.LoadGroup__c, i.Product_SKU__r.Maximum_Order_Qty__c, i.Product_SKU__r.Multiple_Order_Qty__c, i.Product_SKU__r.Name, i.Product_SKU__r.PS_Product_SKU__c, i.Product_SKU__r.Strategic_Value__c, i.Product_SKU__r.Unit_of_Measure__c, i.Quantity_in_Stock__c, i.Ship_From__c from Inventory__c i where Product_SKU__r.Strategic_Value__c != 'High'
					
		var sql = "Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, p.Strategic_Value__c, p.Unit_of_Measure__c, p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, (Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) from Product2 p where isActive = true"
		var sql1 = "Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, p.Strategic_Value__c, p.Unit_of_Measure__c, p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, (Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) from Product2 p where isActive = true and Strategic_Value__c = 'High' and (Strategic_Value__c = 'High' or "
		var sql2 = "Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, p.Strategic_Value__c, p.Unit_of_Measure__c, p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, (Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) from Product2 p where isActive = true and Strategic_Value__c = 'Medium'"
		var sql3 = "Select p.Description, p.Family, p.Id, p.IsActive, p.Name, p.PS_Product_SKU__c, p.Strategic_Value__c, p.Unit_of_Measure__c, p.Maximum_Order_Qty__c, p.Multiple_Order_Qty__c, (Select Name, Quantity_in_Stock__c, Ship_From__c From Inventory__r) from Product2 p where isActive = true and Strategic_Value__c = 'Low'"
					
		//var callback = {onSuccess: handleSuccess, onFailure: handleFailure};
		
		
		//alert('#Elements in HASH-TABLE: ' + j);
		
		
		//for (var i=0; i< records.length; i++) {
		//	var record = records[i];
		//}
		//alert('Count i: ' + i);
						
						
		//var callback = {onSuccess: handleSuccess, onFailure: handleFailure};
		//start = new Date().getTime();
		//start1 = new Date().getTime();
		//setTime = 1;
		sforce.connection.query(sql, callback);
		//sforce.connection.query(sql2, callback);
		//sforce.connection.query(sql3, callback);
		//end = new Date().getTime();
		//alert('Time used for ' + setTime + ' in ms: ' + (end - start1));
		//alert('Call 1 placed');
		//start2 = new Date().getTime();
		//setTime = 2;
		//sforce.connection.query(sql2, callback);
		//alert('Call 2 placed');
		
		
	}

	function handleFailureJS(error) {
		alert('Error: ' + error);
		//alert("Having issues to load all products. Expect some delay when entering SKUs.");
	}

	function handleSuccessJS(result) {
		//alert('SUCCESS from callback');

		//var result = sforce.connection.query(sql);
		//alert('QUERY PRODUCTS - Alert 2');
		//records = result.getArray("records");
		
		//var hashObject = {};
		//alert('RESULT ' + result);
		var queryMore = true;
		var NoProducts = 0;
		var b = '';
		deleteAttachments();
		
		//var result = sforce.connection.query("select id, name from account");
		var it = new sforce.QueryResultIterator(result);

		//while (it.hasNext()) {
		//	var account = it.next();
		//	sforce.debug.log(account.Name);
		//}

		//while (queryMore) {
		
		var list_attachments = new Array();
		var k = 0;
		while (it.hasNext()) {
			//var records = result.getArray("records");
			//var sb = new sforce.StringBuffer();
			//for (var i = 0; i < records.length; i++) {
				if (NoProducts > 0 && NoProducts % 10000 == 0){
					var c = base64Encode(b);
					list_attachments[k] = c;
					k++;
					//createAttachment(c);
					b = '';
				}
				
				//sb.append(records[i].Name).append(",");
				//var record = records[i];
				var record = it.next();				
				b+= record + ';';
				//alert('RecordName: ' + record.Name);
				//sessvars.hashObjectJS[record.Name] = record;
				//sessvars.NoProducts ++;
				NoProducts ++;
				document.getElementById('thePage:theForm:noproducts').value = NoProducts;
				document.getElementById('thePage:theForm:noatts').value = k;
				//alert('Record: ' + sessvars.hashObjectJS[record.Name]);
			//}
			
			//storeCookie('ProductData', records.join("@/@") );
			//document.cookie = 'ProductData=' + result;
			//alert('Count i: ' + i);
			//alert('records.length: ' + records.length);
			//alert('sb.toString(): ' + sb.toString());
			
			//if (result.getBoolean("done")) {
			//	queryMore = false;
			//} else {
			//	result = sforce.connection.queryMore(result.queryLocator);
			//}					
		}
		
		var d = base64Encode(b);
		list_attachments[k] = d;
		k++;
		
		for (var m = 0; m < list_attachments.length; m++){
			createAttachment(list_attachments[m]);
		}
		//createAttachment(d);
		//alert('SESSVARS: ' + sessvars.hashObjectJS);
		
		
		alert('#Products in Memory: ' + NoProducts);
		//alert('Memory usage: '+sessvars.usedMem+' Kb ('+sessvars.usedMemPercent+'%)&nbsp;&nbsp;&nbsp;');
		//var j = 0;
		//var co = '';
		//for (k in sessvars.hashObjectJS) {
		 // k contains the key
		 // hashObject[k] contains the value
			//j = j + 1;
			//if (j<= 5) {
			//	co += k + ':' + sessvars.hashObjectJS[k].Description + ';';
			//}
		//}
		//alert('Content:' + co);
		//storeCookie('ProductData',co);
		//storeCookie('ProductData',records);
		
		//var endDate = new Date();
		//end = new Date().getTime();
		
		//alert('READY! #Products loaded: ' + j + ' - Time used in ms: ' + (end - start));
		//if (setTime == 1){
			//alert('Time used for ' + setTime + ' in ms: ' + (end - start1));
		//} else {
			//alert('Time used for ' + setTime + ' in ms: ' + (end - start2));
		//}
		//alert('Call READY...');
	}
	
	function getParentIdForAttachment(){
		qr = sforce.connection.query("Select Id from Account where Name = 'Product Attachment Account' limit 1");
		var ids = new Array();
		var records = qr.getArray("records");
		for (var i = 0; i < records.length; i++) {
			var record = records[i];				
			ids[i] = record.Id;
		}
		//alert('Account ParentId: ' + ids[0]);
		return ids[0];
	}
	
	function deleteAttachments(){		
		var parentId = getParentIdForAttachment();
		var SOQL = "Select Id from Attachment where Name = 'ProductInfo.txt' and ParentId = '" + parentId + "' limit 1000"
		qr = sforce.connection.query(SOQL);
		var ids = new Array();
		var records = qr.getArray("records");
		for (var i = 0; i < records.length; i++) {
			var record = records[i];				
			ids[i] = record.Id;
		}
		if (ids.length > 0){
			var deleteResults = sforce.connection.deleteIds(ids);
		}
		//alert('Attachments deleted');
	}
	
	function createAttachment(body){
		alert('Creating an attachment');
		var a = new sforce.SObject("Attachment");
		a.Name = 'ProductInfo.txt';
		a.Body = body;
		a.ParentId = getParentIdForAttachment();
		
		//'001T000000F7raXIAR';
		a.IsPrivate = false;
		var saveresult = sforce.connection.create([a]);

		//alert('Attachment created');		
	}
	
	function displayProductName(body){
		inputStr = base64Decode(body);
		var records = new Array();
		records = inputStr.split(";");
		for (var i = 0; i < records.length; i++) {
			var record = records[i];
			if (i == 0){
				alert('Rec ' + i + ' / ' + records.length + ': ' + record.Name);
			}
		}
		
		
	}
	
	function parseProductCache(){
		
	}
