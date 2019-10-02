/*

    Name: UGears
    Created By: Jason McCormack (GearsCRM)
    Created Date: 2012-10-10    
    Description: Single utility class that contains numerous helper classes/methods
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public class UGears 
{
    public static final UStringClass UString = new UStringClass();
    public static final UDateTimeClass UDateTime = new UDateTimeClass();
    public static final UDateClass UDate = new UDateClass();
    public static final UBooleanClass UBoolean = new UBooleanClass();
    public static final UDebugClass UDebug = new UDebugClass();
    public static final UHTTPClass UHTTP = new UHTTPClass();
    public static final UStaticResourceClass UStaticResource = new UStaticResourceClass();
    public static final USObjectClass USObject = new USObjectClass();
    public static final UUserClass UUser = new UUserClass();
    //public static final UKnowledgeClass UKnowledge = new UKnowledgeClass();
    public static final UCollectionClass UCollection = new UCollectionClass();
    public static final UMessageClass UMessage = new UMessageClass();
    public static final UUIClass UUI = new UUIClass();
    public static final UOrgClass UOrg = new UOrgClass();
    //public static final UClass U = new UClass;
            
    //#####################################################################
    //UString
    //#####################################################################
    public class UStringClass
    {    
        //This is handy for taking a list of field names and turning them into a string for a dynamic SOQL query
        //There are plenty of other uses as well
        public String getConcatenatedString(List<String> values, String delimiter)
        {
            String valuesString = '';
            
            if(values == null || values.size() == 0)
            {
                return valuesString;
            }
            
            if(delimiter == null || delimiter.trim().length() == 0)
            {
                delimiter = ','; //CSV Delimiter
            }
            
            Boolean firstValue = true;
            
            for(String value : values)
            {
                if(firstValue == true)
                {
                    valuesString += value;
                    
                    firstValue = false;
                }   
                else
                {
                    valuesString += delimiter + value;
                }
            }
            
            return valuesString;
        }
        
        //Grabbed from the PKB2 code
        public Boolean isValidEmail(String email) 
        {
            if(isNullOrEmpty(email) == true)
            {
                return false;
            }
    
            String emailPatternString = '\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*';
            Pattern emailPattern = Pattern.compile(emailPatternString);
            Matcher emailMatcher = emailPattern.matcher(email);
            
            return emailMatcher.matches();
        }
        
        public String wrapValue(String value, String wrapperCharacter)
        {
            if(isNullOrEmpty(value) == true)
            {
                return value;
            }
                    
            if(isNullOrEmpty(wrapperCharacter) == true)
            {
                return value;
            }
            
            String returnValue = '';        
    
            if(value.startsWith(wrapperCharacter) == false)
            {
                returnValue += wrapperCharacter;
            }
            
            returnValue += value;
    
            if(value.endsWith(wrapperCharacter) == false)
            {
                returnValue += wrapperCharacter;
            }
             
            return returnValue;
        }
    
        public Boolean isNullOrEmpty(String value)
        {
            if(value == null || value.trim().length() == 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
        public String isNullOrEmptyToValue(String value, String defaultValue)
        {
            if(isNullOrEmpty(value) == true)
            {
                return defaultValue;
            }
            else
            {
                return value;
            }
        }
        
        public String getFormattedDateString(Date dateValue, String format)
        {
            if(dateValue == null)
            {
                return null;
            }       
            
            if(isNullOrEmpty(format) == true)
            {
                format = 'US';
            }
            
            String year = String.valueOf(dateValue.year());
            String month = String.valueOf(dateValue.month());
            String day = String.valueOf(dateValue.day());
            String[] dateValues = new String[3];
                
            if(format.trim().equalsIgnoreCase('UK') == true)
            {   
                dateValues[0] = day;
                dateValues[1] = month;
                dateValues[2] = year;
            }
            else
            {
                dateValues[0] = month;
                dateValues[1] = day;
                dateValues[2] = year;
            }         
                       
            String stringDate = String.format('{0}/{1}/{2}', dateValues);
            
            return stringDate;
        }
        
        public String stripCharacters(String value, List<String> charactersToRemove)
        {
            for(String character : charactersToRemove)
            {
                if(value.contains(character) == true)
                {
                    value = value.replaceAll(character, '');
                }
            }
        
            return value;
        }
        
        public String escape(String value, List<String> charactersToEscape)
        {
            for(String character : charactersToEscape)
            {
                if(value.contains(character) == true)
                {
                    value = value.replaceAll('\\' + character, getEscapeCharacterValue(character));
                }
            }
        
            return value;
        }
        
        public String escapeURL(String value)
        {       
            Map<String, String> escapeCharacters = getEscapeCharacterMap();    
                    
            for(String key : escapeCharacters.keySet())
            {
                if(value.contains(key) == true)
                {
                    value = value.replaceAll(key, escapeCharacters.get(key));
                }
            }
        
            return value;
        }   
        
        public String getEscapeCharacterValue(String character)
        {       
            String returnValue = character;     
            Map<String, String> escapeCharacters = getEscapeCharacterMap();
            
            if(escapeCharacters.containsKey(character) == true)      
            {
                returnValue = escapeCharacters.get(character);          
            }
        
            return returnValue;
        }   
        
        public Map<String, String> getEscapeCharacterMap()
        {               
            Map<String, String> escapeCharacters = new Map<String, String>(); //Character, Escape Value
            
            escapeCharacters.put('[','%5B');        
            escapeCharacters.put(']','%5D');
            escapeCharacters.put('`','%60');
            escapeCharacters.put(';','%3B');
            escapeCharacters.put('/','%2F');
            //escapeCharacters.put('?','%3F');
            escapeCharacters.put(':','%3A');
            escapeCharacters.put('@','%40');
            escapeCharacters.put('=','%3D');        
            escapeCharacters.put('&','%26');                        
            escapeCharacters.put('$','%24');
            escapeCharacters.put(' ','%20');
            escapeCharacters.put('<','%3C');
            escapeCharacters.put('>','%3E');
            escapeCharacters.put('#','%23');
            escapeCharacters.put('%','%25');
            escapeCharacters.put('{','%7B');
            escapeCharacters.put('}','%7D');
            escapeCharacters.put('|','%7C');
            escapeCharacters.put('\\','%5C');
            escapeCharacters.put('^','%5E');
            escapeCharacters.put('~','%7E');  
            
            return escapeCharacters;
        }
        
        public String makeSplitableCSVString(String qualifier, String separaterCharacter, String splitCharacter, String data)
        {
            if(isNullOrEmpty(qualifier) == true)
            {
                qualifier = '';
            }
            
            if(isNullOrEmpty(separaterCharacter) == true)
            {
                separaterCharacter = ','; //Assume CSV
            }
            
            if(isNullOrEmpty(splitCharacter) == true)
            {
                splitCharacter = '¦'; //Assume Broken Bar (Alt+0166)
            }
              
            if(isNullOrEmpty(data) == true)
            {
                return ''; //Send back an empty string
            }                
            
            String returnValue = '';
            String currentCharacter = '';
            Boolean startQuote = false;
            Boolean endQuote = false;
             
            for(Integer i = 0; i < data.trim().length(); i++)
            {
                currentCharacter = data.substring(i, i + 1);
    
                if(currentCharacter.equals(qualifier) == true)
                {
                    if(startQuote == false)
                    {
                        startQuote = true;
                        endQuote = false;                    
                    }
                    else
                    {
                        startQuote = false;                
                        endQuote = true;
                    }
                }
                else if(currentCharacter.equals(separaterCharacter) == true)
                {
                    if(endQuote == true)
                    {
                        currentCharacter = splitCharacter;
                    }
                }
                else
                {
                
                }
                
                returnValue += currentCharacter;
            }            
             
            return returnValue;
        } 
        
        public string padValueToLength(String valueToPad, Integer length, String stringToPadWith, Boolean padLeft)
        {
            if(isNullOrEmpty(valueToPad) == true)
            {
                //Just return the value is null or empty
                return valueToPad;
            } 
                
            if(valueToPad.length() > length)
            {
                //Just return the value
                return valueToPad;
            }
            
            return padValue(valueToPad, valueToPad.length() - length, stringToPadWith, padLeft);        
        }
        
        public string padValue(String valueToPad, Integer numberOfCharacters, String stringToPadWith, Boolean padLeft)
        {
            if(isNullOrEmpty(valueToPad) == true)
            {
                //Just return the value is null or empty
                return valueToPad;
            }     
        
            if(numberOfCharacters == 0)
            {
                //Just return the value since the value is 0 for numberOfCharacters
                return valueToPad;
            }    
            
            if(isNullOrEmpty(stringToPadWith) == true)
            {
                //Just return the value since the is no character to pad the value with
                return valueToPad;
            }            
            
            if(numberOfCharacters < 0)
            {
                //Flip to be a positive value. 
                //Without this, the while loop below becomes an endless loop 
                //since the condition will always evaluate to true            
                numberOfCharacters = numberOfCharacters * -1; 
            }
            
            String returnValue = '';
            String padString = '';
            
            if(stringToPadWith.length() > 1)
            {
                numberOfCharacters = numberOfCharacters * stringToPadWith.length();
            }
            
            Integer i = 0;
       
            while(i != numberOfCharacters)
            {
                padString += stringToPadWith;
                
                i++;
            }
            
            if(padLeft == true)
            {
                returnValue = padString + valueToPad;
            }
            else
            {
                returnValue = valueToPad + padString;        
            }
            
            System.debug('RETURN VALUE = ' + returnValue);        
            
            return returnValue;
        }    
                
    
    
        public String nullToEmptyString(String value)
        {
            if(value == null)
            {
                return '';
            }
            else
            {
                return value;
            }
        }
        
        public String getRandomString(Integer length)
        {
            if(length == null)
            {
                length = 1 + Math.round( Math.random() * 8 );
            }
            
            String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
            String returnString = '';
            
            while(returnString.length() < length)
            {
                Integer characterPosition = Math.round(Math.random() * (characters.length() - 1) );
                
                returnString += characters.substring(characterPosition , characterPosition + 1 );
            }
            
            return returnString;
        }
        
        //Pulled from the pkb2 package by force.com labs
        public String randomUUID()
        {
            String kHexChars = '0123456789abcdefABCDEF';
            String returnValue = '';
            Integer nextByte = 0;
        
            for(Integer i = 0; i < 16; i++)
            {
                if(i==4 || i==6 || i==8 || i==10)
                {
                    returnValue += '-';
                }
                //generate a "byte"; i.e., number in range [-2^7,2^7-1]
                nextByte = (Math.round(Math.random() * 255)-128) & 255;
    
                if(i==6)
                {
                    nextByte = nextByte & 15;
                    nextByte = nextByte | (4 << 4);
                }
                
                if(i==8)
                {
                    nextByte = nextByte & 63;
                    nextByte = nextByte | 128;
                }
                
                returnValue += charAt(kHexChars,nextByte >> 4);
                returnValue += charAt(kHexChars,nextByte & 15);
            }
            return returnValue;
        } 
        
        //Pulled from the pkb2 package by force.com labs
        public String charAt(String str, Integer index) 
        {
            if(str == null)
            {
                return null;
            }
            
            if(str.length() <= 0)
            {
                return str;    
            }
            
            if(index < 0 || index >= str.length())
            {
                return null;    
            }
            
            return str.substring(index, index+1);
        }                      
        
        public String properCase(String value)
        {
            return properCase(value, null);
        }
                
        public String properCase(String value, String separator)
        {
            if(value == null || value.trim().length() == 0)
            {
                return value;           
            }
            
            if(separator == null || separator.trim().length() == 0)
            {
                separator = ' ';            
            }
                
            List<String> values = value.split(separator);
            String returnValue = '';
            
            for(String v : values)
            {
                if(returnValue.trim().equals('') == true)
                {
                    returnValue += v.toLowerCase().capitalize();
                }
                else
                {
                    returnValue += separator + v.toLowerCase().capitalize();
                }               
            }   
            
            return returnValue;
        } 
        
        //This is an extremely simplified version and assumes no spaces in the URLs
        public String convertURLsToAnchors(String value)
        {
            return convertURLsToAnchors(value, '_self');
        }
        
        public String convertURLsToAnchors(String value, String target)
        {
            if(isNullOrEmpty(value) == true)
            {
                return value;
            }
            
            String returnValue = value;                     
            Set<String> valuesToCheckFor = new Set<String>();
            
            valuesToCheckFor.add('http://');
            valuesToCheckFor.add('https://');
            
            for(String valueToCheckFor : valuesToCheckFor)
            {
                if(value.containsIgnoreCase(valueToCheckFor) == true)
                {
                    Integer currentIndex = 0;
                    Integer nextSpaceIndex = 0;
                    Boolean doesNotExist = false;
                    Set<String> urlsToReplace = new Set<string>();
            
                    while(currentIndex != -1)
                    {
                        currentIndex = returnValue.indexOfIgnoreCase(valueToCheckFor, currentIndex + 1);
                        nextSpaceIndex = returnValue.indexOf(' ', currentIndex + 1);
                        
                        UDebug.printDebug('CURRENT INDEX: ' + currentIndex);
                        UDebug.printDebug('NEXT SPACE INDEX: ' + nextSpaceIndex);
                        
                        if(nextSpaceIndex == -1)
                        {
                            nextSpaceIndex = returnValue.length();
                        }
                        
                        if(currentIndex != -1)
                        {
                            String urlValue = returnValue.substring(currentIndex, nextSpaceIndex);
                            
                            UDebug.printDebug('URL VALUE: ' + urlValue);
                            
                            if(urlValue != null && urlValue.trim().length() > 0)
                            {
                                urlsToReplace.add(urlValue);
                            }
                        }
                    }
                    
                    for(String urlToReplace : urlsToReplace)
                    {                       
                        returnValue = returnValue.replace(urlToReplace, String.format('<a href="{0}" target="{1}">{0}</a>', new String[]{urlToReplace, target}));
                    }
                }
            }
            
            return returnValue;
        }
    }

    //#####################################################################
    //UDateTime
    //#####################################################################
    
    public class UDateTimeClass 
    {
        public DateTime getLocalDateTime()
        {
            /*
            Date currentDate = Date.today()();
            Time currentTime = ();
     
            Datetime localDateTime = datetime.newinstance(currentDate, currentTime);
            
            return localDateTime; 
            */
            return null;        
        }
        
        public String getSOQLDateTimeString(DateTime value)
        {       
            return getSOQLDateTimeString(value, null);      
        }
        
        public String getSOQLDateTimeString(DateTime value, String timezoneKey)
        {       
            String tzKey = 'Z'; //Assume GMT
            
            if(timezoneKey != null && timezoneKey.trim().length() > 0)
            {
                tzKey = timezoneKey;    
            }
            
            return value.format('yyyy-MM-dd\'T\'HH:mm:ss' + tzKey);     
        }           
        
        public List<SelectOption> getTimeOptions(Time startTime, Time endTime, Integer intervalInMinutes, Boolean use24HourClock)
        {
            if(startTime == null)
            {
                startTime = Time.newInstance(0, 0, 0, 0);
            }
            
            if(endTime == null)
            {
                endTime = Time.newInstance(0, 0, 0, 0);
                //endTime = Time.newInstance(23, 59, 59, 999);
            }
            
            if(endTime < startTime)
            {
                throw new CustomException('Problem');
            }           
            
            if(startTime == endTime)
            {
                //endTime = endTime.addMinutes(-1);
            }
            
            //UDebug.printDebug('START TIME: ' + startTime);
            //UDebug.printDebug('END TIME: ' + endTime);                    
            
            Time timeValue = startTime;
            Boolean isPMTime = false;
            
            if(timeValue >= Time.newInstance(12, 0, 0, 0))
            {
                isPMTime = true;
            }
            
            Integer startHour = startTime.hour();
            Integer endHour = endTime.hour();
            Integer timeSlots = 0;
            Integer timeSlotCounter = 0;
            
            if(startTime == endTime)
            {
                timeSlots = (24 * ((60 / intervalInMinutes) + Math.mod(60, IntervalInMinutes)));
            }
            else
            {
                timeSlots = (endHour - startHour) * ((60 / intervalInMinutes) + Math.mod(60, IntervalInMinutes));
            }
            
            //UDebug.printDebug('TIME SLOTS: ' + timeSlots);
                        
            List<SelectOption> options = new List<SelectOption>();
            
            //while(timeValue <= endTime)
            while(timeSlotCounter < timeSlots)
            {
                //UDebug.printDebug('TIME VALUE: ' + timeValue);
                
                Integer hourValue = timeValue.hour();
                Integer minuteValue = timeValue.minute();
                String amPMValue = (isPMTime == false ? 'AM' : 'PM');
                
                if(hourValue == 0)
                {
                    hourValue = 12; //For 12 midnight
                }
                
                if(use24HourClock == false)
                {
                    if(hourValue > 12)
                    {
                        hourValue = hourValue - 12;
                    }
                }
                            
                String value = hourValue + ':' + (minuteValue == 0 ? '00' : minuteValue < 10 ? '0' + String.valueOf(minuteValue) : String.valueOf(minuteValue)) + ' ' + amPMValue;
                
                System.debug(value);
                
                SelectOption so = new SelectOption(value, value);   
                
                options.add(so);    
                
                timeValue = timeValue.addMinutes(intervalInMinutes);
                
                if(timeValue >= Time.newInstance(12, 0, 0, 0))
                {
                    isPMTime = true;
                }
                else
                {
                    isPMTime = false;
                }   
            
                //UDebug.printDebug('TIME SLOT COUNTER: ' + timeSlotCounter);
                
                timeSlotCounter++;      
            }
            
            UDebug.printDebug('TIME OPTIONS: ' + options);
            
            return options;         
        }
        
        public String getTimestamp(DateTime dt)
        {
            if(dt == null)
            {
                dt = DateTime.now();
            }
            
            String timestamp = '';
            
            timestamp += dt.year();
            timestamp += dt.month();
            timestamp += dt.day();
            timestamp += dt.hour();
            timestamp += dt.minute();
            timestamp += dt.second();
            timestamp += dt.millisecond();
            
            return timestamp;
        }
    }       
    
    //#####################################################################
    //UDate
    //##################################################################### 

    public class UDateClass 
    {
        public Date getCurrentQuarterEndDate()
        {
            Date todaysDate = Date.today();
            Date currentQuarterEndDate = null;
            
            if(todaysDate >= Date.newInstance(todaysDate.year(), 1, 1) && todaysDate <= Date.newInstance(todaysDate.year(), 3, 31))
            {
                currentQuarterEndDate = Date.newInstance(todaysDate.year(), 3, 31);
            } 
            else if(todaysDate >= Date.newInstance(todaysDate.year(), 4, 1) && todaysDate <= Date.newInstance(todaysDate.year(), 6, 30))
            {
                currentQuarterEndDate = Date.newInstance(todaysDate.year(), 6, 30);
            } 
            else if(todaysDate >= Date.newInstance(todaysDate.year(), 7, 1) && todaysDate <= Date.newInstance(todaysDate.year(), 9, 30))
            {
                currentQuarterEndDate = Date.newInstance(todaysDate.year(), 9, 30);
            } 
            else if(todaysDate >= Date.newInstance(todaysDate.year(), 10, 1) && todaysDate <= Date.newInstance(todaysDate.year(), 12, 31))
            {
                currentQuarterEndDate = Date.newInstance(todaysDate.year(), 12, 31);
            } 
            else
            {
                //Should never get here
            }
            
            return currentQuarterEndDate;
        }       
        
        public Date getCurrentMonthEndDate()
        {
            return getMonthEndDate(Date.today());
        }
        
        public Date getMonthEndDate(Date d)
        {
            Integer daysInMonth = Date.daysInMonth(d.year(), d.month());
                                    
            Date d2 = Date.newInstance(d.year(), d.month(), daysInMonth);               
                        
            return d2;
        }
    }
    
    //#####################################################################
    //UBoolean
    //#####################################################################

    public class UBooleanClass 
    {
        public Boolean parse(Object value)
        {
            Boolean returnValue = false;
            
            if(value instanceof String)
            {
                String stringValue = '';
                
                if(value != null)
                {
                    stringValue = String.valueOf(value).trim();                                 
                }
                
                if(stringValue.equalsIgnoreCase('True') == true)
                {
                    returnValue = true;
                }
                else if(stringValue.equalsIgnoreCase('T') == true)
                {
                    returnValue = true;
                }
                else if(stringValue.equalsIgnoreCase('Yes') == true)
                {
                    returnValue = true;
                }
                else if(stringValue.equalsIgnoreCase('Y') == true)
                {
                    returnValue = true;
                }
                else if(stringValue.equalsIgnoreCase('On') == true)
                {
                    returnValue = true;
                }
                else if(stringValue.equalsIgnoreCase('1') == true)
                {
                    returnValue = true;
                }
            }
            else if(value instanceof Boolean)
            {
                if(value == true)
                {
                    returnValue = true;
                }           
            }
            else if(value instanceof Integer)
            {
                if(value == 1)
                {
                    returnValue = true;
                }
            }
            
            return returnValue;     
        }           
    }
    
    //#####################################################################
    //UDebug
    //##################################################################### 
    
    public class UDebugClass 
    {
        public void printDebug(String debugText)
        {
            System.debug('\n\n########## - ' + debugText.trim() + '\n');        
        }
        
        public void printDmlMessagesToDebug(DmlException e)
        {       
            if(e == null)
            {
                return;
            }
            
            for (Integer i = 0; i < e.getNumDml(); i++) 
            {    
                printDebug(e.getDmlMessage(i));         
            }
        }
        
        public void debugPageParameters(PageReference pr)
        {
            if(pr == null)
            {
                return;
            }
            
            for(String param : pr.getParameters().keySet())
            {
                printDebug(param + ' = ' + ApexPages.currentPage().getParameters().get(param));
            }
        }       
    }
    
    //#####################################################################
    //UHTTP
    //#####################################################################     

    public class UHTTPClass 
    {
        public String getQueryStringParameter(PageReference page, String key)
        {
            if(page == null)
            {
                return null;
            }
            
            if(UString.isNullOrEmpty(key) == true)
            {
                return null;
            }
            
            String returnValue = page.getParameters().get(key);
            
            return returnValue;
        }
        
        //Assumes the current page
        public String getQueryStringValue(String key)
        {
            if(UString.isNullOrEmpty(key) == true)
            {
                return null;            
            }
                    
            return getQueryStringParameter(ApexPages.currentPage(), key);
        } 
        
        public String getURL(String sObjectLink, String mode, Map<String, String> urlParams)
        {
            String url = '';
            Integer i = 0;
            List<String> charactersToEscape = new List<String>();
            
            charactersToEscape.add('&');
            
            if(UString.isNullOrEmpty(sObjectLink) == true)
            {
                return url;
            }        
            
            if(UString.isNullOrEmpty(mode) == true)
            {
                mode = '/o';
            }        
            
            if(urlParams == null || urlParams.size() == 0)
            {
                return url;
            }
            
            url += sObjectLink;
            url += mode;
            
            for(String key : urlParams.keySet())
            {
                string value = urlParams.get(key);
                
                if(value != null && value.trim().length() > 0)
                {
                    if(i == (urlParams.size() - 1))
                    {
                        url += key + '=' + UString.escape(urlParams.get(key), charactersToEscape);            
                    }
                    else
                    {
                        url += key + '=' + UString.escape(urlParams.get(key), charactersToEscape) + '&';
                    }
                }
                
                i++;
            }                              
                    
            return url;
        }
        
        public Map<String, String> getRequestParameters(String url) 
        {
            if (url == null)
            {
                return null;
            }
            
            Map<String, String> parameters = new Map<String, String>();
            
            Integer questionMarkIndex = url.indexOf('?'); 
            
            if (questionMarkIndex == -1) 
            {
                return parameters;
            }
    
            String queryString = url.substring(questionMarkIndex + 1);
                    
            List<String> nameValuePairs = queryString.split('&');
            
            for (String nameValuePair : nameValuePairs) 
            {
                List<String> nameAndValue = nameValuePair.split('=');
                
                if (nameAndValue.size() == 2) 
                {
                    parameters.put(nameAndValue.get(0), nameAndValue.get(1));
                } 
                else 
                {
                    parameters.put(nameAndValue.get(0), '');
                }
            }
    
            return parameters;
        }       
        
        public HttpResponse getOAuthResponse(String url, String sessionId, HttpRequestType requestType)
        {                   
            if(url == null || url.trim().length() == 0)
            {
                throw new CustomException('UHTTP.getOAuthResponse - Invalid URL');
            }   
            
            if(sessionId == null || sessionId.trim().length() == 0)
            {
                throw new CustomException('UHTTP.getOAuthResponse - Invalid Session Id');
            }
            
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            
            request.setHeader('Authorization', 'OAuth ' + sessionId);
            request.setEndPoint(url);
            
            if(requestType == HttpRequestType.POST)
            {
                request.setMethod('POST');
            }
            else if(requestType == HttpRequestType.GET)
            {
                request.setMethod('GET');
            }
            else
            {
                throw new CustomException('UHTTP.getOAuthResponse - Invalid HTTP Request Type');
            }
            
            HttpResponse response = httpProtocol.send(request);
        
            return response;
        }       
    }
    
    //#####################################################################
    //UStaticResource
    //#####################################################################
    
    public class UStaticResourceClass 
    {
        public String getResourceURL(String resourceName) 
        {       
            StaticResource resource = [Select
                                            Name, 
                                            NamespacePrefix, 
                                            SystemModStamp 
                                        from
                                            StaticResource 
                                        where
                                             Name = :resourceName
                                        limit 1];
            
            return getResourceURL(resource.Name, resource.NamespacePrefix, resource.SystemModStamp);
        }
        
        public String getResourceURL(String resourceName, String namespace, DateTime systemModStamp) 
        {
            if(resourceName == null || resourceName.trim().length() == 0)
            {
                //May want to change to throw an exception
                return '';
            }
            
            if(systemModStamp == null)
            {
                //May want to change to throw an exception
                return '';
            }
                        
            String resourcePath = '';
            
            resourcePath += '/resource/';
            resourcePath += SystemModStamp.getTime() + '/';
            resourcePath += (namespace != null && namespace.trim().length() > 0 ? namespace + '__' : '');
            resourcePath += resourceName;
       
            return resourcePath;
        }               
    }
    
    //#####################################################################
    //USObject
    //##################################################################### 
    
    public class USObjectClass 
    {
        public String getQueueName(Id queueId)
        {
            if(queueId == null)
            {
                throw new CustomException('USObject.getQueueName - A queue Id is required');
            }
            
            Set<Id> ids = new Set<Id>();
            
            ids.add(queueId);
            
            Map<Id, String> queueNamesMap = getQueueNamesMap(ids);
            
            String queueName = queueNamesMap.get(queueId);
            
            return queueName;       
        }   
        
        public Map<Id, String> getQueueNamesMap(Set<Id> queueIds)
        {
            if(queueIds == null)
            {
                throw new CustomException('USObject.getQueueNamesMap - A set of queue Ids is required');
            }
            
            List<Group> queues = [select Id, Name from Group where Id in :queueIds and Type = 'Queue'];
            Map<Id, String> queueNamesMap = new Map<Id, String>();
            
            for(Group queue : queues)
            {
                queueNamesMap.put(queue.Id, queue.Name);
            }
        
            return queueNamesMap;       
        }
        
        public Map<String, Id> getQueueNameToQueueIdMap(Set<String> queueNames)
        {
            if(queueNames == null)
            {
                throw new CustomException('USObject.getQueueNameToQueueIdMap - A set of queue names is required');
            }
            
            List<Group> queues = [select Id, Name from Group where Name in :queueNames and Type = 'Queue'];
            Map<String, Id> queueNameToQueueIdMap = new Map<String, Id>();
            
            for(Group queue : queues)
            {
                queueNameToQueueIdMap.put(queue.Name, queue.Id);
            }
        
            return queueNameToQueueIdMap;       
        }
        
        public Id getQueueId(String queueName)
        {
            if(queueName == null || queueName.trim().length() == 0)
            {
                throw new CustomException('USObject.getRecordTypeId - A queue name value is required');
            }
            
            List<Group> records = [select Id from Group where Name = :queueName];
            
            Id queueId = null;
            
            if(records.size() > 0)
            {
                //Grab the first. This should always be one
                queueId = records[0].Id;
            }
            
            return queueId;     
        }
        
        public String getRecordTypeName(Id recordTypeId)
        {           
            if(recordTypeId == null)
            {
                throw new CustomException('USObject.getRecordTypeName - A recordTypeId is required');
            }
            
            List<RecordType> records = [select Id, Name from RecordType where Id = :recordTypeId];
            
            String recordTypeName = null;
            
            if(records.size() > 0)
            {
                //Grab the first. This should always be one
                recordTypeName = records[0].Name;
            }
            
            return recordTypeName;      
        }       
                
        public Id getRecordTypeId(String sObjectType, String recordTypeName)
        {
            if(sObjectType == null || sObjectType.trim().length() == 0)
            {
                throw new CustomException('USObject.getRecordTypeId - An sObjectType value is required');
            }
            
            if(recordTypeName == null || recordTypeName.trim().length() == 0)
            {
                throw new CustomException('USObject.getRecordTypeId - A recordTypeName value is required');
            }
            
            return UtilityClass.getRecordTypeByName(Schema.getGlobalDescribe().get(sObjectType),recordTypeName);
        }
        
        public Map<Id, RecordType> getRecordTypeMap(String sObjectType)
        {
            if(sObjectType == null || sObjectType.trim().length() == 0)
            {
                throw new CustomException('USObject.getRecordTypeId - An sObjectType value is required');
            }
            
            Map<Id, RecordType> recordTypesMap = new Map<Id, RecordType>([select SystemModstamp,
                                                                                SobjectType,
                                                                                NamespacePrefix,
                                                                                Name,
                                                                                LastModifiedDate,
                                                                                LastModifiedById,
                                                                                IsActive,
                                                                                Id,
                                                                                DeveloperName,
                                                                                Description,
                                                                                CreatedDate,
                                                                                CreatedById,
                                                                                BusinessProcessId 
                                                                            from 
                                                                                RecordType 
                                                                            where 
                                                                                SObjectType = :sObjectType]);
            
            return recordTypesMap;
        }       
        
        public SObject getCustomSettingByProfileName(String customSettingName, String profileName)
        {
            String profileId = [select Id from Profile where Name = :profileName limit 1].Id;
            
            return getCustomSetting(customSettingName, profileId);
        }
        
        public SObject getCustomSettingByProfileId(String customSettingName, String profileId)
        {
            SObject setting = getCustomSetting(customSettingName);
            
            setting.put('SetupOwnerId', profileId);
            
            return setting;
        }
        
        public SObject getCustomSetting(String customSettingName)
        {
            return getCustomSetting(customSettingName, null);
        }
        
        public SObject getCustomSetting(String customSettingName, String ownerId)
        {
            if(ownerId == null || ownerId.trim().length() == 0)
            {
                ownerId = UserInfo.getOrganizationId();
            }
            
            if(ownerId.substring(0, 3).equalsIgnoreCase('00E') == true)
            {
                ownerId = UserInfo.getOrganizationId();
            }
            
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(customSettingName);
    
            SObject customSetting = sObjectType.newSObject();
    
            if(customSetting.Id == null)
            {
                customSetting.put('SetupOwnerId', ownerId);
                customSetting.put('Name', 'Default');
            }   
            
            return customSetting;                       
        }
                
        public Set<String> getIdSetFromSOBjectList(List<SObject> records)
        {
            return getSetFromSOBjectList(records, 'Id');
        }
          
        public Set<Id> getIdSetFromSObjectList(List<SObject> records, String fieldName)
        {
            Set<String> stringValues = getSetFromSObjectList(records, fieldName);
            Set<Id> idValues = new Set<Id>();
            
            for(String stringValue : stringValues)
            {
                idValues.add((Id) stringValue);
            }
            
            return idValues; 
        }         
            
        public Set<String> getSetFromSObjectList(List<SObject> records, String fieldName)
        {
            return getSetFromSObjectList(records, fieldName, false);
        }
        
        public Set<String> getSetFromSObjectList(List<SObject> records, String fieldName, Boolean allowNull)
        {
            Set<String> values = new Set<String>();
            
            if(fieldName == null || fieldName.trim().length() == 0)
            {
                throw new CustomException('USObject.getSetFromSObjectList - A field name is required');
            }
            
            UDebug.printDebug('HERE');
            
            for(SObject record : records)
            {
                String value = (String) record.get(fieldName);
                
                if(value != null && value.trim().length() > 0)
                {
                    values.add(value);
                }
                else if(allowNull == true)
                {
                    values.add(value);
                }
            }
                                    
            return values;
        }
        
        public Map<Id, List<SObject>> getListMap(List<SObject> sObjects, String keyFieldName)
        {
            Map<Id, List<SObject>> keyToListMap = new Map<Id, List<SObject>>();
            
            if(sObjects == null || sObjects.size() == 0)
            {
                return keyToListMap;
            }
            
            for(SObject s : sObjects)
            {
                Id keyValue = (Id) s.get(keyFieldName);
                List<SObject> records = null;
                
                if(keyToListMap.containsKey(keyValue) == false)
                {
                    records = new List<SObject>();          
                }
                else
                {
                    records = keyToListMap.get(keyValue);
                }
                
                records.add(s);
                    
                keyToListMap.put(keyValue, records);
            }
            
            return keyToListMap;
        }
        
        public Map<Id, SObject> getIdMapFromSOBjectList(List<SObject> records, String keyFieldName)
        {
            Map<Id, SObject> idToSObjectMap = new Map<Id, SObject>();
            
            if(keyFieldName == null || keyFieldName.length() == 0)
            {
                //Need to handle
            }               
            
            for(SObject record : records)
            {
                try
                {
                    Id key = (Id) record.get(keyFieldName);            
                    
                    idToSObjectMap.put(key, record);
                }
                catch(Exception e)
                {
                    
                }
            }
            
            return idToSObjectMap;
        }       
        
        public Map<String, SObject> getMapFromSOBjectList(List<SObject> records, String keyFieldName)
        {
            Map<String, SObject> idToSObjectMap = new Map<String, SObject>();
            
            if(keyFieldName == null || keyFieldName.length() == 0)
            {
                //Need to handle
            }               
            
            for(SObject record : records)
            {
                String key = (String) record.get(keyFieldName);            
                
                idToSObjectMap.put(key, record);
            }
            
            return idToSObjectMap;
        }
        
        public Map<String, String> getMapFromSOBjectList(List<SObject> records, String keyFieldName, String valueFieldName)
        {
            Map<String, String> idsMap = new Map<String, String>();
            
            if(keyFieldName == null || keyFieldName.length() == 0)
            {
                //Need to handle
            }
            
            if(valueFieldName == null || valueFieldName.length() == 0)
            {
                //Need to handle
            }
            
            for(SObject record : records)
            {
                String key = (String) record.get(keyFieldName);
                String value = (String) record.get(valueFieldName);
                
                idsMap.put(key, value);
            }
            
            return idsMap;
        }   
        
        public Map<Id, Set<Id>> getIdToIdSetMap(List<SObject> sObjects, String keyFieldName, String valueFieldName)
        {
            Map<Id, Set<Id>> idToSetMap = new Map<Id, Set<Id>>();
            
            if(keyFieldName == null || keyFieldName.length() == 0)
            {
                //Return empty map
                return idToSetMap;
            }
            
            if(valueFieldName == null || valueFieldName.length() == 0)
            {
                //Return empty map
                return idToSetMap;
            }
            
            for(SObject s : sObjects)
            {
                Id key = (Id) s.get(keyFieldName);
                Id value = (Id) s.get(valueFieldName);
                Set<Id> ids = null;
                
                if(idToSetMap.containsKey(key) == true)
                {
                    ids = idToSetMap.get(key);
                }
                else
                {
                    ids = new Set<Id>();
                }
                
                ids.add(value);
                
                idToSetMap.put(key, ids);
            }
            
            return idToSetMap;
        }                   
        
        public Map<String, List<SObject>> getSObjectListMap(List<SObject> sObjects, String keyFieldName)
        {
            Map<String, List<SObject>> sObjectListMap = new Map<String, List<SObject>>();
                
            if(keyFieldName == null || keyFieldName.length() == 0)
            {
                //Return empty map
                return sObjectListMap;
            }   
            
            for(SObject s : sObjects)
            {
                String key = (String) s.get(keyFieldName);            
                List<SObject> sObjectsList = null;
                
                if(sObjectListMap.containsKey(key) == true)
                {
                    sObjectsList = sObjectListMap.get(key);
                }
                else
                {
                    sObjectsList = new List<SObject>();
                }
                
                sObjectsList.add(s);
                
                sObjectListMap.put(key, sObjectsList);                          
            }           
            
            return sObjectListMap;
        }           
            
        public List<Schema.DescribeFieldResult> getMatchingEditableFields(SObject newRecord, SObject oldRecord)
        {
            List<Schema.DescribeFieldResult> matchingFields = getMatchingEditableFields(newRecord, oldRecord, null);
            
            return matchingFields;          
        }   
        
        public List<Schema.DescribeFieldResult> getMatchingEditableFields(SObject newRecord, SObject oldRecord, Set<String> fieldExceptions)
        {
            if(fieldExceptions == null)
            {
                fieldExceptions = new Set<String>();    
            }
            
            List<Schema.DescribeFieldResult> matchingFields = new List<Schema.DescribeFieldResult>();
            
            Schema.DescribeSObjectResult newRecordDescribe = newRecord.getSObjectType().getDescribe();      
            Map<String, Schema.SObjectField> newRecordFields = newRecordDescribe.fields.getMap();
            
            Schema.DescribeSObjectResult oldRecordDescribe = oldRecord.getSObjectType().getDescribe();
            Map<String, Schema.SObjectField> oldRecordFields = oldRecordDescribe.fields.getMap();
            
            for(String key : newRecordFields.keySet())
            {           
                if(oldRecordFields.containsKey(key) == true)
                {
                    Schema.DescribeFieldResult f1 = newRecordFields.get(key).getDescribe();
                    
                    if(f1.isCreateable() == true)
                    {                   
                        if(fieldExceptions.contains(key.trim().toUpperCase()) == false)
                        {
                            matchingFields.add(f1);
                        }
                    }
                }
            }
            
            return matchingFields;          
        } 
        
        public DescribeFieldResult getFieldDescribe(String sObjectName, String sObjectFieldName)
        { 
            Schema.SObjectType sfObjectType = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeFieldResult fieldResult = sfObjectType.getDescribe().fields.getMap().get(sObjectFieldName).getDescribe();
            
            return fieldResult;
        }
        
        public List<SObject> getRecordsToInsert(List<SObject> records)
        {
            List<SObject> recordsToInsert = new List<SObject>();
            
            for(SObject record : records)
            {
                if(record.Id == null)
                {
                    recordsToInsert.add(record);
                }
            }
            
            return recordsToInsert;
        }
        
        public List<SObject> getRecordsToUpdate(List<SObject> records)
        {
            List<SObject> recordsToUpdate = new List<SObject>();
            
            for(SObject record : records)
            {
                if(record.Id != null)
                {
                    recordsToUpdate.add(record);
                }
            }
            
            return recordsToUpdate;
        }   
        
        public String getObjectNameFieldName(SObject sfObject)
        {
            String objectType = sfObject.getSObjectType().getDescribe().getName();
            
            return getObjectNameFieldName(objectType);
        }
        
        public String getObjectNameFieldName(Id recordId)
        {       
            String objectType = recordId.getSObjectType().getDescribe().getName();
            
            return getObjectNameFieldName(objectType);
        }
        
        public String getObjectNameFieldName(String sfObjectName)
        {
            Map<String, String> sObjectNameToNameFieldMap = new Map<String, String>();
            
            sObjectNameToNameFieldMap.put('CASE', 'CaseNumber');
            sObjectNameToNameFieldMap.put('SOLUTION', 'Title');
            
            if(sObjectNameToNameFieldMap.containsKey(sfObjectName.toUpperCase()))
            {
                return sObjectNameToNameFieldMap.get(sfObjectName.toUpperCase());
            }
            else
            {
                return 'Name';
            }
        }   
    }
    
    //#####################################################################
    //UUser
    //##################################################################### 
    
    public with sharing class UUserClass 
    {       
        public Boolean isPortalUser(User userRecord)
        {
            if(isPartnerPortalUser(userRecord) == true || isCustomerPortalUser(userRecord) == true)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
        public Boolean isPortalUser(ID userId)
        {       
            if(isQueue(userId))
            {
                return false;
            }
            
            List<User> userRecord = [Select id, UserType from User where id=:userId LIMIT 1];
            
            if (userRecord.size() == 0 || userRecord == null)
            {
                throw new CustomException('Unable to determine the User\'s UserType.'); 
            }
            
            return isPortalUser(userRecord[0]);
        }
        
        
        public Map<Id, Boolean> CheckPortalUsers(set<ID> createdByIds)
        {
            Map<Id, Boolean> returnMap = new Map<ID,Boolean>();
            
            List<User> userRecords = [Select id, UserType from User where id in :createdbyIds];
            for(User u : userRecords)
            {
                if (isQueue(u.id))
                {
                    returnMap.put(u.id,false);
                }   
                else
                {
                    returnMap.put(u.id, isPortalUser(u));
                }
            }
            
            return returnMap;       
        }
        
        
        public Boolean isQueue(ID UserId)
        {
            if (UserId == null)
            {
                return false;
            }
            
            system.debug(UserId);
            string userIdString = UserId;   
            
            return userIdString.startsWith('00G');
        }
        
        
        //Requires UserType to be passed as part of the userRecord
        public Boolean isPartnerPortalUser(User userRecord)
        {
            Set<String> validUserTypes = new Set<String>();
            
            validUserTypes.add('POWERPARTNER');
            
            if(validUserTypes.contains(userRecord.UserType.trim().toUpperCase()) == true)
            {
                return true;
            }
            else
            {
                return false;
            }
        }   
        //Requires Profile.UserLicense.Name to be passed in the user record
        public Boolean isPartnerCommunityUser(User userRecord)
        {
            Set<String> validLicenseTypes = new Set<String>();
            validLicenseTypes.add('partner community');

            if(validLicenseTypes.contains(userRecord.Profile.UserLicense.Name.toLowerCase()))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
        //Requires UserType to be passed as part of the userRecord
        public Boolean isCustomerPortalUser(User userRecord)
        {
            Set<String> validUserTypes = new Set<String>();
            
            validUserTypes.add('CSPLITEPORTAL');
            
            if(validUserTypes.contains(userRecord.UserType.trim().toUpperCase()) == true)
            {
                return true;
            }
            else
            {
                return false;
            }
        }   
        
        public String getUserType(String userType)
        {
            String typeOfUser = userType;
            
            if(userType != null && userType.trim().length() > 0)
            {
                if(userType.equalsIgnoreCase('CsnOnly'))
                {
                    typeOfUser = 'Chatter Free';
                }
                else if(userType.equalsIgnoreCase('PowerPartner'))
                {
                    typeOfUser = 'Partner';
                }
                else if(userType.equalsIgnoreCase('CSPLitePortal'))
                {
                    typeOfUser = 'High Volume Portal';
                }
                else if(userType.equalsIgnoreCase('CustomerSuccess'))
                {
                    typeOfUser = 'Customer Portal';
                }
                else if(userType.equalsIgnoreCase('PowerCustomerSuccess'))
                {
                    typeOfUser = 'Customer Portal Manager';
                }               
            }
            
            return typeOfUser;
        }       
        
        public Boolean isActiveUser(Id userId)
        {
            User u = [select Id from User where Id = :userId];
            
            return isActiveUser(u);
        }
        
        public Boolean isActiveUser(User userRecord)
        {
            Set<Id> userIds = new Set<Id>{userRecord.Id};
            
            Map<Id, Boolean> userIdToIsActiveMap = getActiveUserMaps(userids);
            
            Boolean isActive = userIdToIsActiveMap.get(userRecord.Id);
            
            return isActive;
        }
        
        public Map<Id, Boolean> getActiveUserMaps(Set<Id> userIds)
        {
            Map<Id, Boolean> userIdToIsActiveMap = new Map<Id, Boolean>();
            
            for(User u : [select Id, IsActive from User where Id in :userIds])
            {
                userIdToIsActiveMap.put(u.Id, u.IsActive);
            }
            
            //Go through the user ids passed in and add the missing ids with a value of false since they
            //were not found above.
            for(Id userId : userIds)
            {
                if(userIdToIsActiveMap.containsKey(userId) == false)
                {
                    UGears.UDebug.printDebug('MISSING USER ID TO ADD: ' + userId);
                    
                    userIdToIsActiveMap.put(userId, false);
                }
            }
            
            return userIdToIsActiveMap;
        }
        
        public Double getTimeZoneOffsetHours(Id userId)
        {
            Set<Id> ids = new Set<Id>();
            
            ids.add(userId);
            
            Map<Id, Double> userIdToTimeZoneOffsetHoursMap = getUserIdToTimeZoneOffsetHours(ids);
            
            return userIdToTimeZoneOffsetHoursMap.get(userId);
        }
        
        public Map<Id, Double> getTimeZoneOffsetHours(List<Id> userIds)
        {
            Set<Id> ids = new Set<Id>();
            
            ids.addAll(userIds);
            
            return getUserIdToTimeZoneOffsetHours(ids);
        }
        
        public Map<Id, Double> getUserIdToTimeZoneOffsetHours(Set<Id> userIds)
        {
            Map<String, Double> userTimeZoneSidToTimeZoneOffsetMap = getUserTimeZoneSidToTimeZoneOffsetMap();
            Map<Id, Double> userIdToTimeZoneOffsetHoursMap = new Map<Id, Double>();         
            List<User> records = [select 
                                        Id,
                                        TimeZoneSidKey 
                                    from 
                                        User 
                                    where 
                                        Id in :userIds];
                                        
            UDebug.printDebug('MAP VALUES: ' + userTimeZoneSidToTimeZoneOffsetMap);                                     
                                        
            for(User record : records)  
            {
                String tzKey = record.TimeZoneSidKey;
                Double value = userTimeZoneSidToTimeZoneOffsetMap.get(tzKey);
                
                userIdToTimeZoneOffsetHoursMap.put(record.Id, value);
            }                                   
                                        
            return userIdToTimeZoneOffsetHoursMap;                                      
        }
        
        public Map<String, Double> getUserTimeZoneSidToTimeZoneOffsetMap()
        {
            Map<String, Double> userTimeZoneSidToTimeZoneOffsetMap = new Map<String, Double>();
            Map<String, String> userTimeZoneSidToTimeZoneOffsetValueMap = getUserTimeZoneSidToTimeZoneOffsetValueMap();
            
            for(String key : userTimeZoneSidToTimeZoneOffsetValueMap.keySet())
            {               
                String value = userTimeZoneSidToTimeZoneOffsetValueMap.get(key).replace('+', '').replace(':45', ':75').replace(':30', ':50').replace(':15', ':25').replace(':', '.'); //Grab the first element for the value
                
                UDebug.printDebug(key + ' = ' + value);
                
                userTimeZoneSidToTimeZoneOffsetMap.put(key, Double.valueOf(value));                         
            }
            
            return UserTimeZoneSidToTimeZoneOffsetMap;
        }
        
        public Map<String, String> getUserTimeZoneSidToTimeZoneOffsetValueMap()
        {
            Map<String, String> userTimeZoneSidToTimeZoneOffsetValueMap = new Map<String, String>();
            DescribeFieldResult fieldResult = USObject.getFieldDescribe('User', 'TimeZoneSidKey');
            List<Schema.PicklistEntry> items = fieldResult.getPicklistValues();
            
            for(Schema.PicklistEntry item : items)
            {
                List<String> values = item.getLabel().split(' ');
                
                String key = values.get(values.size() - 1).replace('(', '').replace(')', ''); //Grab the last element for the key   
                String value = values.get(0).replace('(GMT', '').replace(')', ''); //Grab the first element for the value
                
                UDebug.printDebug(key + ' = ' + value);
                
                userTimeZoneSidToTimeZoneOffsetValueMap.put(key, value);                            
            }
            
            return userTimeZoneSidToTimeZoneOffsetValueMap;
        }
    }   
    
    //#####################################################################
    //UKnowledge
    //#####################################################################     
    
    /*  
    public with sharing class UKnowledgeClass 
    {
        private List<DescribeDataCategoryGroupStructureResult> getKnowledgeArticleCategoryGroupStructureResult(Boolean topCategoriesOnly)
        {       
            List<String> categoryGroups = new List<String>();
            List<String> types = new List<String>();
        
            types.add('KnowledgeArticleVersion');
    
            List<DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(types);
    
            List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
        
             for(DescribeDataCategoryGroupResult result : describeCategoryResult)
             {
                DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
                
                pair.setSobject(result.getSobject());
                pair.setDataCategoryGroupName(result.getName());
                
                pairs.add(pair);
             }
                 
             List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, topCategoriesOnly);
            
            return describeCategoryStructureResult;
        }
            
        private List<DescribeDataCategoryGroupResult> getKnowledgeArticleCategoryGroupResult()
        {       
            List<String> categoryGroups = new List<String>();
            List<String> types = new List<String>();
        
            types.add('KnowledgeArticleVersion');
    
            List<DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(types);
            
            return describeCategoryResult;
        }
            
        public List<String> getKnowledgeArticleCategoryGroups()
        {       
            List<String> categoryGroups = new List<String>();           
            List<DescribeDataCategoryGroupResult>describeCategoryResult = getKnowledgeArticleCategoryGroupResult();
    
            for(DescribeDataCategoryGroupResult result : describeCategoryResult)
            {
                System.debug('CATEGORY GROUP NAME = ' + result.getName());
                
                categoryGroups.add(result.getName());            
            }
            
            return categoryGroups;
        }
        
        public List<SelectOption> getCategoryGroupOptions(Boolean addNullOption, String nullOptionDisplayValue)
        {
            List<SelectOption> options = new List<SelectOption>();
            List<String> categoryGroups = getKnowledgeArticleCategoryGroups();
            
            if(nullOptionDisplayValue == null || nullOptionDisplayValue.trim().length() == 0)
            {
                nullOptionDisplayValue = ' -- Please select a value -- ';
            }
            
            if(addNullOption == true)
            {
                options.add(new SelectOption('', nullOptionDisplayValue));
            }
            
            for(String categoryGroup : categoryGroups)
            {
                System.debug('CATEGORY GROUP OPTION = ' + categoryGroup);
                
                options.add(new SelectOption(categoryGroup, categoryGroup));
            }
            
            return options;
        }
        
        public List<SelectOption> getKnowledgeArticleChildCategoryOptions()
        {
            List<SelectOption> options = new List<SelectOption>();
            List<DescribeDataCategoryGroupStructureResult> results = getKnowledgeArticleCategoryGroupStructureResult(false);
            
            for(DescribeDataCategoryGroupStructureResult result : results)
            {
                System.debug('CATEGORY GROUP RESULT = ' + result);
            
                DataCategory [] toplevelCategories = result.getTopCategories();
                
                //Recursively get all the categories     
                List<DataCategory> allCategories = getAllCategories(toplevelCategories);
    
                for(DataCategory category : allCategories) 
                {
                    System.debug('CHILD CATEGORY = ' + category);
                        
                    options.add(new SelectOption(category.getName(), category.getLabel()));                           
                }
            }
            
            return options;
        }
        
        //From Salesforce Knowledge Dev Reference
        private DataCategory[] getAllCategories(DataCategory [] categories)
        {
            if(categories.isEmpty())
            {
                return new DataCategory[]{};
            } 
            else 
            {
                DataCategory [] categoriesClone = categories.clone();
                DataCategory category = categoriesClone[0];
                
                DataCategory[] allCategories = new DataCategory[]{category};
                
                categoriesClone.remove(0);
                categoriesClone.addAll(category.getChildCategories());
                allCategories.addAll(getAllCategories(categoriesClone));
                
                return allCategories;
            }
        }       
        
        /*
        public void loadPKBDropdownSetting(String pkbName, String articleType, String dropdownType)
        {
            if(pkbName == null || pkbName.trim().length() == 0)
            {
                throw new CustomException('UKnowledge.loadPKBDropdownSetting - An pkbName value is required');  
            }
            
            if(articleType == null || articleType.trim().length() == 0)
            {
                throw new CustomException('UKnowledge.loadPKBDropdownSetting - An articleType value is required');  
            }
            
            if(dropdownType == null || dropdownType.trim().length() == 0)
            {
                throw new CustomException('UKnowledge.loadPKBDropdownSetting - An dropdownType value is required'); 
            }
            
            String soqlQuery = 'Select ' + 
                                        'Id ' +
                                    'from ' +
                                        'PKBDropdown__c ' + 
                                    'where ' + 
                                        'PKB_Name__c = \'' + pkbName + '\' and ' +  
                                        'Dropdown_Type__c = \'' + String.escapeSingleQuotes(dropdownType) + '\' ';
                                                                
            try
            {
                delete Database.query(soqlQuery);
            }   
            catch(DmlException e)
            {
                System.debug('EXCEPTION: ' + e);
            }                                   
            
            soqlQuery = 'Select ' + 
                                        'DataCategoryName, ' +
                                        'DataCategoryGroupName ' +
                                    'From ' + 
                                        articleType.replace('__kav', '').replace('__ka', '') + '__DataCategorySelection ';  
    
            UDebug.printDebug('SOQL QUERY: ' + soqlQuery);
                                        
            List<SObject> items = Database.query(soqlQuery); 
            List<PKBDropdown__c> recordstoInsert = new List<PKBDropdown__c>();
            Set<String> itemsAlreadyAdded = new Set<String>();
            Integer counter = 0;
            
            for(SObject item : items)   
            {
                String dataCategoryGroupName = (String) item.get('DataCategoryGroupName');
                
                if(dataCategoryGroupName != null && dataCategoryGroupName.trim().length() > 0 && dataCategoryGroupName.trim().equalsIgnoreCase(dropdownType) == true)
                {
                    if(itemsAlreadyAdded.contains((String) item.get('DataCategoryName')) == false)
                    {
                        PKBDropdown__c dropdownItem = new PKBDropdown__c();
                        
                        dropdownItem.Name = pkbName + ' ' + (counter + 1);
                        dropdownItem.PKB_Name__c = pkbName;
                        dropdownItem.Dropdown_Type__c = dropdownType;
                        dropdownItem.Dropdown_Value__c = (String) item.get('DataCategoryName');
                        dropdownItem.Dropdown_Label__c = String.valueOf(item.get('DataCategoryName')).replace('_', ' ');
                        
                        recordstoInsert.add(dropdownItem);
                        
                        itemsAlreadyAdded.add((String) item.get('DataCategoryName'));
                        
                        counter++;
                    }
                }
            }                               
            
            try
            {
                insert recordsToInsert;
            }
            catch(DmlException e)
            {
                System.debug('EXCEPTION: ' + e);
            }
        }   
        * /     
    }   
    */
    
    //#####################################################################
    //UCollection
    //##################################################################### 
    
    public with sharing class UCollectionClass 
    {
        public Set<Object> sortSet(Set<Object> setToSort, SortDirection direction)
        {
            List<Object> listToSort = new List<Object>(setToSort);
            
            if(direction == SortDirection.DESCENDING)
            {
                listToSort = sortDescending(listToSort);
            }
            else
            {
                listToSort.sort();
            }
            
            Set<Object> sortedSet = new Set<Object>(listToSort);
            
            return sortedSet;
        }
        
        public List<Object> sortDescending(List<Object> listToSort)
        {
            //Make sure we sort the list first
            listToSort.sort();
            
            Object[] descendingList = new Object[listToSort.size()];
            Integer index = 0;
            
            for(Integer i = (listToSort.size() - 1); i >= 0; i--)
            {
                descendingList[index] = listToSort[i];
                
                index++;
            }
                                
            return descendingList;          
        }
    }
    
    //#####################################################################
    //UMessage
    //##################################################################### 
    
    public with sharing class UMessageClass 
    {
        public void addConfirmPageMessage(String msg)
        {
            ApexPages.addMessage(getPageMessage(ApexPages.Severity.CONFIRM, msg));
        }     
        
        public void addErrorPageMessage(String msg)
        {
            ApexPages.addMessage(getPageMessage(ApexPages.Severity.ERROR, msg));
        }   
        
        public void addFatalPageMessage(String msg)
        {
            ApexPages.addMessage(getPageMessage(ApexPages.Severity.FATAL, msg));
        }     
        
        public void addInfoPageMessage(String msg)
        {
            ApexPages.addMessage(getPageMessage(ApexPages.Severity.INFO, msg));
        }    
        
        public void addWarningPageMessage(String msg)
        {
            ApexPages.addMessage(getPageMessage(ApexPages.Severity.WARNING, msg));
        }
        
        public ApexPages.Message getConfirmPageMessage(String msg)
        {
            return getPageMessage(ApexPages.Severity.CONFIRM, msg);
        }     
        
        public ApexPages.Message getErrorPageMessage(String msg)
        {
            return getPageMessage(ApexPages.Severity.ERROR, msg);
        }   
        
        public ApexPages.Message getFatalPageMessage(String msg)
        {
            return getPageMessage(ApexPages.Severity.FATAL, msg);
        }     
        
        public ApexPages.Message getInfoPageMessage(String msg)
        {
            return getPageMessage(ApexPages.Severity.INFO, msg);
        }    
        
        public ApexPages.Message getWarningPageMessage(String msg)
        {
            return getPageMessage(ApexPages.Severity.WARNING, msg);
        }       
        
        private ApexPages.Message getPageMessage(ApexPages.Severity severity, String msg)
        {
            return new ApexPages.Message(severity, msg);
        }
    }   
    
    //#####################################################################
    //UUI
    //#####################################################################     
        
    public class UUIClass
    {
        public String emptySelectOptionValue;
        
        public void setEmptySelectOptionValue()
        {
            //This could be change to reference a value in a custom setting if needed for a project
            emptySelectOptionValue = '--None--'; //--None-- is the default SF option for an empty value
        }
        
        public SelectOption getEmptySelectOption()
        {           
            return getEmptySelectOption(emptySelectOptionValue);
        }
        
        public SelectOption getEmptySelectOption(String emptyText)
        {
            return getEmptySelectOption(emptyText, '');
        }
        
        public SelectOption getEmptySelectOption(String emptyText, String emptyValue)
        {
            setEmptySelectOptionValue();
            
            if(emptyText == null)
            {
                emptyText = emptySelectOptionValue;
            }
            
            if(emptyValue == null)
            {
                emptyValue = '';
            }
            
            return new SelectOption(emptyValue, emptyText);
        }
         
        public List<SelectOption> getSelectOptionsList(List<String> values, Boolean allowNull)
        {
            return getSelectOptionsList(values, allowNull, emptySelectOptionValue);
        }
        
        public List<SelectOption> getSelectOptionsList(List<String> values, Boolean allowNull, String nullDisplayValue)
        {
            if(values == null)
            {
                throw new CustomException('Values cannot be null');
            }        
            
            List<SelectOption> options = new List<SelectOption>();
            
            if(allowNull == true)
            {
                options.add(getEmptySelectOption(nullDisplayValue));
            }
            
            for(String value : values)
            {               
                options.add(new SelectOption(value, value));
            }
            
            return options;
        }  
        
        public List<SelectOption> getSelectOptionsList(Map<String, String> valuesMap, Boolean allowNull)
        {
            return getSelectOptionsList(valuesMap, allowNull, emptySelectOptionValue);
        }
        
        public List<SelectOption> getSelectOptionsList(Map<String, String> valuesMap, Boolean allowNull, String nullDisplayValue)
        {           
            List<SelectOption> options = new List<SelectOption>();
            
            if(allowNull == true)
            {
                options.add(getEmptySelectOption(nullDisplayValue));
            }
            
            List<String> values = new List<String>();
            
            values.addAll(valuesMap.keySet());          
            values.sort();
            
            for(String value : values)
            {
                String mapValue = valuesMap.get(value);
                
                options.add(new SelectOption(value, mapValue));
            }
            
            return options;
        }        
        
        public List<SelectOption> getSelectOptionsForSobjectField(String sObjectName, String sObjectFieldName)
        { 
            return getSelectOptionsForSobjectField(sObjectName, sObjectFieldName, null);
        }
                    
        public List<SelectOption> getSelectOptionsForSobjectField(String sObjectName, String sObjectFieldName, Set<String> fieldValuesToIgnore)
        { 
            if(fieldValuesToIgnore == null)
            {
                fieldValuesToIgnore = new Set<String>();
            }
            
            Schema.DescribeFieldResult fieldResult = getFieldDescribe(sObjectName, sObjectFieldName);           
            List<Schema.PicklistEntry> items = fieldResult.getPicklistValues();

            List<SelectOption> options = new List<SelectOption>();
            
            for(Schema.PicklistEntry item : items)
            {
                if(fieldValuesToIgnore.contains(item.getValue()) == false)
                {                   
                    options.add(new SelectOption(item.getValue(), item.getLabel()));
                }               
            } 
            
            return options;
        }
        
        public String getDefaultPicklistValue(String sObjectName, String sObjectFieldName)
        { 
            Schema.DescribeFieldResult fieldResult = getFieldDescribe(sObjectName, sObjectFieldName);           
            List<Schema.PicklistEntry> items = fieldResult.getPicklistValues();
            
            String defaultValue = null;
            
            for( Schema.PicklistEntry item : items)
            {
                if(item.isActive() == true && item.isDefaultValue() == true)
                {
                    defaultValue = item.getValue(); 
                    
                    break;              
                }                               
            } 
            
            return defaultValue;
        }
        
        public DescribeFieldResult getFieldDescribe(String sObjectName, String sObjectFieldName)
        { 
            Schema.SObjectType sfObjectType = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeFieldResult fieldResult = sfObjectType.getDescribe().fields.getMap().get(sObjectFieldName).getDescribe();
            
            return fieldResult;
        }
        
        public String getSFDefaultErrorMessage()
        {
            return 'You must enter a value';
        }
        
        public String getSFAttachmentsURL(Id parentId, String parentName, String returnURL)
        {
            if(parentId == null)
            {
                throw new CustomException('UUI.getSFAttachmentsURL - A parent Id is required');
            }
            
            if(parentName == null || parentName.trim().length() == 0)
            {
                throw new CustomException('UUI.getSFAttachmentsURL - A parent name is required');
            }
            
            if(returnURL == null || returnURL.trim().length() == 0)
            {
                returnURL = '%2F' + parentId;
            }
            
            List<String> values = new List<String>();
            
            values.add(parentId);
            values.add(parentName.replace(' ', '+'));
            values.add(returnURL);
            
            String url = '/p/attach/NoteAttach?pid={0}&parentname={1}&retURL={2}';
            
            return String.format(url, values);
        }
    }   
    
    public class UOrgClass
    { 
        public String getOrgEdition()
        {
            List<Organization> orgs = [select Id, OrganizationType from Organization];
          
            if (orgs.size() == 1)
            {
                return orgs[0].OrganizationType;
            }
            else
            {
                return null;
            }
        }
        
        public Boolean editionHasSandboxes()
        {
            String orgEdition = getOrgEdition();
            
            if(orgEdition.equalsIgnoreCase('Enterprise Edition'))
            {
                return true;
            }
            else if(orgEdition.equalsIgnoreCase('Unlimited Edition'))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
                                        
        public Boolean isSandbox()
        {
            return isSandbox(URL.getSalesforceBaseUrl().getHost());
        }
        
        public Boolean isSandbox(String hostUrl)
        {         
            String host = null;
            
            if(hostUrl == null || hostUrl.trim().length() == 0)
            {               
                host = URL.getSalesforceBaseUrl().getHost();
            }
            else
            {
                host = hostUrl;
            }             
               
            String server = host.substring(0, host.indexOf('.'));
          
            if (server.contains('--'))
            {
                return true;
            }
            
            
            if (server.equalsIgnoreCase('tapp0'))
            {
                return true;
            }
          
            if (server.length() > 2)
            {
                if (server.substring(0, 2).equalsIgnoreCase('cs'))
                {
                    try
                    {
                       Integer.valueOf(server.substring(2, server.length()));
                    }
                    catch (Exception ex)
                    {                      
                       return false;
                    }      
                             
                    return true;
                }
            }
                        
            return false;
        }   
    }
    
    //#####################################################################
    //Enums
    //##################################################################### 
    
    public enum SortDirection 
    {
        ASCENDING, 
        DESCENDING
    }
    
    public enum Environment 
    {
        PRODUCTION,
        STAGING, 
        UAT,
        DEV
    }   
    
    public enum HttpRequestType 
    {
        POST, 
        GET
    }   
        
    //#####################################################################
    //Exceptions
    //##################################################################### 
        
    public class CustomException extends Exception {}   
    
    //#####################################################################
    //Unit Tests
    //#####################################################################
    private static testMethod void testUString()
    {
        List<String> values = new List<String>();
        
        values.add('A');
        values.add('B');
        values.add('C');
        
        String concatenatedString1 = UString.getConcatenatedString(values, ',');
        
        System.assertEquals('A,B,C', concatenatedString1, UTestData.getAssertMessage(1, 1));
        
        String emptyString = UString.nullToEmptyString(null);       
        
        System.assert(emptyString.equalsIgnoreCase('') == true, UTestData.getAssertMessage(1, 2));
        
        emptyString = 'Test';
        
        System.assert(emptyString.equalsIgnoreCase('Test') == true, UTestData.getAssertMessage(1, 3));
        
        String url = UString.escape('adb&?def', new String[]{'&'});
        url = UString.escapeURL('adb&?def');
        String character = UString.getEscapeCharacterValue('&');
        Map<String, String> escapeCharacterMap = UString.getEscapeCharacterMap();
        UString.stripCharacters('ab-ba', new String[]{'-'});
        String formattedDateString1 = UString.getFormattedDateString(Date.today(), 'US');  
        String formattedDateString2 = UString.getFormattedDateString(null, 'US');  
        String formattedDateString3 = UString.getFormattedDateString(Date.today(), null);        
        String formattedDateString4 = UString.getFormattedDateString(Date.today(), 'UK');                  
        String splitCSVString1 = UString.makeSplitableCSVString(null, null, null, null);        
        String splitCSVString2 = UString.makeSplitableCSVString(null, null, null, 'Test, Test, Test');              
        String splitCSVString3 = UString.makeSplitableCSVString('"', null, null, 'Test, Test, Test');    
        String splitCSVString4 = UString.makeSplitableCSVString('"', null, null, 'Test, "Test", Test');        
        
        String s1 = UString.escape('abc[??[]$@xyz', new String[]{'[', ']', '?', '$', '@'});             
        String s2 = UString.isNullOrEmptyToValue('234', '123');
        String s3 = UString.isNullOrEmptyToValue(null, '123');   
        String s4 = UString.escapeUrl('http://somewhere@something');
        String s5 = UString.padValueToLength('TEST', 30, 'X', false);             
        String s6 = UString.padValueToLength('TEST', 30, 'X', true);        
        String s7 = UString.padValueToLength('TESTTESTTEST', 10, 'X', true);              
        String s8 = UString.padValueToLength(null, 10, 'X', true);
        String s9 = UString.padValue('TESTTESTTEST', 0, 'X', true);         
        String s10 = UString.padValue('TESTTESTTEST', -10, 'X', true);        
        String s11 = UString.padValue('TESTTESTTEST', 10, '', true);            
        String s12 = UString.padValue(null, 10, 'X', true);  
        String s13 = UString.padValue(null, 10, null, true);  
        String s14 = UString.padValueToLength('TEST', 30, 'XYZ', false);
        String s15 = UString.wrapValue('Test', '"');              
        String s16 = UString.wrapValue(null, '"');        
        String s17 = UString.wrapValue('Test', null);       
        String s18 = UString.getRandomString(10);     
        String s19 = UString.getRandomString(100); 
        String s20 = UString.nullToEmptyString('TEST');
        String s21 = UString.randomUUID();
        String s22 = UString.properCase('TEST TEST TEST');
        String s23 = UString.convertURLsToAnchors('THIS IS A TEST HTTP://test.test.test');
        
        Boolean b1 = UString.isValidEmail('test@test.com');
        Boolean b2 = UString.isValidEmail('test@test');             
    }
    
    private static testmethod void testUDateTime()
    {
        String s1 = UDateTime.getSOQLDateTimeString(DateTime.now());
        String s2 = UDateTime.getTimestamp(DateTime.now());
        
        DateTime dt1 = UDateTime.getLocalDateTime();
        
        List<SelectOption> timeOptions = UDateTime.getTimeOptions(Time.newInstance(0, 0, 0, 0), Time.newInstance(0, 0, 0, 0), 60, false);
    }   
    
    private static testmethod void testUDate()
    {
        Date d1 = UDate.getCurrentQuarterEndDate();
        Date d2 = UDate.getCurrentMonthEndDate();
    }   
    
    private static testmethod void testUBoolean()
    {
        Boolean b1 = UBoolean.parse('True');
        
        System.assert(b1 == true, 'Boolean test #1 failed');
        
        Boolean b2 = UBoolean.parse('T');
        
        System.assert(b2 == true, 'Boolean test #2 failed');
        
        Boolean b3 = UBoolean.parse('Yes');
        
        System.assert(b3 == true, 'Boolean test #3 failed');
        
        Boolean b4 = UBoolean.parse('Y');
        
        System.assert(b4 == true, 'Boolean test #4 failed');
        
        Boolean b5 = UBoolean.parse('On');
        
        System.assert(b5 == true, 'Boolean test #5 failed');
        
        Boolean b6 = UBoolean.parse('1');
        
        System.assert(b6 == true, 'Boolean test #6 failed');
        
        Boolean b7 = UBoolean.parse(true);
        
        System.assert(b7 == true, 'Boolean test #7 failed');
        
        Boolean b8 = UBoolean.parse(1);
        
        System.assert(b8 == true, 'Boolean test #8 failed');
        
        Boolean b9 = UBoolean.parse('ShouldBeFalse');
        
        System.assert(b9 == false, 'Boolean test #9 failed');
    } 
    
    private static testmethod void testUDebug()
    {
        UDebug.printDebug('This is a sample message');
        
        Contact c1 = new Contact();
        
        c1.FirstName = 'Test';
        c1.LastName = 'Contact 1';
        
        try
        {
            update c1;
        }
        catch(DmlException e)
        {
            UDebug.printDmlMessagesToDebug(e);
            UDebug.printDmlMessagesToDebug(null);
        } 
        
        PageReference pr = new PageReference('/home/home.jsp?test=test');
        
        UDebug.debugPageParameters(pr);
        UDebug.debugPageParameters(null);       
    }
    
    private static testmethod void testUHTTP()
    {
        String s1 = UHTTP.getQueryStringParameter(null, null);
        String s2 = UHTTP.getQueryStringParameter(new PageReference('test?id=123'), null);
        String s3 = UHTTP.getQueryStringParameter(new PageReference('test?id=123'), 'id');
        
        String s4 = UHTTP.getQueryStringValue(null);
        String s5 = UHTTP.getQueryStringValue('id');          
                
        Map<String, String> testMap = new Map<String, String>();
        
        testMap.put('test', 'mytest');
        testMap.put('test2', 'mytest2');      
        
        UHTTP.getURL('Test', null, testMap);       
        UHTTP.getURL(null, null, testMap); 
        UHTTP.getURL('Test', null, null);   
        
        System.assertEquals(null, UHTTP.getRequestParameters(null));

        Map<String, String> requestParameters = UHTTP.getRequestParameters('/Listing');
        System.assertEquals(0, requestParameters.size());

        requestParameters = UHTTP.getRequestParameters('/Listing?id=1234');
        System.assertEquals(1, requestParameters.size());
        System.assertEquals('1234', requestParameters.get('id'));
        
        requestParameters = UHTTP.getRequestParameters('/Listing?id=1234&tipho=');
        System.assertEquals(2, requestParameters.size());
        System.assertEquals('1234', requestParameters.get('id'));
        System.assertEquals('', requestParameters.get('tipho'));
        
        requestParameters = UHTTP.getRequestParameters('/Listing?fipho=&id=1234');
        System.assertEquals(2, requestParameters.size());
        System.assertEquals('1234', requestParameters.get('id'));
        System.assertEquals('', requestParameters.get('fipho'));        
    }       
    
    private static testmethod void testUStaticResource()
    {
        DateTime now = DateTime.now();      
        
        String resourcePath = UStaticResource.getResourceURL('test', 'testnamespace', now);
        
        System.assertEquals(resourcePath, '/resource/' + now.getTime() + '/testnamespace__test', 'TEST #1/CHECK #1');
        
        String resourcePath2 = UStaticResource.getResourceURL('test', null, now);
        
        System.assertEquals(resourcePath2, '/resource/' + now.getTime() + '/test', 'TEST #1/CHECK #2');
        
        List<StaticResource> staticResources = [select Name, SystemModStamp from StaticResource where NamespacePrefix = null limit 1];
        
        if(staticResources.size() == 1)
        {
            StaticResource sr = staticResources[0];
             
            String resourcePath3 = UStaticResource.getResourceURL(sr.Name);
        
            //System.assertEquals(resourcePath3, '/resource/' + sr.SystemModStamp.getTime() + '/' + sr.Name, 'TEST #1/CHECK #3');
        }
        
        String resourcePath4 = UStaticResource.getResourceURL('', null, now);
        
        System.assertEquals(resourcePath4, '', 'TEST #1/CHECK #4');
        
        String resourcePath5 = UStaticResource.getResourceURL('test', null, null);
        
        System.assertEquals(resourcePath5, '', 'TEST #1/CHECK #5');
    }   
                    
    private static testmethod void testUSObject()
    {UtilityTestLoader.setAutomation(false);

        Group groupRecord = [select Id, Name from Group where Name != null and Type = 'Queue' limit 1];
        
        Id id1 = USObject.getQueueId(groupRecord.Name);
        
        System.assertEquals(groupRecord.Id, id1, UTestData.getAssertMessage(1, 1));
        
        //Id id2 = USObject.getRecordTypeId('Test', 'Test');
        //Id id3 = USObject.getRecordTypeId('Test', 'Test');
        
        //SObject so1 = USObject.getCustomSettingByProfileName('Commission_Meeting_Quotas__c', 'System Administrator');
        
        //Add accounts and contacts that are needed to test the various USObject methods
        List<Account> accounts = UTestData.getAccounts(1);
        
        insert accounts;                    
        
        List<Contact> contacts = UTestData.getContacts(accounts, 1);
        
        UTestData.addEmailToRecords(contacts, 'Email');
        
        insert contacts;
                
        Set<String> set1 = USObject.getIdSetFromSOBjectList(accounts);
        Map<Id, List<SObject>> map1 = USObject.getListMap(contacts, 'AccountId');
        Map<String, SObject> map2 = USObject.getMapFromSOBjectList(contacts, 'Id');
        Map<String, String> map3 = USObject.getMapFromSOBjectList(contacts, 'Id', 'Name');
        Map<Id, Set<Id>> map4 = USObject.getIdToIdSetMap(contacts, 'AccountId', 'Id');
        Map<String, List<SObject>> map5 = USObject.getSObjectListMap(contacts, 'AccountId');
        List<Schema.DescribeFieldResult> list1 = USObject.getMatchingEditableFields(new Contact(), new Lead());
        List<Schema.DescribeFieldResult> list2 = USObject.getMatchingEditableFields(new Contact(), new Lead(), new Set<String>{'Name'});
        
        Set<Id> accountIds = USObject.getIdSetFromSObjectList(accounts, 'Id');
        Map<Id, SObject> accountsIdToAccountMap = USObject.getIdMapFromSOBjectList(accounts, 'Id');
        
        List<SObject> list3 = USObject.getRecordsToInsert(accounts);
        List<SObject> list4 = USObject.getRecordsToUpdate(accounts);
        
        DescribeFieldResult dfr1 = USObject.getFieldDescribe('Account', 'Name');
        
        Map<Id, RecordType> map6 = USObject.getRecordTypeMap('Account');
    }   
    
    private static testMethod void testUUser()
    {        UtilityTestLoader.setAutomation(false);
       
        Integer numberOfUsers = 1;
        Integer numberOfAccounts = 1;
        Integer numberOfContacts = 1;
        
        //Insert accounts
        List<Account> accounts = UTestData.getAccounts(numberOfAccounts);
        
        insert accounts;
        
        accounts = [select Id from Account where Id in :accounts];
        
        System.assertEquals(numberOfAccounts, accounts.size(), UTestData.getAssertMessage(1, 1));       
        
        //Insert contacts
        List<Contact> contacts = UTestData.getContacts(accounts, numberOfContacts);
        
        UTestData.addEmailToRecords(contacts, 'Email');
        
        insert contacts;
        
        contacts = [select Id, Email from Contact where Id in :contacts];
        
        System.assertEquals(numberOfContacts, contacts.size(), UTestData.getAssertMessage(1, 2));
                
        //Insert users
        List<User> users = new List<User>();
        
        //Normal user
        users.add(UTestData.getUserRecord(UTestData.getStandardProfileId('System Administrator')));
        
        //Customer portal user - DISABLED DUE TO ISSUES WITH @FUTURES IN PortalUtil
        //users.add(UTestData.getCustomerPortalUserRecord(contacts[0].Id, UTestData.getCustomerPortalProfileId('CTCT Customer Portal User')));
        
        //Set portal user email to contact email - Done to address issue in PortalUtils.provisionCustomerPortalUser
        //users[1].Email = contacts[0].Email;
        
        insert users;
        
        users = [select Id, UserType from User where Id in :users];
        
        System.assertEquals(numberOfUsers, users.size(), UTestData.getAssertMessage(1, 3));
        
        System.assertEquals(false, UUser.isPortalUser(users[0]), UTestData.getAssertMessage(1, 4));
        System.assertEquals(false, UUser.isPortalUser(users[0].Id), UTestData.getAssertMessage(1, 5));
        
        Map<Id, Boolean> usersMap = UUser.CheckPortalUsers(new Set<Id>{users[0].Id});
        System.assertEquals(false, usersMap.get(users[0].Id), UTestData.getAssertMessage(1, 6));
        
        //Portal User Test...
        List<User> portalUsers = [SELECT Id, Name FROM User where UserType like '%Portal%' and IsActive = true limit 1];
        if (portalUsers.size()!=0)
        {
            System.assertEquals(true, UUser.isPortalUser(portalUsers[0].Id), UTestData.getAssertMessage(1, 7));     
        }
        
        //Guest User Test...       
        List<User> guests = null;
        
        try
        {
            guests = [select id from User where profile.UserLicense.LicenseDefinitionKey = 'PID_Guest_User'];
        }
        catch(QueryException e)
        {
        
        }       
        
        if (guests!=null && guests.size() > 0)
        {
            System.assertEquals(false, UUser.isPortalUser(guests[0].id), UTestData.getAssertMessage(1, 8)); 
        }        
        
        //Bad Id Test..
        boolean exceptionExpected = false;
        
        try
        {
            System.assertEquals(false, UUser.isPortalUser(contacts[0].id), UTestData.getAssertMessage(1, 9));
        }
        catch(Exception e)
        {
            exceptionExpected = true;
        }
        
        System.assertEquals(true, exceptionExpected, UTestData.getAssertMessage(1, 10));    
        
        List<User> users2 = [select Id, IsActive from User limit 10];
        
        Map<Id, Boolean> userIdToIsActiveMap = UUSer.getActiveUserMaps(USObject.getIdSetFromSOBjectList(users2, 'Id'));
        
        Integer counter = 11; //Start at 11 becomes the last test before this is 10
        
        for(Id key : userIdToIsActiveMap.keySet())
        {
            Boolean isActive = userIdToIsActiveMap.get(key);
            
            System.assertEquals(isActive, UUser.isActiveUser(key), UTestData.getAssertMessage(1, counter));
            
            counter++;
        }   
        
        Double d1 = UUser.getTimeZoneOffsetHours(UserInfo.getUserId());
        
        Map<String, Double> map1 = UUser.getUserTimeZoneSidToTimeZoneOffsetMap();
        Map<String, String> map2 = UUser.getUserTimeZoneSidToTimeZoneOffsetValueMap();
        Map<Id, Double> map3 = UUser.getTimeZoneOffsetHours(new List<Id>{UserInfo.getUserId()});
    }
    
    /*
    private static testmethod void testUKnowledge()
    {
        List<DescribeDataCategoryGroupStructureResult> list1 = UKnowledge.getKnowledgeArticleCategoryGroupStructureResult(true);
        List<DescribeDataCategoryGroupStructureResult> list2 = UKnowledge.getKnowledgeArticleCategoryGroupStructureResult(false);
        List<String> list3 = UKnowledge.getKnowledgeArticleCategoryGroups();
        List<SelectOption> list4 = UKnowledge.getCategoryGroupOptions(true, 'Test');
        List<SelectOption> list5 = UKnowledge.getCategoryGroupOptions(false, 'Test');
        List<SelectOption> list6 = UKnowledge.getKnowledgeArticleChildCategoryOptions();
    }   
    */
    
    private static testmethod void testUCollection()
    {UtilityTestLoader.setAutomation(false);

        //Add accounts and contacts that are needed to test the various USObject methods
        List<Account> accounts = UTestData.getAccounts(1);
        
        insert accounts;                    
        
        List<Contact> contacts = UTestData.getContacts(accounts, 1);
        
        UTestData.addEmailToRecords(contacts, 'Email');
        
        insert contacts;
        
        Set<Object> set1 = new Set<Object>();
        
        set1.addAll((List<Object>) contacts);
        
        Set<Object> set2 = UCollection.sortSet(set1, UGears.SortDirection.Descending);
                        
        List<Object> list1 = UCollection.sortDescending(contacts);      
    }
    
    private static testmethod void testUMessage()
    {
        ApexPages.Message m1 = UMessage.getConfirmPageMessage('Confirm');
        ApexPages.Message m2 = UMessage.getErrorPageMessage('Error');
        ApexPages.Message m3 = UMessage.getFatalPageMessage('Fatal');
        ApexPages.Message m4 = UMessage.getInfoPageMessage('Info');
        ApexPages.Message m5 = UMessage.getWarningPageMessage('Warning');
        
        UMessage.addConfirmPageMessage('Confirm');
        UMessage.addErrorPageMessage('Error');
        UMessage.addFatalPageMessage('Fatal');
        UMessage.addInfoPageMessage('Info');
        UMessage.addWarningPageMessage('Warning');        
    }       
    
    private static testmethod void testUUI()
    {        
        SelectOption so1 = UUI.getEmptySelectOption();
        
        System.assertEquals('--None--', so1.getLabel(), UTestData.getAssertMessage(1, 1));
        System.assertEquals('', so1.getValue(), UTestData.getAssertMessage(1, 2));
        
        Map<String, String> valuesMap = new Map<String, String>();
        
        valuesMap.put('A', 'A');
        valuesMap.put('B', 'B');
        valuesMap.put('C', 'B');
        
        List<SelectOption> options1 = UUI.getSelectOptionsList(valuesMap.values(), true);
        
        System.assertEquals(4, options1.size(), UTestData.getAssertMessage(1, 3));
        
        List<SelectOption> options2 = UUI.getSelectOptionsList(valuesMap, true);
        
        System.assertEquals(4, options2.size(), UTestData.getAssertMessage(1, 4));
        
        String sObjectName = 'Account';
        String sObjectFieldName = 'Type';
        
        DescribeFieldResult result1 = UUI.getFieldDescribe(sObjectName, sObjectFieldName);
        String defaultAccountType = null;
        List<SelectOption> accountTypes = new List<SelectOption>();
        List<Schema.PicklistEntry> items = result1.getPicklistValues();

        for(Schema.PicklistEntry item : items)
        {
            if(item.isDefaultValue() == true)
            {
                defaultAccountType = item.getValue();
            }
            
            accountTypes.add(new SelectOption(item.getValue(), item.getLabel()));                       
        } 
        
        List<SelectOption> options3 = UUI.getSelectOptionsForSobjectField(sObjectName, sObjectFieldName);
        
        System.assertEquals(accountTypes.size(), options3.size(), UTestData.getAssertMessage(1, 5));
        
        String s1 = UUI.getDefaultPicklistValue(sObjectName, sObjectFieldName);
        
        System.assertEquals(defaultAccountType, s1, UTestData.getAssertMessage(1, 6));
        System.assertEquals('You must enter a value', UUI.getSFDefaultErrorMessage(), UTestData.getAssertMessage(1, 7));  
        
        //Insert accounts
        Integer numberOfAccounts = 1;
        
        List<Account> accounts = UTestData.getAccounts(numberOfAccounts);
                
        insert accounts;
        
        accounts = [select Id, Name from Account where Id in :accounts];
        
        System.assertEquals(numberOfAccounts, accounts.size(), UTestData.getAssertMessage(1, 8));
        
        String s2 = UUI.getSFAttachmentsURL(accounts[0].Id, accounts[0].Name, '/' + accounts[0].Id);                                                 
    }
    
    private static testmethod void testUOrg()
    {
        System.assert(UOrg.getOrgEdition() != null, UTestData.getAssertMessage(1, 1));      
        System.assertEquals(true, UOrg.isSandbox('tapp0.salesforce.com'), UTestData.getAssertMessage(1, 2));
        System.assertEquals(true, UOrg.isSandbox('cs1.salesforce.com'), UTestData.getAssertMessage(1, 3));
        System.assertEquals(false, UOrg.isSandbox('na1.salesforce.com'), UTestData.getAssertMessage(1, 4));
    }
}