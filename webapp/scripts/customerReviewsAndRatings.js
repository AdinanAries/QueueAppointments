

function toggleShowReviewsForm(number){
	
	var deleteFormName = "deleteAppointmentHistoryForm" + number;
	var deleteForm = document.getElementById(deleteFormName);
	
	var formName = "ratingAndReviewForm" + number;
	var thisForm = document.getElementById(formName);
	
	var addFavformName = "addFavProvFormFromRecent" + number;
	var addFavForm = document.getElementById(addFavformName);
	
	if(thisForm.style.display === "none"){
		
		if(addFavForm.style.display === "block"){
			addFavForm.style.display = "none";
		}
		
		if(deleteForm.style.display === "block"){
			deleteForm.style.display = "none";
		}
		
		thisForm.style.display = "block";
		
	}else{
		
		thisForm.style.display = "none";
		
	}
	
	
}