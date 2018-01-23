/**
* 
* 	This class holds a structure as a helping construct for storing product information and according inventory information
*	in memory. 
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|02.12.2009 |First draft
*
*
*/

public with sharing class ClsProductCache {

	/*************************************************************************
  	* Define Varibales and Properties
  	*************************************************************************/
  	
  	public Id productId {get; set;}
  	public Product2 product {get; set;}
  	public List<Inventory__c> list_invs {get; set;}
  	
  	/*************************************************************************
  	* Constructor
  	*************************************************************************/
  	public ClsProductCache() {
  		productId = null;
  		product = new Product2();
  		list_invs = new List<Inventory__c>();
  	}

}