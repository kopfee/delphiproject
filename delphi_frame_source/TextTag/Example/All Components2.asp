<% project(); %>
<% pform(); %>
<% newfile("@name"); %>
<html>
<head>
<Title>Component List</Title>
</head>
<body>
<H1>Form : <% property("name"); %></H1>
<table border=1 cellpadding="1" cellspacing="0" width="755" bordercolor="#000000">
  <tr> 
    <td width="141"><b>Name</b></td>
    <td width="169"><b>ClassName</b></td>
    <td width="218"><b>Caption</b></td>
    <td width="225"><b>Text</b></td>
  </tr>
  <% component("TComponent"); %> 
  <tr> 
    <td width="141"><% name("object"); %></td>
    <td width="169"><% name("class"); %></td>
    <td width="218"><% property("Caption"); %>&nbsp;</td>
    <td width="225"><% property("Text"); %>&nbsp;</td>
  </tr>
  <% endcomponent(); %> 
</table>
</body>
</html>
<% endpform(); %>
<% endproject(); %>