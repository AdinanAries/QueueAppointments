//this file helps to collect the address data for the different address fields

var businessLocation = document.getElementById("businessLocation");

var HouseNumber = document.getElementById("HouseNumber");
var Street = document.getElementById("Street");
var Town = document.getElementById("Town");
var City = document.getElementById("City");
var ZCode = document.getElementById("ZCode");
var Country = document.getElementById("Country");

function SetAddressAddressLocation(){
	
    if(HouseNumber.value == "" || Street.value == "" || Town.value == "" ||
        City.value == "" || ZCode.value == "" || Country.value == ""){
        document.getElementById('AddrStatusIcon').classList.remove('fa-check');
	document.getElementById('AddrStatusIcon').classList.add('fa-exclamation-triangle');
        document.getElementById('AddrStatusIcon').style.color = "red";
    }
    else{
        document.getElementById('AddrStatusIcon').classList.remove('fa-exclamation-triangle');
	document.getElementById('AddrStatusIcon').classList.add('fa-check');
        document.getElementById('AddrStatusIcon').style.color = "#58FA58";
	businessLocation.style.color = "white";
    }
	
	var HouseNumberValue = HouseNumber.value;
	var StreetValue = Street.value;
	var TownValue = Town.value;
	var CityValue = City.value;
	var ZCodeValue = ZCode.value;
	var CountryValue = Country.value;
	
	businessLocation.value = HouseNumberValue + " " + StreetValue + ", " + TownValue + ", " +
				    CityValue + ", " + ZCodeValue + " " + CountryValue;
	
}

setInterval(SetAddressAddressLocation, 1);