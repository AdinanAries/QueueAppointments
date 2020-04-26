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
		ConfirmAppointmentStatusTxt.innerHTML = "Choose payment";
		ConfirmAppointmentStatusTxt.style.backgroundColor = "red";
	}
	
	if(formsTimeValue === " "){
		ConfirmAppointmentStatusTxt.innerHTML = "Choose appointment time";
		ConfirmAppointmentStatusTxt.style.backgroundColor = "red";
	}
	
	if(formsDateValue === ""){
		ConfirmAppointmentStatusTxt.innerHTML = "Choose appointment date";
		ConfirmAppointmentStatusTxt.style.backgroundColor = "red";
	}
	
	if((Cash === true || CreditDebit === true) && (formsTimeValue !== " " && formsDateValue !== "")){
		
		submitAppointment.style.backgroundColor = "darkslateblue";
		submitAppointment.disabled = false;
		ConfirmAppointmentStatusTxt.innerHTML = "";
		ConfirmAppointmentStatusTxt.style.backgroundColor = "green";
	}
	else{
		
		submitAppointment.style.backgroundColor = "darkgrey";
		submitAppointment.disabled = true;
	}
	
}

setInterval(toggleEnableFinalApntmntBtn, 1);
