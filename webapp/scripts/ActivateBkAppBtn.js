var BookAppointmentBtn = document.getElementById("BookAppointmentBtn");
var totallist = document.getElementById("totallist").value;
var SVCSelectStatus = document.getElementById("SVCSelectStatus");

BookAppointmentBtn.disabled = true;
BookAppointmentBtn.style.backgroundColor = "darkgrey";

function tryEnableBkAppBtn(){
	
	for(var i = 1; i <= totallist; i++){
		
		var checkBoxName = "CheckboxOfServiceNo" + i;
		var checkBoxValue = document.getElementById(checkBoxName).checked;
		
		if(checkBoxValue === true){
			
			BookAppointmentBtn.disabled = false;
			BookAppointmentBtn.style.backgroundColor = "red";
			SVCSelectStatus.innerHTML = "";
			break;
			
		}else{
			BookAppointmentBtn.disabled = true;
			BookAppointmentBtn.style.backgroundColor = "darkgrey";
			SVCSelectStatus.innerHTML = "You must select a service to continue";
		}
	
	}

	
}

function enableBkAppBtn(number){
	
	thisCheckBoxName = "CheckboxOfServiceNo" + number;
	
	thisCheckBox = document.getElementById(thisCheckBoxName);
	
	if(thisCheckBox.checked === true)
		BookAppointmentBtn.disabled = false;
		BookAppointmentBtn.style.backgroundColor = "red";
		SVCSelectStatus.innerHTML = "";
}

tryEnableBkAppBtn();

setInterval(tryEnableBkAppBtn, 1);