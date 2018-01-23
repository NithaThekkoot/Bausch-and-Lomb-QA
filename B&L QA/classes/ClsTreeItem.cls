/**
* 
* 	This class holds a structure as a helping construct for displaying Order Line Item information related to  
*	Order Header information in a tree structure for Order Tracking. 
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|09.09.2009 |First draft
*
*
*/
public with sharing class ClsTreeItem {
	
	/*************************************************************************
  	* Define Varibales and Properties
  	*************************************************************************/
  	
  	public Order_Line_Item__c item {get; set;}
  	public List<ClsTreeShipment> list_shipments {get; set;}
  	
  	private static Boolean hasChild;
  	
  	/*************************************************************************
  	* Constructor
  	*************************************************************************/
  	
  	public ClsTreeItem(){
  		this.item = new Order_Line_Item__c();
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
  		if(this.list_shipments.size()>0){
  			returnValue = true;
  		}
  		return returnValue;
  	}
  	
  	public List<Order_Line_Item__c> getitemList(){
  		List<Order_Line_Item__c> list_return = new List<Order_Line_Item__c>();
  		list_return.add(this.item);
  		return list_return;
  	}
  	
  	public String getcustUnitPrice(){
		//Integer itemNumber = getItemNumber();
		if (this.item.Unit_Price__c != null && this.item.CurrencyIsoCode != null){
			Double dvalue = this.item.Unit_Price__c;
			Decimal value = dvalue;
			value = value.divide(1,2);
			String curr = this.item.CurrencyIsoCode;
			String zeroes = '';
			for (Integer i = 0; i < 2 - value.scale(); i++){
				//zeroes += '0';
			}
			return curr + ' ' + String.valueOf(value) + zeroes;
		} else {
			return '';
		}	 	
	}
	
	public String getcustExtendedPrice(){
		//Integer itemNumber = getItemNumber();
		System.debug('********** get custExtendedPrice **********');
		System.debug('--> this.oli.Extended_Price__c: ' + this.item.Extended_Price__c);
		System.debug('--> this.oli.CurrencyIsoCode: ' + this.item.CurrencyIsoCode);
		if (this.item.Extended_Price__c != null && this.item.CurrencyIsoCode != null){
			Double dvalue = this.item.Extended_Price__c;
			Decimal value = dvalue;
			value = value.divide(1,2);			
			String curr = this.item.CurrencyIsoCode;
			String zeroes = '';
			System.debug('--> curr: ' + curr);
			System.debug('--> value: ' + value);
			System.debug('--> value.scale(): ' + value.scale());						
			for (Integer i = 0; i < 2 - value.scale(); i++){
				zeroes += '0';
			}
			System.debug('--> zeroes: ' + zeroes);
			System.debug('--> return: ' + curr + ' ' + String.valueOf(value) + zeroes);			
			return curr + ' ' + String.valueOf(value) + zeroes;
		} else {
			return '';
		}	 	
	}
}