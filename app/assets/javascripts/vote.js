/* global $ */

function updateVotes(snackName){
    var remainingVotes = parseInt($('#remainingVotes').text().substr(-1));
    $('#remainingVotes').text("Votes remaining: " + String(remainingVotes-1));
    $('#remainingVotes').attr("votes", String(remainingVotes-1));
    
    var votes = $('.voteCount[name="'+snackName+'"]').text();
    var newVotes = String(parseInt(votes) + 1);
    $('.voteCount[name="'+snackName+'"]').text(newVotes);
}

$(document).on('turbolinks:load', function() {
    $('button[class="vote"]').off('click').on('click', function() {
      var snackName = $(this).attr("name");
      var req = $.ajax({
    		dataType: "json",
    		type: "POST",
    		url: "/vote/vote",
    		data: {suggestion_name: snackName}
     });
	  
    req.success(function() {
      updateVotes(snackName);
    });
      
    req.error(function() {
      console.log(req)
      alert(JSON.parse(req.responseText)["error"]);
    });
      
    });
})