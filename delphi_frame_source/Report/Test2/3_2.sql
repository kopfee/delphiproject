select O.*,I.*,C.*,E.* from Orders O,Items I,Customer C,Employee E 
Where O.EmpNo=E.EmpNo and O.CustNo=C.CustNo and O.OrderNo=I.OrderNo
order by O.EmpNo,O.CustNo,O.OrderNo