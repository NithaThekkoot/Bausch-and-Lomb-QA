public with sharing class CPQBundalisedProductInformation 
{
	private String bundleIds;
	private String bundleDescriptions;
	
	/**************************************************************************/
	/****************************** CONSTRUCTORS ******************************/
	/**************************************************************************/
	
	public CPQBundalisedProductInformation()
	{
	}
	
	public CPQBundalisedProductInformation(String bundleIds, String bundleDescriptions)
	{
		this.bundleIds = bundleIds;
		this.bundleDescriptions = bundleDescriptions;
	}
	
	/**************************************************************************/
	/*************************** GETTERS AND SETTERS **************************/
	/**************************************************************************/
	
	public String getBundleIds()
	{
		return this.bundleIds;
	}
	
	public void setBundleIds(String bundleIds)
	{
		this.bundleIds = bundleIds;
	}
	
	public String getBundleDescriptions()
	{
		return this.bundleDescriptions;
	}
	
	public void setBundleDescriptions()
	{
		this.bundleDescriptions = bundleDescriptions;
	}
	
	/**************************************************************************/
	/****************************** OTHER METHODS *****************************/
	/**************************************************************************/
	
	public void addBundleId(String bundleId)
	{
		if (this.bundleIds == null)
		{
			this.bundleIds = bundleId;
		} else
		{
			this.bundleIds= this.bundleIds + '~' + bundleId;
		}
	}
	
	public void addBundleDescription(String bundleDescription)
	{
		if (this.bundleDescriptions == null)
		{
			this.bundleDescriptions = bundleDescription;
		} else
		{
			this.bundleDescriptions= this.bundleDescriptions + '~' + bundleDescription;
		}
	}
}