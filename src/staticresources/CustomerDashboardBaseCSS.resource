* { 
	font-family: 'Open Sans' !important; 
}

#header { 
    margin-top: 10px;
	line-height: 22px; 
	font-family: 'Open Sans' !important;
    margin-bottom: 20px;
}

#header .title { 
	font-size: 14px; 
	color: #e51937; 
	font-weight: bold; 
}

#header h1 { 
	font-size: 20px; 
	font-weight: bold; 
}

#header .pageTitleIcon { 
	margin-top: 9px;
    margin-right: 10px !important;
}

#search { 
    	margin-top: 10px; 
    	margin-bottom: 20px; 
    	font-family: 'Open Sans' !important; 
    	
}

#search .searchTop {
    padding: 0;
}

#search .searchBottom {
    margin-top: -10px;
}

#search .searchBox { 
   	float: left;
    display: inline-block;
    padding: 4px;
    width: 220px;
}

#search .goButton { 
    background: #ffcc33; 
    border: 0px; 
    padding: 5px; 
    font-size: 14px; 
	float: left;
    display: inline-block;
    margin-left: 8px;
}

#search .recentAccounts { 
    border: 1px solid #ddd; 
    padding: 4px 8px; 
    background: #eee; 
    margin-left: 80px; 
    display: inline-block;
    float: left;
}

#search .searchType { 
    margin-left: -16px; 
}

#content { 
    margin-top: 10px; 
    font-family: 'Open Sans' !important; 
}

.pbSubheader h3 { 
    color: #e51937; 
    line-height: 22px; 
    font-size: 16px !important; 
    cursor: pointer;
    -webkit-touch-callout: none;
    -webkit-user-select: none; 
    -khtml-user-select: none; 
    -moz-user-select: none; 
    -ms-user-select: none; 
    user-select: none; 
}

.pbSubheader { 
    border-top: 2px solid #bbb !important; 

}

.data2Col {
    border: 0 !important;
}

.loader-gif { 
    float: left;
	width: 28px;  
    margin-left: 4px;
    visibility: hidden;
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

.disabled-form-element { 
	background: #e9e9e9 !important; 
	pointer-events: none; 
	color: #ccc !important; 
}

.detailTable { 
    font-size: 13px; 
    width: 99%; 
    min-width: 1000px; 
    border-collapse: separate !important; 
    border-spacing: 0 6px !important; 
}

.detailTable tr {
    padding-bottom: 4px;
}

.detailTable tr td { 
    padding: 8px; 
} 

.detailTable tr td:first-child {
    border-spacing: 0px !important;
}

.detailTable tr td.seperator {
    padding: 0;
    border-bottom: 1px solid #ccc;
}

.detailTable tr td.no-data { 
    background: #f1f1f1;
} 

.detailTable tr:last-child td { 
    border: 0 !important; 
}

.detailTable .detailFieldLabel { 
    color: #444 !important; 
    text-align: left; 
    font-weight: bold; 
    white-space: nowrap;
    width: 11%;
    padding-left: 30px;
}

.detailTable tr td.detailFieldLabel:first-child {
    padding-left: 8px;
}

.detailTable .detailFieldValue { 
    text-align: left; 
    width: 15%; 
    color: #777 !important;
}

.detailTable .detailFieldSplitValue, .detailTable .detailFieldSplitValueIndicator { 
    color: #777 !important; 
    text-align: left; 
    width: 9.5%; 
}

.detailTable .detailFieldSplitValueIndicator { 
    text-align: Left; 
    color: #ff9900 !important; 
    font-style: italic; 
}

.detailTable a, .detailTable a:hover { 
    color: #0066ff !important; 
    text-decoration: none; 
}

.productTable { 
    font-size: 13px; 
    min-width: 1000px; 
    text-align: center; 
    margin: 20px 0 10px 0; 
}

.productTable td { 
    width: 160px; 
    font-weight: bold; 
    white-space: nowrap;
}

.productTable td.active { 
    background: #dff2ff; 
    border: 1px solid #3a97b5 !important; 
    border-radius: 3px; padding: 10px 4px; 
}

.productTable td.active:after { 
    content:  "\A\2713"; 
    font-size: 26px; 
    color: #81bc04; 
    display: block; 
} 

.ratingContainer {
	margin-left: 180px; 
    margin-top: -40px;
}

.rating { 
    display: block; 
    font-size: 24px; 
    padding-top: 2px;
    color: #bbb; position: 
        relative; max-width: 260px; 
}

.rating .starActive:after { 
    content: "\2605"; 
    color: #ffcc00; 
}

.rating .starInactive:after { 
    content: "\2606"; 
}

.rating .servicingRules { 
    visibility: hidden; 
    width: 220px; 
    background-color: #555 !important; 
    color: #fff; 
    padding: 8px; 
    border-radius: 6px; 
    position: absolute; 
    z-index: 1; 
    font-size: 14px; 
} 

.rating:hover .servicingRules:not(:empty) { 
    visibility: visible; 
    cursor: text; 
}

.rating:hover { 
    cursor: pointer; 
} 

.platformProgramIndicatorContainer {
	float: right; 
    margin-top: -30px; 
    font-size: 18px;
    font-weight: bold;
}

.platformProgramIndicator { 
    color: #3a97b5 !important; 
}

.tooltipRegion:hover .hover:not(:empty) { 
    visibility: visible; 
    cursor: text; 
}

.hover { 
    visibility: hidden; 
    width: 220px; 
    background-color: #555 !important; 
    color: #fff; 
    padding: 8px; 
    border-radius: 6px; 
    position: absolute; 
    z-index: 1; 
    font-size: 14px; 
} 

.ui-tooltip {
    background: #ffffcc !important;
}