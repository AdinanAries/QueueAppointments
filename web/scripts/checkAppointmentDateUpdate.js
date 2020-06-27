var datepicker = document.getElementById("datepicker");
var datePickerStatus = document.getElementById("datePickerStatus");

var currentDate = new Date();

var currentMonth = currentDate.getMonth();
currentMonth += 1;
currentMonth += "";
	
if(currentMonth.length < 2)
    currentMonth = "0" + currentMonth;
	
var currentDay = currentDate.getDate() + "";

if(currentDay.length < 2)
   currentDay = "0" + currentDay;
	
var currentYear = currentDate.getFullYear();

currentDate = currentMonth + "/" + currentDay + "/" + currentYear;

if(document.getElementById("datePickerStatus"))
    datePickerStatus.innerHTML = "";


function checkDateUpdateValue(){

    var datepickerValue = datepicker.value;

    var datePickerDateObject = new Date(datepickerValue);

    if(datePickerDateObject < (new Date())){
			
	if(datepickerValue === currentDate){
				
	    if(datePickerStatus.innerHTML == ""){
		datePickerStatus.innerHTML = "Today's Date: " + currentDate;
		datePickerStatus.style.backgroundColor = "green";
            }
				
	}
	else{
	    datePickerStatus.innerHTML = "Only today's date or future date allowed";
            datePickerStatus.style.backgroundColor = "red";
	    datepicker.value = currentDate;
	}
    }
    else{
		
	datePickerStatus.innerHTML = "";
	//datePickerStatus.innerHTML = "Chosen Date: " + datepicker.value;
	//datePickerStatus.style.backgroundColor = "green";
    }
	
}

if(document.getElementById("datepicker"))
    setInterval(checkDateUpdateValue, 1);

