
function setSuggestedTime(number){
	
	//-------------------------------------------------------
	var HHSelector = document.getElementById("HHSelector");
	var MMSelector = document.getElementById("MMSelector");
	
	HHSelector.selectedIndex = 0;
	MMSelector.selectedIndex = 0;
	//---------------------------------------------------------
	
	var DivName = "AvailableTimeDiv" + number;
	var AvailableTimeDiv = document.getElementById(DivName);
	
	var FormattedTimeName = "FormattedTimeAvalible" + number;
	var FormattedTimeAvalible = document.getElementById(FormattedTimeName);
	
	var AvailableTimeName = "TimeAvailable" + number;
	var TimeAvailable = document.getElementById(AvailableTimeName);
	
	var formsTimeValue = document.getElementById("formsTimeValue");
	var displayTime = document.getElementById("displayTime");
	var ShowThisAppointmentTimeForFinishAppointmentWindow =
		document.getElementById("ShowThisAppointmentTimeForFinishAppointmentWindow");
	var SuggestedTimeDivStatus = document.getElementById("SuggestedTimeDivStatus");
	
	formsTimeValue.value = TimeAvailable.innerHTML;
	displayTime.innerHTML = FormattedTimeAvalible.innerHTML;
	
	if(ShowThisAppointmentTimeForFinishAppointmentWindow !== null)
		ShowThisAppointmentTimeForFinishAppointmentWindow.innerHTML = "";
	
	//SuggestedTimeDivStatus.style.backgroundColor = "green";
	SuggestedTimeDivStatus.innerHTML = "<i style='color: green' class='fa fa-check'></i> Appointment time has been set to " + FormattedTimeAvalible.innerHTML;
	
	var DivColor = AvailableTimeDiv.style.backgroundColor;
	
	AvailableTimeDiv.style.backgroundColor = "darkgrey";
	
}

function showSuggestedTime(){
	
	var AllSuggestedTimeDiv = document.getElementById("AllSuggestedTimeDiv");
	var showAllSuggestedTimeBtn = document.getElementById("showAllSuggestedTimeBtn");
	
	showAllSuggestedTimeBtn.style.display = "none";
	AllSuggestedTimeDiv.style.display = "block";
}