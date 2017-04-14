/* global $ */

function customToggle(){
    $('#suggest').toggle();
    $('#customForm').toggle();
    $('#suggestCustom').toggle();
}

function dropUpdate(){
    var dropValue = $('#dropdown option:selected').attr("value");
    if (dropValue == "custom"){
        customToggle();
    } else {
        if (!$("#suggest").is(":visible")){
            customToggle();
        }
    }
}
 
function buildSuggestion(){
    var suggestion = {}
    suggestion["name"] = $('#dropdown option:selected').attr("name");
    suggestion["lastPurchaseDate"] = $('#dropdown option:selected').attr("date");
    return suggestion
}

function buildCustomSuggestion(){
    var suggestion = {}
    suggestion["name"] = $('#name').val();
    suggestion["location"] = $('#location').val();
    return suggestion
}

$(document).on('turbolinks:load', function() {
    $('#suggestCustom').hide()
    $('#customForm').hide();
    $('#suggest').show();
    
    $('#suggest').off('click').on('click', function() {
		var req = $.ajax({
			dataType: "json",
			type: "POST",
			url: "/suggestion/suggest",
			data: {suggestion: buildSuggestion()}
		});
		
		req.success(function() {
            alert("Successful Suggestion");
        });
        
        req.error(function() {
            alert(JSON.parse(req.responseText)["error"]);
        });
	})
	
	$('#suggestCustom').off('click').on('click', function() {
		var req = $.ajax({
			dataType: "json",
			type: "POST",
			url: "/suggestion/custom_suggest",
			data: {suggestion: buildCustomSuggestion()}
		});
		
		req.success(function() {
            alert("Successful Suggestion");
        });
        
        req.error(function() {
            alert(JSON.parse(req.responseText)["error"]);
        });
	})
})