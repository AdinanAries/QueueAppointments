
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
			
			userProfileFormStatus.innerHTML = "Uncompleted Form";
			userProfileFormStatus.style.backgroundColor = "red";
			ChangeProfileUpdateBtn.disabled = true;
			ChangeProfileUpdateBtn.style.backgroundColor = "darkgrey";
			
		}
		else{
			
			userProfileFormStatus.innerHTML = "OK";
			userProfileFormStatus.style.backgroundColor = "green";
			ChangeProfileUpdateBtn.disabled = false;
			ChangeProfileUpdateBtn.style.backgroundColor = "pink";
			
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
			
			NewAddressStatus.innerHTML = "Uncompleted Form";
			NewAddressStatus.style.backgroundColor = "red";
			NewAddressBtn.disabled = true;
			NewAddressBtn.style.backgroundColor = "darkgrey";
			
		}
		else{
			NewAddressStatus.innerHTML = "OK";
			NewAddressStatus.style.backgroundColor = "green";
			NewAddressBtn.disabled = false;
			NewAddressBtn.style.backgroundColor = "pink";
		}
	
}

if(document.getElementById("NewAddressHNumber")){
    setInterval(checkAddNewAddressForm,1);
}