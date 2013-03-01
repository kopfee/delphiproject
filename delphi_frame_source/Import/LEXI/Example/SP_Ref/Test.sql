/* test procedure proc1 */
drop proc proc1
create proc proc1
  @var1 char(10),
  @var2 int
as
begin
  exec proc2 '2'
  select @var3=1,@var4=2
  select col1,col2 from table1 t,table2 where t.col3=col4
  select @var5=1,@var6=2
  insert into table3(col3,col4) values(1,2)
  insert table4 values(1,2)
  update table5 set col5=1, col6=2
  if exists(select * from table6 where col7=@var1)
  begin
    delete table7 where col8=@var2
  end
end
go

exec proc1 'a',1

/* test procedure proc1 */
drop proc proc2
create proc proc2
  @var1 char(10),
  @var2 int
as
begin
  exec @re = proc1 '2'
  select @var3=1,@var4=2
  select col1,col2 from table1 t,table2 where t.col3=col4
  select @var5=1,@var6=2
  insert into table3(col3,col4) values(1,2)
  insert table4 values(1,2)
  update table5 set col5=1, col6=2
  if exists(select * from table6 where col7=@var1)
  begin
    delete table7 where col8=@var2
  end
end
go

exec proc2 'a',1

