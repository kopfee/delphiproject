<!-- Index.htm -->
<html>
<head>
<Title>Form List</Title>
</head>
<body>
<h1>Forms</h1>
<% form(); %>
<a href="<% newfilename("@object"); %>">Form : <% property("name"); %> : <% name("class"); %> </a><BR>
<% endform(); %>
</body>
</html>