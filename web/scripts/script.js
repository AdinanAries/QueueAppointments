/*var datesP = document.getElementById("displayDate");
//the above code line would break the program where displayDate element doesn't exist

if (document.getElementById("displayDate"))
  var datesP = document.getElementById("displayDate");
//only create the date element variable if the displayDate object exists in the DOM*/

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js')
  .then(function(registration) {
    console.log('Registration successful, scope is:', registration.scope);
  })
  .catch(function(error) {
    console.log('Service worker registration failed, error:', error);
  });
}

function QueueClock() {
  var date = new Date();
  var hours = date.getHours() + "";
  var minutes = date.getMinutes() + "";
  var seconds = date.getSeconds() + "";
  var day = date.getDay();

  if (hours > 12) {
    if (hours == 24) {
      hours = 12;
      seconds += " AM";
    } else {
      hours = hours - 12;
      seconds += " PM";
    }
  } else if (hours < 12) {
    if (hours == 0) {
      hours = 12;
      seconds += " AM";
    } else {
      seconds += " AM";
    }
  } else if (hours == 12) {
    seconds += " PM";
  }

  if (minutes.length < 2) {
    minutes = `0 + ${minutes}`;
  }

  if (seconds.length < 5) {
    seconds = `0 + ${seconds}`;
  }

  var weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  var clock = weekDays[day] + " " + hours + ":" + minutes + ":" + seconds;

  datesP.innerHTML = clock;
}

//QueueClock();

//setInterval(QueueClock, 1000);

/*function HideExploreLoader(){
    document.getElementById("ExploreLoading").style.display = "block";
}

function HideAccountLoader(){
    document.getElementById("UserProfileLoading").style.display = "none";
}

function HideSpotsLoader(){
    document.getElementById("SpotsLoading").style.display = "none";
}

function HideSearchLoader(){
    document.getElementById("SearchLoading").style.display = "none";
}

function HideFavoritesLoader(){
    document.getElementById("FavoritesLoading").style.display = "none";
}*/

function toggleEnableFinalApntmntBtn() {
  var submitAppointment = document.getElementById("submitAppointment");

  submitAppointment.style.backgroundColor = "darkgrey";
  submitAppointment.disabled = true;

  var Cash;
  if (document.getElementById("Cash")) {
    //returns true if checked, otherwise false
    Cash = document.getElementById("Cash").checked;
  }

  var CreditDebit = document.getElementById("Credit/Debit").checked;
  var formsTimeValue = document.getElementById("formsTimeValue").value;
  var formsDateValue = document.getElementById("formsDateValue").value;
  var ConfirmAppointmentStatusTxt = document.getElementById(
    "ConfirmAppointmentStatusTxt"
  );

  if (Cash === false || CreditDebit === false) {
    ConfirmAppointmentStatusTxt.innerHTML = "Choose payment";
    ConfirmAppointmentStatusTxt.style.backgroundColor = "red";
  }

  if (formsTimeValue === " ") {
    ConfirmAppointmentStatusTxt.innerHTML = "Choose appointment time";
    ConfirmAppointmentStatusTxt.style.backgroundColor = "red";
  }

  if (formsDateValue === "") {
    ConfirmAppointmentStatusTxt.innerHTML = "Choose appointment date";
    ConfirmAppointmentStatusTxt.style.backgroundColor = "red";
  }

  if (
    (Cash === true || CreditDebit === true) &&
    formsTimeValue !== " " && formsDateValue !== ""
  ) {
    submitAppointment.style.backgroundColor = "red";
    submitAppointment.disabled = false;
    ConfirmAppointmentStatusTxt.innerHTML = "";
    ConfirmAppointmentStatusTxt.style.backgroundColor = "green";
  } else {
    submitAppointment.style.backgroundColor = "darkgrey";
    submitAppointment.disabled = true;
  }
}

if (document.getElementById("submitAppointment")) {
  setInterval(toggleEnableFinalApntmntBtn, 1);
}

function toggleHideDelete(number) {
  var deleteFormName = "deleteAppointmentForm" + number;
  var changeFormName = "changeBookedAppointmetForm" + number;
  var AddFavformName = "addFavProvForm" + number;

  var deleteform1 = document.getElementById(deleteFormName);
  var changeform1 = document.getElementById(changeFormName);
  var AddFavform = document.getElementById(AddFavformName);

  if (deleteform1.style.display === "none") {
    if (changeform1.style.display === "block") {
      changeform1.style.display = "none";
    }

    if (AddFavform.style.display === "block") {
      AddFavform.style.display = "none";
    }

    deleteform1.style.display = "block";
  } else {
    deleteform1.style.display = "none";
  }
}

function toggleFutureHideDelete(number) {
  var deleteFormName = "deleteFutureAppointmentForm" + number;
  var changeFormName = "changeFutureAppointmetForm" + number;
  var AddFavformName = "addFutureFavProvForm" + number;

  var deleteform1 = document.getElementById(deleteFormName);
  var changeform1 = document.getElementById(changeFormName);
  var AddFavform = document.getElementById(AddFavformName);

  if (deleteform1.style.display === "none") {
    if (changeform1.style.display === "block") {
      changeform1.style.display = "none";
    }

    if (AddFavform.style.display === "block") {
      AddFavform.style.display = "none";
    }

    deleteform1.style.display = "block";
  } else {
    deleteform1.style.display = "none";
  }
}

function toggleHideDeleteHistory(number) {
  var reviewformName = "ratingAndReviewForm" + number;
  var reviewForm = document.getElementById(reviewformName);

  var addFavformName = "addFavProvFormFromRecent" + number;
  var addFavForm = document.getElementById(addFavformName);

  var deleteFormName = "deleteAppointmentHistoryForm" + number;

  var deleteform1 = document.getElementById(deleteFormName);

  if (deleteform1.style.display === "none") {
    if (reviewForm.style.display === "block") {
      reviewForm.style.display = "none";
    }

    if (addFavForm.style.display === "block") {
      addFavForm.style.display = "none";
    }

    deleteform1.style.display = "block";
  } else {
    deleteform1.style.display = "none";
  }
}

function hideDelete(number) {
  var deleteFormName = "deleteAppointmentForm" + number;

  var deleteform = document.getElementById(deleteFormName);

  deleteform.style.display = "none";
}

function hideFutureDelete(number) {
  var deleteFormName = "deleteFutureAppointmentForm" + number;

  var deleteform = document.getElementById(deleteFormName);

  deleteform.style.display = "none";
}

function hideDeleteHistory(number) {
  var deleteFormName = "deleteAppointmentHistoryForm" + number;

  var deleteform = document.getElementById(deleteFormName);

  deleteform.style.display = "none";
}

function toggleChangeAppointment(number) {
  var deleteFormName = "deleteAppointmentForm" + number;
  var changeFormName = "changeBookedAppointmetForm" + number;
  var AddFavformName = "addFavProvForm" + number;

  var changeform = document.getElementById(changeFormName);
  var deleteform = document.getElementById(deleteFormName);
  var AddFavform = document.getElementById(AddFavformName);

  if (changeform.style.display === "none") {
    if (deleteform.style.display === "block") {
      deleteform.style.display = "none";
    }

    if (AddFavform.style.display === "block") {
      AddFavform.style.display = "none";
    }

    changeform.style.display = "block";
  } else {
    changeform.style.display = "none";
  }
}

function toggleChangeFutureAppointment(number) {
  var deleteFormName = "deleteFutureAppointmentForm" + number;
  var changeFormName = "changeFutureAppointmetForm" + number;
  var AddFavformName = "addFutureFavProvForm" + number;

  var changeform = document.getElementById(changeFormName);
  var deleteform = document.getElementById(deleteFormName);
  var AddFavform = document.getElementById(AddFavformName);

  if (changeform.style.display === "none") {
    if (deleteform.style.display === "block") {
      deleteform.style.display = "none";
    }

    if (AddFavform.style.display === "block") {
      AddFavform.style.display = "none";
    }

    changeform.style.display = "block";
  } else {
    changeform.style.display = "none";
  }
}

function toggleHideAddServiceDiv() {
  var addServiceForm = document.getElementById("addServiceDiv");

  if (addServiceForm.style.display === "none") {
    addServiceForm.style.display = "block";
    $(".scrolldiv").animate({ scrollTop: $(document).height() }, "slow");
  } else {
    addServiceForm.style.display = "none";
  }
}

function toggleHideEditService(number) {
  var editServiceName = "changeServiceForm" + number;
  var editServiceForm = document.getElementById(editServiceName);

  if (editServiceForm.style.display === "none") {
    editServiceForm.style.display = "block";
  } else {
    editServiceForm.style.display = "none";
  }
}

function ShowFutureSpotsForm() {
  var BlockFutureSpotsForm = document.getElementById("BlockFutureSpotsForm");

  if (BlockFutureSpotsForm.style.display === "none")
    BlockFutureSpotsForm.style.display = "block";
  else BlockFutureSpotsForm.style.display = "none";
}

function toggleShowBlockFutureSpotsForm() {
  var BlockFutureSpotsForm = document.getElementById("BlockFutureSpotsForm");
  var CloseFutureDaysForm = document.getElementById("CloseFutureDaysForm");
  var MakeReservationForm = document.getElementById("MakeReservationForm");

  //if (CloseFutureDaysForm.style.display === "block")
  CloseFutureDaysForm.style.display = "none";

  //if (MakeReservationForm.style.display === "block")
  MakeReservationForm.style.display = "none";

  if (BlockFutureSpotsForm.style.display === "none") {
    $("#BlockFutureSpotsForm").slideDown("fast");
    BlockFutureSpotsForm.style.display = "block";
  } else $("#BlockFutureSpotsForm").slideUp("fast");
}

function toggleShowCloseFutureDysForm() {
  var CloseFutureDaysForm = document.getElementById("CloseFutureDaysForm");
  var MakeReservationForm = document.getElementById("MakeReservationForm");
  var BlockFutureSpotsForm = document.getElementById("BlockFutureSpotsForm");

  //if (BlockFutureSpotsForm.style.display === "block")
  BlockFutureSpotsForm.style.display = "none";

  //if (MakeReservationForm.style.display === "block")
  MakeReservationForm.style.display = "none";

  if (CloseFutureDaysForm.style.display === "none") {
    $("#CloseFutureDaysForm").slideDown("fast");
    CloseFutureDaysForm.style.display = "block";
  } else $("#CloseFutureDaysForm").slideUp("fast");
}

function toggleShowMakeReservationForm() {
  var CloseFutureDaysForm = document.getElementById("CloseFutureDaysForm");
  var MakeReservationForm = document.getElementById("MakeReservationForm");
  var BlockFutureSpotsForm = document.getElementById("BlockFutureSpotsForm");

  //if (CloseFutureDaysForm.style.display === "block")
  CloseFutureDaysForm.style.display = "none";

  //if (BlockFutureSpotsForm.style.display === "block")
  BlockFutureSpotsForm.style.display = "none";

  if (MakeReservationForm.style.display === "none") {
    $("#MakeReservationForm").slideDown("fast");
    MakeReservationForm.style.display = "block";
  } else $("#MakeReservationForm").slideUp("fast");
}

function togglehideAddClientForm(number) {
  var deleteAppointmentHistoryFormName =
    "deleteAppointmentHistoryForm" + number;
  var deleteAppointmentHistoryForm = document.getElementById(
    deleteAppointmentHistoryFormName
  );

  if (deleteAppointmentHistoryForm.style.display === "block")
    deleteAppointmentHistoryForm.style.display = "none";

  var AddClientFormName = "AddClientForm" + number;
  var AddClientForm = document.getElementById(AddClientFormName);

  if (AddClientForm.style.display === "none")
    AddClientForm.style.display = "block";
  else AddClientForm.style.display = "none";
}

function toggleHideAddCustomerForm() {
  var addCustomerForm = document.getElementById("customerForm");
  var addBusinessForm = document.getElementById("businessForm");

  if (addCustomerForm.style.display === "none") {
    if (addBusinessForm.style.display === "block") {
      addBusinessForm.style.display = "none";
    }
    $("#customerForm").slideDown("slow");
    addCustomerForm.style.display = "block";
  } else {
    $("#customerForm").slideUp("slow");
  }
}

function toggleHideAddBusinessForm() {
  var addCustomerForm = document.getElementById("customerForm");
  var addBusinessForm = document.getElementById("businessForm");

  if (addBusinessForm.style.display === "none") {
    if (addCustomerForm.style.display === "block") {
      addCustomerForm.style.display = "none";
    }
    $("#businessForm").slideDown("slow");
    addBusinessForm.style.display = "block";
  } else {
    $("#businessForm").slideUp("slow");
  }
}

function showSecondSetProvIcons() {
  var firstSetProvIcons = document.getElementById("firstSetProvIcons");
  var secondSetProvIcons = document.getElementById("secondSetProvIcons");

  //firstSetProvIcons.style.display = "none";
  $("#firstSetProvIcons").slideUp("slow");
  //secondSetProvIcons.style.display = "block";
  $("#secondSetProvIcons").slideDown("slow");
}

function showFirstSetProvIcons() {
  var firstSetProvIcons = document.getElementById("firstSetProvIcons");
  var secondSetProvIcons = document.getElementById("secondSetProvIcons");

  //firstSetProvIcons.style.display = "block";
  $("#firstSetProvIcons").slideDown("slow");
  //secondSetProvIcons.style.display = "none";
  $("#secondSetProvIcons").slideUp("slow");
}

function showThirdSetProvIcons() {
  var thirdSetProvIcons = document.getElementById("thirdSetProvIcons");
  var secondSetProvIcons = document.getElementById("secondSetProvIcons");

  //thirdSetProvIcons.style.display = "block";
  $("#thirdSetProvIcons").slideDown("slow");
  //secondSetProvIcons.style.display = "none";
  $("#secondSetProvIcons").slideUp("slow");
}

function showSecondFromThirdProvIcons() {
  var thirdSetProvIcons = document.getElementById("thirdSetProvIcons");
  var secondSetProvIcons = document.getElementById("secondSetProvIcons");

  //thirdSetProvIcons.style.display = "none";
  $("#thirdSetProvIcons").slideUp("slow");
  //secondSetProvIcons.style.display = "block";
  $("#secondSetProvIcons").slideDown("slow");
}

function toggleshowOtherSettings() {
  var ShowHourBtn = document.getElementById("ShowHourBtn");
  var showOtherSettingsBtn = document.getElementById("showOtherSettingsBtn");
  var ShowOtherSettingsDiv = document.getElementById("ShowOtherSettingsDiv");
  var ShowHoursOpenDiv = document.getElementById("ShowHoursOpenDiv");

  ShowOtherSettingsDiv.style.display = "block";
  showOtherSettingsBtn.style.backgroundColor = "plum";
  ShowHoursOpenDiv.style.display = "none";
  ShowHourBtn.style.backgroundColor = "pink";
}

function toggleshowHoursOpen() {
  var ShowHourBtn = document.getElementById("ShowHourBtn");
  var showOtherSettingsBtn = document.getElementById("showOtherSettingsBtn");
  var ShowOtherSettingsDiv = document.getElementById("ShowOtherSettingsDiv");
  var ShowHoursOpenDiv = document.getElementById("ShowHoursOpenDiv");

  ShowOtherSettingsDiv.style.display = "none";
  showOtherSettingsBtn.style.backgroundColor = "pink";
  ShowHoursOpenDiv.style.display = "block";
  ShowHourBtn.style.backgroundColor = "plum";
}

function toggleshowClients() {
  var ShowClientsBtn = document.getElementById("ShowClientsBtn");
  var ShowBlockedPeopleBtn = document.getElementById("ShowBlockedPeopleBtn");
  var ProviderClientsDiv = document.getElementById("ProviderClientsDiv");
  var BlockedPeopleDiv = document.getElementById("BlockedPeopleDiv");

  BlockedPeopleDiv.style.display = "none";
  ShowBlockedPeopleBtn.style.backgroundColor = "pink";
  ProviderClientsDiv.style.display = "block";
  ShowClientsBtn.style.backgroundColor = "plum";
}

function toggleshowBlockedPeople() {
  var ShowClientsBtn = document.getElementById("ShowClientsBtn");
  var ShowBlockedPeopleBtn = document.getElementById("ShowBlockedPeopleBtn");
  var ProviderClientsDiv = document.getElementById("ProviderClientsDiv");
  var BlockedPeopleDiv = document.getElementById("BlockedPeopleDiv");

  BlockedPeopleDiv.style.display = "block";
  ShowBlockedPeopleBtn.style.backgroundColor = "plum";
  ProviderClientsDiv.style.display = "none";
  ShowClientsBtn.style.backgroundColor = "pink";
}

function showDeleteFavProv(number) {
  var formName = "deleteFavProviderForm" + number;

  var deleteFavProviders = document.getElementById(formName);

  //deleteFavProviders.style.display = "none";
  if (deleteFavProviders.style.display === "none") {
    deleteFavProviders.style.display = "block";
  } else {
    deleteFavProviders.style.display = "none";
  }
}

function hideDeleteFavProv(number) {
  var formName = "deleteFavProviderForm" + number;

  var deleteFavProviders = document.getElementById(formName);

  deleteFavProviders.style.display = "none";
}

function showAddFavProv(number) {
  var formName = "addFavProvFormFromRecent" + number;
  var deleteFormName = "deleteAppointmentHistoryForm" + number;
  var reviewformName = "ratingAndReviewForm" + number;

  var addFavProviders = document.getElementById(formName);
  var deleteForm = document.getElementById(deleteFormName);
  var reviewForm = document.getElementById(reviewformName);

  //addFavProviders.style.display = "none"
  if (addFavProviders.style.display === "none") {
    if (reviewForm.style.display === "block") {
      reviewForm.style.display = "none";
    }

    if (deleteForm.style.display === "block") {
      deleteForm.style.display = "none";
    }

    addFavProviders.style.display = "block";
  } else {
    addFavProviders.style.display = "none";
  }
}

function showAddFavProvFromCurrentAppointment(number) {
  var formName = "addFavProvForm" + number;
  var deleteFormName = "deleteAppointmentForm" + number;
  var changeFormName = "changeBookedAppointmetForm" + number;

  var addFavProviders = document.getElementById(formName);
  var deleteForm = document.getElementById(deleteFormName);
  var changeForm = document.getElementById(changeFormName);

  //addFavProviders.style.display = "none";
  if (addFavProviders.style.display === "none") {
    if (deleteForm.style.display === "block") {
      deleteForm.style.display = "none";
    }

    if (changeForm.style.display === "block") {
      changeForm.style.display = "none";
    }

    addFavProviders.style.display = "block";
  } else {
    addFavProviders.style.display = "none";
  }
}

function showAddFavProvFromFutureAppointment(number) {
  var formName = "addFutureFavProvForm" + number;
  var deleteFormName = "deleteFutureAppointmentForm" + number;
  var changeFormName = "changeFutureAppointmetForm" + number;

  var addFavProviders = document.getElementById(formName);
  var deleteForm = document.getElementById(deleteFormName);
  var changeForm = document.getElementById(changeFormName);

  //addFavProviders.style.display = "none";
  if (addFavProviders.style.display === "none") {
    if (deleteForm.style.display === "block") {
      deleteForm.style.display = "none";
    }

    if (changeForm.style.display === "block") {
      changeForm.style.display = "none";
    }

    addFavProviders.style.display = "block";
  } else {
    addFavProviders.style.display = "none";
  }
}

function activateHistory() {
  var AppointmentsTab = document.getElementById("AppointmentsTab");
  var HistoryTab = document.getElementById("HistoryTab");
  var FavoritesTab = document.getElementById("FavoritesTab");

  var AppListDiv = document.querySelector(".AppListDiv");
  var AppHistoryDiv = document.querySelector(".AppHistoryDiv");
  var FavDiv = document.querySelector(".FavDiv");

  HistoryTab.style.backgroundColor = "#ccccff";
  HistoryTab.style.border = "none";
  HistoryTab.style.borderTop = "black 1px solid";

  AppointmentsTab.style.backgroundColor = "cornflowerblue";
  AppointmentsTab.style.border = "1px solid black";

  FavoritesTab.style.backgroundColor = "cornflowerblue";
  FavoritesTab.style.border = "black 1px solid";

  AppListDiv.style.display = "none";
  AppHistoryDiv.style.display = "block";
  FavDiv.style.display = "none";

  $(".scrolldiv").animate({ scrollTop: 0 }, "fast");
}

function activateAppTab() {
  var AppointmentsTab = document.getElementById("AppointmentsTab");
  var HistoryTab = document.getElementById("HistoryTab");
  var FavoritesTab = document.getElementById("FavoritesTab");

  var AppListDiv = document.querySelector(".AppListDiv");
  var AppHistoryDiv = document.querySelector(".AppHistoryDiv");
  var FavDiv = document.querySelector(".FavDiv");

  HistoryTab.style.backgroundColor = "cornflowerblue";
  HistoryTab.style.border = "black 1px solid";

  AppointmentsTab.style.backgroundColor = "#ccccff";
  AppointmentsTab.style.border = "none";
  AppointmentsTab.style.borderTop = "1px solid black";

  FavoritesTab.style.backgroundColor = "cornflowerblue";
  FavoritesTab.style.border = "black 1px solid";

  AppListDiv.style.display = "block";
  AppHistoryDiv.style.display = "none";
  FavDiv.style.display = "none";

  $(".scrolldiv").animate({ scrollTop: 0 }, "fast");
}

function activateFavTab() {
  var AppointmentsTab = document.getElementById("AppointmentsTab");
  var HistoryTab = document.getElementById("HistoryTab");
  var FavoritesTab = document.getElementById("FavoritesTab");

  var AppListDiv = document.querySelector(".AppListDiv");
  var AppHistoryDiv = document.querySelector(".AppHistoryDiv");
  var FavDiv = document.querySelector(".FavDiv");

  HistoryTab.style.backgroundColor = "cornflowerblue";
  HistoryTab.style.border = "black 1px solid";

  AppointmentsTab.style.backgroundColor = "cornflowerblue";
  AppointmentsTab.style.border = "1px solid black";

  FavoritesTab.style.backgroundColor = "#ccccff";
  FavoritesTab.style.border = "none";
  FavoritesTab.style.borderTop = "1px solid black";

  AppListDiv.style.display = "none";
  AppHistoryDiv.style.display = "none";
  FavDiv.style.display = "block";

  $(".scrolldiv").animate({ scrollTop: 0 }, "fast");
}

//Services Provider page Tab Settings

function activateProvAppointmentsTab() {
  var ProvAppointmentsTab = document.getElementById("ProvAppointmentsTab");
  var ProvHistoryTab = document.getElementById("ProvHistoryTab");

  var CurrentProvAppointmentsDiv = document.getElementById(
    "CurrentProvAppointmentsDiv"
  );
  var ProviderAppointmentHistoryDiv = document.getElementById(
    "ProviderAppointmentHistoryDiv"
  );

  ProvHistoryTab.style.backgroundColor = "cornflowerblue";
  ProvHistoryTab.style.border = "1px solid black";

  ProvAppointmentsTab.style.backgroundColor = "#6699ff";
  ProvAppointmentsTab.style.border = "none";
  ProvAppointmentsTab.style.borderTop = "1px solid black";

  CurrentProvAppointmentsDiv.style.display = "block";
  ProviderAppointmentHistoryDiv.style.display = "none";
}

function activateProvHistoryTab() {
  var ProvAppointmentsTab = document.getElementById("ProvAppointmentsTab");
  var ProvHistoryTab = document.getElementById("ProvHistoryTab");

  var CurrentProvAppointmentsDiv = document.getElementById(
    "CurrentProvAppointmentsDiv"
  );
  var ProviderAppointmentHistoryDiv = document.getElementById(
    "ProviderAppointmentHistoryDiv"
  );

  ProvAppointmentsTab.style.backgroundColor = "cornflowerblue";
  ProvAppointmentsTab.style.border = "black 1px solid";

  ProvHistoryTab.style.backgroundColor = "#6699ff";
  ProvHistoryTab.style.border = "none";
  ProvHistoryTab.style.borderTop = "1px solid black";

  CurrentProvAppointmentsDiv.style.display = "none";
  ProviderAppointmentHistoryDiv.style.display = "block";
}

function activateServicesTab() {
  var Services = document.getElementById("Services");
  var HoursOpen = document.getElementById("HoursOpen");
  var Clients = document.getElementById("Clients");

  var ServiceListDiv = document.getElementById("ServiceListDiv");
  var hoursOpenDiv = document.getElementById("hoursOpenDiv");
  var clientsListDiv = document.getElementById("clientsListDiv");

  Clients.style.backgroundColor = "cornflowerblue";
  Clients.style.border = "black 1px solid";

  HoursOpen.style.backgroundColor = "cornflowerblue";
  HoursOpen.style.border = "1px solid black";

  Services.style.backgroundColor = "#ccccff";
  Services.style.border = "none";
  Services.style.borderTop = "1px solid black";

  ServiceListDiv.style.display = "block";
  hoursOpenDiv.style.display = "none";
  clientsListDiv.style.display = "none";
}

function activateHourOpenTab() {
  var Services = document.getElementById("Services");
  var HoursOpen = document.getElementById("HoursOpen");
  var Clients = document.getElementById("Clients");

  var ServiceListDiv = document.getElementById("ServiceListDiv");
  var hoursOpenDiv = document.getElementById("hoursOpenDiv");
  var clientsListDiv = document.getElementById("clientsListDiv");

  Services.style.backgroundColor = "cornflowerblue";
  Services.style.border = "black 1px solid";

  Clients.style.backgroundColor = "cornflowerblue";
  Clients.style.border = "1px solid black";

  HoursOpen.style.backgroundColor = "#ccccff";
  HoursOpen.style.border = "none";
  HoursOpen.style.borderTop = "1px solid black";

  ServiceListDiv.style.display = "none";
  hoursOpenDiv.style.display = "block";
  clientsListDiv.style.display = "none";
}

function activateClientsTab() {
  var Services = document.getElementById("Services");
  var HoursOpen = document.getElementById("HoursOpen");
  var Clients = document.getElementById("Clients");

  var ServiceListDiv = document.getElementById("ServiceListDiv");
  var hoursOpenDiv = document.getElementById("hoursOpenDiv");
  var clientsListDiv = document.getElementById("clientsListDiv");

  HoursOpen.style.backgroundColor = "cornflowerblue";
  HoursOpen.style.border = "black 1px solid";

  Services.style.backgroundColor = "cornflowerblue";
  Services.style.border = "1px solid black";

  Clients.style.backgroundColor = "#ccccff";
  Clients.style.border = "none";
  Clients.style.borderTop = "1px solid black";

  ServiceListDiv.style.display = "none";
  hoursOpenDiv.style.display = "none";
  clientsListDiv.style.display = "block";
}

function toggleShowEditPerInfoDiv() {
  var EditPerInfoDiv = document.getElementById("EditPerInfoDiv");

  if (EditPerInfoDiv.style.display === "none")
    $("#EditPerInfoDiv").slideDown("fast");
  else $("#EditPerInfoDiv").slideUp("fast");
}

function toggleShowEditBizInfoDiv() {
  var EditBizInfoDiv = document.getElementById("EditBizInfoDiv");

  if (EditBizInfoDiv.style.display === "none")
    $("#EditBizInfoDiv").slideDown("fast");
  else $("#EditBizInfoDiv").slideUp("fast");
}

function showCustExtraUsrAcnt() {
  document.getElementById("News").style.display = "none";
  document.getElementById("Calender").style.display = "none";
  document.getElementById("ExtrasNotificationDiv").style.display = "none";

  document.getElementById("PermDivNotiBtn").style.backgroundColor = "#334d81";
  document.getElementById("PermDivCalBtn").style.backgroundColor = "#334d81";

  if (
    document.getElementById("ExtrasUserAccountDiv").style.display === "none"
  ) {
    document.getElementById("PermDivUserBtn").style.backgroundColor = "#3d6999";
    $("#ExtrasUserAccountDiv").slideDown("fast");
  } else {
    document.getElementById("PermDivUserBtn").style.backgroundColor = "#334d81";
    $("#ExtrasUserAccountDiv").slideUp("fast");
    $("#News").slideDown("fast");
    document.getElementById("News").style.display = "block";
  }
}

function showCustExtraCal() {
  document.getElementById("News").style.display = "none";
  document.getElementById("ExtrasUserAccountDiv").style.display = "none";
  document.getElementById("ExtrasNotificationDiv").style.display = "none";

  document.getElementById("PermDivNotiBtn").style.backgroundColor = "#334d81";
  document.getElementById("PermDivUserBtn").style.backgroundColor = "#334d81";

  if (document.getElementById("Calender").style.display === "none") {
    document.getElementById("PermDivCalBtn").style.backgroundColor = "#3d6999";
    $("#Calender").slideDown("fast");
  } else {
    document.getElementById("PermDivCalBtn").style.backgroundColor = "#334d81";
    $("#Calender").slideUp("fast");
    $("#News").slideDown("fast");
    document.getElementById("News").style.display = "block";
  }
}

function showCustExtraNotification() {
  document.getElementById("News").style.display = "none";
  document.getElementById("ExtrasUserAccountDiv").style.display = "none";
  document.getElementById("Calender").style.display = "none";

  document.getElementById("PermDivCalBtn").style.backgroundColor = "#334d81";
  document.getElementById("PermDivUserBtn").style.backgroundColor = "#334d81";

  if (
    document.getElementById("ExtrasNotificationDiv").style.display === "none"
  ) {
    document.getElementById("PermDivNotiBtn").style.backgroundColor = "#3d6999";
    $("#ExtrasNotificationDiv").slideDown("fast");
  } else {
    document.getElementById("PermDivNotiBtn").style.backgroundColor = "#334d81";
    $("#ExtrasNotificationDiv").slideUp("fast");
    $("#News").slideDown("fast");
    document.getElementById("News").style.display = "block";
  }
}

function showCustExtraUsrAcnt2() {
  document.getElementById("News2").style.display = "none";
  document.getElementById("Calender2").style.display = "none";
  document.getElementById("ExtrasNotificationDiv2").style.display = "none";

  //document.getElementById("PermDivNotiBtn").style.backgroundColor = "#334d81";
  //document.getElementById("PermDivCalBtn").style.backgroundColor = "#334d81";

  if (
    document.getElementById("ExtrasUserAccountDiv2").style.display === "none"
  ) {
    //document.getElementById("PermDivUserBtn").style.backgroundColor = "blue";
    $("#Extras2").slideDown("fast");
    $("#ExtrasUserAccountDiv2").slideDown("fast");
  } else {
    //document.getElementById("PermDivUserBtn").style.backgroundColor = "#334d81";
    $("#ExtrasUserAccountDiv2").slideUp("fast");
    $("#Extras2").slideUp("fast");
    //document.getElementById("News2").style.display = "block";
  }
}

function showCustExtraCal2() {
  document.getElementById("News2").style.display = "none";
  document.getElementById("ExtrasUserAccountDiv2").style.display = "none";
  document.getElementById("ExtrasNotificationDiv2").style.display = "none";

  //document.getElementById("PermDivNotiBtn").style.backgroundColor = "#334d81";
  //document.getElementById("PermDivUserBtn").style.backgroundColor = "#334d81";

  if (document.getElementById("Calender2").style.display === "none") {
    //document.getElementById("PermDivCalBtn").style.backgroundColor = "blue";
    $("#Extras2").slideDown("fast");
    $("#Calender2").slideDown("fast");
    //document.getElementById("Extras2").style.display = "block";
  } else {
    //document.getElementById("PermDivCalBtn").style.backgroundColor = "#334d81";
    $("#Calender2").slideUp("fast");
    $("#Extras2").slideUp("fast");
    //document.getElementById("Extras2").style.display = "none";
    //document.getElementById("News2").style.display = "block";
  }
}

function showCustExtraNotification2() {
  document.getElementById("News2").style.display = "none";
  document.getElementById("ExtrasUserAccountDiv2").style.display = "none";
  document.getElementById("Calender2").style.display = "none";

  //document.getElementById("PermDivCalBtn").style.backgroundColor = "#334d81";
  //document.getElementById("PermDivUserBtn").style.backgroundColor = "#334d81";

  if (
    document.getElementById("ExtrasNotificationDiv2").style.display === "none"
  ) {
    //document.getElementById("Extras2").style.display = "block";
    //document.getElementById("PermDivNotiBtn").style.backgroundColor = "blue";
    $("#Extras2").slideDown("fast");
    $("#ExtrasNotificationDiv2").slideDown("fast");
  } else {
    //document.getElementById("PermDivNotiBtn").style.backgroundColor = "#334d81";
    $("#ExtrasNotificationDiv2").slideUp("fast");
    $("#Extras2").slideUp("fast");
    //document.getElementById("Extras2").style.display = "none";
    //document.getElementById("News2").style.display = "block";
  }
}

function showCustExtraNews() {
  document.getElementById("ExtrasNotificationDiv2").style.display = "none";
  document.getElementById("ExtrasUserAccountDiv2").style.display = "none";
  document.getElementById("Calender2").style.display = "none";

  //document.getElementById("PermDivCalBtn").style.backgroundColor = "#334d81";
  //document.getElementById("PermDivUserBtn").style.backgroundColor = "#334d81";

  if (document.getElementById("News2").style.display === "none") {
    //document.getElementById("PermDivNotiBtn").style.backgroundColor = "blue";
    $("#Extras2").slideDown("fast");
    $("#News2").slideDown("fast");
    //document.getElementById("Extras2").style.display = "block";
  } else {
    //document.getElementById("PermDivNotiBtn").style.backgroundColor = "#334d81";
    $("#News2").slideUp("fast");
    $("#Extras2").slideUp("fast");
    //document.getElementById("Extras2").style.display = "none";
    //document.getElementById("News2").style.display = "block";
  }
}

//----------------------------------------------

function showAppointmentsTr() {
  document.getElementById("AppointmentsTrBtn").style.backgroundColor =
    "#eeeeee";
  document.getElementById("EventsTrBtn").style.backgroundColor = "#ccc";
  document.getElementById("EventsTr").style.display = "none";
  document.getElementById("AppointmentsTr").style.display = "block";
}
function showEventsTr() {
  document.getElementById("EventsTrBtn").style.backgroundColor = "#eeeeee";
  document.getElementById("AppointmentsTrBtn").style.backgroundColor = "#ccc";
  document.getElementById("AppointmentsTr").style.display = "none";
  document.getElementById("EventsTr").style.display = "block";
}

function showAppointmentsTr2() {
  document.getElementById("AppointmentsTrBtn2").style.backgroundColor =
    "#eeeeee";
  document.getElementById("EventsTrBtn2").style.backgroundColor = "#ccc";
  document.getElementById("EventsTr2").style.display = "none";
  document.getElementById("AppointmentsTr2").style.display = "block";
}
function showEventsTr2() {
  document.getElementById("EventsTrBtn2").style.backgroundColor = "#eeeeee";
  document.getElementById("AppointmentsTrBtn2").style.backgroundColor = "#ccc";
  document.getElementById("AppointmentsTr2").style.display = "none";
  document.getElementById("EventsTr2").style.display = "block";
}

function showPCustExtraUsrAcnt() {
  document.getElementById("PhoneNews").style.display = "none";
  document.getElementById("PhoneCalender").style.display = "none";
  document.getElementById("PhoneExtrasNotificationDiv").style.display = "none";

  if (
    document.getElementById("PhoneExtrasUserAccountDiv").style.display ===
    "none"
  ) {
    $("#PhoneExtrasUserAccountDiv").slideDown("fast");
  }
}

function showPCustExtraCal() {
  document.getElementById("PhoneNews").style.display = "none";
  document.getElementById("PhoneExtrasUserAccountDiv").style.display = "none";
  document.getElementById("PhoneExtrasNotificationDiv").style.display = "none";

  if (document.getElementById("PhoneCalender").style.display === "none") {
    $("#PhoneExtras").slideDown("fast");
    $("#PhoneCalender").slideDown("fast");
  }
}

function showPCustExtraNotification() {
  document.getElementById("PhoneNews").style.display = "none";
  document.getElementById("PhoneExtrasUserAccountDiv").style.display = "none";
  document.getElementById("PhoneCalender").style.display = "none";

  if (
    document.getElementById("PhoneExtrasNotificationDiv").style.display ===
    "none"
  ) {
    $("#PhoneExtras").slideDown("fast");
    $("#PhoneExtrasNotificationDiv").slideDown("fast");
  }
}

function showPCustExtraNews() {
  document.getElementById("PhoneExtrasNotificationDiv").style.display = "none";
  document.getElementById("PhoneExtrasUserAccountDiv").style.display = "none";
  document.getElementById("PhoneCalender").style.display = "none";

  if (document.getElementById("PhoneNews").style.display === "none") {
    $("#PhoneExtras").slideDown("fast");
    $("#PhoneNews").slideDown("fast");
  }
}

//-------------------------------------------

function hideExtraDropDown() {
  document.getElementById("ExtraDropDown").style.display = "none";
}

//Everything that needs internet always at bottom

$(function() {
  $("#datepicker").datepicker();
});

function toggleHideAppointmentsDiv() {
  var appointmentsDiv = document.getElementById("appointmentsDiv");
  var hideAppointments = document.getElementById("hideAppointments");

  //important for just onetime click.
  //appointmentsDiv.style.display = "block";

  if (appointmentsDiv.style.display === "block") {
    $("#appointmentsDiv").fadeOut("fast");
    hideAppointments.innerHTML = "Show Spots";
    $("html, body").animate({ scrollTop: 0 }, "fast");
    appointmentsDiv.style.display = "none";
  } else {
    $("html, body").animate({ scrollTop: 298 }, "fast");
    $("#appointmentsDiv").fadeIn("slow");
    hideAppointments.innerHTML = "Hide Spots";
    appointmentsDiv.style.display = "block";
  }
}

function showProfile() {
  $("html, body").animate({
    scrollTop: $("#newbusiness").position().top
  });
}

function hideProvApptListAndMkReservForMobile() {
  if ($(window).width() < 1000) {
    var appointmentsDiv = document.getElementById("appointmentsDiv");
    var hideAppointments = document.getElementById("hideAppointments");

    appointmentsDiv.style.display = "none";
    hideAppointments.innerHTML = "Show Spots";
    //hideAppointments.style.backgroundColor = "red";
    hideAppointments.style.color = "white";

    document.getElementById("MakeReservationForm").style.display = "none";
  } else {
    // change functionality for larger screens
  }
}

if (
  document.getElementById("hideAppointments") &&
  document.getElementById("appointmentsDiv")
) {
  hideProvApptListAndMkReservForMobile();
}

$(window).scroll(function() {
  if ($(window).scrollTop() > 100) {
    $("#miniNav").fadeIn("slow");
  }
});
$(window).scroll(function() {
  if ($(window).scrollTop() < 100) {
    $("#miniNav").fadeOut("fast");
  }
});

function scrollToTop() {
  $("html, body").animate({ scrollTop: 0 }, "fast");
}

//open new window not working with google chrome
function showPhotoUploadwindow() {
  window.open(
    "./UploadPhotoWindow.jsp",
    "_blank",
    "resizable=yes, scrollbars=yes, titlebar=yes, width=600, height=500, top=10, left=10"
  );
  //"height=500,width=600,status=yes,toolbar=no,menubar=no,location=no");
}

/*var HeightFirstAttemp = false;
var pageHeight = 0;
var pageWidth = 0;

function GetPageHeight(){
    
    if(HeightFirstAttemp === false){
        pageHeight = $("body").height();
        pageWidth = $("body").width();
    }
    
    HeightFirstAttemp = true;
    
    //alert(pageHeight);   
    //alert(pageWidth);
}

GetPageHeight();*/

function setBodyToScroll(){
    
    if($("body").height() < 720 && $("body").width() > 1000){
        
        document.getElementById("footer").style.display = "none";
        //document.getElementById("content").style.height = "auto";
        document.getElementById("main").style.minHeight = "700px";
        
        document.querySelector(".DashboardContent").style.height = "700px";
        document.querySelector(".Main").style.height = "700px";
        
        document.getElementsByTagName("body")[0].style.position = "static";
        document.getElementsByTagName("body")[0].style.height = "700px";
        document.getElementsByTagName("body")[0].style.overflowY = "scroll";
        
    }
    
}

setBodyToScroll();

/*var allHrefs = document.getElementsByTagName("a");

$(document).ready(function() {
    for(k = 0; k < allHrefs.length; k++){
        function(){
            $("a")[k].click(function() {
                alert("clicked");
              document.getElementById("PageLoader").style.display = "block";
            });
        };
    }
});*/

/*window.addEventListener("beforeunload", function () {
  document.body.classList.add("animate-out");
  //$("body").slideDown("fast");
    //$("#News2").slideDown("fast");
});*/