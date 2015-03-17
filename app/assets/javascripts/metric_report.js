displayMetricReport = function(bulkData, dates, reportDiv, maxWidth, reportTitle) {
  console.log(bulkData);
  console.log("dates "+dates);

  var margin = {top: 40, right: 0, bottom: 110, left: 50},
      width  = maxWidth - margin.left - margin.right,
      height = 500 - margin.top - margin.bottom;

  // var x = d3.scale.ordinal()
  //     .rangeRoundBands([0, width], .7);

  var x = d3.time.scale().range([0, width]);

  var y = d3.scale.linear()
      .range([height, 0]);

  //X Axis
  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
      .tickFormat(d3.time.format("%d/%m %H:%M"));

  //Y Axis
  var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
      .tickFormat(d3.format("d"));

  var line = d3.svg.line()
      .x(function(d) { return x(d.date); })
      .y(function(d) { return y(d.result); });

  var svg = d3.select(reportDiv).append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var result = bulkData;
  var data   = result['data'];

  data.forEach(function(d) {
    d.date   = Date.parse(d.taken_at);
    d.result = +d.value;
  });

  // x.domain(dates);
  x.domain([d3.min(data, function (d) { return d.date; })-1, d3.max(data, function (d) { return d.date; })]);
  y.domain([d3.min(data, function (d) { return d.result; })-1, d3.max(data, function (d) { return d.result; })]);

  //Draw Axis
  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
    // .selectAll("text")
    //   .style("text-anchor", "end")
    //   .attr("dx", "-.8em")
    //   .attr("dy", ".15em")
    //   .attr("transform", function(d) {
    //       return "rotate(-65)"
    //       })
    .append("text")
      .attr("x", width / 2 )
      .attr("y", 35 )
      .style("text-anchor", "middle")
      .text("Date");

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("x", - height / 2)
      .attr("y", - 40)
      .style("text-anchor", "middle")
      .text("Valeur de PH");

  //Draw Graphic
  svg.append("path")
      .datum(data)
      .attr("class", "line")
      .attr("d", line);

  //Title
  svg.append("foreignObject")
    .attr("id", "reportTitle")
    .attr("x", 0)
    .attr("y", height + (margin.bottom - 60))
    .attr("width", width)
    .attr("height", height / 2)
    .append("xhtml:body")
    .attr("text-anchor", "middle")
    .html(reportTitle);
};