
document.getElementById("AddUserSignUpBtn").disabled = true;
document.getElementById("AddUserSignUpBtn").style.backgroundColor = "darkgrey";
document.getElementById("provSignUpBtn").disabled = true;
document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";

function EnableCustomerSignUpBtn(){

	var fName = document.getElementById("firstName").value;
	var mName = document.getElementById("middleName").value;
	var lName = document.getElementById("lastName").value;
	var email = document.getElementById("email").value;
	var phoneNumber = document.getElementById("phoneNumber").value;
	var userName = document.getElementById("userName").value;
	var firstPassword = document.getElementById("firstPassword").value;
	var secondPassword = document.getElementById("secondPassword").value;
	
	if(fName !== "" && mName !== "" && lName !== "" &&
	   phoneNumber !== "" && userName !== "" && firstPassword !== "" && secondPassword !== ""){
		   
		if(firstPassword === secondPassword){
			
			if(firstPassword.length < 8){
                            document.getElementById("AddUserSignUpBtn").disabled = true;
                            document.getElementById("AddUserSignUpBtn").style.backgroundColor = "darkgrey";
                            document.getElementById("passwordStatus").innerHTML = "Password too short";
                            document.getElementById("formStatus").innerHTML = "";
			}
			else{
				
                            if(userName === firstPassword){
                                document.getElementById("AddUserSignUpBtn").disabled = true;
				document.getElementById("AddUserSignUpBtn").style.backgroundColor = "darkgrey";
				document.getElementById("passwordStatus").innerHTML = "Same Username as Password";
				document.getElementById("formStatus").innerHTML = "";
                            }else{
                                if(email === ""){
                                    document.getElementById("provSignUpBtn").disabled = true;
                                    document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";
                                    document.getElementById("passwordStatus").innerHTML = "Please verify your email";
                                    document.getElementById("CustEmailVeriDiv").style.display = "block";
                                    document.getElementById("provFormStatus").innerHTML = "BizEmailVeriDiv";
                                }else{
                                    document.getElementById("AddUserSignUpBtn").disabled = false;
                                    document.getElementById("AddUserSignUpBtn").style.backgroundColor = "darkslateblue";
                                    document.getElementById("AddUserSignUpBtn").style.cssText = '#AddUserSignUpBtn:hover{ background-color: red; }';
                                    document.getElementById("passwordStatus").innerHTML = "";
                                    document.getElementById("formStatus").innerHTML = "OK";
                                }
                            }
			}
		}
		else{
                    document.getElementById("AddUserSignUpBtn").disabled = true;
                    document.getElementById("AddUserSignUpBtn").style.backgroundColor = "darkgrey";
                    document.getElementById("passwordStatus").innerHTML = "Passwords don't match";
                    document.getElementById("formStatus").innerHTML = "";
		}
	}
	else{
            document.getElementById("AddUserSignUpBtn").disabled = true;
            document.getElementById("AddUserSignUpBtn").style.backgroundColor = "darkgrey";
            document.getElementById("formStatus").innerHTML = "uncompleted form";
            document.getElementById("passwordStatus").innerHTML = "";
	}

}

setInterval(EnableCustomerSignUpBtn,1);

function EnableProviderSignUpBtn(){

	var fName = document.getElementById("firstProvName").value;
	var mName = document.getElementById("middleProvName").value;
	var lName = document.getElementById("lastProvName").value;
	var email = document.getElementById("provEmail").value;
	var phoneNumber = document.getElementById("provPhoneNumber").value;
	var businessName = document.getElementById("businessName").value;
	var businessLocation = document.getElementById("businessLocation").value;
	var businessEmail = document.getElementById("businessEmail").value;
	var businessTel = document.getElementById("businessTel").value;
	var businessType = document.getElementById("businessType").value;
	var otherBusinessType = document.getElementById("otherBusinessType").value;
	var userName = document.getElementById("provUserName").value;
	var firstPassword = document.getElementById("firstProvPassword").value;
	var secondPassword = document.getElementById("secondProvPassword").value;
	
	if(fName !== "" && mName !== "" && lName !== "" &&
	   phoneNumber !== "" && userName !== "" && firstPassword !== "" && secondPassword !== "" &&
	   businessName !== "" && businessLocation !== "" && businessEmail !== "" && businessTel !== "" ){
		document.getElementById("otherBusinessType").style.display = "none";
		if(firstPassword === secondPassword){
			
			if(firstPassword.length < 8){
				document.getElementById("provSignUpBtn").disabled = true;
				document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";
				document.getElementById("provPasswordStatus").innerHTML = "Password too short";
				document.getElementById("provFormStatus").innerHTML = "";
			}
			else{
				if(businessType === "Select Business Type"){
                                    
                                    document.getElementById("otherBusinessType").style.display = "none";
                                    
                                    if(businessType === "Select Business Type"){
                                        document.getElementById("provSignUpBtn").disabled = true;
                                        document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";
                                        document.getElementById("provPasswordStatus").innerHTML = "Specify business Type";
                                        document.getElementById("provFormStatus").innerHTML = "";
                                    }
                                    
				}
				else{
					
                                    if(userName === firstPassword){
                                       document.getElementById("provSignUpBtn").disabled = true;
				       document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";
				       document.getElementById("provPasswordStatus").innerHTML = "Same Username as Password";
				       document.getElementById("provFormStatus").innerHTML = "";
                                    }else{
					if(email === ""){
                                            document.getElementById("provSignUpBtn").disabled = true;
                                            document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";
                                            document.getElementById("provPasswordStatus").innerHTML = "Please verify your email";
                                            document.getElementById("BizEmailVeriDiv").style.display = "block";
                                            document.getElementById("provFormStatus").innerHTML = "";
                                        }else{
                                            if(businessType === "Other"){
                                                document.getElementById("otherBusinessType").style.display = "block";
                                        
                                                if(otherBusinessType === ""){
                                                    document.getElementById("provSignUpBtn").disabled = true;
                                                    document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";
                                                    document.getElementById("provPasswordStatus").innerHTML = "Specify business Type";
                                                    document.getElementById("provFormStatus").innerHTML = "";
                                                }else{
                                                    document.getElementById("provSignUpBtn").disabled = false;
                                                    document.getElementById("provSignUpBtn").style.backgroundColor = "pink";
                                                    document.getElementById("provSignUpBtn").style.cssText = '#provSignUpBtn:hover{ background-color: red; }';
                                                    document.getElementById("provPasswordStatus").innerHTML = "";
                                                    document.getElementById("provFormStatus").innerHTML = "OK";
                                                }
                                            }else{
                                                document.getElementById("provSignUpBtn").disabled = false;
                                                document.getElementById("provSignUpBtn").style.backgroundColor = "pink";
                                                document.getElementById("provSignUpBtn").style.cssText = '#provSignUpBtn:hover{ background-color: red; }';
                                                document.getElementById("provPasswordStatus").innerHTML = "";
                                                document.getElementById("provFormStatus").innerHTML = "OK";
                                            }
                                        }
                                    }
				}
                            }
			
		}
		else{
                    document.getElementById("otherBusinessType").style.display = "none";
                    document.getElementById("provSignUpBtn").disabled = true;
                    document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";
                    document.getElementById("provPasswordStatus").innerHTML = "Passwords don't match";
                    document.getElementById("provFormStatus").innerHTML = "";
		}
	}
	else{
            document.getElementById("otherBusinessType").style.display = "none";
            document.getElementById("provSignUpBtn").disabled = true;
            document.getElementById("provSignUpBtn").style.backgroundColor = "darkgrey";
            document.getElementById("provFormStatus").innerHTML = "uncompleted form";
            document.getElementById("provPasswordStatus").innerHTML = "";
	}

}

setInterval(EnableProviderSignUpBtn,1);
