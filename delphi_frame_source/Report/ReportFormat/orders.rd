DBDEMOS


orders
SELECT Customer.CustNo, Customer.Company, Orders.OrderNo, Items.ItemNo, Items.PartNo, Items.Qty, Items.Discount, Orders.SaleDate, Orders.ShipDate, Orders.Freight, Orders.AmountPaid, Orders.ItemsTotal, Orders.PaymentMethod, Orders.ShipToContact, Orders.EmpNo, Orders.ShipToAddr1, Orders.ShipToAddr2, Orders.ShipToCity, Orders.ShipToState, Orders.ShipToZip, Orders.ShipToCountry, Orders.ShipToPhone, Orders.ShipVIA, Orders.PO, Orders.Terms, Orders.TaxRate, Customer.Addr1, Customer.Addr2, Customer.City, Customer.State, Customer.Zip, Customer.Country, Customer.Phone, Customer.FAX, Customer.Contact, Customer.TaxRate
FROM "orders.db" Orders
   INNER JOIN "customer.db" Customer
   ON  (Customer.CustNo = Orders.CustNo)  
   INNER JOIN "items.db" Items
   ON  (Orders.OrderNo = Items.OrderNo)  
WHERE  Customer.CustNo < 1354 
ORDER BY Customer.CustNo, Orders.OrderNo, Items.ItemNo

