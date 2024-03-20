<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Loan One System</title>
<script src="js/jquery-3.6.1.js" type="text/javascript"></script>
<script src="js/jquery.validate.min.js" type="text/javascript"></script>
<script src="js/additional-methods.min.js" type="text/javascript"></script>
 <!-- Bootstrap -->
<link href="css/bootstrap-5.2.3.css" rel="stylesheet">
<link rel="shortcut icon" href="./favicon.ico"/>
<link href="css/styles.css" rel="stylesheet" type="text/css">

<script type="text/javascript">

var curMod = null;
//$(document).ready(function(){

	function doMessage(msg)
	{
		
		$('#ln1subFooter').html(msg +  curMod);
			
	}
	
	function getModules()
  	{
			
		$.ajax({		 				
				url : 'Loan1Ctrl',
				type: 'POST',
				data : {"uid": <%=session.getAttribute("uid")%>, "moduleid": 2},
				dataType: 'JSON',
		
				success:function(data)
				{
					//$('#ln1Menu').html(data);
					
					var obj = JSON.parse(JSON.stringify(data));
					var menus = '';

					for( var i = 0; i < obj.length; i++ ) {			    					
						//menus+='<li class="nav-item"><a class="nav-link" href="#">' + obj[i].name + '</a></li>';
						menus+='<a href = "#"  id = "M"'+obj[i].id+' onClick = "openModule(\''+obj[i].url+'\');">'+ obj[i].name +' </a>';
						//menus += '<a href="#">' + obj[i].name + '</a>';
					}
					$('#ln1Menu').html(menus);
					//$('#ln1Footer').html("Invalid Credentials") 
					//openModule('welcome.jsp');
				}					
 			}).fail(function (errorobj, textstatus, error) { 
 				var responseText = errorobj.responseText.trim() ;
 				//alert("Ingia hapa"+responseText)
 				$('#ln1Footer').html(responseText);
 			});  			
  			
  	}

	function openModule(url)
	{
		if(curMod == null)
		{
		  $("#ln1Module").load("./"+url, function(responseTxt, statusTxt, xhr){
		    if(statusTxt == "success")
		    	$('#ln1Footer').html("External content loaded successfully!");
		    if(statusTxt == "error")
		    	$('#ln1Footer').html("Error: " + xhr.status + ": " + xhr.statusText);
		  });
		}
		else
		{
			//alert("Closed the module first");
			doMessage("Closed the module first");
		}
	}
//});

</script>	
</head>
<body>

<%
if(session.getAttribute("uname")==null){
	
	response.sendRedirect("login.jsp");
}

%>

<div id="ln1Header" align="center" style="border: 1px solid gray; width: 99%; height: 50px; background-color: gray;"> 
	<h3 style="color: white;">Loan One System</h3>
</div>

<div id="ln1Menu" class="vertical-menu" style="border: 1px solid gray; width: 15%; height: 600px; float: left; background-color: gray;" > 

	<nav class="navbar bg-light">
	  <ul class="navbar-nav" id="menu1">
	    <li class="nav-item">
	      <a class="nav-link" href="#">Person</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link" href="#">Loan Application</a>
	    </li>
	    
	    <!-- Dropdown -->
	    <li class="nav-item dropdown">
	      <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
	        Dropdown link
	      </a>
	      <div class="dropdown-menu">
	        <a class="dropdown-item" href="#">Link 1</a>
	        <a class="dropdown-item" href="#">Link 2</a>
	        <a class="dropdown-item" href="#">Link 3</a>
	      </div>
	    </li>
	  </ul>
	
	</nav>
</div>

<div id="ln1Module" style="border: 1px solid gray; width: 84%; height: 600px; float: left;"> 
	
</div>

<div id="ln1Footer" align="center" style="border: 1px solid gray; width: 99%; height: 80px; margin-top: 600px;">  
<h1>Welcome <%=session.getAttribute("uname") %></h1>
</div>
<script type="text/javascript">
	getModules();
</script>	
</body>
</html>