function generate_profile_graph(renderto, daily_upper, daily_avg, daily_lower, daily_time, title, xaxis_label_interval)
{
var line_chart;
Highcharts.setOptions({
    colors: ['#cccccc','#cccccc']
});

chart = new Highcharts.Chart({
    chart: {
        renderTo: renderto,
        defaultSeriesType: 'area',
		zoomType: 'x',
        marginTop:35,
        marginRight:40,
        marginLeft:70,
        marginBottom:90,
        //backgroundColor:'#fff',
		backgroundColor:{
		linearGradient: [0, 350, 0, 0],
		stops: [
	 	[0, 'rgb(230, 232, 220)'],
	   	[.5,'rgb(250, 250, 250)'],
		[1, 'rgb(230, 232, 220)']
				]
	 		},
        borderWidth:0,
        borderColor:'black',
        plotBackgroundColor:{
		linearGradient: [0, 350, 0, 0],
		stops: [
	 	[0, 'rgb(230, 232, 220)'],
	   	[.5,'rgb(250, 250, 250)'],
		[1, 'rgb(230, 232, 220)']
				]
	 		},
        plotBorderWidth:0,
        plotBorderColor:'red',
    },
    credits:{
        enabled:false
    },
    title: {
        text: title,
        x: 0 //center
    },

    tooltip: {
        borderWidth:1,
        formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                this.x +' : ' + Highcharts.numberFormat(this.y, 3) + 'kW';
        }
    },
    legend: {
	      shadow: true,
	      borderWidth:1,


    },
    plotOptions: {
        series: {
            shadow: false,
            lineWidth:1,
            marker: {
                enabled: false,
                symbol: 'circle',
                radius: 1,
                states: {
                    hover: {
                        enabled: true
                    }
                }
            }
        }
    },
    xAxis: {
        categories: daily_time,
        tickmarkPlacement: 'on',
        startOnTick:true,
        tickInterval: xaxis_label_interval,
        endOnTick:false,
		maxZoom:5,
        lineColor:'#ccc',
        tickColor:'#ccc',
		labels: {
            rotation: -30,
			y:30
		}
         },
    yAxis: {
        title: {
            text: 'kiloWatts',
            rotation: 270,
            margin:15,		
            style: {
                textAlign:'right',
				fontSize:'14px'
            },
        },
        gridLineWidth:0,
        lineWidth:0,
        lineColor:'#ccc',
        min:0,
        tickColor:'#ccc',
        tickPosition:'outside',
        tickLength:5,
        tickInterval:10,
        startOnTick:true,
    },
    series: [{
        name: '+1 Std Dev',
        data: daily_upper,
        fillOpacity:.5,
    }, {
        name: 'Mean',
        data: daily_avg,
        lineWidth:2,
        color:'#4572A7',
        type:'line',
    }, {
        name: '-1 Std Dev',
        data: daily_lower,
        fillColor: {
		linearGradient: [0, 350, 0, 0],
		stops: [
	 	[0, 'rgb(230, 232, 220)'],
	   	[.5,'rgb(250, 250, 250)'],
		[1, 'rgb(230, 232, 220)']
				]
	 		},
        fillOpacity:10

    }]
});
/* handle the turning off and on of series ------------------------- */
var query = $.browser.msie ?
    '.highcharts-legend span' :
    '.highcharts-legend text';

$(query).each(function(index, element) {
    $(element).click(function() {
        var maxData     = chart.series[0];
        var minData     = chart.series[2];
        
        if(index == 0){
            if(maxData.visible){
                minData.show();
            }
            else{
                minData.hide();
            }
        }
        if(index == 2){
            if(minData.visible){
                maxData.show();
            }
            else{
                maxData.hide();
            }
        }
    });
});

return line_chart
}


function  generate_summary_graph(data, start_date, end_date, xTitle, yTitle, document_type)

{
	Highcharts.setOptions({
		global: {
			useUTC: false
				}
	});
	
	var masterChart = new Highcharts.Chart({
	      chart: {
	         renderTo: 'summary_top',
	         zoomType: 'x',
			 borderColor:'#757575',
			 borderWidth: 2,
			 marginTop: 60,
	         marginBottom: 40,
	         marginRight: 40,      
	         marginLeft: 65,
			 backgroundColor:{
			 		linearGradient: [0, 250, 0, 0],
			 		stops: [[0, 'rgb(230, 232, 220)'],[.5,'rgb(250, 250, 250)'],[1, 'rgb(230, 232, 220)']] 					 }		 
	      					 },		
	       title: {
	         text: xTitle,
			 y:20,
				 style :{
					fontSize:'18px',
					fontFamily:'Trebuchet MS',
					fontWeight: 'bold'
				},
	      },
	       subtitle: {
	         text: document.ontouchstart === undefined ?
	            'Click and drag in the plot area to zoom in':
	            'Drag your finger over the plot to zoom in',
				y:40

	      },
	      xAxis: {
	         type: 'datetime',
	         maxZoom: 'default'
	      },
	      yAxis: {
	         title: {
	            text: 'Kilowatts',
				margin: 10,
				style: {
					fontSize:'16px',
					fontFamily:'Trebuchet MS'
				},
	         },
	         startOnTick: false,
	         showFirstLabel: false
	      },
	      tooltip: {
		    // borderColor: '#6E9B2D',
	         formatter: function() {
	            return ''+
	               Highcharts.dateFormat('%H:%M - %A %e %B %Y', this.x) + ' - '+
	               ''+ Highcharts.numberFormat(this.y, 3) +' kW';
	         }
	      },
	      legend: {
	         enabled: false
	      },
	      plotOptions: { // Hello
	         area: {
	            fillColor: {
	               linearGradient: [0, 0, 0, 200],
	               stops: [
	                   [0, '#4572A7'],
	                   [.1, '#4572A7'],
	                   [1, '#ffffff']
	]
	            },
	            lineWidth: 1,
	            marker: {
	               enabled: false,
	               states: {
	                  hover: {
	                     enabled: true,
	                     radius: 5
	                  }
	               }
	            },
				events: {
				     click: function(event) {
						$( "#dialog" ).dialog( "open");
						$( ".uploaded_documents_query_link" ).attr('href', generate_document_uploads_query_url(event.point.x, document_type));
					 }
				},
	            shadow: false,
	            states: {
	               hover: {
	                  lineWidth: 1                  
	               }
	            }
	         }
	      },

		  credits:
		{
			enabled:false
		},

	      series: [{
	         type: 'area',	         	         	         
	         data: data
	      }]
	   });
  
	return masterChart
}
