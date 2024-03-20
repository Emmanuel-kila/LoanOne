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
<script src="js/popper.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
 <!-- Bootstrap -->
<link href="css/bootstrap-5.2.3.css" rel="stylesheet">
<link rel="shortcut icon" href="./favicon.ico"/>
<link href="css/styles.css" rel="stylesheet" type="text/css">
<link href="css/style-navbar.css" rel="stylesheet">

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
					var previd =''

					for( var i = 0; i < obj.length; i++ ) {			    					
						//menus+='<li class="nav-item"><a class="nav-link" href="#">' + obj[i].name + '</a></li>';
						//menus+='<a href = "#"  id = "M"'+obj[i].id+' onClick = "openModule(\''+obj[i].url+'\');">'+ obj[i].name +' </a>';
						//menus += '<a href="#">' + obj[i].name + '</a>';
						if (previd != obj[i].main_menuid)
						{
							menus += '<li> <a href="#mm'+ obj[i].main_menuid +'" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">'
							+ obj[i].menu_name +'</a> <ul class="collapse list-unstyled" id="mm'+ obj[i].main_menuid +'">';
							
							menus += 	'<li> <a href="#" id = "M'+obj[i].id+'" onClick = "openModule(\''+obj[i].url+'\');">'+ obj[i].name +'</a></li>'
							previd = obj[i].main_menuid;
						}
						else
						{
							menus += 	'<li> <a href="#" id = "M'+obj[i].id+'" onClick = "openModule(\''+obj[i].url+'\');">'+ obj[i].name +'</a></li>'
						}
						
						if( obj.length==i+1 || (obj.length>i+1 && previd != obj[i+1].main_menuid ))
						{
							menus += '</ul></li>'	
						}
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

<div class="wrapper">
        <!-- Sidebar  -->
        <nav id="sidebar">
        	<div id="logo2" class="rounded-image" align="center">
    			<img src="images/Logo2.jpg" alt="Loan One">
  			</div>
            <div class="sidebar-header">
                <h3></h3>
            </div>

			
			<ul class="list-unstyled components">
				<!--  <p>Dummy Heading</p> -->
				<div id="ln1Menu">
					<li class="active">
						<a href="#homeSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
						<i class="fas fa-home"></i>
						Home</a>
						<ul class="collapse list-unstyled" id="homeSubmenu">
							<li>
								<a href="#">Home 1</a>
							</li>
							<li>
								<a href="#">Home 2</a>
							</li>
							<li>
								<a href="#">Home 3</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="#">About</a>
					</li>
					<li>
						<a href="#pageSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Pages</a>
						<ul class="collapse list-unstyled" id="pageSubmenu">
							<li>
								<a href="#">Page 1</a>
							</li>
							<li>
								<a href="#">Page 2</a>
							</li>
							<li>
								<a href="#">Page 3</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="#">Portfolio</a>
					</li>
					<li>
						<a href="#">Contact</a>
					</li>
				</div>
			</ul>			

            <ul class="list-unstyled CTAs">
                <li>
                    <a href="#" class="download">Log out</a>
                </li>
            </ul>
        </nav>

        <!-- Page Content  -->
        <div id="content">
			<!-- header  -->
			<div id="ln1Header" >
				<H1>Toroch Gaa Rural Sacco</H1>
			</div>

			<div id="ln1Module"> 
		
			</div>
	
			<div id="ln1Footer">  
				<p>&copy; 2024 Loan One System. All rights reserved.</p>
			</div>
			
        </div>
</div>
<script type="text/javascript">
	getModules();
</script>	
</body>
</html>