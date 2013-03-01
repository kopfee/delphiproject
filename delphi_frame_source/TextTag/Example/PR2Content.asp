<!-- content.htm --><% form(); %><% newfile("@object"); %>
<html>
<head>
<Title>Control List</Title>
</head>
<body>
<H2>Form : <% property("name"); %></H2>
<BR>
<h3>TButton</h3>
<table border=1>
<tr><td><B>Name</B></td><td><B>Caption</B></td></tr>
<% component("TButton"); %><tr><td><% property("name"); %></td><td><% property("Caption"); %></td></tr><% endcomponent(); %>
</table>
<h3>TMemo</h3>
<table border=1>
<tr><td><B>Name</B></td><td><B>ReadOnly</B></td></tr>
<% component("TMemo"); %><tr><td><% property("name"); %></td><td><% property("ReadOnly"); %></td></tr><% endcomponent(); %>
</table>
<h3>TLabel</h3>
<table border=1>
<tr><td><B>Name</B></td><td><B>Caption</B></td><td><B>Font.Name</B></td><td><B>Font.Size</B></td></tr>
<% component("TLabel"); %><tr><td><% property("name"); %></td><td><% property("Caption"); %></td>
<% persistent("Font"); %>
<td><% property("Name"); %></td><td><% property("Size"); %></td>
<% endpersistent(); %>
</tr><% endcomponent(); %>
</table>
<h3>TEdit</h3>
<table border=1>
<tr><td><B>Name</B></td><td><B>Text</B></td></tr>
<% component("TEdit"); %><tr><td><% property("name"); %></td><td><% property("Text"); %></td></tr><% endcomponent(); %>
</table>
<h3>TListBox</h3>
<table border=1>
<tr><td><B>Name</B></td><td><B>Text</B></td></tr>
<% component("TListBox"); %><tr><td><% property("name"); %></td>
<td><table>
  <% strings("Items") %><% stringvalue(); %><BR>
  <% endstrings(); %>
  </table>
</td>
</tr><% endcomponent(); %>
</table>
<h3>THeaderControl</h3>
<table border=1>
<tr><td><B>Name</B></td><td><B>Text</B></td></tr>
<% component("THeaderControl"); %><tr><td><% property("name"); %></td>
<td><table>
  <% items("Sections"); %><% property("Text"); %><BR>
  <% enditems(); %>
  </table>
</td>
</tr><% endcomponent(); %>
</table>
</body>
</html><% endform(); %>