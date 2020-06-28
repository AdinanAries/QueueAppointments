function showLineTakenMessage(number){
	
	var name = "LineTakenMessage" + number;
	var object = document.getElementById(name);
	object.style.display = "block";
	
}

function showYourPositionMessage(number){
	
	var name = "YourLinePositionMessage" + number;
	var object = document.getElementById(name);
	object.style.display = "block";
	
}

function ShowQueueLinDivBookAppointment(number){
	
	var name = "bookAppointmentFromLineDiv" + number;
	var object = document.getElementById(name);
	object.style.display = "block";
	
}
$(document).ready(function(){
    
    function setBodyToScroll(){
        
        if($("body").height() < 720 && $("body").width() > 1000){
            //alert("here");
            document.getElementById("footer").style.display = "none";
            document.getElementById("ExtraproviderIcons").style.paddingTop = "15px";
            document.getElementById("newbusiness").style.height = (($("body").height()) - 120) + "px";
            document.getElementById("content").style.height = (($("body").height()) - 30) + "px";
            //document.getElementById("content").style.height = "auto";
            //document.getElementById("main").style.minHeight = "700px";
            //alert("here");
            //document.querySelector(".DashboardContent").style.height = "700px";
            //document.querySelector(".Main").style.height = "700px";

            document.getElementsByTagName("body")[0].style.position = "static";
            document.getElementsByTagName("body")[0].style.height = "auto";
            //document.getElementsByTagName("body")[0].style.overflowY = "scroll";

        }
    }


    //alert("here");
    setBodyToScroll();
    
});

$(document).ready(()=>{
    function showPassword(){

        document.querySelectorAll(".showPassword").forEach((showPasswordBtn) => {

            if(showPasswordBtn.classList.contains("fa-eye")){
                showPasswordBtn.classList.remove("fa-eye");
                showPasswordBtn.classList.add("fa-eye-slash");
            }else{
                showPasswordBtn.classList.remove("fa-eye-slash");
                showPasswordBtn.classList.add("fa-eye");
            }
        });
        document.querySelectorAll(".passwordFld").forEach((passwordFld) =>{
            if(passwordFld.type === "password"){
                passwordFld.type = "text";
            }else{
                passwordFld.type = "password";
            }
        });
    }

    $(".showPassword").click(()=>{
        showPassword();
    });
});