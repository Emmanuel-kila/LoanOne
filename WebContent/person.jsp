<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Person</title>

<script type="text/javascript">

function doPerson(mode)
{
	if(mode==1)
	{
		doMessage("Add button clicked");
		curMod = "add";
	}
	else if(mode==2)
	{
		doMessage("Edit butt on clicked");
		curMod = "edit";
	}
	else if(mode==3)
	{
		$("#frmPerson").validate();
		if($("#frmPerson").valid())
		{
			alert("form is valid");
		}
		doMessage("Save button clicked");
		alert("Save button clicked");
		curMod = "save";
	}
	else if(mode==4)
		doMessage("Delete button clicked");
	else if(mode==5)
	{
		doMessage("Cancel button clicked");
		if(curMod == null){
			//unload the page
			openModule('welcome.jsp');
		}
		else
		{
			//give warning if there is unsaved data
			//proceed is user insists
			curMod=null;
		}
		
	}
		
}

/*function doMessage(msg)
{
	
	$('#ln1subFooter').html(msg +  curMod);
		
}*/
</script>
</head>
<body>
	<div id="ln1SubHeader" align="left" style="border: 1px solid gray; width: 100%; height: 50px; "> 
		<h3 style="color: white;">>>Person</h3>
	</div>
	
	<div id="ln1subMenu" class="vertical-menu" style="border: 1px solid gray; width: 10%; height: 500px; float: left; " >

	    <a class="nav-link" href="#">Photo</a>
	    <a class="nav-link" href="#">Biometric</a>

	</div>
	
	<div style="border: 1px solid gray; width: 80%; height: 500px; float: left;"> 
		<br />
		<form id="frmPerson" name="frmPerson">
    		  <div class="container" style="width: 99%;float: left;"> 
    		   	<div class="form-group" align="left" style="width: 49%;float: left;">
					<div class="form-inline">
					  <label id="lblPID" for="pid">PID</label>
					  <input type="text" name="pid" id="pid" placeholder="Person ID" size="20px" autocomplete="off" tabindex="1" readonly>
					  <button id="btnsearch" class="btn btn-primary ms-2">Search</button>
					</div>
										
    		   		<label id="lblfirstname" for="firstname">First Name</label>
    		   		<input type="text" name="firstname" id="firstname" class="form-control" placeholder="First Name" size="30px" autocomplete="off" required tabindex="3">

    		   		<label id="lblothername" for="othername">Other Name</label>
    		   		<input type="text" name="othername" id="othername" class="form-control" placeholder="Other Name" size="30px" autocomplete="off" required tabindex="5">

    		   		<label id="lbldob" for="dob">Date of Birth</label>
    		   		<input type="date" name="dob" id="dob" class="form-control" placeholder="dd/MMM/yyyy" size="30px" autocomplete="off" required tabindex="7">

    		   		<label id="lbladdress" for="address">Address</label>
    		   		<input type="text" name="address" id="address" class="form-control" placeholder="Address" size="30px" autocomplete="off" required tabindex="9">

    		   		<label id="lblnextofkin" for="nextofkin">Next of Kin</label>
    		   		<input type="text" name="nextofkin" id="nextofkin" class="form-control" placeholder="Next of Kin" size="30px" autocomplete="off" required tabindex="11">

    		   	</div>
    		   	<div class="form-group" style="width: 49%;float: right;">
    		   		<label id="lbltype_id" for="type_id">Type</label>
    		   		<select id="type_id" name="type_id" class="form-control" required tabindex="2">
    		   			<option selected></option>
    		   			<option value="1">Client</option>
    		   		</select>
    		   		
    		   		<label id="lblmiddlename" for="middlename">Middle Name</label>
    		   		<input type="text" name="middlename" id="middlename" class="form-control" placeholder="Middle Name" size="30px" autocomplete="off" required tabindex="4">
    		   		
    		   		<label id="lblemail" for="email">Email</label>
    		   		<input type="email" name="email" id="email" class="form-control" placeholder="email" size="30px" autocomplete="off" required tabindex="6">

    		   		<label id="lblphone" for="phone">Phone</label>
    		   		<input type="text" name="phone" id="phone" class="form-control" placeholder="Phone" size="30px" autocomplete="off" required tabindex="8">
 
     		   		<label id="lblidnumber" for="idnumber">ID Number</label>
    		   		<input type="text" name="idnumber" id="idnumber" class="form-control" placeholder="ID Number" size="30px" autocomplete="off" required tabindex="10">

    		   		<label id="lblincome" for="income">Income</label>
    		   		<input type="number" name="income" id="income" class="form-control" placeholder="Income" size="30px" autocomplete="off" required tabindex="12">
    		   		
    		   	</div>

    		  </div> 	    		   
    	</form>
    	
	</div>
	<div align="center" style="border: 1px solid gray; width: 10%; height: 500px; float: left;" > 
			<div style="height: 250px;"></div>
			<div align="center" class="d-grid gap-2 col-8">
 		   	<button class="btn btn-outline-secondary" id="btnadd" onclick="doPerson(1)">Add</button>
		   	<button class="btn btn-outline-secondary" id="btnedit" onclick="doPerson(2)">Edit</button>
		   	<button class="btn btn-outline-secondary" id="btnsave" onclick="doPerson(3)">Save</button>
 		   	<button class="btn btn-outline-danger" id="btndelete" onclick="doPerson(4)">Delete</button>
		   	<button class="btn btn-outline-info" id="btncancel" onclick="doPerson(5)">Cancel</button>
		   	</div>
	</div>
	<div id="ln1subFooter" style="border: 1px solid gray; width: 100%; height: 48px; margin-top: 500px;"> </div>
</body>
</html>