function generate_progress_graph(renderingto,barColor, incompleteColor, ongoingColor, completedColor, incompleteData, ongoingData, completedData)
{

var progress_chart = new Highcharts.Chart({
    chart: {
        renderTo: renderingto,
        defaultSeriesType: 'bar',
        margin: [0,0,0,0],
        width: 185,
        height: 20,
        borderWidth: 0,
        shadow: false,
		borderColor: barColor		
    },
    credits: {
        enabled: false
    },
    color: 'red',
    title: {
        text: '',		
    },
    xAxis: {
        categories: ['test'],
        title: {
            enabled: false
        }
    },
    yAxis: {
        min: 0,
        max: 100,
        title: {
            enabled: false
        },
        gridLineWidth: 0,
        lineWidth: 0,
        showFirstLabel: false
    },
    legend: {
        enabled: false
    },
    tooltip: {
        enabled: false
    },	
	exporting: {
         enabled: false
    },
    plotOptions: {
        bar: {
            stacking: 'normal',
            borderWidth:1,
            groupPadding:0,
            pointPadding:0,
            lineWidth:0,
            shadow: true		
        }
    },
    series: [{
		color: {
	          linearGradient: ['20px', 0, '4px', 0],			      	
	          stops: [
	            [0, '#FF0000'],
				[.4,'#DBB6B6'],
				[.6,'#FF0000'],
	            [1, '#8F2020']
	          ]
	        },
	    data: incompleteData
	},
	{
		color: {
	          linearGradient: ['20px', 0, '4px', 0],			      	
	          stops: [
	            [0, '#FF8000'],
				[.4,'#FFD996'],
				[.6,'#FF8000'],
	            [1, '#A65B00']
	          ]
	        },
		data: ongoingData
	},
	{
		color: {
	          linearGradient: ['20px', 0, '4px', 0],			      	
	          stops: [
	            [0, '#39D428'],
				[.4,'#C6F0B2'],
				[.6,'#39D428'],
	            [1, '#2D8700']
	          ]
	        },
		data: completedData
	}]
})
return progress_chart
}

	




