var signupBtn = document.getElementById("SignUpAndBookBtn");
var formstatus = document.getElementById("SignUpAndBookStatus");


function checkInputFlds(){
	
	var firstName = document.getElementById("SUPfirstName").value;
	var middleName = document.getElementById("SUPmiddleName").value;
	var lastName = document.getElementById("SUPlastName").value;
	var telephone = document.getElementById("SUPtelephone").value;
	var email = document.getElementById("SUPemail").value;
	var userName = document.getElementById("SUPuserName").value;
	var mainPassword = document.getElementById("SUPpassword").value;
	var confirmPassword = document.getElementById("SUPconfirm").value;
	
	 if( (firstName !== "enter your first name" && firstName !== "")&&
		(middleName !== "enter your middle name" && middleName !=="") &&
		(lastName !== "enter your last name" && lastName !=="") && 
		(telephone !== "enter your telephone/mobile number here" && telephone !=="") &&
		(email !== "enter your email address here" && email !=="") && 
		(userName !== "enter user name here" && userName !=="") &&
		(mainPassword !== "Password" && mainPassword !=="") &&
		(confirmPassword !== "Password" && confirmPassword !=="") ){
			
			if(mainPassword !== "Password" && mainPassword !== ""){
				
				if(mainPassword !== confirmPassword){
			
					signupBtn.disabled = true;
					signupBtn.style.backgroundColor = "darkgrey";
					formstatus.innerHTML = "Passwords Don't Match";
					formstatus.style.backgroundColor = "red";
					
				}
				else if(mainPassword.length < 8){
					
					signupBtn.disabled = true;
					signupBtn.style.backgroundColor = "darkgrey";
					formstatus.innerHTML = "Password Very Short";
					formstatus.style.backgroundColor = "red";
				
				}
				else{
					if(userName === mainPassword){
                        signupBtn.disabled = true;
						signupBtn.style.backgroundColor = "darkgrey";
						formstatus.innerHTML = "Same Username as Password";
						formstatus.style.backgroundColor = "red";
                    }else{
						signupBtn.disabled = false;
						signupBtn.style.backgroundColor = "pink";
						signupBtn.style.cssText = '#SignUpAndBookBtn:hover{ background-color: red; }';
						formstatus.innerHTML = "OK";
						formstatus.style.backgroundColor = "green";
					}
				}
				
			}
		}
	
	else{
		
		signupBtn.disabled = true;
		signupBtn.style.backgroundColor = "darkgrey";
		formstatus.innerHTML = "Uncompleted Form";
		formstatus.style.backgroundColor = "green";
		
	}
	
	
	
	
	
	
}


checkInputFlds();

setInterval(checkInputFlds, 1);
