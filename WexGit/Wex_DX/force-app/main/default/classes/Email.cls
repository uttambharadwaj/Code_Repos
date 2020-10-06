/*

	Name: Email
	Created By: Jason McCormack (GearsCRM)
	Created Date: 
	Description: 
    
	Modified By: 
	Modified Date: 
	Description: 

*/

public with sharing class Email 
{
    private String senderEmailValue;
    private String senderDisplayNameValue;
    private Set<String> emailAddresses;
    private List<String> toAddressesList;
    private List<String> ccAddressesList;
    private List<String> bccAddressesList;
    private String subjectValue;
    private String plainTextBodyValue;
    private String htmlBodyValue;    
    
    public String SenderEmail
    {
        get
        {
            return senderEmailValue;
        }
                
        set
        {
            this.senderEmailValue = value;
            this.senderDisplayNameValue = value;
        }
    }
    
    public String SenderDisplayName
    {
        get
        {
            return senderDisplayNameValue;
        }
                
        set
        {
            this.senderDisplayNameValue = value;
        }
    }
    
    public List<String> ToAddresses
    {
        get
        {
            return toAddressesList;
        }
                
        set
        {
            addAddressesToMsg(value, 'To');
        }
    }
    
    public List<String> CcAddresses
    {
        get
        {
            return ccAddressesList;
        }
                
        set
        {
            addAddressesToMsg(value, 'CC');
        }
    }  
    
    public List<String> BccAddresses
    {
        get
        {
            return bccAddressesList;
        }
                
        set
        {
            addAddressesToMsg(value, 'BCC');
        }
    }      
    
    public String Subject
    {
        get
        {
            return subjectValue;
        }
                
        set
        {
            this.subjectValue = value;
        }
    }
    
    public String HTMLBody
    {
        get
        {
            return htmlBodyValue;
        }
                
        set
        {
            this.htmlBodyValue = value;
        }
    }   
    
    public String PlainTextBody
    {
        get
        {
            return plainTextBodyValue;
        }
                
        set
        {
            this.plainTextBodyValue = value;
        }
    }              
    
    public Email()
    {
        this.emailAddresses = new Set<String>();
        this.toAddressesList = new List<String>();
        this.ccAddressesList = new List<String>();
        this.bccAddressesList = new List<String>();                
    }    
        
    public void send()
    {
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();

        msg.setToAddresses(toAddresses);
        
        if(ccAddresses.size() > 0)
        {
            msg.setCcAddresses(ccAddresses);
        }
        
        if(bccAddresses.size() > 0)
        {
            msg.setBccAddresses(bccAddresses);
        }        
        
        msg.setReplyTo(senderEmailValue);
        msg.setSenderDisplayName(senderDisplayNameValue);
        msg.setSubject(subjectValue);
        msg.setPlainTextBody(plainTextBodyValue);
        msg.setHtmlBody(htmlBodyValue);

        if(isValid() == true)
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{msg});
        }    
    }
    
    public void addToAddress(String emailAddress)
    {
        if(emailAddress == null || emailAddress.trim().length() == 0)
        {
            return;
        }
        
        addAddressesToMsg(new String[]{emailAddress}, 'To');
    }
    
    public void addCcAddress(String emailAddress)
    {
        if(emailAddress == null || emailAddress.trim().length() == 0)
        {
            return;
        }
        
        addAddressesToMsg(new String[]{emailAddress}, 'CC');
    } 
    
    public void addBccAddress(String emailAddress)
    {
        if(emailAddress == null || emailAddress.trim().length() == 0)
        {
            return;
        }
        
        addAddressesToMsg(new String[]{emailAddress}, 'BCC');
    }        
    
    private void addAddressesToMsg(List<String> addresses, String addressType)
    {
        for(String address : addresses)
        {
            if(emailAddresses.contains(address) == false)
            {
                emailAddresses.add(address);
                
                if(addressType.trim().equalsIgnoreCase('To') == true)
                {
                    toAddressesList.add(address);
                }
                else if(addressType.trim().equalsIgnoreCase('CC') == true)
                {
                   ccAddressesList.add(address);                
                }    
                else if(addressType.trim().equalsIgnoreCase('BCC') == true)
                {
                    bccAddressesList.add(address);                
                }  
                else
                {
                    //No place to put the address       
                }              
            }
        }         
    }
    
    private Boolean isValid()
    {
        Boolean returnValue = true;
        
        if(senderEmailValue == null || senderEmailValue.trim().length() == 0)
        {
            returnValue = false;
        }
        
        if(subjectValue == null || subjectValue.trim().length() == 0)
        {
            returnValue = false;
        } 
        
        if((plainTextBodyValue == null || plainTextBodyValue.trim().length() == 0) && (htmlBodyValue == null || htmlBodyValue.trim().length() == 0))
        {
            returnValue = false;
        }                
        
        if(toAddresses.size() == 0)
        {
            returnValue = false;
        }
        
        return returnValue;
    }
    
    public static testMethod void testEmailMessage() 
    {    
        Email msg = new Email();
        
        msg.SenderEmail = 'Test@Test.Test';
        msg.Subject = 'This is a test';
        msg.PlainTextBody = 'This is the body of the test email';
        msg.HTMLBody = msg.PlainTextBody;
        
        msg.addToAddress('Test1@Test.Test');
        msg.addCcAddress('Test2@Test.Test');
        msg.addBccAddress('Test3@Test.Test');
        
        String s1 = msg.SenderEmail;                
        String s2 = msg.SenderDisplayName;        
        String s3 = msg.Subject;
        String s4 = msg.PlainTextBody;
        String s5 = msg.HTMLBody;        
                        
        List<String> l1 = msg.ToAddresses;
        List<String> l2 = msg.CcAddresses;
        List<String> l3 = msg.BccAddresses;     
        
        try {
        
        msg.send();
            
        }
        catch(Exception e) {
            System.debug('Sorryz');
        }
    }    
}