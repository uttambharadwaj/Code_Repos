public without sharing class OCMSForm {
//
//	public String JSONResponse {get; set;}
//	public String action {get; set;}
//	private Map<String, String> parameters;
//
//	public OCMSForm() {
//	}
//
//	public void loadResponse() {
//		this.parameters =  System.currentPageReference().getParameters();
//		this.action = this.parameters.get('action');
//		if(this.action == 'saveData'){
//			this.saveData();
//		}
//		else if (this.action == 'getData')
//		{
//			this.getData();
//		}
//	}
//
//	private void saveData()
//	{
//		String sSession = this.parameters.get('sess');
//		String sStatus = this.parameters.get('status');
//		String sUser = this.parameters.get('username');
//		sUser = sUser.toLowerCase();
//		String sPCLI = this.parameters.get('pcli_id');
//		String sContent = this.parameters.get('content_id');
//		String sData = this.parameters.get('data');
//		String sProgram = this.parameters.get('program');
//
//		OCMS_Form_Data__c fd = new OCMS_Form_Data__c();
//		fd.Username__c = sUser;
//		fd.PCLI__c = sPCLI;
//		fd.Content__c = sContent;
//		fd.Data__c = sData;
//		fd.Modified_Date__c = Datetime.now();
//		fd.SessionId__c = sSession;
//		fd.Status__c = sStatus;
//
//		try {
//			upsert fd SessionId__c;
//			this.JSONResponse = '{"status":"success"}';
//
//			//  Remove the previously saved form data
//			if (sStatus == 'saveforlater')
//			{
//				for (OCMS_Form_Data__c o : [SELECT Id, Name, Status__c, SessionId__c FROM OCMS_Form_Data__c WHERE Id != :fd.Id AND Status__c = :sStatus AND Username__c = :sUser AND SessionId__c != :sSession])
//				{
//					delete o;
//				}
//			}
//			if (sStatus == 'submitted')
//			{
//				for (OCMS_Form_Data__c o : [SELECT Id, Name, Status__c, SessionId__c FROM OCMS_Form_Data__c WHERE Id != :fd.Id AND Status__c != :sStatus AND Username__c = :sUser])
//				{
//					delete o;
//				}
//			}
//			if (sStatus == 'abandoned')
//			{
//				//  check if we have enough to create a lead in the abandoned records
//				processFormData(sData);
//			}
//		}
//		catch (Exception ex)
//		{
//			this.JSONResponse = '{"status":"failed","error":"' + ex.getStackTraceString() + '","username":"' + fd.Username__c + '","pcli":"' + fd.PCLI__c +
//								'","content":"' + fd.Content__c + '","data":[' + fd.Data__c + '],"modified":"' + fd.Modified_Date__c + '"}';
//		}
//	}
//
//	private void getData()
//	{
//		String sUser = this.parameters.get('username');
//		sUser = sUser.toLowerCase();
//		String sPCLI = this.parameters.get('pcli_id');
//		String sContent = this.parameters.get('content_id');
//
//		String soql = 'SELECT Id, Username__c, PCLI__c, Content__c, Data__c, Modified_Date__c FROM OCMS_Form_Data__c WHERE PCLI__c = \'' + sPCLI +	'\' AND Content__c = \'' + sContent + '\' AND Username__c = \'' + sUser + '\' AND Status__c = \'saveforlater\' ORDER BY Modified_Date__c DESC LIMIT 1';
//
//		SObject[] res = Database.Query(soql);
//		if (res.size() > 0)
//		{
//			this.JSONResponse = '{"status":"success", "data":' + (String)res[0].get('Data__c') + '}';
//		}
//		else
//		{
//			this.JSONResponse = '{"status":"failed"}';
//		}
//	}
//
//	class FormField {
//		private String value {get; set;}
//		private String klass {get; set;}
//	}
//
//	public void processFormData(String d)
//	{
//		List<FormField> lFields = new List<FormField>();
//		System.JSONParser jp = JSON.createParser(d);
//		jp.nextToken();
//		while (jp.nextToken() != null)
//		{
//			if (jp.getCurrentToken() == JSONToken.START_OBJECT)
//			{
//				if (jp.getCurrentName() == 'program')
//				{
//					FormField ff = (FormField)jp.readValueAs(FormField.class);
//					FormField newFF = new FormField();
//					newFF.klass = 'program';
//					newFF.value = ff.klass;
//					lFields.add(newFF);
//					System.debug(newFF);
//				}
//				else
//				{
//					FormField ff = (FormField)jp.readValueAs(FormField.class);
//					lFields.add(ff);
//					System.debug(ff);
//				}
//			}
//		}
//		if (lFields.size() > 0)
//			processLeadRecord(lFields);
//	}
//
//	private Boolean processLeadRecord(List<FormField> ff)
//	{
//		Map<String, String> leadMap = new Map<String, String>();
//		for (FormField f : ff)
//		{
//			String fname = '';
//			if (f.klass == 'program')
//			{
//				leadMap.put(f.klass, f.value);
//			}
//			else
//			{
//				fname = getFieldName(f.klass);
//				if (fname != '')
//				{
//					leadMap.put(fname, f.value);
//				}
//			}
//		}
//
//		System.debug('******* Final mapped fields: ' + leadMap);
//
//		String[] reqFields = new String[] {'Promotional_Code__c', 'Company_Name__c', 'First_Name__c', 'Last_Name__c'};
//		String[] optFields = new String[] {'Email__c','Business_Phone__c','City__c','State__c','Zip_code__c'};
//
//		for (String f: reqFields)
//		{
//			if (leadMap.get(f) == '')
//				return false;
//		}
//
//		Boolean bOpts = false;
//		for (String f: optFields)
//		{
//			if (leadMap.get(f) != '')
//				bOpts = true;
//		}
//
//		if (bOpts == false)
//			return false;
//
//		//  we should have everything to create a lead now
//		try
//		{
//			Lead l = new Lead();
//			l.Company = leadMap.get('Company_Name__c');
//			l.FirstName = leadMap.get('First_Name__c');
//			l.LastName = leadMap.get('Last_Name__c');
//			l.Coupon_Code__c = leadMap.get('Promotional_Code__c');
//			l.Email = leadMap.get('Email__c');
//			l.Phone = leadMap.get('Business_Phone__c');
//			l.City = leadMap.get('City__c');
//			l.State = leadMap.get('State__c');
//			l.PostalCode = leadMap.get('Zip_code__c');
//			l.Estimated_Monthly_Vehicle_Expenditures__c = leadMap.get('Estimate_Monthly_Vehicle_Expenses__c');
//			insert l;
//			System.debug(l);
//			return true;
//		}
//		catch (Exception ex)
//		{
//			return false;
//		}
//	}
//
//	private String getFieldName(String f)
//	{
//		String[] fname = f.split('__c_');
//		if (fname.size() > 1)
//			return fname[1];
//		else
//			return '';
//	}
//
//	static testMethod void testOCMSForm()
//	{
//		OCMSForm f = new OCMSForm();
//		ApexPages.currentPage().getParameters().put('action', 'saveData');
//		ApexPages.currentPage().getParameters().put('username', 'stantivetest@stantive.com');
//		ApexPages.currentPage().getParameters().put('pcli_id', 'a123456789012');
//		ApexPages.currentPage().getParameters().put('content_id', 'a987654321021');
//		ApexPages.currentPage().getParameters().put('data', '{"TestData1":"Test1", "TestData2":"Test2", "TestData3":"Test3"');
//
//		f.loadResponse();
//		System.debug(f.JSONResponse);
//
//		ApexPages.currentPage().getParameters().put('action','getData');
//		ApexPages.currentPage().getParameters().put('username', 'stantivetest@stantive.com');
//		ApexPages.currentPage().getParameters().put('pcli_id', 'a123456789012');
//		ApexPages.currentPage().getParameters().put('content_id', 'a987654321021');
//		f.loadResponse();
//		System.debug(f.JSONResponse);
//
//		//  Test invalid content ID
//		ApexPages.currentPage().getParameters().put('content_id', 'a9876543333333');
//		f.loadResponse();
//		System.debug(f.JSONResponse);
//
//		OCMS_Form_Data__c oc = new OCMS_Form_Data__c();
//		oc.Content__c = '123';
//		oc.Username__c = 'user';
//		oc.PCLI__c = 'P123';
//		oc.Status__c = 'abandoned';
//		oc.SessionID__c = '43252333';
//		oc.Data__c = '{"pcli_id": {"value": "a1KS00000000viKMAQ","klass": ""},"content_id": {"value": "a16S0000002AJr2IAG","klass": ""},"f_a16S0000002AJqfIAG": {"value": "Test Company 2","klass": "WeFormObject__c_Company_Name__c"},"f_a16S0000002AJqTIAW": {"value": "","klass": "WeFormObject__c_Doing_Business_As__c"}, "program": {"value":"166325", "klass": "ProgramTest"},"f_a16S0000002AJqlIAG": {"value": "R","klass": "WeFormObject__c_First_Name__c"},"f_a16S0000002AJqdIAG": {"value": "Collins","klass": "WeFormObject__c_Last_Name__c"},"f_a16S0000002AJqoIAG": {"value": "ps@stantive.com","klass": "WeFormObject__c_Email__c"},"f_a16S0000002AJqYIAW": {"value": "RC01","klass": "WeFormObject__c_Promotional_Code__c"},"f_a16S0000002AJqtIAG": {"value": "Kingston","klass": "WeFormObject__c_City__c"},"f_a16S0000002AJqzIAG": {"value": "ON","klass": "WeFormObject__c_State__c"}}';
//		insert oc;
//
//		f.processFormData(oc.Data__c);
//	}
}