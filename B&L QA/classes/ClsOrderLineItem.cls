/**
* 
* 	This class holds a structure as a helping construct for displaying combined order line item information from 
*	different objects in several Visualforce pages (e.g. Order Entry page). 
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Dennis Flüchter  |dennis.fluechter@itbconsult.com 	|01.09.2009 |First draft
*
*
*/

public class ClsOrderLineItem {

	/*************************************************************************
  	* Define Varibales and Properties
  	*************************************************************************/
  	
  	public Order_Line_Item__c oli {get; set;}
  	//public ProductCatalog__c pc {get; set;} //Product2
  	public Product2 pc {get; set;} //Product2
  	public Inventory__c inv {get; set;}
  	
  	public String quantityColor {get; set;}
  	public String maxColor {get; set;}
  	public String multipleColor {get; set;}
  	public String stockColor {get; set;}
  	
  	public Boolean showSKUPicklist {get; set;}
  	
  	public Boolean validSKU {get; set;}
  	public Boolean validPriceFromWS {get;set;}  	
  	
  	/*Variables to test SKU lookup functionality*/
	public String SKU_lkid {get; set;}
	public String SKU_lkold {get; set;}
	public String SKU_lktp {get; set;} //a0K
	public String SKU_lspf {get; set;} //0
	public String SKU_mod {get; set;} //0
	public string SKU_field {get; set;}
	public string SKU_oldId {get; set;}
	
	/*Variables that hold values for hidden input fields*/
	public String productDescription;
	public String UOM; 
	public Double stock; 
	public Double max;
	public Double mult; 
	
  	
  	/*************************************************************************
  	* Constructor
  	*************************************************************************/
  	public ClsOrderLineItem() {
  		this.oli = new Order_Line_Item__c();
  		//this.pc = new ProductCatalog__c();
  		this.pc = new Product2();
  		this.inv = new Inventory__c();
  		
  		this.quantityColor = 'black';
  		this.maxColor = 'black';
  		this.multipleColor = 'black';
  		this.stockColor = 'black';
  		
  		this.showSKUPicklist = false;
  		
  		this.validSKU = false;
  		
  		//SKU LookUpTest 
		this.SKU_lkid = ''; 
		this.SKU_lkold = ''; 
		//this.SKU_lktp = 'a0K'; //'01t' standard Product Table
		this.SKU_lktp = '01t'; 
		this.SKU_lspf = '0';
		this.SKU_mod = '0';
		this.SKU_field = '';
		this.SKU_oldId = '';
		
		this.validPriceFromWS = true;
  	}

	public String getcustUnitPrice(){
		//Integer itemNumber = getItemNumber();
		if (this.oli.Unit_Price__c != null && this.oli.CurrencyIsoCode != null){
			Double dvalue = this.oli.Unit_Price__c;
			Decimal value = dvalue;
			value = value.divide(1,2);
			String curr = this.oli.CurrencyIsoCode;
			String zeroes = '';
			for (Integer i = 0; i < 2 - value.scale(); i++){
				//zeroes += '0';
			}
			return curr + ' ' + String.valueOf(value) + zeroes;
		} else {
			return '';
		}	 	
	}
	
	public String getcustOverridePrice(){
		//Integer itemNumber = getItemNumber();
		if (this.oli.Override_Price__c != null && this.oli.CurrencyIsoCode != null){
			Double dvalue = this.oli.Override_Price__c;
			Decimal value = dvalue;
			value = value.divide(1,2);
			String curr = this.oli.CurrencyIsoCode;
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
		System.debug('--> this.oli.Extended_Price__c: ' + this.oli.Extended_Price__c);
		System.debug('--> this.oli.CurrencyIsoCode: ' + this.oli.CurrencyIsoCode);
		if (this.oli.Extended_Price__c != null && this.oli.CurrencyIsoCode != null){
			Double dvalue = this.oli.Extended_Price__c;
			Decimal value = dvalue;
			value = value.divide(1,2);			
			String curr = this.oli.CurrencyIsoCode;
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
	
	public Boolean getshowWarningIcon(){
		Boolean returnValue = false;
		System.debug('--> this.validSKU: ' + this.validSKU);
	  	System.debug('--> this.SKU_field: ' + this.SKU_field);
		if (this.validSKU == false && this.SKU_field != ''){
			returnValue = true;
		}
		System.debug('--> getShowWarningIcon: ' + returnValue);
		return returnValue;
	}
	
	public String getproductDescription(){
		return this.productDescription; 
	}
	
	public void setproductDescription(String productDescription){
		this.productDescription = productDescription;
		if (productDescription != ''){
			this.pc.Description = this.productDescription;
		}
	}
	
	public String getUOM(){
		return this.UOM; 
	}
	
	public void setUOM(String UOM){
		this.UOM = UOM;
		if(UOM != ''){
			this.pc.Unit_of_Measure__c = this.UOM;
		}
	}
	
	public Double getstock(){
		return this.stock;
	}
	
	public void setstock(Double stock){	
		System.debug('********** set Stock **********');
		System.debug('--> Stock: ' + stock);
		System.debug('--> this.inv.Quantity_in_Stock__c: ' + this.inv.Quantity_in_Stock__c);
		this.stock = stock;
		if (stock >= 0 && stock != null){
			this.inv.Quantity_in_Stock__c = this.stock.intValue();
		}
	}
	
	public Double getmax(){
		//Decimal returnValue = this.max;
		//returnValue = returnValue.divide(1,0);
		return this.max; //.intValue();
		//return returnValue; 
	}
	
	public void setmax(Double max){		
		System.debug('********** set Max **********');
		System.debug('--> Max: ' + max);
		System.debug('--> this.pc.Maximum_Order_Qty__c: ' + this.pc.Maximum_Order_Qty__c);
		this.max = max;
		if(max >= 0 && max != null){
			this.pc.Maximum_Order_Qty__c = this.max.intValue();
		}
	}
	
	public Double getmult(){
		return this.mult; 
	}
	
	public void setmult(Double mult){
		System.debug('********** set Multiple **********');
		System.debug('--> Mult: ' + mult);
		System.debug('--> this.pc.Multiple_Order_Qty__c: ' + this.pc.Multiple_Order_Qty__c);
		this.mult = mult;
		if (mult >= 0 && mult != null){
			this.pc.Multiple_Order_Qty__c = this.mult.intValue();
		}
	}
	
	public void changeValidPriceFromWS(){
		//this.validPriceFromWS = !this.validPriceFromWS;
		this.validPriceFromWS = false;
	}
}