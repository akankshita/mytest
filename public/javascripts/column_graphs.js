function generate_column_graph(renderto, thetitle, data, categories)
{

//(container1L, thetitle1L)

	var everyChart = new Highcharts.Chart({
    chart: {
	borderWidth: 1,
	backgroundColor:{
	linearGradient: [0, 350, 0, 0],
	stops: [
 	[0, 'rgb(230, 232, 220)'],
   	[.5,'rgb(250, 250, 250)'],
	[1, 'rgb(230, 232, 220)']
			]
 		},
   		shadow: true,
        marginTop: 40,
    	marginRight: 30,
    	marginBottom: 60,
    	marginLeft: 70,
    	plotBackgroundColor: null,
    	borderColor: 'green',
    	borderRadius: 5,
        renderTo: renderto,
        defaultSeriesType: 'column'
    		},	
	
   	xAxis: {
        categories: categories,
        labels: {
            rotation: -30,
			y:30	
        }
    },
	
	yAxis: {
		title: { 
		text: 'kW hours',
		margin:5,
		style: {		
			fontSize:'16px',
			fontFamily:'Trebuchet MS',
			fontWeight: 'bold'
	   	       },
		}
	},

  
   	 plotOptions: {
         series: {
            cursor: 'pointer',
			borderColor: 'grey',
			borderWidth: 1	
      	         }
      },
	credits: {
	enabled: false
	},
	
	legend: {
	enabled: false
	},

	title: {
		style:{
		     fontSize:'16px',
			 fontFamily:'Trebuchet MS',
			 fontWeight: 'bold'
		      },
        text: thetitle,  
		y:20
	},
	 tooltip: {
         formatter: function() {
            return ''+
               Highcharts.numberFormat(this.y, 3) +' kW hours';
         }
      },
    
	series: [{
		color: {
	       linearGradient: ['40px', '60px', 0, '200px'],			      	
	       stops: [
	            [0, 'rgb(151, 202, 249)'],
	            [1, 'rgb(61, 102, 148)']
	          ]
	        },
        data: data
	}]   
})

return everyChart
}



