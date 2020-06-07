function toggleEnableFinalApntmntBtn(){
	
	var submitAppointment = document.getElementById("submitAppointment");
	
	submitAppointment.style.backgroundColor = "darkgrey";
	submitAppointment.disabled = true;
	
	var Cash = document.getElementById("Cash").checked;
	var CreditDebit = document.getElementById("Credit/Debit").checked;
	var formsTimeValue = document.getElementById("formsTimeValue").value;
	var formsDateValue = document.getElementById("formsDateValue").value;
	var ConfirmAppointmentStatusTxt = document.getElementById("ConfirmAppointmentStatusTxt");
	
	if(Cash === false || CreditDebit === false){
		ConfirmAppointmentStatusTxt.innerHTML = "<i style='color: red' class='fa fa-exclamation-triangle'></i> Choose payment";
	}
	
	if(formsTimeValue === " "){
            ConfirmAppointmentStatusTxt.innerHTML = "<i style='color: red' class='fa fa-exclamation-triangle'></i> Choose appointment time";
	}
	
	if(formsDateValue === ""){
            ConfirmAppointmentStatusTxt.innerHTML = "<i style='color: red' class='fa fa-exclamation-triangle'></i> Choose appointment date";
	}
	
	if((Cash === true || CreditDebit === true) && (formsTimeValue !== " " && formsDateValue !== "")){
		
		submitAppointment.style.backgroundColor = "darkslateblue";
		submitAppointment.disabled = false;
		ConfirmAppointmentStatusTxt.innerHTML = "";
	}
	else{
		
		submitAppointment.style.backgroundColor = "darkgrey";
		submitAppointment.disabled = true;
	}
	
}

setInterval(toggleEnableFinalApntmntBtn, 1);
