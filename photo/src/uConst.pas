unit uConst;

interface
const
    photoQuery = 'select cust.CUSTID, cust.CUSTTYPE, cust.CUSTNAME, cust.CLASSCODE,' +
        ' cust.CLASSNAME,cust.AREACODE,area.AREANAME,cust.STUEMPNO, cust.DEPTCODE,' +
        ' cust.SPECIALTYCODE,cust.IDNO,ctype.CUSTTYPENAME,dept.DEPTNAME,spec.SPECIALTYNAME,' +
        ' photo.PHOTODATE ,photo.PHOTOTIME from YKT_CUR.T_CUSTOMER cust ' +
        ' left join YKT_CUR.T_CUSTTYPE ctype on ctype.CUSTTYPE=cust.CUSTTYPE  left join ' +
        ' YKT_CUR.T_DEPT dept on dept.DEPTCODE=cust.DEPTCODE left join YKT_CUR.T_SPECIALTY' +
        ' spec on spec.SPECIALTYCODE=cust.SPECIALTYCODE  left join YKT_CUR.T_PHOTO photo' +
        ' on photo.CUSTID=cust.CUSTID left join YKT_CUR.T_AREA area on cust.AREACODE=area.AREACODE where 1>0';
    photoStats = 'select area.AREANAME,dept.DEPTNAME, spec.SPECIALTYNAME,count(*) as totnum,' +
        ' count(photo.photodate) as photonum,(count(cust.CUSTID)-count(photo.photodate)) as unphotonum' +
        ' from YKT_CUR.T_CUSTOMER cust left join ykt_cur.t_photo photo on ' +
        ' cust.custid=photo.custid left join YKT_CUR.T_DEPT dept on cust.DEPTCODE=dept.DEPTCODE' +
        ' left join YKT_CUR.T_SPECIALTY spec on cust.SPECIALTYCODE=spec.SPECIALTYCODE ' +
        ' left join YKT_CUR.T_AREA area on cust.AREACODE=area.AREACODE  where 1>0';
    deptQuery = 'select dictval as DEPTCODE, dictcaption as DEPTNAME from v_dictionary' +
        ' where dicttype=-22 order by dictcaption';
    specQuery = 'select dictval as SPECIALTYCODE,dictcaption as SPECIALTYNAME from v_dictionary' +
        ' where dicttype=-23 order by dictcaption ';
    typeQuery = 'select CUSTTYPE, CUSTTYPENAME from(select -1 as CUSTTYPE, '''' as CUSTTYPENAME ' +
        ' from YKT_CUR.T_CUSTTYPE union select CUSTTYPE, CUSTTYPENAME from YKT_CUR.T_CUSTTYPE)t order by CUSTTYPENAME';
    areaQuery = 'select dictval as AREACODE,dictcaption as AREANAME from v_dictionary' +
        ' where dicttype=-28 order by dictcaption ';
implementation

end.
