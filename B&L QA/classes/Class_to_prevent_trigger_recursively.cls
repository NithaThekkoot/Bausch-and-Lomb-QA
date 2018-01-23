/*
* Created By : Rohit Aggarwal
*   This class is used to prevent the triggers to call Recursively
*/
public class Class_to_prevent_trigger_recursively {

public static boolean IsCaseAutoPopulate = true;
public static boolean IsContactAutoPopulate = true;
public static boolean IsOwnerUpdate = true;  // used to prevent account_AI_ChangeOwner trigger to run recursively
private static boolean afterInsertStoreVisit_AI_CreateEventTrigger = false;  //used to prevent storeVisit_AI_CreateEvent trigger to run recursively


  public static boolean hasAlreadyFiredAfterInsertStoreVisitTrigger() {
        return afterInsertStoreVisit_AI_CreateEventTrigger;
       }
  public static void setAlreadyFiredAfterInsertStoreVisitTrigger() {
        afterInsertStoreVisit_AI_CreateEventTrigger = true;
    }  

}