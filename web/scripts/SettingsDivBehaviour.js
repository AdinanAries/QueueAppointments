function showSettingsDiv() {
  var SettingsDiv = document.getElementById("SettingsDiv");

  if (SettingsDiv.style.display === "none") $("#SettingsDiv").slideDown("fast");
  else $("#SettingsDiv").slideUp("fast");
  
  if(document.getElementById("UpdateUserAccountForm")){
        $("#UpdateUserAccountForm").slideUp("slow");
        //document.getElementById("UpdateUserAccountForm").style.display = "none";
    }
    if(document.getElementById("SetUserAddress")){
        $("#SetUserAddress").slideUp("slow");
        //document.getElementById("SetUserAddress").style.display = "none";
    }
    if(document.getElementById("SendFeedBackForm")){
        $("#SendFeedBackForm").slideUp("slow");
        //document.getElementById("SendFeedBackForm").style.display = "none";
    }
}

function showLoginForm() {
  var SettingsDiv = document.getElementById("SettingsDiv");

  if (SettingsDiv.style.display === "none") $("#SettingsDiv").slideDown("fast");
  else $("#SettingsDiv").slideUp("fast");
}

function showLoginFormsDiv() {
  var UserAcountLoginForm = document.getElementById("UserAcountLoginForm");

  if (UserAcountLoginForm.style.display === "none")
    $("#UserAcountLoginForm").slideDown("fast");
  else $("#UserAcountLoginForm").slideUp("fast");
}

function showContactUsDiv() {
  var ContactUsDiv = document.getElementById("ContactUsDiv");

  if (ContactUsDiv.style.display === "none")
    $("#ContactUsDiv").slideDown("fast");
  else $("#ContactUsDiv").slideUp("fast");
}

function showPaymentsForm() {
  var PaymentsCardForm = document.getElementById("PaymentsCardForm");

  if (PaymentsCardForm.style.display === "none")
    $("#PaymentsCardForm").slideDown("fast");
  else $("#PaymentsCardForm").slideUp("fast");
}

function checkLogInFormFieldsStatus() {
  var changeUserAccountStatus = document.getElementById(
    "changeUserAccountStatus"
  );
  var LoginFormBtn = document.getElementById("LoginFormBtn");
  var NewPasswordFld = document.getElementById("NewPasswordFld");
  var CurrentPasswordFld = document.getElementById("CurrentPasswordFld");
  var ConfirmPasswordFld = document.getElementById("ConfirmPasswordFld");
  var UpdateLoginNameFld = document.getElementById("UpdateLoginNameFld");
  var ThisPass = document.getElementById("ThisPass");

  LoginFormBtn.disabled = true;
  LoginFormBtn.style.backgroundColor = "darkgrey";

  if (
    NewPasswordFld.value === "" ||
    CurrentPasswordFld.value === "" ||
    ConfirmPasswordFld.value === "" ||
    UpdateLoginNameFld.value === ""
  ) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>Uncompleted Form";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else if (
    /*else if (ThisPass.value === "WrongPass"){
			
			changeUserAccountStatus.innerHTML = "Enter your old password correctly";
			changeUserAccountStatus.style.backgroundColor = "red";
			//LoginFormBtn.disabled = true;
			//LoginFormBtn.style.backgroundColor = "darkgrey";
			
		}*/
    NewPasswordFld.value !== ConfirmPasswordFld.value ||
    (NewPasswordFld.value === "" && ConfirmPasswordFld.value === "")
  ) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>New Passwords don't match";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else if (NewPasswordFld.value.length < 8) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>New password too short";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: green;' aria-hidden='true' class='fa fa-check'></i>OK";
    LoginFormBtn.disabled = false;
    LoginFormBtn.style.backgroundColor = "darkslateblue";
  }
}
if (document.getElementById("LoginFormBtn")) {
  setInterval(checkLogInFormFieldsStatus, 1);
}

function checkExtraLogInFormFieldsStatus() {
  var changeUserAccountStatus = document.getElementById(
    "ExtrachangeUserAccountStatus"
  );
  var LoginFormBtn = document.getElementById("ExtraLoginFormBtn");
  var NewPasswordFld = document.getElementById("ExtraNewPasswordFld");
  var CurrentPasswordFld = document.getElementById("ExtraCurrentPasswordFld");
  var ConfirmPasswordFld = document.getElementById("ExtraConfirmPasswordFld");
  var UpdateLoginNameFld = document.getElementById("ExtraUpdateLoginNameFld");
  var ThisPass = document.getElementById("ExtraThisPass");

  LoginFormBtn.disabled = true;
  LoginFormBtn.style.backgroundColor = "darkgrey";

  if (
    NewPasswordFld.value === "" ||
    CurrentPasswordFld.value === "" ||
    ConfirmPasswordFld.value === "" ||
    UpdateLoginNameFld.value === ""
  ) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>Uncompleted Form";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else if (
    /*else if (ThisPass.value === "WrongPass"){
			
			changeUserAccountStatus.innerHTML = "Enter your old password correctly";
			changeUserAccountStatus.style.backgroundColor = "red";
			//LoginFormBtn.disabled = true;
			//LoginFormBtn.style.backgroundColor = "darkgrey";
			
		}*/
    NewPasswordFld.value !== ConfirmPasswordFld.value ||
    (NewPasswordFld.value === "" && ConfirmPasswordFld.value === "")
  ) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>New Passwords don't match";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else if (NewPasswordFld.value.length < 8) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>New password too short";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: green;' aria-hidden='true' class='fa fa-check'></i>OK";
    LoginFormBtn.disabled = false;
    LoginFormBtn.style.backgroundColor = "darkslateblue";
  }
}
if (document.getElementById("ExtraLoginFormBtn")) {
  setInterval(checkExtraLogInFormFieldsStatus, 1);
}

function checkExtraLogInFormFieldsStatus2() {
  var changeUserAccountStatus = document.getElementById(
    "ExtrachangeUserAccountStatus2"
  );
  var LoginFormBtn = document.getElementById("ExtraLoginFormBtn2");
  var NewPasswordFld = document.getElementById("ExtraNewPasswordFld2");
  var CurrentPasswordFld = document.getElementById("ExtraCurrentPasswordFld2");
  var ConfirmPasswordFld = document.getElementById("ExtraConfirmPasswordFld2");
  var UpdateLoginNameFld = document.getElementById("ExtraUpdateLoginNameFld2");
  var ThisPass = document.getElementById("ExtraThisPass2");

  LoginFormBtn.disabled = true;
  LoginFormBtn.style.backgroundColor = "darkgrey";

  if (
    NewPasswordFld.value === "" ||
    CurrentPasswordFld.value === "" ||
    ConfirmPasswordFld.value === "" ||
    UpdateLoginNameFld.value === ""
  ) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>Uncompleted Form";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else if (
    /*else if (ThisPass.value === "WrongPass"){
			
			changeUserAccountStatus.innerHTML = "Enter your old password correctly";
			changeUserAccountStatus.style.backgroundColor = "red";
			//LoginFormBtn.disabled = true;
			//LoginFormBtn.style.backgroundColor = "darkgrey";
			
		}*/
    NewPasswordFld.value !== ConfirmPasswordFld.value ||
    (NewPasswordFld.value === "" && ConfirmPasswordFld.value === "")
  ) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>New Passwords don't match";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else if (NewPasswordFld.value.length < 8) {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>New password too short";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else {
    changeUserAccountStatus.innerHTML = "<i style='margin-right: 5px; color: green;' aria-hidden='true' class='fa fa-check'></i>OK";
    LoginFormBtn.disabled = false;
    LoginFormBtn.style.backgroundColor = "darkslateblue";
  }
}
if (document.getElementById("ExtraLoginFormBtn2")) {
  setInterval(checkExtraLogInFormFieldsStatus2, 1);
}

function PaymentsFormCheckInputs() {
  var PaymentsUpdateBtn = document.getElementById("PaymentsUpdateBtn");
  var CardNumberFld = document.getElementById("CardNumberFld");
  var HoldersNameFld = document.getElementById("HoldersNameFld");
  var ExpDateFld = document.getElementById("ExpDateFld");
  var SecCodeFld = document.getElementById("SecCodeFld");
  var PaymentFormStatus = document.getElementById("PaymentFormStatus");

  if (
    CardNumberFld.value === "" ||
    HoldersNameFld.value === "" ||
    ExpDateFld.value === "" ||
    SecCodeFld.value === ""
  ) {
    PaymentFormStatus.innerHTML = "<i style='margin-right: 5px; color: orange;' aria-hidden='true' class='fa fa-exclamation-triangle'></i>Uncompleted Form";
    PaymentsUpdateBtn.disabled = true;
    PaymentsUpdateBtn.style.backgroundColor = "darkgrey";
  } else {
    PaymentFormStatus.innerHTML = "<i style='margin-right: 5px; color: green;' aria-hidden='true' class='fa fa-check'></i>OK";
    PaymentsUpdateBtn.disabled = false;
    PaymentsUpdateBtn.style.backgroundColor = "darkslateblue";
  }
}

if (document.getElementById("PaymentsUpdateBtn")) {
  setInterval(PaymentsFormCheckInputs, 1);
}
