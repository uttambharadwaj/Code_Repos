/**
* This external javascript is used on DupeCheckPage and CreditApplicationPage VF pages to perform validations and auto population
* Created by: Ashish Takke
* Created date: 05/01/2015
*/

//used to auto populate client id and client name fields on VF page
function autoPopulateFields(){
    var programName = document.getElementById('creditApp:creditAppForm:pageBlock:dupChkPageBlockSection:program_name').value;
	
	var app_Type = document.getElementById('creditApp:creditAppForm:pageBlock:dupChkPageBlockSection:app_type');	
	while(app_Type.length > 0){
		app_Type.remove(0);
	}
		
    if(programName == 'SP Fleet Card') {

		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_id').value = '30';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_name').value = 'ExxonMobil Saipan';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:acc_client_name').value = 'ExxonMobil Saipan';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:card_pin').value = '';

		//set application type
		app_Type.options[app_Type.options.length] = new Option('--None--', '');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil Saipan Staff', 'ExxonMobil Saipan Staff');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil Saipan Standard', 'ExxonMobil Saipan Standard');
		
		//set country based on program name
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:shipping_country').value = 'Saipan';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:billing_country').value = 'Saipan';
	} else if(programName == 'GU Fleet Card') {
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_id').value = '31';
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_name').value = 'ExxonMobil Guam';
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:acc_client_name').value = 'ExxonMobil Guam';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:card_pin').value = '';

		//set application type
		app_Type.options[app_Type.options.length] = new Option('--None--', '');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil Guam Staff', 'ExxonMobil Guam Staff');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil Guam Standard', 'ExxonMobil Guam Standard');
		
		//set country based on program name
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:shipping_country').value = 'Guam';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:billing_country').value = 'Guam';
	} else if(programName == 'SG Fleet Card') {
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_id').value = '33';
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_name').value = 'ExxonMobil Singapore';
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:acc_client_name').value = 'ExxonMobil Singapore';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:card_pin').value = 'Y';
		
		//set application type
		app_Type.options[app_Type.options.length] = new Option('--None--', '');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil Singapore Embassy', 'ExxonMobil Singapore Embassy');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil Singapore Reseller/Staff', 'ExxonMobil Singapore Reseller/Staff');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil Singapore Standard', 'ExxonMobil Singapore Standard');

		//set country based on program name
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:shipping_country').value = 'Singapore';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:billing_country').value = 'Singapore';
    } else if(programName == 'HK Fleet Card') {
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_id').value = '32';
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_name').value = 'ExxonMobil Hong Kong';
        document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:acc_client_name').value = 'ExxonMobil Hong Kong';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:card_pin').value = '';

		//set application type
		app_Type.options[app_Type.options.length] = new Option('--None--', '');
		//app_Type.options[app_Type.options.length] = new Option('ExxonMobil Hong Kong Disabled Driver', 'ExxonMobil Hong Kong Disabled Driver');
		//app_Type.options[app_Type.options.length] = new Option('ExxonMobil Hong Kong Embassy', 'ExxonMobil Hong Kong Embassy');
		//app_Type.options[app_Type.options.length] = new Option('ExxonMobil Hong Kong Reseller', 'ExxonMobil Hong Kong Reseller');
		//app_Type.options[app_Type.options.length] = new Option('ExxonMobil Hong Kong Staff', 'ExxonMobil Hong Kong Staff');
		//app_Type.options[app_Type.options.length] = new Option('ExxonMobil Hong Kong Standard', 'ExxonMobil Hong Kong Standard');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil HK Duty Free Customer', 'ExxonMobil HK Duty Free Customer');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil HK General', 'ExxonMobil HK General');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil HK IDS Commercial', 'ExxonMobil HK IDS Commercial');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil HK IDS Personal', 'ExxonMobil HK IDS Personal');
		app_Type.options[app_Type.options.length] = new Option('ExxonMobil HK Personal Customers', 'ExxonMobil HK Personal Customers');
		
		//set country based on program name
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:shipping_country').value = 'Hong Kong';
		document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:billing_country').value = 'Hong Kong';
    } else {
		//set application type
		app_Type.options[app_Type.options.length] = new Option('--None--', '');
	}
}

//used to go back to home page
function backToHome(){
    window.open('/home/home.jsp','_parent');      
}

//used to restrict user from changing client name
function restrictClientName(){
    var client_name = document.getElementById('creditApp:creditAppForm:pageBlock:progPageBlockSection:client_name').value;
    alert('You are not allowed to change this value.');
    document.getElementById('creditApp:creditAppForm:pageBlock:progPageBlockSection:acc_client_name').value = client_name;
}

//used to clear search fields on duplicate check VF page
function clearFields(){
    document.getElementById('creditApp:creditAppForm:pageBlock:dupChkPageBlockSection:program_name').value = '';
    document.getElementById('creditApp:creditAppForm:pageBlock:dupChkPageBlockSection:app_type').value = '';
    document.getElementById('creditApp:creditAppForm:pageBlock:dupChkPageBlockSection:trading_name').value = '';
    document.getElementById('creditApp:creditAppForm:pageBlock:dupChkPageBlockSection:company_name').value = '';
    document.getElementById('creditApp:creditAppForm:pageBlock:dupChkPageBlockSection:reg_number').value = '';
    document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_id').value = '';
    document.getElementById('creditApp:creditAppForm:pageBlock:hiddenPageBlockSection:client_name').value = '';
}

//used to disable Billing address fields when it is same as Physical Address
function disableBillingAddress(){
    var chkboxValue = document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:chkbox').checked;
    if(chkboxValue){
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:street').disabled = true;
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:city').disabled = true;
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:country').disabled = true;
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:state').disabled = true;
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:postalCode').disabled = true;
    } else {
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:street').disabled = false;
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:city').disabled = false;
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:country').disabled = false;
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:state').disabled = false;
        document.getElementById('creditApp:creditAppForm:pageBlock:billing_address:postalCode').disabled = false;
    }
}

//used to update Account cycle same as Billing Frequency
function updateAccountCycle(){
    var billing_freq = document.getElementById('creditApp:creditAppForm:pageBlock:acc_info:billing_freq').value;
    document.getElementById('creditApp:creditAppForm:pageBlock:acc_info:acc_cycle').value = billing_freq;
    document.getElementById('creditApp:creditAppForm:pageBlock:acc_info:acc_cycle').disabled = true;
}

//used to update SalesAreaMarketing same as SalesAreaAdmin
function updateSalesAreaMarketing(){
    var sales_area_admin = document.getElementById('creditApp:creditAppForm:pageBlock:progPageBlockSection:sales_area_admin').value;
    document.getElementById('creditApp:creditAppForm:pageBlock:progPageBlockSection:sales_area_marketing').value = sales_area_admin;
    document.getElementById('creditApp:creditAppForm:pageBlock:progPageBlockSection:sales_area_marketing').disabled = true;
}