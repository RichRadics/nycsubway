function map_add_boxes(timeLabels_length) {
	// Main box for current date/time
	d3.select('#d3MapSVG')
	.append('svg')
	.attr('x',350)
	.attr('y',25)
	.attr('id','mainTimeLabel')
	.attr('class','infoBox')

	d3.select('#mainTimeLabel')
	.append('rect')
	.attr('height', 50)
	.attr('width', 250)
	.attr('rx','10')
	.attr('ry','10')

	d3.select('#mainTimeLabel')
	.append('text')
	.attr('id','#mainTimeLabelText')
	.attr('class','mainTimeLabelText')
	.attr('x', 50)
	.attr('y', 35)
	.attr('fill','white')
	.text('hello this is text')

	// and build the time nav list
	d3.select('#d3MapSVG')
	.append('svg')
	.attr('id','timeLabelsBox')
	.attr('class','infoBox')
	.attr('x',10)
	.attr('y',120)
	.attr('width',150)
	.attr('height', timeLabels_length*15+50)

	d3.select('#timeLabelsBox')
	.append('rect')
	.attr('width',150)
	.attr('height', timeLabels_length*15+50)
	.attr('rx','10')
	.attr('ry','10')

	d3.select('#timeLabelsBox')
	.append('text')
	.attr('x', 50)
	.attr('y', 25)
	.text('Date/time')
	.attr('class', 'timeLabelsBoxTitle')
}