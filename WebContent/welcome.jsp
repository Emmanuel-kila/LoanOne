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
		  height: 70%;
		  width: 80%;
		}

		.middle {
		  display: table-cell;
		  vertical-align: middle;
		}

		.inner {
		  margin-left: auto;
		  margin-right: auto;
		  width: 400px;
		  text-align: center;
		  /* Whatever width you want */
		}

	</style>
<meta charset="utf-8">
<title></title>
<script type="text/javascript">

</script>
</head>

<body>

	<div class="outer">
  		<div class="middle">
    		<div class="inner">
				<figure>
				  <img src="${pageContext.request.contextPath}/images/Logo1.png" alt="Loan One"/>
				  <figcaption>Welcome to Loan One</figcaption>
				</figure>
			</div> 
		</div>
	</div>
</body>
</html>