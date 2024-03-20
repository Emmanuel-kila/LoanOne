<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<style>
		.outer {
		  display: table;
		  position: absolute;
		  top: 0;
		  /*left: 0;*/
		  height: 100%;
		  width: 100%;
		}

		.middle {
		  display: table-cell;
		  vertical-align: middle;
		}

		.inner {
		  margin-left: auto;
		  margin-right: auto;
		  width: 450px;
		  text-align: center;
		  border-width: 2px; 
		  border-color: #6D31EDFF; /* primary-500 */
		  border-style: solid; 
		  box-shadow: 0px 0px 1px
		  /* Whatever width you want */
		}
		.button {
			width: 150px;
		}
	</style>
<meta charset="utf-8">
<title>Welcome</title>
<link rel="shortcut icon" href="./favicon.ico"/>
<script src="js/jquery-3.6.1.js" type="text/javascript"></script>
<script src="js/jquery.validate.min.js" type="text/javascript"></script>
<script src="js/additional-methods.min.js" type="text/javascript"></script>
<!-- <script src="https://code.jquery.com/jquery-1.11.1.min.js"></script> -->
<!--<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script> -->
<!--<script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/additional-methods.min.js"></script> -->
<script type="text/javascript">
$(document).ready(function(){

	$('#btnLogin').click(function()
  		{
			
			$("#frmLogin").validate();
  			if($("#frmLogin").valid())
  			{
				$.ajax({		
	  				
	  					url : 'Loan1Ctrl',
	  					type: 'POST',
	  					data : $('#frmLogin').serialize(),
	  					dataType: 'JSON',
	  			
	  					success:function(data)
	  					{
	  	  					var obj = JSON.parse(JSON.stringify(data));
	  	  					var lstatus =obj[0].success;
	  						//$('#errZone').html(obj[0].success);
	  						if (lstatus=="OK"){
	  							window.open("Loan1.jsp", "_self", "toolbar=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=400,height=400");
	  						}
	  						else
	  						{
	  							$('#errZone').html("Invalid Credentials")
	  						}
	  						
	  					}					
	  			}).fail(function (errorobj, textstatus, error) { 
	  				var responseText = errorobj.responseText.trim() ;
	  				//alert("Ingia hapa"+responseText)
	  				$('#errZone').html(responseText);
	  			});  			
  			}
  		});

});
</script>
</head>

<body>

	<div class="outer">
  		<div class="middle">
    		<div class="inner">
    			<form id="frmLogin" name="frmLogin">
    			<input type="hidden" id="moduleid" name="moduleid" value="1">
				<h1>Login</h1>
      			<p>	<label for="username"><b>User Name :</b></label> &nbsp; <input type="text" id="username" name="username" size="30" required autocomplete="off"></p>
				<p>	<label for="password">&nbsp;&nbsp;&nbsp;<b>Password :</b></label> &nbsp; <input type="password" id="passkey" name="passkey" size="30" required></p>
				<p align="center"><input type="button" value ="OK" id="btnLogin" class="button"></p>
				<p id='errZone' style="color: red; font-weight: bold; font-size: 16px;">.</p>
				</form>
			</div> 
		</div>
	</div>
</body>
</html>