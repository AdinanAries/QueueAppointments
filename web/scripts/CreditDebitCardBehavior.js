var submitAppointment = document.getElementById("submitAppointment");
var CardDetailsDiv = document.getElementById("CreditDebitCardDetails");

function toggleShowCardDetailsDiv(){
	
	submitAppointment.style.display = "none";
	$("#CreditDebitCardDetails").slideDown("fast");
	$("html, body").animate({ scrollTop: $(document).height()}, "fast");
	//CardDetailsDiv.style.display = "block";
	
	
}

function toggleShowCardDetailsDivforLogoutPage(){
	var scrollPos =  (document.body.scrollHeight - 850);
        //alert(scrollPos);
	submitAppointment.style.display = "none";
	$("#CreditDebitCardDetails").slideDown("fast");
	$("html, body").animate({ scrollTop: scrollPos}, "fast");
	//CardDetailsDiv.style.display = "block";
	
	
}

function toggleHideCardDetailsDiv(){
	
	submitAppointment.style.display = "block";
	$("#CreditDebitCardDetails").slideUp("fast");
	//CardDetailsDiv.style.display = "none";
}