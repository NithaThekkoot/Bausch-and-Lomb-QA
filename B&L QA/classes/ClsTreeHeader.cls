/**
* 
* 	This class holds a structure as a helping construct for displaying Order Header information and its
*	underlying information in a tree structure for Order Tracking. 
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|09.09.2009 |First draft
*  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|11.05.2010 |Color for Order Status added
*
*
*/
public with sharing class ClsTreeHeader {
	
	/*************************************************************************
  	* Define Varibales and Properties
  	*************************************************************************/
  	
  	public Order_Header__c header {get; set;}
  	public List<ClsTreeItem> list_items {get; set;}
  	public List<ClsTreeShipment> list_shipments {get; set;}
  	
  	private Boolean hasChild;
  	
  	/*************************************************************************
  	* Constructor
  	*************************************************************************/
	
	public ClsTreeHeader(){
		this.header = new Order_Header__c();
  		this.list_items = new List<ClsTreeItem>();
  		this.list_shipments = new List<ClsTreeShipment>();
	}
	
	
	/*************************************************************************
  	* All Methods Except Getter and Setter Methods
  	*************************************************************************/
  	
  	/*************************************************************************
  	* Getter and Setter Methods
  	*************************************************************************/
  	
  	public Boolean gethasChild(){
  		Boolean returnValue = false;
  		if(this.list_items.size() > 0 || this.list_shipments.size() > 0){
  			returnValue = true;
  		}
  		return returnValue;
  	}
  	
  	public Boolean gethasItemChild(){
  		Boolean returnValue = false;
  		if(this.list_items.size() > 0){
  			returnValue = true;
  		}
  		return returnValue;
  	}
  	
  	public Boolean gethasShipmentChild(){
  		Boolean returnValue = false;
  		if(this.list_shipments.size() > 0){
  			returnValue = true;
  		}
  		return returnValue;
  	}
  	
  	public List<Order_Header__c> getheaderList(){
  		List<Order_Header__c> list_return = new List<Order_Header__c>();
  		list_return.add(this.header);
  		return list_return;
  	}
  	
  	public String getOrderDate(){
  		String returnValue = '';
  		if (this.header.Order_Date__c != null){
  			returnValue = this.header.Order_Date__c.format();
  		}
  		return returnValue;
  	}
  	
  	public String getAccountId(){
  		String returnValue = '';
  		if(this.header.Account__r.Id != null){
  			returnValue = String.valueOf(this.header.Account__r.Id).substring(0,15);
  		}
  		return returnValue;
  	}
  	
  	public String getcustFreightAmount(){
		if (this.header.Freight_Amount__c != null && this.header.CurrencyIsoCode != null){			
			Double dvalue = this.header.Freight_Amount__c;
			Decimal value = dvalue;
			value = value.divide(1,2);
			String curr = this.header.CurrencyIsoCode;
			String zeroes = '';
			for (Integer i = 0; i < 2 - value.scale(); i++){
				zeroes += '0';
			}
			return curr + ' ' + String.valueOf(value) + zeroes;
		} else {
			return '';
		} 	
	}
	
	public String getOrderStatusColor(){
		String returnValue = '#EEECD1';
		if (this.header.Order_Status__c == 'C'){
			returnValue = '#00FF00'; //green
		} else if (this.header.Order_Status__c == 'X'){
			returnValue = '#FF0000';	//red
		} else {
			returnValue = '#FFFF2A'; //yellow
		}
		return returnValue;	
	}
}