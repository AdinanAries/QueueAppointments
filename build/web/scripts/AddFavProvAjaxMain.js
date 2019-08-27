function login(number){  

  var email = document.nameForm.email.value;  
  $.ajax({  
    type: "GET",  
    url: "ProcessForm",  
    data: "email="+email,  
    success: function(result){  
      alert(result);
    }                
  });  
}