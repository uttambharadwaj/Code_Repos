public with sharing class WEXHelper {
    public static boolean IsProduction() {
        return ( UserInfo.getOrganizationId() == '00DS0000000H9z0' );
    }
    public static String getSecureSitesURL() {
        return 'https://onlineservices.secure.force.com/';
    }
    public static String replaceChar(String input, String badVal, String newVal){
        if (input != null && badVal != null && newVal != null){
            return input.replaceAll(badVal, newVal);
        }
        return '';
    }

    public static String replaceChar(String input, List<String> badVals, String newVal){
        if (input != null && badVals != null && newVal != null){
             
            for (String badVal : badVals){
                input = input.replaceAll(badVal, newVal);
            }
            return input;
        }
        return '';
    }

//**************************************
// Date related functions      
    public static Long getDayOfWeek(DateTime pDate){
       Datetime tmpDateTime = Datetime.newInstance(1985,6,24);
       return Math.mod(pDate.getTime() - tmpDateTime.getTime(),7);
    }  
    
    public static Integer skipToNextBusinessDay(DateTime pDate){

       Integer returnInt = 0;
       Long dayOfTheWeek = getDayOfWeek(pDate);
       if(dayOfTheWeek == 0){
          returnInt = 1;
       }
       if(dayOfTheWeek == 6){
          returnInt = 2;
       }

       return returnInt;
    }
//**************************************
      
    public static List<SelectOption> getStates(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        options.add(new SelectOption('AL','AL'));
        options.add(new SelectOption('AK','AK'));
        options.add(new SelectOption('AZ','AZ'));
        options.add(new SelectOption('AR','AR'));
                                 
        options.add(new SelectOption('CA','CA'));
        options.add(new SelectOption('CO','CO'));
        options.add(new SelectOption('CT','CT'));
        options.add(new SelectOption('DE','DE'));
        options.add(new SelectOption('DC','DC'));
        options.add(new SelectOption('FL','FL'));
                                          
        options.add(new SelectOption('GA','GA'));
        options.add(new SelectOption('HI','HI'));
        options.add(new SelectOption('ID','ID'));
        options.add(new SelectOption('IL','IL'));
        options.add(new SelectOption('IN','IN'));
        options.add(new SelectOption('IA','IA'));
                                          
        options.add(new SelectOption('KS','KS'));
        options.add(new SelectOption('KY','KY'));
        options.add(new SelectOption('LA','LA'));
        options.add(new SelectOption('ME','ME'));
        options.add(new SelectOption('MD','MD'));
        options.add(new SelectOption('MA','MA'));
                                          
        options.add(new SelectOption('MI','MI'));
        options.add(new SelectOption('MN','MN'));
        options.add(new SelectOption('MS','MS'));
        options.add(new SelectOption('MO','MO'));
        options.add(new SelectOption('MT','MT'));
        options.add(new SelectOption('NE','NE'));
                                          
        options.add(new SelectOption('NV','NV'));
        options.add(new SelectOption('NH','NH'));
        options.add(new SelectOption('NJ','NJ'));
        options.add(new SelectOption('NM','NM'));
        options.add(new SelectOption('NY','NY'));
        options.add(new SelectOption('NC','NC'));
                                          
        options.add(new SelectOption('ND','ND'));
        options.add(new SelectOption('OH','OH'));
        options.add(new SelectOption('OK','OK'));
        options.add(new SelectOption('OR','OR'));
        options.add(new SelectOption('PA','PA'));
        options.add(new SelectOption('RI','RI'));
                                          
        options.add(new SelectOption('SC','SC'));
        options.add(new SelectOption('SD','SD'));
        options.add(new SelectOption('TN','TN'));
        options.add(new SelectOption('TX','TX'));
        options.add(new SelectOption('UT','UT'));
        options.add(new SelectOption('VT','VT'));
                                          
        options.add(new SelectOption('VA','VA'));
        options.add(new SelectOption('WA','WA'));
        options.add(new SelectOption('WV','WV'));
        options.add(new SelectOption('WI','WI'));
        options.add(new SelectOption('WY','WY'));

        return options;
    }
    
    public static List<SelectOption> getStatesWithNames() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','-- Select --'));
            options.add(new SelectOption('AL','Alabama'));
            options.add(new SelectOption('AK','Alaska'));
            options.add(new SelectOption('AZ','Arizona'));
            options.add(new SelectOption('AR','Arkansas'));
            options.add(new SelectOption('CA','California'));
            options.add(new SelectOption('CO','Colorado'));
            options.add(new SelectOption('CT','Connecticut'));
            options.add(new SelectOption('DE','Delaware'));
            options.add(new SelectOption('DC','Dist of Columbia'));
            options.add(new SelectOption('FL','Florida'));
            options.add(new SelectOption('GA','Georgia'));
            options.add(new SelectOption('HI','Hawaii'));
            options.add(new SelectOption('ID','Idaho'));
            options.add(new SelectOption('IL','Illinois'));
            options.add(new SelectOption('IN','Indiana'));
            options.add(new SelectOption('IA','Iowa'));
            options.add(new SelectOption('KS','Kansas'));
            options.add(new SelectOption('KY','Kentucky'));
            options.add(new SelectOption('LA','Louisiana'));
            options.add(new SelectOption('ME','Maine'));
            options.add(new SelectOption('MD','Maryland'));
            options.add(new SelectOption('MA','Massachusetts'));
            options.add(new SelectOption('MI','Michigan'));
            options.add(new SelectOption('MN','Minnesota'));
            options.add(new SelectOption('MS','Mississippi'));
            options.add(new SelectOption('MO','Missouri'));
            options.add(new SelectOption('MT','Montana'));
            options.add(new SelectOption('NE','Nebraska'));
            options.add(new SelectOption('NV','Nevada'));
            options.add(new SelectOption('NH','New Hampshire'));
            options.add(new SelectOption('NJ','New Jersey'));
            options.add(new SelectOption('NM','New Mexico'));
            options.add(new SelectOption('NY','New York'));
            options.add(new SelectOption('NC','North Carolina'));
            options.add(new SelectOption('ND','North Dakota'));
            options.add(new SelectOption('OH','Ohio'));
            options.add(new SelectOption('OK','Oklahoma'));
            options.add(new SelectOption('OR','Oregon'));
            options.add(new SelectOption('PA','Pennsylvania'));
            options.add(new SelectOption('RI','Rhode Island'));
            options.add(new SelectOption('SC','South Carolina'));
            options.add(new SelectOption('SD','South Dakota'));
            options.add(new SelectOption('TN','Tennessee'));
            options.add(new SelectOption('TX','Texas'));
            options.add(new SelectOption('UT','Utah'));
            options.add(new SelectOption('VT','Vermont'));
            options.add(new SelectOption('VA','Virginia'));
            options.add(new SelectOption('WA','Washington'));
            options.add(new SelectOption('WV','West Virginia'));
            options.add(new SelectOption('WI','Wisconsin'));
            options.add(new SelectOption('WY','Wyoming'));
        
            return options;
        }
    
    public static String getValue(String name, String function){
        List<WEX_Map__c> wexMaps = [select value__c from WEX_Map__c where name = :name and function__c = :function];
        
        if (wexMaps.size() > 0) return wexMaps[0].value__c;
        
        return '';
    }
}