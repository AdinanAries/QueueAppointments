
function checkChangeProfileInfoForm(){
	
	var ChangeProfileUpdateBtn = document.getElementById("ChangeProfileUpdateBtn");
	var ChangeProfileFirstName = document.getElementById("ChangeProfileFirstName");
	var ChangeProfileMiddleName = document.getElementById("ChangeProfileMiddleName");
	var ChangeProfileLastName = document.getElementById("ChangeProfileLastName");
	var ChangeProfilePhoneNumber = document.getElementById("ChangeProfilePhoneNumber");
	var ChangeProfileHouseNumber = document.getElementById("ChangeProfileHouseNumber");
	var ChangeProfileStreet = document.getElementById("ChangeProfileStreet");
	var ChangeProfileTown = document.getElementById("ChangeProfileTown");
	var ChangeProfileCity = document.getElementById("ChangeProfileCity");
	var ChangeProfileCountry = document.getElementById("ChangeProfileCountry");
	var ChangeProfileZipCode = document.getElementById("ChangeProfileZipCode");
	var userProfileFormStatus = document.getElementById("userProfileFormStatus");
	
	
	ChangeProfileUpdateBtn.disabled = true;
	ChangeProfileUpdateBtn.style.backgroundColor = "darkgrey";
	
	if(ChangeProfileFirstName.value === "" || ChangeProfileMiddleName.value === "" 
		|| ChangeProfileLastName.value === "" || ChangeProfilePhoneNumber.value === ""
		|| ChangeProfileHouseNumber.value === "" || ChangeProfileStreet.value === "" 
		|| ChangeProfileTown.value === "" || ChangeProfileCity.value === ""
		|| ChangeProfileCountry.value === "" || ChangeProfileZipCode.value === ""){
			
			userProfileFormStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i> Uncompleted Form";
			ChangeProfileUpdateBtn.disabled = true;
			ChangeProfileUpdateBtn.style.backgroundColor = "darkgrey";
			
		}
		else{
			
			userProfileFormStatus.innerHTML = "<i style='margin-right: 5px; color: green;' aria-hidden='true' class='fa fa-check'></i> OK";
			ChangeProfileUpdateBtn.disabled = false;
			ChangeProfileUpdateBtn.style.backgroundColor = "darkslateblue";
			
		}
}

if(document.getElementById("ChangeProfileUpdateBtn")){
    setInterval(checkChangeProfileInfoForm,1);
}


function checkAddNewAddressForm(){
	
	var NewAddressBtn = document.getElementById("NewAddressBtn");
	var NewAddressStatus = document.getElementById("NewAddressStatus");
	var NewAddressZipcode = document.getElementById("NewAddressZipcode");
	var NewAddressCountry = document.getElementById("NewAddressCountry");
	var NewAddressCity = document.getElementById("NewAddressCity");
	var NewAddressTown = document.getElementById("NewAddressTown");
	var NewAddressStreet = document.getElementById("NewAddressStreet");
	var NewAddressHNumber = document.getElementById("NewAddressHNumber");
	
	if(NewAddressHNumber.value === "" || NewAddressStreet.value === "" 
		|| NewAddressTown.value === "" || NewAddressCity.value === ""
		|| NewAddressCountry.value === "" || NewAddressZipcode.value === ""){
			
			NewAddressStatus.innerHTML = "<i class='fa fa-exclamation-triangle' style='color: yellow;'></i> no address field can be empty";
			NewAddressBtn.disabled = true;
			NewAddressBtn.style.backgroundColor = "darkgrey";
			
		}
		else{
			NewAddressStatus.innerHTML = "<i class='fa fa-check' style='color: green;'></i> address form is \"OK\" for submission";
			NewAddressBtn.disabled = false;
			NewAddressBtn.style.backgroundColor = "darkslateblue";
		}
	
}

if(document.getElementById("NewAddressHNumber")){
    setInterval(checkAddNewAddressForm,1);
}