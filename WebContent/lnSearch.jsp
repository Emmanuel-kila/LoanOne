<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Modal Example</title>
    <!-- Bootstrap CSS -->
</head>
<body>
<div id="searchFormModal" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">Customer Search</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <div class="modal-body">
       <form id="searchForm">
          <div class="form-group">
            <label for="searchFilter">Search By:</label>
            <select id="searchFilter">
              <option value="customerName">Customer Name</option>
              <option value="customerId">Customer ID</option>
            </select>
          </div>
          <div class="form-group">
            <label for="searchValue">Search Value:</label>
            <input type="text" id="searchValue" name="searchValue">
          </div>
          <button type="button" class="btn btn-primary" id="searchBtn">Search</button>
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </form>
        <table id="searchResults" class="table table-bordered">
          <thead>
            <tr>
              <th>Customer ID</th>
              <th>Customer Name</th>
              </tr>
          </thead>
          <tbody></tbody>
        </table>
      </div>
    </div>
  </div>
</div>


<script>
    $(document).ready(function() {
        $('#searchCustomer').click(function() {
            var filterType = $('#filterType').val();
            var searchValue = $('#searchValue').val();
            $.ajax({
                url: 'searchCustomers.jsp', // Change to your server-side script
                method: 'POST',
                data: { filterType: filterType, searchValue: searchValue },
                success: function(data) {
                    // Populate DataTable with retrieved data
                    var table = $('#customerTable').DataTable();
                    table.clear().draw();
                    data.forEach(function(customer) {
                        table.row.add([
                            customer.customerId,
                            customer.customerName
                            // Add more columns as needed
                        ]).draw();
                    });
                },
                error: function(xhr, status, error) {
                    console.error(error);
                }
            });
        });

        // Double-click event handler for DataTable rows
        $('#customerTable tbody').on('dblclick', 'tr', function() {
            var customerId = $(this).find('td:first').text();
            $('#customerId').val(customerId);
            $('#searchModal').modal('hide');
            // You may trigger loading customer details here
        });
    });
</script>

</body>
</html>
