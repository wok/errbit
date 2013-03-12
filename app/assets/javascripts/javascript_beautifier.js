//= require jquery
//= require source-map.min.js

$(document).ready(function() {
    // Reformat source to add line metadata
    var sourceElement = $('#source')
    var lines = sourceElement.html().split(/\n/);
    var html = "";
    var n = lines.length;
    for(var i = 0 ; i < n ; i++)
    {
        html += "<div id='line_" + (i+1) + "'>";
        html += lines[i];
        html += "</div>";
    }
    sourceElement.html(html);

    // Parse Source Map
    var sourceMap = window.sourceMap;
    var sourceMapConsumer = new sourceMap.SourceMapConsumer(window.rawSourceMap)

    // Reverse Line/Column mapping
    $("#go").click(function() {
        var line = parseInt($("#line").val());
        var column = parseInt($("#column").val());

        if(line <= 0 || column <= 0)
        {
            alert("Line and Column should be greater than zero.");
            return;
        }

        // Map to proper line/column
        var generatedPosition = sourceMapConsumer.generatedPositionFor({source: window.rawSourceMap.sources[0], line: line, column: column});
        var generatedLine     = generatedPosition.line;
        var generatedColumn   = generatedPosition.column;

        // Highlight line
        $(".line-highlight").removeClass("line-highlight");
        lineElement = $("#line_" + generatedLine);
        lineElement.addClass("line-highlight");

        $('html, body').animate({
            scrollTop: lineElement.offset().top - 200
        }, 500);
    });

    // Handle enter keypress on inputs
    $('#jump input').keypress(function(e) {
        if(e.which == 13) $('#go').click();
    });

   // Line/Column specified in URL
    if(window.location.hash) {
        value = window.location.hash.replace("#", "").split(":");
        $("#line").val(value[0]);
        $("#column").val(value[1]);
        $("#go").click();
    }
});
