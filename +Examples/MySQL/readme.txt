====================================================================

mysql.pas Readme File Part 1, created by Matthias Fichtner, 1999

====================================================================

mysql.pas is a literal translation of relevant parts of MySQL AB's
C header files, mysql.h, mysql_com.h, and mysql_version.h. It serves
as a Pascal interface unit for libmySQL.dll, the client library that
ships with the MySQL database server.

Using mysql.pas, applications developed in Borland Delphi (version
4 and above) can connect to MySQL servers and utilize the full range
of functions defined in the server's C API (Application Programming
Interface).

Like other application programming interfaces (e.g. windows.pas, the
"Windows API", or shellapi.pas, the "Shell API"), mysql.pas does not
contain any visual components; nothing you can place on a project's
form and configure using Object Inspector. It is not installed in
the Delphi IDE.

To use the MySQL API, copy mysql.pas and libmySQL.dll into a Delphi
project's directory and add "MySQL" to its USES clause. Then write
source code that calls the appropriate API functions to connect to a
MySQL server, create databases and tables, insert and modify data,
submit queries, retrieve results, etc.

As mysql.pas is completely compatible with the original C API, there
is no need for separate documentation. For a detailed discussion of
the data types and functions defined in the API, simply refer to the
official documentation:

http://mysql.com/documentation/mysql/bychapter/manual_Clients.html#C

The only aspect not covered in the official documentation is the
dynamic loading of MySQL's client library, libmySQL.dll. Any Delphi
application that uses mysql.pas must load this DLL before it can
call any of the API's functions. The unit's default behaviour is to
try loading the DLL automatically. If it succeeds, the byte value
LIBMYSQL_READY is stored in a variable called libmysql_status. Make
sure you check that variable before using the MySQL API.

If loading libmySQL.dll fails, libmysql_status contains one of two
possible values: LIBMYSQL_MISSING indicates that no suitable library
could be located; LIBMYSQL_INCOMPATIBLE means that the application
tried loading a version of the DLL that is not compatible with the
version of mysql.pas being used. It is then up to the application to
either terminate or find a compatible version of the DLL. In order
to load it, call libmysql_load(), supplying a null-terminated string
containing the library's full path as the function's only parameter.
The function's return value is identical to libmysql_status -- make
sure you check it before using any of the API's functions.

If you do not want mysql.pas to automatically try loading the DLL,
set a compiler conditional called DONT_LOAD_DLL. To do that, select
Project/Options from Delphi's main menu, switch to the Directories/
Conditionals tab, add the symbol to the "Conditional defines" field,
and rebuild your project. It is then up to the application to call
libmysql_load(), supplying either nil or a null-terminated string
containing the library's full path as the function's only parameter.
Again: Don't try using the MySQL API unless the function's return
value is LIBMYSQL_READY.

====================================================================

mysql.pas Readme File, Part 2 created by Samuel Soldat, 2009

====================================================================

The unit mysql.pas is initially created by Matthias Fichtner 
<matthias@fichtner.net> under a license based on the Apache Software 
License, Version 1.1. With the permission of Matthias Fichtner the 
license is now changed to Mozilla Public License Version 1.1. Many 
thanks for that and all his work on mysql.pas to Matthias!

Latest releases of mysql.pas are made available through the
distribution site at: http://www.audio-data.de/mysql.html

Please send questions, bug reports, and suggestions regarding
mysql.pas to Samuel Soldat <samuel.soldat@audio-data.de>

See license.txt for licensing information and disclaimer.

====================================================================

New functions and features provided by mysql.pas

====================================================================

You can call libmysql_load() with nil-parameter. In this case the
name is set to "libmysql.dll" and the library search in all paths
set in path-variable of the environment.

Improved dynamic loading: Now all function give a real error message
if you call them befor you have load the library by calling
libmysql_load() or libmysql_fast_load().

To write library independent code avoid direct access on internal
structures of mysql (all but TMYSQL_ROW). Use this funtions to get/set 
informations from/to internal structures instead:
  mysql_fetch_db, mysql_field_type, mysql_field_flag, mysql_field_length,
  mysql_field_name, mysql_field_tablename, INTERNAL_NUM_FIELD, UpdateField,
  mysql_bind_init, mysql_bind_copy_bind, mysql_bind_set_param

For using mysql.pas together with the new UnicodeString in delphi 2009 
you have different choices.

1) Using the Delphi build-in default conversion from utf16<->Ansi
   --------------------------------------------------------------
   This happend if you make any asignment like

     MyUnicodeString := PAnsiChar

   This will work nice if the character set of the MySqlClient 
   properly matches with your Windows code page.
   

2) Using the Delphi build-in conversion from utf16<->Ansi
   --------------------------------------------------------------
   You can declare a special AnsiString-Type if you want to use
   a different Windows code page. For Examble:
   
   type
     MySqlString = type AnsiString(1251);

   Now you can convert all strings comming from the client to
   utf16-Strings:

     MyUnicodeString := MySqlString(PAnsiChar)

3) Setting the character set of the Client according to the
   Windows code page
   --------------------------------------------------------------
   If the default character set of your client or your server differ
   from your Windows code page, you can set the right character set
   prior you connect to the server. For this the function 
   CodepageToCharsetName may help you to find the right character set. 
   You set your choice with the function

   mysql_options(LibHandle, MYSQL_SET_CHARSET_NAME, PAnsiChar(<CSName>))

   After you have done this, you can continue described in (1).

4) Using the Encoding function of mysql.pas
   --------------------------------------------------------------
   The code page for the conversion done by direct assigning of the 
   AnsiStrings and the UnicodeStrings is fixed by declaration of 
   the AnsiString-type. The code page can changed at runtime only by 
   using the DefaultSystemcode page. This is global for the complete 
   application and come into operation for all further string con-
   versions.
   The TEncoding-class exposed the flexibility to set the code page
   for every conversion you want to do, but the TEncoding-class is
   much slower than the direct string assignment.
   The functions "MySqlToUTF16" and "UTF16ToMySql" do the same
   encodings as Delphi 2009 but optimised for flexibility and speed.
   Same as the TEncoding-class you are able to set the code page 
   at every conversion, but the function provided by mysql.pas do 
   this faster than the TEncoding-class.
   You are able to set the code page at runtime by using the global
   variable "DefaultMySqlcode page" or you can set the code page at 
   every call of this functions.

====================================================================
