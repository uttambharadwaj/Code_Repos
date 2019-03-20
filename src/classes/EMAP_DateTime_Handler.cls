/**
* This class is used as a Handler to perform operations on Date/Time fields
*/
public with sharing class EMAP_DateTime_Handler {


    //Variables used to check weekend and public holiday
    
    //Map of month number to month name
    public static Map<Integer, String> MonthNumberToMonthName_Map = new Map<Integer, String>{
    1=>'January',
    2=>'February',
    3=>'March',
    4=>'April',
    5=>'May',
    6=>'June',
    7=>'July',
    8=>'August',
    9=>'September',
    10=>'October',
    11=>'November',
    12=>'December'
    };
    
    //map of Recurrence Instance (in Holiday object) To Occurance Number
    public static Map<String, Integer> RecurrenceInstanceToOccuranceNumber_Map = new Map<String, Integer>{
    'First'=>1,
    'Second'=>2,
    'Third'=>3,
    'Fourth'=>4
    };
    
    //map of Day Of Week Mask Number (in Holiday object) To Day Of Holiday
    public static Map<Integer, String> DayOfWeekMaskNumberToDayOfHoliday_Map = new Map<Integer, String>{
    1=>'Sun',
    2=>'Mon',
    4=>'Tue',
    8=>'Wed',
    16=>'Thu',
    32=>'Fri',
    64=>'Sat'
    };

    /* method is used to add Business days in given date
    *  Parameters: given date and number of days to add
    */    
    public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd ){
    
        //Add or decrease in BusinessDaysToAdd days
        Date finalDate = StartDate;
        
        Integer direction = BusinessDaysToAdd < 0 ? -1 : 1;
        
        List<Holiday> holidays=[Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];
        
        while(BusinessDaysToAdd != 0) {
        
           finalDate = finalDate.AddDays(direction);
        
           if (!IsWeekendDay(finalDate) && !checkifItisHoliday(finalDate)) {
               BusinessDaysToAdd -= direction;
           }
        }
        
        return finalDate;
    }

    /* method is used to check given date is weekend
    *  Parameters: given date
    */  
    public static Boolean IsWeekendDay(Date dateParam){

        boolean result = false;

        //Recover the day of the week
        Date startOfWeek  = dateParam.toStartOfWeek();

        //Integer dayOfWeek = dateParam.day() - startOfWeek.day();
        Integer dayOfWeek = startOfWeek.daysBetween(dateParam);

        result = (dayOfWeek == 0 || dayOfWeek == 6) ? true : false;

        return result;
    }
   
    
    /* method is used to check given date is working day or not
    *  Parameters: given date
    */ 
    public static boolean checkifItisHoliday(Date currentDate){
        List<Holiday> Holiday_List = [Select h.Name, h.RecurrenceType, h.RecurrenceStartDate, h.RecurrenceMonthOfYear, h.RecurrenceInstance, h.RecurrenceDayOfWeekMask, h.IsRecurrence, h.IsAllDay, h.ActivityDate From Holiday h];
    
        for(Holiday HolidayObj : Holiday_List){
            if( HolidayObj.IsAllDay ){
                if( !HolidayObj.IsRecurrence ){
                    // Variable Holidays like 'Easter Monday' and 'Good Friday'
                    if( CurrentDate.isSameDay( HolidayObj.ActivityDate ) ){
                        //System.debug( '## ' + HolidayObj.Name + ' occurred on the ' + CurrentDate.format() );
                        return true;
                    }
                }
                else if( HolidayObj.IsRecurrence){
                    if( HolidayObj.RecurrenceType == 'RecursYearly' ){
                        // Annual holidays like 'Christmas Day' and 'New Years'
                        if( CurrentDate.month() == HolidayObj.RecurrenceStartDate.month() && CurrentDate.day() == HolidayObj.RecurrenceStartDate.day() ){
                            //System.debug( '## ' + HolidayObj.Name + ' occurred on the ' + CurrentDate.format() );
                            return true;
                        }
                    } else if( HolidayObj.RecurrenceType=='RecursYearlyNth' ) {
                        // Queen's BirtHolidayObj = 1st Monday in June
                        // Labour Day = 4th Monday in October
                        if( MonthNumberToMonthName_Map.get(CurrentDate.month()) == HolidayObj.RecurrenceMonthOfYear ){
                            if( RecurrenceInstanceToOccuranceNumber_Map.containsKey( HolidayObj.RecurrenceInstance ) ){
                                Date StartOfCurrentMonth = CurrentDate.toStartOfMonth();
    
                                Integer OccuranceNumber = RecurrenceInstanceToOccuranceNumber_Map.get( HolidayObj.RecurrenceInstance );
                                Date WeekOfHoliday = StartOfCurrentMonth.addDays( (OccuranceNumber-1)*7 ); // Add Weeks
    
                                String DayOfHoliday = DayOfWeekMaskNumberToDayOfHoliday_Map.get(HolidayObj.RecurrenceDayOfWeekMask);
    
                                for(Integer i=0; i<7; i++){ // Check the week
                                    if( getFormattedDate(WeekOfHoliday.addDays(i), 'EEE') == DayOfHoliday && WeekOfHoliday.addDays(i) == CurrentDate) {
                                        //System.debug( '## ' + HolidayObj.Name + ' occurred on the ' + CurrentDate.format() );
                                        return true;
                                    }
                                }
                            } else if( HolidayObj.RecurrenceInstance == 'Last' ){
                                //-------------Thanks giving holiday - Last Thursday of November-------------------
                                Date StartOfCurrentMonth = CurrentDate.toStartOfMonth();
                                
                                Integer numberDaysInMonth = date.daysInMonth(CurrentDate.year(), CurrentDate.month());
                                Date WeekOfHoliday = StartOfCurrentMonth.addDays(numberDaysInMonth - 7);
                                
                                String DayOfHoliday = DayOfWeekMaskNumberToDayOfHoliday_Map.get(HolidayObj.RecurrenceDayOfWeekMask);
                                
                                for(Integer i=0; i<7; i++){ // Check the week
                                    if( getFormattedDate(WeekOfHoliday.addDays(i), 'EEE') == DayOfHoliday && WeekOfHoliday.addDays(i) == CurrentDate) {
                                        //System.debug( '## ' + HolidayObj.Name + ' occurred on the ' + CurrentDate.format() );
                                        return true;
                                    }
                                }
                                //-------------------END------------------------
                            }
                        }
                    } else {
                    // Isn't a holiday, only yearly holidays are considered
                    }
                }
            } else{
            // Isn't a holiday, only full days are considered
            }
        }
        
        return false;    
    }   
     
    /* used to calculate Date diff in business days
    *  Parameters: Start date and End Date
    */
    public static Integer getDiffBusinessDays(Date startdt, Date enddt) {
        Date tempdate = null;
        /*
        if (startdt > enddt) {
            tempdate = enddt;
            enddt = startdt;
            startdt = tempdate;
        }
        */
        
        Integer i = Math.mod((date.newinstance(1985, 6, 24)).daysBetween(startdt),7); // 24/6/85 was a monday
        
        Map<Integer, Map<Integer, Integer>> m = new Map<Integer, Map<Integer, Integer>> {
            0 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 4 , 4 => 5 , 5 => 5 , 6 => 5 },
            1 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 4 , 4 => 4 , 5 => 4 , 6 => 5 },
            2 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 3 , 4 => 3 , 5 => 4 , 6 => 5 },
            3 => new Map<Integer, Integer> { 1 => 2 , 2 => 2 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
            4 => new Map<Integer, Integer> { 1 => 1 , 2 => 1 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
            5 => new Map<Integer, Integer> { 1 => 0 , 2 => 1 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
            6 => new Map<Integer, Integer> { 1 => 1 , 2 => 2 , 3 => 3 , 4 => 4 , 5 => 5 , 6 => 5 }
        };
    
        Integer i2 = Math.mod((startdt.daysBetween(enddt)),7);
        Integer i3 = (m.get(i)).get(i2);
        if (i2 == null || i2 < 1 || i2 > 6) {
            if (i >= 0 && i <= 4) 
            { 
                i3 = 1; 
            } else { 
                i3 = 0;
            }
        }
        
        i3 = i3 + 5 * (Math.floor( ((Decimal) startdt.daysBetween(enddt)).divide(7,4))).intValue(); 
        
        if (tempdate != null) i3 *= -1; // negative number of days
        
        return i3;
    }
    
    public static String getFormattedDate( Date DateObj, String FormatString ){
        return DateTime.newInstance(DateObj, Time.newInstance(0, 0, 0, 0)).format( FormatString );
    }
    
}