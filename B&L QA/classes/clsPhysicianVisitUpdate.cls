/*
* 
* class to set static variables for triggers on Physician Insert and Update
* PhysicianVisit_BU_UpdateCompetitorInformation, PhysicianVisit_AU_UpdateFutureVisits, PhysicianVisit_AI_UpdateUnplannedCall
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* DeepaLakshmi.R                |deepalakshmi.venkatesh@listertechnologies.com     |30.04.2010  |First Draft
* Sourav Mitra                  |sourav.mitra@listertechnologies.com               |08.09.2010  |Changes to incorporate China SU
* Saranya Sivakumar             |saranya.sivakumar@listertechnologies.com          |19.10.2010  |Changes to incorporate China SU
*/

public class clsPhysicianVisitUpdate
{
    public static boolean isExecute = false;
    public static boolean isUpdate = false;
    public static boolean isInsert = false;
    
    // Added by Sourav 08.10.2010) : To prevent recursion of triggers
    public static Boolean blnhasTriggerFired = false;
    
    public static Boolean blnIsTriggerFiredAlready = false;
    
    public static Boolean blnIsTriggerFiredAlreadyForJntFldWrk = false;
    
    public static Boolean blnIsTriggerJTFieldOwnerToTask = false;
}