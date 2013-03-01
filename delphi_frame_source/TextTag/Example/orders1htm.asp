<html>
<head>
<title>Orders Group Report</title>
<%
  DataEntry("Orders","Orders");
  FileName("Orders1.htm");
%>
</head>
<body bgcolor="#FFFFFF">
<h1>Orders Group Report</h1>
<table border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" width="704">
  <tr bgcolor="#999999"> 
    <td width="85"><font color="#000000">CustNo</font></td>
    <td width="220"><font color="#000000">Company</font></td>
    <td width="107"><font color="#000000">OrderNo</font></td>
    <td width="106"><font color="#000000">Payment</font></td>
    <td width="90"><font color="#000000">ItemNo</font></td>
    <td width="82"><font color="#000000">PartNo</font></td>
  </tr>
  <%ForLoop("Orders")%> 
  <tr> 
    <td width="85"><%FieldValue("CustNo","8")%></td>
    <td width="220"><%FieldValue("Company","20","Center")%></td>
    <td width="107"><%FieldValue("OrderNo","10","Left")%></td>
    <td width="106"><%FieldValue("PaymentMethod","10","Left")%></td>
    <td width="90"><%FieldValue("ItemNo","8","Left")%></td>
    <td width="82"><%FieldValue("PartNo","10","Left")%></td>
  </tr>
  <%EndLoop()%> 
</table>
</body>
</html>
