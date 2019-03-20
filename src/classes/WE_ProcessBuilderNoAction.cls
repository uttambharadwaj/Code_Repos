public class WE_ProcessBuilderNoAction {
    
    @InvocableMethod
    public static void DoNothing(){
        
        /**
         * this method will be invoked from the Process Builder when the administrator
         * does not want to trigger any actions. This enables the admin to create an Action
         * Group which checks a Custom Setting, for example & only continue the Process'
         * execution if the Custom Setting criteria are met. If the criteria aren't met,
         * this method will be invoked & then the Process will be set to STOP.
         * 
         * Once this idea is implemented https://success.salesforce.com/ideaView?id=08730000000DqGRAA0
         * this will no longer be necessary
         **/
        
    }

}