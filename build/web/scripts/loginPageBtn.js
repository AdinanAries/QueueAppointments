function showLoginPageLoginBtn() {
  var loginPageBtn = document.getElementById("loginPageBtn");
  var LoginPageUserNameFld = document.getElementById("LoginPageUserNameFld");
  var LoginPagePasswordFld = document.getElementById("LoginPagePasswordFld");

  loginPageBtn.disabled = true;
  loginPageBtn.style.backgroundColor = "darkgrey";

  if (LoginPageUserNameFld.value !== "" && LoginPagePasswordFld.value !== "") {
    loginPageBtn.disabled = false;
    loginPageBtn.style.backgroundColor = "darkslateblue";
    loginPageBtn.style.cssText =
      "#loginPageBtn:hover{ background-color: steelblue; }";
  } else {
    loginPageBtn.disabled = true;
    loginPageBtn.style.backgroundColor = "darkgrey";
  }
}

if (document.getElementById("loginPageBtn")) {
  setInterval(showLoginPageLoginBtn, 1);
}

function showLoginPageSignUpBtn() {
  var signUpFirtNameFld = document.getElementById("signUpFirtNameFld");
  var sigUpLastNameFld = document.getElementById("sigUpLastNameFld");
  var signUpTelFld = document.getElementById("signUpTelFld");
  var signUpEmailFld = document.getElementById("signUpEmailFld");
  var loginPageSignUpBtn = document.getElementById("loginPageSignUpBtn");

  loginPageSignUpBtn.disabled = true;
  loginPageSignUpBtn.style.backgroundColor = "darkgrey";

  if (
    signUpFirtNameFld.value !== "" &&
    sigUpLastNameFld.value !== "" &&
    signUpTelFld.value !== "" &&
    signUpEmailFld.value !== ""
  ) {
    loginPageSignUpBtn.disabled = false;
    loginPageSignUpBtn.style.backgroundColor = "darkslateblue";
    loginPageSignUpBtn.style.cssText =
      "#loginPageSignUpBtn:hover{ background-color: steelblue; }";
  } else {
    loginPageSignUpBtn.disabled = true;
    loginPageSignUpBtn.style.backgroundColor = "darkgrey";
  }
}

if (document.getElementById("loginPageSignUpBtn")) {
  setInterval(showLoginPageSignUpBtn, 1);
}
