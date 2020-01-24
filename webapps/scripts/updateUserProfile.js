var UpdateUserAccountForm = document.getElementById("UpdateUserAccountForm");
var SendFeedBackForm = document.getElementById("SendFeedBackForm");

function showUserProfileForm(){
	
	if(UpdateUserAccountForm.style.display === "none"){
		
		if(SendFeedBackForm.style.display === "block"){
			
			SendFeedBackForm.style.display = "none";
			
		}
		$("#UpdateUserAccountForm").slideDown("fast");
		UpdateUserAccountForm.style.display = "block";
		
		
	}else{
		
		$("#UpdateUserAccountForm").slideUp("fast");
		
	}
	
}

function showUserFeedBackForm(){
	
	if(SendFeedBackForm.style.display === "none"){
		
		if(UpdateUserAccountForm.style.display === "block"){
			
			UpdateUserAccountForm.style.display = "none";
		}
		$("#SendFeedBackForm").slideDown("fast");
		SendFeedBackForm.style.display = "block";
		
	}else{
		
		$("#SendFeedBackForm").slideUp("fast");
		
	}
	
}