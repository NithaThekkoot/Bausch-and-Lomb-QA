/**
* 
* 	This class holds a structure as a helping construct for displaying Shipment information related to  
*	Order Line Item information in a tree structure for Order Tracking. 
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|09.09.2009 |First draft
*
*
*/

public with sharing class ClsTreeShipment {
	
	/*************************************************************************
  	* Define Varibales and Properties
  	*************************************************************************/
  	
  	public Shipping_History__c shipment {get; set;}
  	public List<ClsTreeItem> list_items {get; set;}
  	
  	/*************************************************************************
  	* Constructor
  	*************************************************************************/
  	
  	public ClsTreeShipment(){
  		this.shipment = new Shipping_History__c();
  		this.list_items = new List<ClsTreeItem>();
  	}
  	
  	
  	/*************************************************************************
  	* All Methods Except Getter and Setter Methods
  	*************************************************************************/
  	
  	/*************************************************************************
  	* Getter and Setter Methods
  	*************************************************************************/
  	
  	public List<Shipping_History__c> getshipmentList(){
  		List<Shipping_History__c> list_return = new List<Shipping_History__c>();
  		list_return.add(this.shipment);
  		return list_return;
  	}
  	
  	public Boolean gethasMultipleItems(){
  		Boolean returnValue = false;
  		if (this.list_items.size() > 1){
  			returnValue = true;
  		}
  		return returnValue;
  	}
  	
  	public String gettrackingURL(){
  		System.debug('********** getTrackingURL **********');
  		String returnValue = ''; //'http://online.pannordic.com/pn_logistics/tracking/pub_shipment_details.jsp?shipmentId=' + this.shipment.Tracking_No__c;
  		if (this.shipment.Carrier__c != null){
  			returnValue = this.shipment.Carrier__r.Website__c + this.shipment.Tracking_No__c;
  		}
  		System.debug('--> returnValue: ' + returnValue);
  		return returnValue;	
  	}
  	
  	public Boolean getemptyTrackingWebsite(){
  		Boolean returnValue = false;
  		if (this.shipment.Carrier__c == null){
  			returnValue = true;
  		} else {
  			if(this.shipment.Carrier__r.Website__c == null){
  				returnValue = true;
  			}
  		}
  		return returnValue;
  	}
}