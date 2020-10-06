// Load the Visualization API and the piechart package.
google.load('visualization', '1', {'packages':['corechart']});
// Load the Visualization API and the piechart package.
google.load('visualization', '1', {'packages':['gauge']});
// Set a callback to run when the Google Visualization API is loaded.
google.load('visualization', '1', {packages:['table']});
google.load('visualization', '1', {packages:['timeline']});
google.setOnLoadCallback(initCharts);
var bar, bar2, gauge, table, table2, table3, col1, col2, data, data2, data3, data4, data5, data6, data7, data8;
var totalAtts;
console.log("total atts: "+ totalAtts);
var cssClassNames = {'hAxis': 'hAxisClass'};

var options1 = {
    tooltip: {trigger: 'hover'},
    legend: {position: 'top'},
    title: 'Attendees Arriving By Name',
    colors: ['#E44308'],
    histogram: { bucketSize: 1, hideBucketItems: false},
    width:window.innerWidth,
    height: window.innerHeight/3,
    vAxis:{textStyle:{fontSize: 10}},
    hAxis:{textStyle:{color: 'none'}},
    backgroundColor: { fill: "none" },
    showTextEvery:1,
    slantedText:true,
    interpolateNulls: false};

var options2 = {
    tooltip: {trigger: 'selection'},
    legend: {position: 'top'},
    title: 'Attendees Arriving By Hour',
    colors: ['#E44308'],
    histogram: { bucketSize: 1, hideBucketItems: false},
    width:window.innerWidth,
    height: window.innerHeight/3,
    vAxis:{textStyle:{fontSize: 10}},
    backgroundColor: { fill: "none" },
    hAxis: {
        textStyle:{fontSize: 10},
        direction:-1,
        slantedText:true,
        slantedTextAngle:30
    },
    interpolateNulls: false};


var options3 = {
    tooltip: {trigger: 'selection'},
    legend: {position: 'top'},
    title: 'Attendees Departing By Hour',
    colors: ['#5F0F99'],
    histogram: { bucketSize: 1, hideBucketItems: false},
    width:window.innerWidth,
    height: window.innerHeight/3,
    backgroundColor: { fill: "none" },
    vAxis:{textStyle:{fontSize: 10}},
    hAxis: {
        textStyle:{fontSize: 10},
        direction:-1,
        slantedText:true,
        slantedTextAngle:30
    },
    interpolateNulls: false};   

var options4 = {
    tooltip: {trigger: 'hover'},
    legend: {position: 'top'},
    title: 'Attendees Departing By Name',
    colors: ['#5F0F99'],
    backgroundColor: { fill: "none" },
    histogram: { bucketSize: 1, hideBucketItems: false},
    width:window.innerWidth,
    height: window.innerHeight/3,
    vAxis:{textStyle:{fontSize: 10}},
    hAxis:{textStyle:{color: 'none'}},
    showTextEvery:1,
    slantedText:true,
    interpolateNulls: false};


function initCharts() {   
    eventsController.getAttInfo(
        function(result, event){
           
            var arrSeries = [];
            var depSeries = [];
            var names = [];
            var arrTitle = "Arrivals";
            var depTitle = "Departures";
            
            var bins = [1,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
            var binTitles = ['12AM-1AM','5AM-6AM','6AM-7AM','7AM-8AM','8AM-9AM','9AM-10AM','10AM-11AM',
                             '11AM-12PM','12PM-1PM','1PM-2PM','2PM-3PM','3PM-4PM','4PM-5PM','5PM-6PM',
                             '6PM-7PM','7PM-8PM','8PM-9PM','9PM-10PM','10PM-11PM',
                             '11PM-12AM'];
            console.log('bins'+bins.length);
            console.log('bin titles'+ binTitles.length);
            var arrHisto = new Array();
            var depHisto = new Array();
            function initHisto(histo,title,bins) {
                
                // header line
                histo.push([]);
                histo[0][0]   = title;
                histo[0][1]   = "Attendees";
                
                // create one row for each bin
                for(b=0; b<binTitles.length; b++ ) {
                    // Create new row
                    histo.push([]);
                    histo[b+1][0]       = ""+binTitles[b];
                    histo[b+1][1]       = 0;
                }
            }
            
            initHisto(arrHisto, arrTitle, bins);
            initHisto(depHisto, depTitle, bins);
            bar = new google.visualization.ColumnChart(document.getElementById('arrChart'));   
            bar2 = new google.visualization.ColumnChart(document.getElementById('depChart'));
            col1 = new google.visualization.ColumnChart(document.getElementById('arrCol'));
            col2 = new google.visualization.ColumnChart(document.getElementById('depCol'));
            table2 = new google.visualization.Table(document.getElementById('tableTwo'));
            table3 = new google.visualization.Table(document.getElementById('tableThree'));
            //var cal1 = new google.visualization.Timeline(document.getElementById('arrCal'));
            // Prepare table model for chart with columns
            data = new google.visualization.DataTable();  
            data7 = new google.visualization.DataTable();   
            data8 = new google.visualization.DataTable(); 
            data2 = new google.visualization.DataTable();     
            
            data2.addColumn('string', 'Name');  
            data2.addColumn('datetime', 'Departure');
            data.addColumn('string', 'Name');  
            data.addColumn('datetime', 'Arrival');  
            data7.addColumn('string','Name');
            data7.addColumn('datetime','Arrival');
            data7.addColumn('string','Flight');
            data7.addColumn('string','Email');
            data8.addColumn('string','Name');
            data8.addColumn('datetime','Departure');
            data8.addColumn('string','Flight');
            data8.addColumn('string','Email');
            //data3.addColumn('string', 'Name')
            //data3.addColumn('number', 'Arrival');
            //data3.addColumn('number', 'Amount');
            
            
            for(var i=0; i<result.length; i++){ 
              
                var res = result[i];
                //var time = new Date(res.Arrival_Date_Time__c).getHours();
                var date1 = res.Arrival_Date_Time__c;
                var date2 = res.Departure_Date_Time__c;
                //console.log('dates: ' + date1 + '' + date2);
                if(date1== undefined){
                    res.Arrival_Date_Time__c = '1';
                }
                 if(date2== undefined){
                    res.Departure_Date_Time__c = '1';
                }
                data.addRow([res.Name, new Date(res.Arrival_Date_Time__c)]);
                data2.addRow([res.Name, new Date(res.Departure_Date_Time__c)]);
                data7.addRow([res.Name, new Date(res.Arrival_Date_Time__c), res.Arrival_Flight_Number__c, res.Email__c]);
                data8.addRow([res.Name, new Date(res.Departure_Date_Time__c), res.Departing_FLight_Number__c, res.Email__c]);
                //data3.addRow([res.Name,Math.round(new Date(res.Arrival_Date_Time__c).getHours())]);
                arrSeries[i]=(new Date(res.Arrival_Date_Time__c).getHours());
                depSeries[i]=(new Date(res.Departure_Date_Time__c).getHours());
                //data3.addRow([i,new Date(res.Arrival_Date_Time__c)]);
                
            }
            
            //go through all attendees and bucket them by arrival/departure
            var arrBuckett = {};
            var depBuckett = {};
            console.log(arrBuckett);
            for(var i=0; i<bins.length; i++){  
                var binName = bins[i];
                var arrNames = [];
                var depNames = [];
                for(var j=0; j<result.length; j++){
                    var res = result[j];
                    if(new Date(res.Arrival_Date_Time__c).getHours()== binName){
                        arrNames.push(res.Name + ' Flight: ' + res.Arrival_Flight_Number__c);
                        //console.log('Name'+ arrBuckett[i]);
                    }
                    if(new Date(res.Departure_Date_Time__c).getHours()== binName){
                        depNames.push(res.Name + ' Flight: ' + res.Departing_Flight_Number__c)
                    }
                    
                }
                arrBuckett[binName]=arrNames;
                depBuckett[binName]=depNames;
            }
            
            var maxFreq     = 0;    // Necessary to set the maximum y-value
            
            function frequency( histo, series, bins ) {
                for(d=0; d<series.length; d++ ) {
                    // first bin
                    if( series[d]<=bins[0] ) {
                        histo[1][1]++;
                        continue;
                    }
                    // last unnamed bin
                    if( bins[bins.length-1]<series[d] ) {
                        histo[bins.length+1][1]++;
                        continue;
                    }
                    // any bin in between
                    for(b=0; b<bins.length-1; b++ ) {
                        if( bins[b]<series[d] && series[d]<=bins[b+1] ) {
                            histo[b+2][1]++;
                        }
                    }
                }
                
                for(h=1; h<histo.length; h++ ) {
                    if( maxFreq<histo[h][1] ) {
                        maxFreq   = histo[h][1];
                    }
                }
            }
            
            frequency( arrHisto, arrSeries, bins );
            frequency( depHisto, depSeries, bins );
            data3 = google.visualization.arrayToDataTable(arrHisto );
            data4 = google.visualization.arrayToDataTable(depHisto );
            var numGrids;
            //  if maxFreq is odd we make it even
            if( maxFreq%2 == 1 ) {
                maxFreq++;
            }
            //  the grid lines should be every even number
            numGrids = maxFreq/2 +1;
            
            col1.setAction({
                id: 'arrNames',                  // An id is mandatory for all actions.
                text: 'View Arrivals',       // The text displayed in the tooltip.
                action: function() {           // When clicked, the following runs.
                    selection = col1.getSelection();
                    switch (selection[0].row) {
                        case 0: alert(arrBuckett[1]); break;
                        case 1: alert(arrBuckett[5]); break;
                        case 2: alert(arrBuckett[6]); break;
                        case 3: alert(arrBuckett[7]); break;
                        case 4: alert(arrBuckett[8]); break;
                        case 5: alert(arrBuckett[9]); break;
                        case 6: alert(arrBuckett[10]); break;
                        case 7: alert(arrBuckett[11]); break;
                        case 8: alert(arrBuckett[12]); break;
                        case 9: alert(arrBuckett[13]); break;
                        case 10: alert(arrBuckett[14]); break;
                        case 11: alert(arrBuckett[15]); break;
                        case 12: alert(arrBuckett[16]); break;
                        case 13: alert(arrBuckett[17]); break;
                        case 14: alert(arrBuckett[18]); break;
                        case 15: alert(arrBuckett[19]); break;
                        case 16: alert(arrBuckett[20]); break;
                        case 17: alert(arrBuckett[21]); break;
                        case 18: alert(arrBuckett[22]); break;
                        case 19: alert(arrBuckett[23]); break;
                        case 20: alert(arrBuckett[24]); break;
                            
                    }
                }
            });
            
            col2.setAction({
                id: 'depNames',                  // An id is mandatory for all actions.
                text: 'View Departures',       // The text displayed in the tooltip.
                action: function() {           // When clicked, the following runs.
                    selection = col2.getSelection();
                    switch (selection[0].row) {
                        case 0: alert(depBuckett[1]); break;
                        case 1: alert(depBuckett[5]); break;
                        case 2: alert(depBuckett[6]); break;
                        case 3: alert(depBuckett[7]); break;
                        case 4: alert(depBuckett[8]); break;
                        case 5: alert(depBuckett[9]); break;
                        case 6: alert(depBuckett[10]); break;
                        case 7: alert(depBuckett[11]); break;
                        case 8: alert(depBuckett[12]); break;
                        case 9: alert(depBuckett[13]); break;
                        case 10: alert(depBuckett[14]); break;
                        case 11: alert(depBuckett[15]); break;
                        case 12: alert(depBuckett[16]); break;
                        case 13: alert(depBuckett[17]); break;
                        case 14: alert(depBuckett[18]); break;
                        case 15: alert(depBuckett[19]); break;
                        case 16: alert(depBuckett[20]); break;
                        case 17: alert(depBuckett[21]); break;
                        case 18: alert(depBuckett[22]); break;
                        case 19: alert(depBuckett[23]); break;
                        case 20: alert(depBuckett[24]); break;
                            
                    }
                }
            });
            
            bar.draw(data, options1);
            bar2.draw(data2, options4);  
            col1.draw(data3, options2);
            col2.draw(data4, options3);
		    table2.draw(data7,{showRowNumber: true});        
            table3.draw(data8,{showRowNumber: true});  
        }, {escape:true});
    
    eventsController.getEveInfo(
        function(result, event){

            gauge = new google.visualization.Gauge(document.getElementById('gauge'));    
            // Prepare table model for chart with columns
            data5 = new google.visualization.DataTable();  
            
          
            data5.addColumn('number', 'Attendees');
            
            for(var i = 0; i < result.length; i++){ 
           
                var res = result[i];
                totalAtts =res.Total_Attendees__c;
                 
                data5.addRow([res.Chatter_Attendees__c]);    
                //data.setCell(i,i,res.Registered_Attendees__c);   
            }
              var gaugeOptions = {legend : {position: 'top', textStyle: {color: 'red', fontSize: 10}}, 'width':window.innerWidth/2,  'height': window.innerHeight/3,
                    min: 0, max: totalAtts, redColor:'#FF8A17', redFrom: 0, redTo: totalAtts * 1/3, yellowColor:'#F7FF79', yellowFrom: totalAtts * 1/3, yellowTo: totalAtts * 2/3,
                    greenColor: '#83D540',greenFrom: totalAtts-1, greenTo: totalAtts, minorTicks: 5, animation:{duration: 1000, easing: 'inAndOut'}};
            gauge.draw(data5, gaugeOptions);
            
            
            
        }, {escape:true});
    eventsController.getAttInfo(
        function(result, event){
            table = new google.visualization.Table(document.getElementById('table'));    
            // Prepare table model for chart with columns
            data6 = new google.visualization.DataTable();  
            
            data6.addColumn('boolean', 'Registered');
            data6.addColumn('string','Name');
            data6.addColumn('string','Title');
            data6.addColumn('datetime','Arrival');
            data6.addColumn('datetime','Departure');
            
            for(var i = 0; i < result.length; i++){ 
                var res = result[i];
                data6.addRow([res.Following_Event_Feed__c, res.Name, res.Job_Title__c,
                              new Date(res.Arrival_Date_Time__c), new Date(res.Departure_Date_Time__c)]);    
                
            }
            
            
            table.draw(data6,{showRowNumber: true,width:window.innerWidth});
            
            //setInterval(function() {
            //data.setValue(0, 0, result.Registered_Attendees__c);
            //gauge.draw(data, gaugeOptions);
            //}, 500);
            
        }, {escape:true});
    
    
}
function drawCharts(){
    var gaugeOptions = {legend : {position: 'top', textStyle: {color: 'red', fontSize: 10}}, 'width':window.innerWidth/2,  'height': window.innerHeight/3,
                    min: 0, max: totalAtts, redColor:'#FF8A17', redFrom: 0, redTo: totalAtts * 1/3, yellowColor:'#F7FF79', yellowFrom: totalAtts * 1/3, yellowTo: totalAtts * 2/3,
                    greenColor: '#83D540',greenFrom: totalAtts-1, greenTo: totalAtts, minorTicks: 5, animation:{duration: 1000, easing: 'inAndOut'}};
    var options1 = {
        tooltip: {trigger: 'hover'},
        legend: {position: 'top'},
        title: 'Attendees Arriving By Name',
        colors: ['#E44308'],
        backgroundColor: { fill: "none" },
        histogram: { bucketSize: 1, hideBucketItems: false},
        width:window.innerWidth,
        height: '600px',
        vAxis:{textStyle:{fontSize: 10}},
        hAxis:{textStyle:{color: 'none'}},
        showTextEvery:1,
        slantedText:true,
        interpolateNulls: false};
    
    var options2 = {
        tooltip: {trigger: 'selection'},
        legend: {position: 'top'},
        title: 'Attendees Arriving By Hour',
        colors: ['#E44308'],
        backgroundColor: { fill: "none" },
        histogram: { bucketSize: 1, hideBucketItems: false},
        width:window.innerWidth,
        height: '600px',
        vAxis:{textStyle:{fontSize: 10}},
           hAxis: {
            textStyle:{fontSize: 10},
            direction:-1,
            slantedText:true,
            slantedTextAngle:30
        },
        showTextEvery:1,
        slantedText:true,
        interpolateNulls: false};
    
    
    var options3 = {
        tooltip: {trigger: 'selection'},
        legend: {position: 'top'},
        title: 'Attendees Departing By Hour',
        colors: ['#5F0F99'],
        backgroundColor: { fill: "none" },
        histogram: { bucketSize: 1, hideBucketItems: false},
        width:window.innerWidth,
        height: '600px',
        vAxis:{textStyle:{fontSize: 10}},
           hAxis: {
            textStyle:{fontSize: 10},
            direction:-1,
            slantedText:true,
            slantedTextAngle:30
        },
        showTextEvery:1,
        slantedText:true,
        interpolateNulls: false};   
    
    var options4 = {
        tooltip: {trigger: 'hover'},
        legend: {position: 'top'},
        title: 'Attendees Departing By Name',
        colors: ['#5F0F99'],
        backgroundColor: { fill: "none" },
        histogram: { bucketSize: 1, hideBucketItems: false},
        width:window.innerWidth,
        height: '600px',
        vAxis:{textStyle:{fontSize: 10}},
        hAxis:{textStyle:{color: 'none'}},
        showTextEvery:1,
        slantedText:true,
        interpolateNulls: false};
    // gauge.draw(data5, gaugeOptions);
    table2.draw(data7,{showRowNumber: true});
    table3.draw(data8,{showRowNumber: true});
    console.log('data' + data);
    bar.draw(data, options1);
    bar2.draw(data2, options4);  
    col1.draw(data3, options2);
    col2.draw(data4, options3);
}   
function drawCharts2(){
   var gaugeOptions = {legend : {position: 'top', textStyle: {color: 'red', fontSize: 10}}, 'width':window.innerWidth/2,  'height': window.innerHeight/3,
                    min: 0, max: totalAtts, redColor:'#FF8A17', redFrom: 0, redTo: totalAtts * 1/3, yellowColor:'#F7FF79', yellowFrom: totalAtts * 1/3, yellowTo: totalAtts * 2/3,
                    greenColor: '#83D540',greenFrom: totalAtts-1, greenTo: totalAtts, minorTicks: 5, animation:{duration: 1000, easing: 'inAndOut'}};
    var options1 = {
        tooltip: {trigger: 'hover'},
        legend: {position: 'top'},
        title: 'Attendees Arriving By Name',
        colors: ['#E44308'],
        backgroundColor: { fill: "none" },
        histogram: { bucketSize: 1, hideBucketItems: false},
        width:window.innerWidth,
        //height: '600px',
        vAxis:{textStyle:{fontSize: 10}},
        hAxis:{textStyle:{color: 'none'}},
        showTextEvery:1,
        slantedText:true,
        interpolateNulls: false};
    
    var options2 = {
        tooltip: {trigger: 'selection'},
        legend: {position: 'top'},
        title: 'Attendees Arriving By Hour',
        colors: ['#E44308'],
        backgroundColor: { fill: "none" },
        histogram: { bucketSize: 1, hideBucketItems: false},
        width:window.innerWidth,
        //height: '600px',
        vAxis:{textStyle:{fontSize: 10}},
        hAxis: {
            textStyle:{fontSize: 10},
            direction:-1,
            slantedText:true,
            slantedTextAngle:30 
        },
        interpolateNulls: false};
    
    
    var options3 = {
        tooltip: {trigger: 'selection'},
        legend: {position: 'top'},
        title: 'Attendees Departing By Hour',
        colors: ['#5F0F99'],
        backgroundColor: { fill: "none" },
        histogram: { bucketSize: 1, hideBucketItems: false},
        width:window.innerWidth,
        //height: '600px',
        vAxis:{textStyle:{fontSize: 10}},
        hAxis: {
            textStyle:{fontSize: 10},
            direction:-1,
            slantedText:true,
            slantedTextAngle:30 
        },
        interpolateNulls: false};   
    
    var options4 = {
        tooltip: {trigger: 'hover'},
        legend: {position: 'top'},
        title: 'Attendees Departing By Name',
        colors: ['#5F0F99'],
        backgroundColor: { fill: "none" },
        histogram: { bucketSize: 1, hideBucketItems: false},
        width:window.innerWidth,
        //height: '600px',
        vAxis:{textStyle:{fontSize: 10}},
        hAxis:{textStyle:{color: 'none'}},
        showTextEvery:1,
        slantedText:true,
        interpolateNulls: false};
    gauge.draw(data5, gaugeOptions);
    table.draw(data6,{showRowNumber: true});
    console.log('data' + data);
    bar.draw(data, options1);
    bar2.draw(data2, options4);  
    col1.draw(data3, options2);
    col2.draw(data4, options3);
}   
