<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Clients</title>

<script type="text/javascript">

function getClients() {
    $.ajax({
        url: 'Loan1Ctrl',
        type: 'POST',
        data: {"uid": <%=session.getAttribute("uid")%>, "moduleid": 105},
        dataType: 'JSON',
        success: function(data) {
            var obj = JSON.parse(JSON.stringify(data));
            var table = $('<table>').addClass('display').attr('id', 'moduleTable');

            // Create table header
            var thead = $('<thead>').appendTo(table);
            var headerRow = $('<tr>').appendTo(thead);
            headerRow.append('<th>PID</th>');
            headerRow.append('<th>Phone</th>');
            headerRow.append('<th>First Name</th>');
            headerRow.append('<th>Middle Name</th>');
            headerRow.append('<th>Other Name</th>');
            headerRow.append('<th>Email</th>');

            // Create table body
            var tbody = $('<tbody>').appendTo(table);
            for (var i = 0; i < obj.length; i++) {
                var module = obj[i];
                var row = $('<tr>').appendTo(tbody);
                row.append('<td>' + module.pid + '</td>');
                row.append('<td>' + module.phone + '</td>');
                row.append('<td>' + module.firstname + '</td>');
                row.append('<td>' + module.middlename + '</td>');
                row.append('<td>' + module.othername + '</td>');
                row.append('<td>' + module.email + '</td>');
            }

            // Append the table to the div
            $('#tblclients').empty().append(table);

            // Initialize DataTable
            $('#moduleTable').DataTable();
        }
    }).fail(function (errorobj, textstatus, error) { 
        var responseText = errorobj.responseText.trim() ;
        $('#ln1Footer').html(responseText);
    });  
}


</script>
</head>

<body>

<div class="card">
    <div class="card-header">
        Client Information
    </div>
    <div id="tblclients" class="card-body">
        <h5 class="card-title">Client details</h5>
        <table id="clientTable" class="display" style="width:100%">
            <thead>
                <tr>
                    <th>PID</th>
                    <th>Phone</th>
                    <th>First Name</th>
                    <th>Middle Name</th>
                    <th>Other Name</th>
                    <th>Email</th>
                </tr>
            </thead>
            <tbody>
                <!-- Table body content will be populated dynamically -->
            </tbody>
        </table>
    </div>
</div>

<script type="text/javascript">
	getClients();
</script>
</body>
</html>