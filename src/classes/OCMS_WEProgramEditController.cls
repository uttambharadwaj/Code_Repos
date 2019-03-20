global with sharing class OCMS_WEProgramEditController extends cms.ContentTemplateController {

	global OCMS_WEProgramEditController(){
	}

	global OCMS_WEProgramEditController(cms.GenerateContent gc){
    	this.content = gc.content;
		this.content_properties = gc.properties; 
	}

	global override String getHTML() {
		return '<div style="display:none;">' +
			   '<div id="OCMSWE-programid">' + programId + '</div>' +
			   '<div id="OCMSWE-programname">' + programName + '</div>' +
			   '<div id="OCMSWE-head-color-from">' + headColorFrom + '</div>' +
			   '<div id="OCMSWE-head-color-to">' + headColorTo + '</div>' +
			   '<div id="OCMSWE-submit-color-from">' + submitColorFrom + '</div>' +
			   '<div id="OCMSWE-submit-color-to">' + submitColorTo + '</div>' +
			   '<div id="OCMSWE-foot-color">' + footColor + '</div>' +
			   '<div id="OCMSWE-topline-color">' + toplineColor + '</div>' +
			   '<div id="OCMSWE-left-margin">' + leftMargin + '</div>' +
			   '</div>';
	}	

    public String programId {     
        get {
            return getProperty('programId');
        }
        set;
    }
    
    public String programName {     
        get {
            return getProperty('programName');
        }
        set;
    }
    
    public String headColorFrom {     
        get {
            return getProperty('headColorFrom');
        }
        set;
    }
    
    public String headColorTo {     
        get {
            return getProperty('headColorTo');
        }
        set;
    }
    
    public String footColor {     
        get {
            return getProperty('footColor');
        }
        set;
    }
    
    public String toplineColor {     
        get {
            return getProperty('toplineColor');
        }
        set;
    }
    
    public String leftMargin {     
        get {
            return getProperty('leftMargin');
        }
        set;
    }
    
    public String submitColorFrom {     
        get {
            return getProperty('submitColorFrom');
        }
        set;
    }
    
    public String submitColorTo {     
        get {
            return getProperty('submitColorTo');
        }
        set;
    }
    
	@IsTest(SeeAllData=true)     
	static void testOCMS_WEProgramEditController(){
		
		OCMS_WEProgramEditController sb = new OCMS_WEProgramEditController(); 
		
		try{
            sb.programId = '12345';
        }catch(exception e){}
        String t_programId = sb.programId;
		
		try{
            sb.programName = 'Stantive';
        }catch(exception e){}
        String t_programName = sb.programName;
        
        String h = sb.getHTML();
        System.debug(h);

		//  Test the generate content constructor
		OCMS_WEProgramEditController pec = new OCMS_WEProgramEditController(new cms.GenerateContent());
	}
}