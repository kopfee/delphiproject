unit MSDataTypes;

(*****   Code Written By Huang YanLai   *****)

{$ALIGN OFF} // turn off alignment of fields in record types.

interface

//  Include DBLIB definitions (it checks to see if they have already
//  been defined)
//
{import from    <srvdbtyp.h>}

type
//#if !defined( DBTYPEDEFS )  // So we don't conflict with DBLIB definitions
//
// define data types
//

  DBBOOL=byte ;
  DBBYTE=byte;
  DBTINYINT=byte;
  DBSMALLINT=smallint;
  DBUSMALLINT=word;
  DBINT=longint;
  DBCHAR=char;
  PDBCHAR = Pchar;
  DBBINARY=byte;
  DBBIT=byte;
  DBFLT8=double;

//#ifndef ODBCVER
  RETCODE = integer;        // SUCCEED or FAIL
//#endif

 DBDATETIME= record   // DataServer datetime type
    dtdays : longint ;            // number of days since 1/1/1900
    dttime : longword ;   // number 300th second since mid
 end ;

 DBMONEY= record    // DataServer money type
    mnyhigh : longint ;
    mnylow : longword ;
 end;

 BOOL = longbool  ;

// These are version 4.2 additions
//
 DBFLT4 = single ; // float ?
 DBMONEY4 = longint ;
 DBREAL = DBFLT4;

 DBDATETIM4= record
    numdays : word ; // No of days since Jan-1-1900
    nummins : word; // No. of minutes since midnight
 end;

// DBDATEREC recordure used by dbdatecrack. This is a version 4.2 addition
 DBDATEREC = record
    year : integer     ;	    { 1753 - 9999 }
    quarter : integer     ;	    { 1 - 4 }
    month : integer     ;	    { 1 - 12 }
    dayofyear : integer     ;	    { 1 - 366 }
    day : integer     ;	    { 1 - 31 }
    week : integer     ;	    { 1 - 54 (for leap years) }
    weekday : integer     ;	    { 1 - 7  (Mon - Sun) }
    hour : integer     ;	    { 0 - 23 }
    minute : integer     ;	    { 0 - 59 }
    second : integer     ;	    { 0 - 59 }
    millisecond : integer     ;    { 0 - 999 }
  end;

const
  MAXNUMERICLEN	=16;

// These are version 6.0 additions
//

type
// Defined identically in OLE-DB header. If OLE-DB header previously included
// skip redefinition.
//
//#if !defined (__oledb_h__)
 DBNUMERIC = record
	precision : BYTE ;
	scale : BYTE ;
	sign : BYTE ;
	val : array[0..MAXNUMERICLEN-1] of byte;
 end  ;
//#endif // !defined (__oledb_h__)

 DBDECIMAL = DBNUMERIC;

//#if !defined( DBPROGNLEN )

const DBPROGNLEN  =10;

//#endif

implementation

end.
