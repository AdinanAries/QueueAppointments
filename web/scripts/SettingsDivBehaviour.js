function showSettingsDiv() {
  var SettingsDiv = document.getElementById("SettingsDiv");

  if (SettingsDiv.style.display === "none") $("#SettingsDiv").slideDown("fast");
  else $("#SettingsDiv").slideUp("fast");
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
    changeUserAccountStatus.innerHTML = "Uncompleted Form";
    changeUserAccountStatus.style.backgroundColor = "green";
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
    changeUserAccountStatus.innerHTML = "New Passwords don't match";
    changeUserAccountStatus.style.backgroundColor = "red";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else if (NewPasswordFld.value.length < 8) {
    changeUserAccountStatus.innerHTML = "New password too short";
    changeUserAccountStatus.style.backgroundColor = "red";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else {
    changeUserAccountStatus.innerHTML = "OK";
    changeUserAccountStatus.style.backgroundColor = "green";
    LoginFormBtn.disabled = false;
    LoginFormBtn.style.backgroundColor = "pink";
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
    changeUserAccountStatus.innerHTML = "Uncompleted Form";
    changeUserAccountStatus.style.backgroundColor = "green";
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
    changeUserAccountStatus.innerHTML = "New Passwords don't match";
    changeUserAccountStatus.style.backgroundColor = "red";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else if (NewPasswordFld.value.length < 8) {
    changeUserAccountStatus.innerHTML = "New password too short";
    changeUserAccountStatus.style.backgroundColor = "red";
    LoginFormBtn.disabled = true;
    LoginFormBtn.style.backgroundColor = "darkgrey";
  } else {
    changeUserAccountStatus.innerHTML = "OK";
    changeUserAccountStatus.style.backgroundColor = "green";
    LoginFormBtn.disabled = false;
    LoginFormBtn.style.backgroundColor = "pink";
  }
}
if (document.getElementById("ExtraLoginFormBtn")) {
  setInterval(checkExtraLogInFormFieldsStatus, 1);
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
    PaymentFormStatus.innerHTML = "Uncompleted Form";
    PaymentFormStatus.style.backgroundColor = "red";
    PaymentsUpdateBtn.disabled = true;
    PaymentsUpdateBtn.style.backgroundColor = "darkgrey";
  } else {
    PaymentFormStatus.innerHTML = "OK";
    PaymentFormStatus.style.backgroundColor = "green";
    PaymentsUpdateBtn.disabled = false;
    PaymentsUpdateBtn.style.backgroundColor = "pink";
  }
}

if (document.getElementById("PaymentsUpdateBtn")) {
  setInterval(PaymentsFormCheckInputs, 1);
}
