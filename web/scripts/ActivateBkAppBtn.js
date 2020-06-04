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
			BookAppointmentBtn.style.backgroundColor = "darkslateblue";
			SVCSelectStatus.innerHTML = "";
			break;
			
		}else{
			BookAppointmentBtn.disabled = true;
			BookAppointmentBtn.style.backgroundColor = "darkgrey";
			SVCSelectStatus.innerHTML = "You must select a service to continue";
		}
	
	}

	
    }

    function toggleAddon(number){
                                                    
        let AddonPlusElem = "AddonPlus" + number;
        let AddonMinusElem = "AddonMinus" + number;
        let AddonPlus = document.getElementById(AddonPlusElem);
        let AddonMinus = document.getElementById(AddonMinusElem);
                                        
        if(AddonMinus.style.display === "none"){
                                                        
            AddonMinus.style.display = "block";
            AddonPlus.style.display = "none";
                                                        
        }else if(AddonMinus.style.display === "block"){
                                                        
            AddonPlus.style.display = "block";
            AddonMinus.style.display = "none";
                                                        
        }
                                                    
    }

function enableBkAppBtn(number){
	toggleAddon(number);
	thisCheckBoxName = "CheckboxOfServiceNo" + number;
	
	thisCheckBox = document.getElementById(thisCheckBoxName);
        
	if(thisCheckBox.checked === true)
		BookAppointmentBtn.disabled = false;
		BookAppointmentBtn.style.backgroundColor = "darkslateblue";
		SVCSelectStatus.innerHTML = "";
}

tryEnableBkAppBtn();

setInterval(tryEnableBkAppBtn, 1);