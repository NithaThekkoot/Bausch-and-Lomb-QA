/**  Pass in Account and Product Info and return Unit price for 1 ea
*
*  	Author		     |Author-Email			   	     	|Date		|Comment
*  	-----------------|----------------------------------|-----------|--------------------------------------------------
*  	Jennie Burns     |                               	|06.11.2010 |First draft
*
*
*/ 

global class AcctPricecheck {
	
	/*************************************************************************
  	* Varibales and Properties
  	*************************************************************************/
	
	Webservice static double requestPrices(String iBusiness_unit,
								 string iProduct,
								 string iShip_To_ID,
								 string iBill_to_id,
								 Double oReturn_Price){
		System.debug('********** requestPrices **********');
		
		Map<String, Double> map_PSSKU_price = new Map<String, Double>(); 
		
		//Declare Webservice Varibales
		ClsWSPriceCalculation.GetPSPriceSOAP WS = new ClsWSPriceCalculation.GetPSPriceSOAP();
		List<ClsWSPriceCalculation.InputData_element> list_WSInput = new List<ClsWSPriceCalculation.InputData_element>();
		List<ClsWSPriceCalculation.OutputData_element> list_WSOutput = new List<ClsWSPriceCalculation.OutputData_element>(); 
		
		
		//Increase Webservice callout timeout limit
		WS.timeout_x = 20000;
		
		//prepare input parameters for the webservice call
				ClsWSPriceCalculation.InputData_element input = new ClsWSPriceCalculation.InputData_element();
					
				input.BUSINESS_UNIT = iBusiness_unit; //'NORSE';
				input.ORDER_DATE = DateTime.now(); //date.today().day + '/' + date.today().month + '/' + date.today().year();
				input.PPRC_APP_CD = 'SO';
				input.PRODUCT_ID = iProduct; // 'SDD-020030PKR';
				input.QTY_ORDERED = 1; //1
				input.SHIP_TO_CUST_ID = iShip_to_id; //'11700910';
				input.SOLD_TO_CUST_ID = iBill_to_id; //'11700910';
				input.UNIT_OF_MEASURE = 'EA';
				list_WSInput.add(input);				

		try{
			//call webservice
			System.debug('--> Try to call WEBSERVICE');
			System.debug('--> list_WSInput.size(): ' + list_WSInput.size());			
			if(list_WSInput.size() != 0){
				list_WSOutput = WS.Price(list_WSInput);
			}
			//list_WSOutput = WS.Price(list_WSInput);
			
			System.debug('--> ***** SUCCESS *****');
			if (list_WSOutput != null){
				System.debug('--> #Items received: ' + list_WSOutput.size());
				
				//parse the response in case of success
				for (ClsWSPriceCalculation.OutputData_element out : list_WSOutput){
					System.debug('*** --> PS PRODUCT ID: ' + out.PRODUCT_ID);
					System.debug('*** --> PRICE: ' + out.NET_UNIT_PRICE);
					if (out.NET_UNIT_PRICE != null && out.NET_UNIT_PRICE != ''){
						System.debug('--> Price received');
						oReturn_Price = Double.valueOf(out.NET_UNIT_PRICE);
										}		
				}
									} else {
			}
			
		} catch (Exception e){
			//an error occurred during the webservice callout, display error message in debug log
			System.debug('--> ERROR: ' + e.getMessage());
			oReturn_Price = 0;
		}
		return oReturn_Price;
	}
}