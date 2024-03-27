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
		$('#mode').val(mode); 
        // Disable btnadd, btnedit, and btndelete
        $('#btnadd, #btnedit, #btndelete').prop('disabled', true);
        // Enable btnsave and btncancel
        $('#btnsave, #btncancel').prop('disabled', false);
	        
		doMessage("Add button clicked");
		curMod = "add";
	}
	else if(mode==2)
	{
		doMessage("Edit button clicked");
		curMod = "edit";
	}
	else if(mode==3)
	{
		$("#frmPerson").validate();
		if($("#frmPerson").valid())
		{
			alert("form is valid");
			//Save record Start
			$.ajax({		
	  				
	  					url : 'Loan1Ctrl',
	  					type: 'POST',
	  					data : $('#frmPerson').serialize(),
	  					dataType: 'JSON',
	  			
	  					success:function(data)
	  					{
	  	  					var obj = JSON.parse(JSON.stringify(data));
	  	  					var lstatus =obj[0].success;
	  						//$('#errZone').html(obj[0].success);
	  						
	  						doMessage(lstatus);
	  						
	  						
	  					}					
	  			}).fail(function (errorobj, textstatus, error) { 
	  				var responseText = errorobj.responseText.trim() ;
	  				//alert("Ingia hapa"+responseText)
	  				doMessage(responseText);
	  			});  
			//Save record End
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
<body style="height: 100vh; margin: 0; background-color: #757272;">
    <div id="ln1SubHeader" align="left" style="border: 1px solid gray; width: 100%; height: 10%;">
        <h3 style="color: white;">>>Person</h3>
    </div>

    <div class="container-big" style="height: 80%; background-color: #f0f0f0; color: #333;">
        <div class="row" style="height: 100%;">
            <div id="ln1subMenu" class="vertical-menu col-md-2" style="border: 1px solid gray; height: 100%;">
                <!-- Content for ln1subMenu -->
                <a class="nav-link" href="#">Documents</a>
                <a class="nav-link" href="#">Biometric</a>
            </div>

            <div id="ln1SubContent" class="col-md-8" style="border: 1px solid gray; height: 100%;">
                <!-- Content for ln1SubContent -->
                <br />
                
				<form id="frmPerson" name="frmPerson">
					<input type="hidden" id="moduleid" name="moduleid" value="100">
					<input type="hidden" id="mode" name="mode" value="">
					<div class="container-big" style="width: 90%;">
						<div class="row">
							<div class="col-md-6">
								<div class="form-group">
									<label id="lblPID" for="pid">PID</label>
									<div class="d-flex align-items-center"> <!-- Use flexbox to align button and input field horizontally -->
										<input type="text" name="pid" id="pid" placeholder="Person ID" class="form-control" autocomplete="off" tabindex="1" readonly>
										<button id="btnsearchPerson" class="btn btn-primary ml-2">Search</button> <!-- Add margin to separate button from input -->
									</div>
								</div>
								
								<!-- Add other form fields -->
							</div>

							<div class="col-md-6">
								<div class="form-group">
									<label id="lbltype_id" for="type_id">Type</label>
									<select id="type_id" name="type_id" class="form-control" required tabindex="2">
										<option selected></option>
										<option value="100">Client</option>
									</select>
								</div>
								<!-- Add other form fields -->
							</div>
						</div>
						<div class="row">
							<div class="col-md-6">
								<label id="lblfirstname" for="firstname">First Name</label>
								<input type="text" name="firstname" id="firstname" class="form-control" placeholder="First Name" autocomplete="off" required tabindex="3">
							</div>
							<div class="col-md-6">
								<label id="lblmiddlename" for="middlename">Middle Name</label>
								<input type="text" name="middlename" id="middlename" class="form-control" placeholder="Middle Name" autocomplete="off" required tabindex="4">
							</div>
						</div>
						<div class="row">
							<div class="col-md-6">
								<label id="lblothername" for="othername">Other Name</label>
								<input type="text" name="othername" id="othername" class="form-control" placeholder="Other Name" autocomplete="off" required tabindex="5">
							</div>
							<div class="col-md-6">
								<label id="lblemail" for="email">Email</label>
								<input type="email" name="email" id="email" class="form-control" placeholder="email" autocomplete="off" required tabindex="6">
							</div>

						</div>
						<div class="row">
							<div class="col-md-6">
								<label id="lbldob" for="dob">Date of Birth</label>
								<input type="date" name="dob" id="dob" class="form-control" placeholder="dd/MMM/yyyy" autocomplete="off" required tabindex="7">
							</div>
							<div class="col-md-6">
								<label id="lblphone" for="phone">Phone</label>
								<input type="text" name="phone" id="phone" class="form-control" placeholder="Phone" autocomplete="off" required tabindex="8">
							</div>
						</div>
						<div class="row">
							<div class="col-md-6">
								<label id="lbladdress" for="address">Address</label>
								<input type="text" name="address" id="address" class="form-control" placeholder="Address" autocomplete="off" required tabindex="9">
							</div>
							<div class="col-md-6">
								<label id="lblidnumber" for="idnumber">ID Number</label>
								<input type="text" name="idnumber" id="idnumber" class="form-control" placeholder="ID Number" autocomplete="off" required tabindex="10">
							</div>
						</div>	
						<div class="row">
							<div class="col-md-6">
								<label id="lblnextofkin" for="nextofkin">Next of Kin</label>
								<input type="text" name="nextofkin" id="nextofkin" class="form-control" placeholder="Next of Kin" autocomplete="off" required tabindex="11">
							</div>
							<div class="col-md-6">
								<label id="lblincome" for="income">Income</label>
								<input type="number" name="income" id="income" class="form-control" placeholder="Income" autocomplete="off" required tabindex="12">
							</div>
						</div>
					</div>

				</form>
            </div>

            <div id="ln1SubButtons" align="center" class="col-md-2" style="border: 1px solid gray; height: 100%;">
                <!-- Content for ln1SubButtons -->
                <div style="height: 50%;"></div> <!-- Adjust height as needed -->
                <div align="center" class="d-grid gap-2 col-8">
                    <button class="btn btn-outline-secondary" id="btnadd" onclick="doPerson(1)">Add</button>
					<button class="btn btn-outline-secondary" id="btnedit" onclick="doPerson(2)">Edit</button>
					<button class="btn btn-outline-secondary" id="btnsave" onclick="doPerson(3)">Save</button>
					<button class="btn btn-outline-danger" id="btndelete" onclick="doPerson(4)">Delete</button>
					<button class="btn btn-outline-info" id="btncancel" onclick="doPerson(5)">Cancel</button>
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