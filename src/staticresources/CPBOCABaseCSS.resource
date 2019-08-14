/* Mobile First! */

/* Site-wide Styles - START */
* { 
	font-family: 'Open Sans', serif;
}
html, body {
	height: 100%;
	margin: 0;
    margin: 0;
    padding: 0;
    font-family: 'Open Sans', serif;
    font-size: 13px;
}
body { 
	width: 100%;
	background: #f5f5f5;     
}

::-webkit-input-placeholder {
	font-style: italic; font-size: 90%;
}
:-moz-placeholder {
	font-style: italic;  font-size: 90%; 
}
::-moz-placeholder {
	font-style: italic;   font-size: 90%;
}
:-ms-input-placeholder {  
	font-style: italic;  font-size: 90%;
}

.step-indicator { display: none !important; }

.no-select { 
	-khtml-user-select: none; 
	-o-user-select: none; 
	-moz-user-select: none; 
	-webkit-user-select: none; 
	user-select: none; 
}

.header-large { 
	font-size: 24px; 
	margin: 0; 
}

.header-small { 
	font-size: 16px; 
    font-weight: 700;
	margin: 0; 
    color: #777;
}

h3 { 
	font-size: 18px; 
	margin: 4px 0; 
}

.clearfix:after {
	visibility: hidden;
	display: block;
	font-size: 0;
	content: " ";
	clear: both;
	height: 0;
}
.clearfix { display: inline-block; }
/* start commented backslash hack \*/
* html .clearfix { height: 1%; }
.clearfix { display: block; }
/* close commented backslash hack */

.page-wrap {
	width: 100%;
	min-height: 100%;
	/* equal to footer height */
	margin-bottom: -22px; 
}

.page-wrap:after {
	content: ".";
	display: block;
}
/* Site-wide Styles - END */

/* Header Section - START */
#header { 
	width: 100%; 
	background: #fff !important; 
	color: #333; 
	padding-top: 10px; 
    display: block;
}

#contactUs { 
    display: none;
	text-align: center; 
	margin-bottom: 10px; 
	display: none; 
    font-size: 14px;
}

#branding { 
	width: 100%; 
	text-align: center; 
	margin-bottom: 10px; 
}

.logo {	
	max-height: 80px; 
	margin-top: 10px; 
	margin-bottom: 10px; 
	pointer-events: none; 
}

.program-name { 
	display: none; 
}
/* Header Section - END */

#content { 
	margin: 0 auto 80px auto; 
}

/* Step Indicator - START */
.step-indicator { 
	background: #e9e9e9; 
	width: 100%; 
	font-size: 12px; 
}

.step { 
	background: inherit; 
	float: left; 
	width: 33%; 
	font-size: 12px; 
	text-transform: uppercase; 
	text-align: center; 
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
	padding: 11px 10px; 
	letter-spacing: -0.06em; 
    height: 100%;
}

.step-active { 
	background: #143154; 
	color: #fff; 
	position: relative; 
	display: inline-block; 
	width: 33%; 
    height: 100%;
}

.step-active:after { 
	display: none; 
}

ul.CompanySearchResults {
	margin-top: -19px;
}

.section-header { 
	width: 100%; 
	padding: 8px 16px; 
	font-size: 16px; 
	color: #fff; 
	font-weight: bold; 
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
    border-radius: 3px 3px 1px 1px;
}
/* Step Indicator - END */

/* Sidebar - START */
.brand-text { 
	text-align: center; 
}

.cardImage { 
	width: 260px; 
	pointer-events: none; 
	margin: 30px auto 0 auto; 
    display: none;
}

.sidebar-section-header, .sidebar-section-dynamic-content, .sidebar-section-static-content { 
	display: none; 
}

.sidebar-section-header { 
	margin: 0 auto; 
	width: 260px; 
	padding: 6px 10px; 
	font-size: 14px; 
	color: #fff; 
	font-weight: bold; 
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
}

.sidebar-section-dynamic-content { 
	width: 260px; 
	background: #fff; 
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
	margin: 0 auto 20px auto; 
}

.sidebar-section-static-content { 
	width: 260px; 
	background: #fff; 
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
	margin: 0 auto 20px auto; 
	padding: 10px 14px; 
	border-left: 1px solid #aaa; 
    border-right: 1px solid #aaa; 
    border-bottom: 1px solid #aaa; 
}

#accordion { 
	width: 260px; 
}

#accordion div { 
	width: 220px; 
	padding: 20px 19px 0 19px; 
}

#accordion div p { 
	width: 220px; 
	padding: 0; 
}

.panel-heading { 
	width: 242px; 
}

.panel-title { 
	font-size: 16px; 
	color: #fff; 
}
/* Sidebar - END */

/* Form Elements - START */
.terms-container { 
	overflow-x: auto;
	background: #efefef; 
	max-height: 200px; 
	overflow-y: scroll;
	border-left: 1px solid #ccc; 
	border-right: 1px solid #ccc; 
	border-bottom: 1px solid #ccc; 
	padding: 10px; 
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
}

.terms-container p { 
	padding: 0; 
	margin 0; 
}

.terms-container blockquote,dl,figure,form,ol,p,pre,table,ul {
    margin-bottom: 1rem; 
    font-size: 90%;
}

.terms-container td {
    padding: .25rem;
}

::placeholder {
  color: #999;
  font-size: 11px;
}

.disclaimer-container { 
	background: #efefef; 
	border-left: 1px solid #ccc; 
	border-right: 1px solid #ccc; 
	border-bottom: 1px solid #ccc; 
	padding: 10px; 
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
}

.disclaimer-checkbox { 
	float: left; 
	width: 8%; 
	padding-top: 2px; 
}

.disclaimer-text { 
	float: left; 
	width: 92%; 
}

.detailList { 
	white-space: nowrap; 
}

.styled-label { 
	color: #555; 
	font-weight: normal; 
	font-size: 11px; 
	padding-left: 2px; 
    text-transform: uppercase;
}

.styled-label-required { 
	color: #d14040; 
}

.styled-input { 
	background-color: rgb(255, 255, 255);
    border: 1px solid rgb(217, 219, 221);
    border-radius: .25rem;
    width: 100%;
    transition: border .1s linear,background-color .1s linear;
    display: inline-block;
    padding: 0 1rem 0 .75rem;
    line-height: 1.875rem;
    min-height: calc(1.875rem + (1px * 2));
}

.styled-select { 
	border: 1px solid #ccc; 
	padding: 8px 10px; 
	width: 100%; 
	border-radius: 0 !important; 
}

.styled-select { 
	width: 100%; 
}

.styled-select-full { 
	width: 100%; 
} 

.styled-input-small { 
	width: 100%; 
}

.erroredInput { 
	border: 1px solid #ebccd1 !important; 
	background: #f2dede !important; 
}

.erroredSection { 
	background: #f2dede !important; 
}

.fieldErrorMessage { 
	margin-top: -6px; 
	line-height: 2px; 
	display: block; 
	padding-bottom: 16px; 
	color: #a94442; 
	font-size: 11px; 
	padding-left: 3px;  
}

.errorFiller { 
	padding-bottom: 0px; 
}

.stepErrors { 
	display: none; 
	background: #f2dede; 
	border: 1px solid #ebccd1; 
	margin: 0 0 20px 0; 
	color: #a94442; 
	padding: 20px; 
	line-height: 15px; 
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
}

.disabled-button { 
	background: #e9e9e9 !important; 
	pointer-events: none; 
	color: #ccc !important; 
	border: 1px solid #ccc !important;
}

.loader-gif { 
	float: right; 
	width: 20px; 
	margin-top: 8px; 
	margin-right: 8px; 
	display: none; 
}

.step-button {
	float: right;
	position: relative;
    display: inline-block;
    padding: 0;
    background: transparent;
    background-clip: border-box;
    border: 1px solid #ddd !important;
    border-radius: .25rem;
    line-height: 1.875rem;
    text-decoration: none;
    color: rgb(0, 112, 210);
    -webkit-appearance: none;
    white-space: normal;
    user-select: none;
    font-weight: normal !important;
}

.caslDisclaimer {
    border: 1px solid #ddd !important;
    background: #f1f1f1;
    padding: 10px;
}
/* Form Elements - END */

/* Footer Section - START */
#footer {
	background: #fff;
	color: #333;
	height: 22px; 
	padding: 4px 0;
	border-top: 1px solid #ccc;
	text-align: center; 
}

#footer { 
    margin-bottom: 80px;
}

#mobile-footer-call {
	display: block;
	position: fixed;
	bottom: 0px;
	height: 80px;
	width: 100%;
	-moz-border-radius: 15px 15px 0px 0px; 
	border-radius: 15px 15px 0px 0px;
	z-index: 99999;
    text-decoration: none;
}

#mobile-footer-call .line1 {
    display: block;
	font-size: 13px;
	text-transform: uppercase;
	color: white;
	text-align: center;
	padding-top: 10px;
}

#mobile-footer-call .line2 {
    display: block;
	font-size: 32px;
	color: white;
	text-align: center;
	font-weight: bold;
}
/* Footer Section - END */

@media only screen and (min-width: 540px) and (max-width: 960px) {
    #content { 
        width: 480px; 
        margin: 0 auto 80px auto; 
    }
    
    .sidebar { 
        display: inline;
        min-width: 380px; 
    }
    
    .form { 
        min-width: 480px; 
        margin-left: -48px; 
    }
    
    .errorFiller { 
        padding-bottom: 12px; 
    }
    
    .styled-label { 
        font-size: 11px; 
    }
    
    .cardImage { 
    	display: block;
	}
}

/* Bigger than a phablet */
@media only screen and (min-width: 960px)  {
	/* Site Wide Styles - START */
	.header-small { font-weight: 700; }

	.container { width: 1200px; }
	/* Site Wide Styles - END */

	/* Header Section - START */
    #header { 
        display: block;
		width: 100%; 
		background: #fff !important; 
		border-bottom: 1px solid #ececec; 
		color: #333; 
		padding-top: 10px; 
	}

	.logo {	
		max-height: 80px; 
		float: left; 
		margin-bottom: 16px; 
	}

	.program-name { 
		float: left; 
		line-height: 90px; 
		padding-left: 20px; 
		display: block; 
	}

	#contactUs { 
		float: right; 
		text-align: left; 
		white-space: nowrap; 
		display: block; 
	}
	/* Header Section - END */
	
	/* Step Indicator - START */
    .step-active { 
		background: #143154; 
		color: #fff; 
		position: relative; 
		display: inline-block; 
		width: 35%; 
		padding-right: 8px; 
		margin-right: 3%; 
		padding-left: 20px; 
	}

    .step-active:after { 
		display: block; 
		content: ''; 
		position: absolute; 
		top: 0; 
		bottom: 0; 
		left: 100%; 
		width: 0; 
		height: 0; 
		border: 20px solid transparent; 
		vertical-align: middle; 
		border-left-color: #143154; 
	}

	.step-active-middle:before { 
		display: block; 
		content:''; 
		position: absolute; 
		top: 0; 
		bottom: 0; 
		right: 82%; 
		width: 0; 
		height: 0; 
		border: 20px solid transparent; 
		vertical-align: middle; 
		border-left-color: #e9e9e9; 
	}
    
    .step-last {
		width: 29% !important;
    }
	/* Step Indicator - END */
    
	/* Sidebar - START */
	.cardImage { 
		width: 260px; 
		pointer-events: none; 
	}

	.sidebar-section-header { 
		display: block; 
		width: 260px; 
		padding: 6px 10px; 
		font-size: 14px; 
		color: #fff; 
		font-weight: bold; 
		-moz-box-sizing: border-box; 
		-webkit-box-sizing: border-box;
		box-sizing: border-box; 
	}

	.sidebar-section-dynamic-content { 
		display: block; 
		width: 260px; 
		background: #fff; 
		-moz-box-sizing: border-box; 
		-webkit-box-sizing: border-box; 
		box-sizing: border-box; 
		margin-bottom: 20px; 
	}

	.sidebar-section-static-content { 
		display: block; 
		width: 260px; 
		background: #fff; 
		-moz-box-sizing: border-box; 
		-webkit-box-sizing: border-box; 
		box-sizing: border-box; 
		margin-bottom: 20px; 
		padding: 10px 14px; 
		border-left: 1px solid #aaa; 
		border-right: 1px solid #aaa; 
		border-bottom: 1px solid #aaa; 
	}
	/* Sidebar - END */

	/* Form Elements - START */
    .styled-select { 
		width: 80%; 
	} 

	.styled-select-full { 
		width: 100%; 
	}

	.styled-input-small { 
		width: 80%; 
	}

	.errorFiller { 
		padding-bottom: 12px; 
	}

	.disclaimer-checkbox { 
		float: left; 
		width: 3%; 
		padding-top: 2px; 
	}

    .form {
        
        padding-top: 20px;
        
    }

	.cardImage { 
    	display: block;
	}
    
	.disclaimer-text { 
		float: left; 
		width: 97%; 
        max-height: 150px;
        overflow-y: auto;
	}

	.disabled-button { 
		background: #e9e9e9 !important; 
		pointer-events: none; 
		color: #ccc !important; 
		border: 1px solid #ccc !important;
	}

	.loader-gif { 
		float: right; 
		width: 20px; 
		margin-top: 8px; 
		margin-right: 8px; 
        display: none; 
	}
	/* Form Elements - END */

	/* Footer Section - START */
	#footer {
		background: #fff;
		color: #333;
		height: 22px; 
		padding: 4px 0 4px 40px;
		border-top: 1px solid #ccc;
		text-align: left;
	}
    #footer {
        margin-bottom: 0;
    }
    #mobile-footer-call, .line1, .line2 {
        display: none;
    }

	.step-indicator { display: none !important; }
	/* Footer Section - END */
}