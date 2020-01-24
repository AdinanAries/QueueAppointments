
var dateElement = document.getElementById("datepicker");
var dateStatus = document.getElementById("datepickerStatus");
var finalDate = document.getElementById("formsDateValue");

var HHSelector = document.getElementById("HHSelector");
var MMSelector = document.getElementById("MMSelector");
var AmPmSelector = document.getElementById("AmPmSelector");
var timeFld = document.getElementById("formsTimeValue");

var AmPmString = "am";
var SelectedTime;

var currentDate = new Date();

var currentHours = currentDate.getHours();
var currentMinutes = currentDate.getMinutes();

if(currentHours > 11){

	if(currentHours  === 12){
		AmPmString = "pm";
	}
	else{
		AmPmString = "pm";
		currentHours -= 12;
	}

}
else if(currentHours === 0){
	currentHours = 12;
	AmPmString = "am";
}




var	actualMonthValue = currentDate.getMonth();
var currentMonth = currentDate.getMonth();
	currentMonth += 1;
	currentMonth += "";
	
var MonthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

var actualDayValue = currentDate.getDate();
var currentDay = currentDate.getDate() + "";
 
var currentYear = currentDate.getFullYear() + "";


if(currentMonth.length < 2 ){
	currentMonth = "0" + currentMonth;
}

if(currentDay.length < 2){
	currentDay = "0" + currentDay;
}

currentDate = currentMonth + "/" + currentDay + "/" + currentYear;

var formattedDate = MonthArray[actualMonthValue] + " " + actualDayValue + ", " + currentYear;


function initializeDate(){
	
	if(dateElement.value === "click here to choose date"){
		dateElement.value = currentDate;
		finalDate.value = currentDate;
	}
	
}

initializeDate();

function checkDate(){
	
	
	var dateElementValue = new Date(dateElement.value);
	
	var datevalue = "";
	var formattedDateValue = "";
	
	if(dateElement.value !== "click here to choose date"){
		
		if(dateElement.value === ""){
			dateElement.value = currentDate;
		}
		
		datevalue = dateElement.value;
		
		var dateValueMonth = datevalue.substring(0,2);
		dateValueMonth = parseInt(dateValueMonth, 10);
		dateValueMonth -= 1;
		
		var dateValueDay = datevalue.substring(3,5);
		dateValueDay = parseInt(dateValueDay, 10);
		
		var dateValueYear = datevalue.substring(6,10);
		
		formattedDateValue = MonthArray[dateValueMonth] + " " + dateValueDay + ", " + dateValueYear;
	
	
		document.getElementById("dateDisplay").innerHTML = "";
		document.getElementById("DateStatus").innerHTML = "";
		
		//hidding the suggested time div incase date is not a today's date
		
		var QueuLineDiv = document.getElementById("QueuLineDiv");
		var HideSuggestedTimeDivStatus = document.getElementById("HideSuggestedTimeDivStatus");
		
		
		if(dateElementValue > (new Date())){
			
			HideSuggestedTimeDivStatus.style.backgroundColor = "red";
			HideSuggestedTimeDivStatus.innerHTML = "Set date to today to see time suggestions";
			QueuLineDiv.style.display = "none";
		
		}
		else{
			
			HideSuggestedTimeDivStatus.innerHTML = "";
			QueuLineDiv.style.display = "block";
			
		}
		
		
		//------------------------------------------------------------------
		
		
		if(dateElementValue < (new Date())){ 
			
			if(dateElement.value == currentDate){
				document.getElementById("dateDisplay").innerHTML = formattedDateValue;
				document.getElementById("DateStatus").innerHTML = formattedDateValue;
				
				finalDate.value = datevalue;
			}
				
			else{
				dateStatus.innerHTML = " choose current date or future date only";
				
				dateElement.value = currentDate;
				document.getElementById("dateDisplay").innerHTML = formattedDateValue;
				document.getElementById("DateStatus").innerHTML = formattedDateValue;
				
				finalDate.value = datevalue;
			}
		}
		else{
			dateStatus.innerHTML = "";
			document.getElementById("dateDisplay").innerHTML = formattedDateValue;
			document.getElementById("DateStatus").innerHTML = formattedDateValue;
			
			finalDate.value = datevalue;
		}
	}
	
	if(document.getElementById("dateDisplay").innerHTML  === "undefined NaN, "){
		
		document.getElementById("dateDisplay").innerHTML = "";
		document.getElementById("DateStatus").innerHTML = "";
		
	}
		
}

setInterval(checkDate,1);



function showTime(){
	
	if(HHSelector.value !== "HH" && MMSelector.value !== "MM"){
		
		if(dateElement.value === currentDate && ((AmPmSelector.value ===  AmPmString 
			 && currentHours !== 12 && parseInt(HHSelector.value, 10) < currentHours ) 
			 || (AmPmSelector.value === "am" && AmPmString === "pm"))){ //if current time is in "PM" you can't select anything with "AM"(AM always in the past)
				 
			//timeFld.value = "";
			//document.getElementById("displayTime").innerHTML = "";
			document.getElementById("timeStatus").innerHTML = "Selected time is in the past";
			document.getElementById("timeStatus").style.backgroundColor = "red";
		
		}
		
		else if(dateElement.value === currentDate && (parseInt(HHSelector.value, 10) === 12 && currentHours !== 12)
				&& AmPmSelector.value === "pm" && AmPmString == "pm"){
			
			//timeFld.value = "";
			//document.getElementById("displayTime").innerHTML = "";
			document.getElementById("timeStatus").innerHTML = "Selected time is in the past";
			document.getElementById("timeStatus").style.backgroundColor = "red";
			
		}
		
		else if(dateElement.value === currentDate && (parseInt(HHSelector.value, 10) === currentHours && AmPmSelector.value ===  AmPmString)
				&& parseInt(MMSelector.value, 10) < currentMinutes){
			
			timeFld.value = "";
			document.getElementById("displayTime").innerHTML = "";
			document.getElementById("timeStatus").innerHTML = "Selected time is in the past";
			document.getElementById("timeStatus").style.backgroundColor = "red";
		
		}
			
		else{
			
			var HHValue = HHSelector.value;
			var MMValue = MMSelector.value;
			var AmPmValue = AmPmSelector.value;
			
			SelectedTime = HHValue + ":" + MMValue + " " + AmPmValue;
			
			document.getElementById("displayTime").innerHTML = SelectedTime;
			document.getElementById("timeStatus").innerHTML = SelectedTime;
			document.getElementById("timeStatus").style.backgroundColor = "green";
			
			HHValue = parseInt(HHValue, 10);
			
			if(AmPmValue === "pm"){
				
				if(HHValue == 12){
					HHValue = "12"; 
				}
				else if(HHValue < 12){
					HHValue += 12;
					HHValue += "";
				}
			}
			
			else if(AmPmValue == "am" && HHValue == 12){
				HHValue = "00";
				
			}
			
			var finalTime = HHValue + ":" + MMValue;
			
			timeFld.value = finalTime;
		}
		
		
	}
	else{
		
		//document.getElementById("displayTime").innerHTML = "";
		//document.getElementById("timeStatus").innerHTML = "";
		
	}

	
}

setInterval(showTime,1);


function showCustomizeDate(){
	
	var customizeAppointmentTime = document.getElementById("customizeAppointmentTime");
	var showCustomizeTimeBtn = document.getElementById("showCustomizeTimeBtn");
	var ShowThisAppointmentTimeForFinishAppointmentWindow = document.getElementById("ShowThisAppointmentTimeForFinishAppointmentWindow");
	
	if(ShowThisAppointmentTimeForFinishAppointmentWindow != null){
		ShowThisAppointmentTimeForFinishAppointmentWindow.style.display = "none";
	}
	customizeAppointmentTime.style.display = "block";
	showCustomizeTimeBtn.style.display = "none";
	
}
