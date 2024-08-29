$( document ).ready(function() {
"use strict";

/*
This file contains an example from SSZVIS website modified to work with Shiny.
https://statistikstadtzuerich.github.io/sszvis/#/bar-chart-vertical

Global variables exposed by Shiny (dependencies): d3, sszvis
*/

   /* Configuration
  ----------------------------------------------- */
  var config = {
    ticks: 5,
    fallback: false, //optional, creates long ticks when true
    targetElement: "" // Set in custom message handler
  }

  var MAX_WIDTH = 800;
  var MAX_CONTROL_WIDTH = 350;

    var queryProps = sszvis
    .responsiveProps()
    .breakpoints([
          { name: 'small', width: 280 },
          { name: 'narrow', width: 516 },
        ])
        .prop('bottomPadding', {
          small: 150,
          narrow: 130,
          _: 130
        })
        .prop('controlWidth', {
      	_: function(width) {
        return Math.min(width, MAX_CONTROL_WIDTH);
        //return Math.max(420, Math.min(MAX_CONTROL_WIDTH, width / 2));
      }
    });


  /* Application state
  ----------------------------------------------- */
  var state = {
  	rawData: [],
    data: [],
    lineData: [],
    dates: [],
    selection: [],
    categories: [],
    selectedFilter: null,
    filters: []
  };
  
    // Data preparation
  // -----------------------------------------------
  function parseRow(d) {
    return {
      // In order to correctly parse values as dates, we need to pass a Swiss date format
      // (see https://github.com/StatistikStadtZuerich/sszvis/blob/master/src/parse.js),
      // e.g. 02.03.2004. As the dates come in the form or a numeric value (year), we need to
      // add "01.01." to them, so they'll be parsed correctly. Could also be done on Shiny side.
      xValue: sszvis.parseDate("01.01." + d["Jahr"]),
      yValue: d["Anzahl"],
      category: d["Kategorie"],
      filterCat: d["Button"],
    };
  }


  /* Shortcuts
  ----------------------------------------------- */
  var xAcc = sszvis.prop('xValue');
  var yAcc = sszvis.prop('yValue');
  var cAcc = sszvis.prop('category');
  var fAcc = sszvis.prop('filterCat');
  
  
  /* State transitions
  ----------------------------------------------- */
  var actions = {
    prepareState: function(data) {
      state.rawData = data;
      state.selectedCategory = 'Anzahl Beschäftigte';
      state.filters = sszvis.set(state.rawData,fAcc);
      actions.selectFilter(state.filters[0]);
      actions.resetDate();
    },

    changeDate: function(inputDate) {
      // Find the date of the datum closest to the input date
      var closestDate = xAcc(closestDatum(state.data, xAcc, inputDate));
      // Find all data that have the same date as the closest datum
      var closestData = state.lineData.map(function(linePoints) {
        // For each line pick the first datum that matches
        return sszvis.find(function(d) {
          return xAcc(d).toString() === closestDate.toString();
        }, linePoints);
      });
      // Make sure that the selection has a value to display
      state.selection = closestData.filter(
        sszvis.compose(sszvis.not(isNaN), yAcc)
      );

      render(state);
    },

    resetDate: function() {
      // Find the most recent date in the data and set it as the selected date
      var mostRecentDate = d3.max(state.data, xAcc);
      actions.changeDate(mostRecentDate);
    },


    selectFilter: function(filter){
      state.selectedFilter = filter;
      state.data = state.rawData.filter(function(d){
        return fAcc(d) == state.selectedFilter;
      });


      state.lineData = sszvis.cascade()
        .arrayBy(cAcc, d3.ascending)
        .apply(state.data);
      state.maxValue = d3.max(state.data, yAcc);
      state.dates = d3.extent(state.data, xAcc);
      state.categories = sszvis.set(state.data, cAcc);

      actions.resetDate();
    },


    resize: function() { render(state); }
  };


  /* Render
  ----------------------------------------------- */
  function render(state) {
    var props = queryProps(sszvis.measureDimensions(config.targetElement));
    var bounds = sszvis.bounds({ top: 80, bottom: props.bottomPadding  }, config.targetElement);
	  var chartWidth = Math.min(bounds.innerWidth, MAX_WIDTH);
	
    // Scales
    var xScale = d3.scaleTime()
      .domain(state.dates)
      .range([0, bounds.innerWidth]);

    var yScale = d3.scaleLinear()
      .domain([0, state.maxValue*1.2])
      .range([bounds.innerHeight, 0]);

    // CONFIG
    //choose color scale depending on number of categories
    var colorScale = ['#000000','#DB247D', '#3431DE'];
  
    var cScale = d3.scaleOrdinal()
          .domain(state.categories)
          .range(colorScale);


    // Layers
    var chartLayer = sszvis.createSvgLayer(config.targetElement, bounds, {
        // CONFIG
        title: (''),
        description: ('')
      })
      .datum(state.lineData);

   var controlLayer = sszvis.createHtmlLayer(config.targetElement);
   
   // Entferne alte Linien (sofern vorhanden)
   chartLayer.selectGroup('line').selectAll('*').remove();

    // Components
    var line = sszvis.line()
      .x(sszvis.compose(xScale, xAcc))
      .y(sszvis.compose(yScale, yAcc))
      // Access the first data point of the line to decide on the stroke color
      .stroke(sszvis.compose(cScale, cAcc, sszvis.first));

    // Add the highlighted data as additional ticks to the xScale
    // CONFIG use config.ticks if defined in config object
    var xTickValues = config.ticks ? xScale.ticks(config.ticks) : xScale.ticks();
    xTickValues = xTickValues.concat(state.selection.map(xAcc));

    var xAxis = sszvis.axisX.time()
      .scale(xScale)
      .orient('bottom')
      .tickValues(xTickValues)
      .alignOuterLabels(true)
      .highlightTick(isSelected)
      // CONFIG
      .title('Jahr');

    var yAxis = sszvis.axisY()
      .scale(yScale)
      .orient('right')
      .contour(true)
      // CONFIG
      //.tickLength(config.fallback ? bounds.innerWidth : null)
      // CONFIG
      .title(formatYAxis(state.selectedFilter))
      .dyTitle(-20)
      .tickFormat(function(d) {
        return d === 0 ? null : sszvis.formatNumber(d);
      });

    // CONFIG use a second x-Axis with only tick labels.
    // Necessary in order to prevent horizontal lines to be drawn above data lines
    // if config.fallback == true
    var yAxis2 = sszvis.axisY()
      .scale(yScale)
      .orient('right')
      .contour(true);

    var rulerLabel = sszvis.modularTextSVG()
      .bold(sszvis.compose(sszvis.formatNumber, yAcc))
      // CONFIG use category name as ruler label
      .plain(formatTooltip(state.selectedFilter) , cAcc);

    var highlightLayer = sszvis.annotationRuler()
      .top(0)
      .bottom(bounds.innerHeight)
      .x(sszvis.compose(xScale, xAcc))
      .y(sszvis.compose(yScale, yAcc))
      .label(rulerLabel)
      .flip(function(d) {
        return xScale(xAcc(d)) >= bounds.innerWidth / 2;
      })
      .color(sszvis.compose(cScale, cAcc));

     var cLegend = sszvis.legendColorOrdinal()
        .scale(cScale)
        .horizontalFloat(true)
        .floatWidth(bounds.innerWidth);

     var buttonGroup = sszvis.buttonGroup()
      .values(state.filters)
      .width(props.controlWidth)
      .current(state.selectedFilter)
      .change(actions.selectFilter);

    // Rendering

    chartLayer.selectGroup('xAxis')
      .attr('transform', sszvis.translateString(0, bounds.innerHeight))
      .call(xAxis);

    // CONFIG draw yAxis with long horizontal ticks (if config.fallback == true)
    // before the data lines
    chartLayer.selectGroup('yAxis')
      .call(yAxis);

    // CONFIG draw data lines above long horizonzal ticks (if config.fallback == true)
    chartLayer.selectGroup('line')
      .call(line);

    // CONFIG draw tick labels with contours once again so that they are above the data lines
    //(if config.fallback == true) Maybe there is an easier solution to this issue
    chartLayer.selectGroup('yAxis2')
      .call(yAxis2);

    //buttons
    controlLayer.selectDiv('controls')
      .style('left', Math.max(0, (bounds.innerWidth - buttonGroup.width()) / 2) + 'px')
      .style('top', 10 + 'px')
      .call(buttonGroup);

    chartLayer.selectGroup('cScale')
      // the color legend should always be positioned 60px below the bottom axis
      .attr('transform', sszvis.translateString(1, bounds.innerHeight + 60))
      .call(cLegend);

    chartLayer.selectGroup('highlight')
      .datum(state.selection)
      .call(highlightLayer)
      .call(separateTwoLabelsVerticalOverlap);

    // Interaction
    var interactionLayer = sszvis.move()
      .xScale(xScale)
      .yScale(yScale)
      .on('move', actions.changeDate)
      .on('end', actions.resetDate);

    chartLayer.selectGroup('interaction')
      .call(interactionLayer);

    sszvis.viewport.on('resize', actions.resize);
  }


    /* Helper functions
  ----------------------------------------------- */

  function closestDatum(data, accessor, datum) {
    var i = d3.bisector(accessor).left(data, datum, 1);
    var d0 = data[i - 1];
    var d1 = data[i] || d0;
    return datum - accessor(d0) > accessor(d1) - datum ? d1 : d0;
  }

  function isSelected(d) {
    return sszvis.contains(state.selection.map(xAcc).map(String), String(d));
  }

  function separateTwoLabelsVerticalOverlap(g) {
    var THRESHOLD = 2;
    var labelBounds = [];

    // Reset vertical shift
    g.selectAll('text').each(function(d) {
      d3.select(this).attr('y', '');
    });

    // Calculate bounds
    g.selectAll('.sszvis-ruler__label').each(function(d, i) {
      var bounds = this.getBoundingClientRect();
      labelBounds.push({
        category: cAcc(d),
        // startTop: bounds.top,
        // startBottom: bounds.bottom,
        top: bounds.top,
        bottom: bounds.bottom,
        dy: 0
      });
    });

    // console.log(labelBounds.length)
    // Sort by vertical position (only supports labels of same height)
    labelBounds = labelBounds.sort(function(a, b) {
      return d3.ascending(a.top, b.top);
    });

    // Calculate overlap and correct position
    for (var i = 0; i < 10; i++) {

      for (var j = 0; j < labelBounds.length; j++) {
        for (var k = j + 1; k < labelBounds.length; k++) {
          if (j === k) continue;
          var firstLabel = labelBounds[j];
          var secondLabel = labelBounds[k];
          var overlap = firstLabel.bottom - secondLabel.top;
          if (overlap >= THRESHOLD) {
            firstLabel.bottom -= overlap / 2;
            firstLabel.top -= overlap / 2;
            firstLabel.dy -= overlap / 2;
            secondLabel.bottom += overlap / 2;
            secondLabel.top += overlap / 2;
            secondLabel.dy += overlap / 2;
          }

        }
      }
    }

    // Shift vertically to remove overlap
    g.selectAll('text').each(function(d) {
      var label = sszvis.find(function(l) {
        return l.category === cAcc(d)
      }, labelBounds);
      if (label) {
        d3.select(this)
          .attr('y', label.dy);

      }
    });
  }

  window.onresize = function(){
    render(state)
  }

  function yAxisExtent(yAxEx) {
    if (yAxEx === 'Arbeitsstätten') return [0,50000];
    if (yAxEx === 'Anzahl Beschäftigte') return [0,500000];
    if (yAxEx === 'Anzahl Vollzeitäquivalente') return [0,400000];
  }

  function formatYAxis(yAxEx) {
    if (yAxEx === 'Arbeitsstätten') return 'Anzahl Arbeitsstätten';
    if (yAxEx === 'Anzahl Beschäftigte') return 'Anzahl Beschäftigte';
    if (yAxEx === 'Anzahl Vollzeitäquivalente') return 'Anzahl Vollzeitäquivalente';
  }

  function formatTooltip(yAxEx) {
      if (yAxEx === 'Arbeitsstätten') return ' Arbeitsstätten';
      if (yAxEx === 'Anzahl Beschäftigte') return ' Beschäftigte';
      if (yAxEx === 'Anzahl Vollzeitäquivalente') return ' Vollzeitäquivalente';
  }


  /** Shiny -> JS

We are listening for an "update_data" event sent from the server-side of the
Shiny app to run the following logic with a new data attached to the event (data).
It already comes in a form of parsed JSON object (array of observations), so there
is no need to parse the CSV / JSON anymore, as was the case in original example -
just a logic to extract needed properties is present (parseRow).
*/
  Shiny.addCustomMessageHandler("update_data", function (message) {
    try {
      var container_id = message.container_id[0];
      config.targetElement = container_id;
      var data = message.data;
      var parsedRows = data.map((d) => parseRow(d));
      actions.prepareState(parsedRows);
    } catch (e) {
      throw e;
    }
  });
});

