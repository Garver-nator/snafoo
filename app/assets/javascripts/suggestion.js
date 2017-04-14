/* global $ */

// Switches from custom input forms to normal dropdown and vice versa
function customToggle(){
    $('#suggest').toggle();
    $('#customForm').toggle();
    $('#suggestCustom').toggle();
}

// Checks if the dropdown menu is changed to or from custom, then toggles the form type
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

// Creates a suggestion hash to send via AJAX
function buildSuggestion(){
    var suggestion = {}
    suggestion["name"] = $('#dropdown option:selected').attr("name");
    suggestion["lastPurchaseDate"] = $('#dropdown option:selected').attr("date");
    return suggestion
}

// Creates a custom suggestion hash from the text boxes to send via AJAX
function buildCustomSuggestion(){
    var suggestion = {}
    suggestion["name"] = $('#name').val();
    suggestion["location"] = $('#location').val();
    return suggestion
}

$(document).on('turbolinks:load', function() {
    
    // Initialize to non-custom input
    $('#suggestCustom').hide()
    $('#customForm').hide();
    $('#suggest').show();
    
    // Regular suggestion button AJAX POST
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
	
	// Custom suggestion button AJAX POST
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