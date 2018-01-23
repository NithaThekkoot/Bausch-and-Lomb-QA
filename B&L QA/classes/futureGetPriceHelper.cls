public with sharing class futureGetPriceHelper {

    //Private variable to hold status locally.
    private static boolean isFromFutureGetPrice = false;
    
    //Method to recieve value of the variable being held.
    public static void isFromThisClass(boolean fromClass) {
        isFromFutureGetPrice = fromClass;
    }
    
    //Method to return stored value to requesting app.
    public static boolean returnFromClass() {
        return isFromFutureGetPrice;
    }
}