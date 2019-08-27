var submitAppointment = document.getElementById("submitAppointment");
var CardDetailsDiv = document.getElementById("CreditDebitCardDetails");

function toggleShowCardDetailsDiv(){
	
	submitAppointment.style.display = "none";
	$("#CreditDebitCardDetails").slideDown("slow");
	$("html, body").animate({ scrollTop: $(document).height() }, "slow");
	//CardDetailsDiv.style.display = "block";
	
	
}

function toggleHideCardDetailsDiv(){
	
	submitAppointment.style.display = "block";
	$("#CreditDebitCardDetails").slideUp("slow");
	//CardDetailsDiv.style.display = "none";
}