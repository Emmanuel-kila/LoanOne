<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Person</title>

<script type="text/javascript">

function doRole(mode)
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

$(document).ready(function() {
	  // Show search form on button click
	  $("#btnsearchPerson").click(function() {
	    $("#searchFormModal").modal("show");
	  });

	  // Perform search on form submission
	  $("#searchForm").submit(function(event) {
	    event.preventDefault(); // Prevent default form submission
	    // Get search filter and value
	    var searchFilter = $("#searchFilter").val();
	    var searchValue = $("#searchValue").val();
	    // Use AJAX to send request to server for search (e.g., to a servlet)
	    // Server retrieves results from database and sends back in a suitable format (e.g., JSON)
	    // Parse response and create HTML table rows for results
	    // Append rows to the #searchResults element
	  });

	  // Handle row double-click to select customer
	  $("#searchResults").on("dblclick", "tr", function() {
	    var customerId = $(this).find("td:first").text(); // Get customer ID from first column
	    // Populate customer ID field in main form
	    $("#customerForm #customerId").val(customerId);
	    // Close search form
	    $("#searchFormModal").modal("hide");
	    // Load customer details based on the selected ID (use AJAX to fetch details from server)
	  });
	});
	
</script>
</head>
<body style="height: 100vh; margin: 0; ">
    <div id="ln1SubHeader" align="left" style="border: 1px solid gray; width: 100%; height: 10%;">
        <h3 style="color: white;">>>Roles</h3>
    </div>

    <div class="container-big" style="height: 80%;">
        <div class="row" style="height: 100%;">
            <div id="ln1subMenu" class="vertical-menu col-md-2" style="border: 1px solid gray; height: 100%;">
                <!-- Content for ln1subMenu -->
                <a class="nav-link" href="#">Roles</a>
            </div>

            <div id="ln1SubContent" class="col-md-8" style="border: 1px solid gray; height: 100%;">
                <!-- Content for ln1SubContent -->
                <br />
                
				<form id="frmPerson" name="frmPerson">
					<div class="container" style="width: 90%;">
						<div class="row">
							<div class="col-md-4">
								<div class="form-group">
									<label id="lblRoleID" for="RoleID">Role ID</label>
									<div class="d-flex align-items-center"> <!-- Use flexbox to align button and input field horizontally -->
										<input type="text" name="RoleID" id="pid" placeholder="Role ID" class="form-control" autocomplete="off" tabindex="1" readonly>
										<button id="btnsearchRole" class="btn btn-primary ml-2">Search</button> <!-- Add margin to separate button from input -->
									</div>
								</div>
								
								<!-- Add other form fields -->
							</div>

							<div class="col-md-4">
								<div class="form-group">
									<label id="lblRoleName" for="RoleName">Name</label>
									<input type="text" name="RoleName" id="RoleName" placeholder=RoleName class="form-control" autocomplete="off" tabindex="1" readonly>
								</div>
								<!-- Add other form fields -->
							</div>
							
							<div class="col-md-4">
								<div class="form-group">
								<input type="checkbox" id="chkDisabled" name="chkDisabled" value="disabledValue" class="form-check-input" tabindex="3">
								<label class="form-check-label" id="lblDisabled" for="chkDisabled">Disabled</label>
								</div>
								<!-- Add other form fields -->
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<label id="lblfirstname" for="firstname">First Name</label>
								<input type="text" name="firstname" id="firstname" class="form-control" placeholder="First Name" autocomplete="off" required tabindex="3">
							</div>
						</div>

					</div>

				</form>
            </div>

            <div id="ln1SubButtons" align="center" class="col-md-2" style="border: 1px solid gray; height: 100%;">
                <!-- Content for ln1SubButtons -->
                <div style="height: 50%;"></div> <!-- Adjust height as needed -->
                <div align="center" class="d-grid gap-2 col-8">
                    <button class="btn btn-outline-secondary" id="btnadd" onclick="doRole(1)">Add</button>
					<button class="btn btn-outline-secondary" id="btnedit" onclick="doRole(2)">Edit</button>
					<button class="btn btn-outline-secondary" id="btnsave" onclick="doRole(3)">Save</button>
					<button class="btn btn-outline-danger" id="btndelete" onclick="doRole(4)">Delete</button>
					<button class="btn btn-outline-info" id="btncancel" onclick="doRole(5)">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    
	<!-- Modal to display search form -->
	<div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-lg">
	        <div class="modal-content">
	            <!-- Content of lnSearch.jsp will be loaded here -->
	            <div id="searchModalContent"></div>
	        </div>
	    </div>
	</div>
    
    <div id="ln1subFooter" style="border: 1px solid gray; width: 100%; height: 10%;">
        <!-- Content for ln1subFooter -->
    </div>
</body>
</html>
    <label id="lblfirstname" for="firstname">First Name</label>
    <input type="text" name="firstname" id="firstname" class="textbox" placeholder="First Name" autocomplete="off" required tabindex="3">
</div>
	   		
	</div>
	
	<div style="border: 1px solid gray; width: 10%; height: 500px; float: left;" > Buttons</div>
	<div style="border: 1px solid gray; width: 100%; height: 48px; margin-top: 500px;"> footer </div>
</body>
</html>