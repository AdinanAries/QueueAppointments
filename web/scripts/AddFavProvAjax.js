//Ajax for adding favorite providers by clients

     
    $(document).ready(function() {                        
        $('#submit').click(function(event) {  
            var username= $('#user').val();
        $.get('ActionServlet',{user:username},function(responseText) { 
            $('#welcometext').text(responseText);         
                    });
                });
    });
	
	
	$(document).ready(function() {

 $.ajax({
 url : './GetURL',
 dataType : "json",
 type : "Post",
 success : function(result) {
    alert(result);

 },
 error : function(responseText) {
   alert("error");
 }
 });

});
        