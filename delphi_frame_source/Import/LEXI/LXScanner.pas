{
  modified by hyl
    1. change float-point number process: not allow ','
    2. change unit name to LXScanner.pas, change TToken to TLXToken, TScanner to TLXScanner
    in order to avoid name conclict.
}
{
  Scanner.pas

  Written by Frank Plagge
  Copyright (c) 1998 by Frank Plagge, Elsterweg 39, 38446 Wolfsburg, Germany
  All rights reserved

  Please send comments to plagge@wolfsburg.de

  *****************************************************************************
  many thanks for bug reports and ideas to
     - Takayuki Ogawa (t2ogawa@krhm.jvc-victor.co.jp):
             + stop the analysis caused by user event result
             + handling block comments
             + reading system leadbytes

     - Kovacs Lehel - Istvan (klehel@praemium.ro):
             + take a stream instead of files as input for the analysis

     - Oliver Matla (wolfpack@eulink.net) :
             + take a stream instead of files as input for the analysis
             + bug within recognition of special char $ followed by an
               identifier

     - Peter (peter@tankebolaget.se) :
             + bug / conflict within number and special char recognition
  *****************************************************************************

  V 1.01 - Jan 3rd, 1998
           first implementation, never trust a version 1.00 :-)

  V 1.02 - Jan 12th, 1998
           + hexdecimals with the new token ttHexDecimal added
           + the hex numbers are defined like C e.g. 0x12AB or like
             Pascal e.g. $12AB
           + the state machine is extended by states 13, 14, 15 and 16

  V 1.03 - Aug 8th, 1998
            + the complete input source is changed from file into stream
            - the filename property is no longer available
            + german mutated vowels added (because i needed this:-) )
            + analysis can be stopped by a return value of the token event
              a stopped analysis can be restarted with the method restart
            + scanner can handle block comments, the result is a ttcomment token
              for each comment line. the state machine is extended by the state
              18 which handles the comment block reading. state 18 is the
              starting point of the machine if the comment block reading is
              active.

  V 1.04 - Aug 14th, 1998
            + bugfix for comment recognition
            + added TLXToken.CopyFrom method
            + improved recognition of $ as special char and following identifier
            + added the property AllowFigures for inclusion or exclusion of
              figures within identifiers or keywords
            + improved recognition of integer followed directly by , or .
            + default palette name changed to "Enhanced"
            + readonly property version added
            - special sulution for german mutated vowels deleted
            + property AdditionalChars added, language specific letters for
              identifiers can be integrated there
            + the addition to the list of tokens can be prevented by setting
              the variable AddToList within the event OnTokenRead to false

  V 1.05 - Mar 29th, 1999
            + bugfix for comment recognition

  V 1.06 - Oct 19th, 1999
            + bugfix delete the list of saved tokens before destroy the
              scanner object

  *****************************************************************************
  Permission to use, copy,  modify, and distribute this software and its
  documentation without fee for any purpose is hereby granted, provided that
  the above copyright notice appears on all copies and that both that copyright
  notice and this permission notice appear in all supporting documentation.

  NO REPRESENTATIONS ARE MADE ABOUT THE SUITABILITY OF THIS SOFTWARE FOR ANY
  PURPOSE. IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
  NEITHER FRANK PLAGGE OR ANY OTHER PERSON SHALL BE LIABLE FOR ANY DAMAGES
  SUFFERED BY THE USE OF THIS SOFTWARE.
  *****************************************************************************

   description:
   This module contains the component TLXScanner. It contains the complete
   lexical analysis of a stream source. This is a necessary basis to realize
   a parser for any language. The analysis produces a stream of token.


   properties and events at design time and runtime:

    property AdditionalChars: string  -- default: ''
    every language specific letter that is allowed within identifiers
    can be integrated here. the letters 'a' to 'z' and 'A' to 'Z' are the
    standard letters for identifiers. if any other additional letter is needed
    it can be entered in this property. the scanner component sorts the string
    automatical.

    property AllowFigures: Boolean  -- default: true
    if this property is true, figures are allowed within every identifier or
    keyword. if this property is false no figures are allowed and every figure
    will cause a ttIdentifier or ttKeyword token. the figure will be interpreted
    as the beginning of a new token with the type ttInteger.

    property AllowIdentifier: Boolean  -- default: true
    if this property is true, every identifier which is not a keyword will
    result a ttIdentifier token. if this property is false every non keyword
    identifier will cause a ttError token

    property CommentLine: string  -- default: '//'
    this property contains the leading char for a comment. every comment is
    introduced with this string and is ended by the end of line

    property CommentBegin: string  -- default: '{'
    this property contains the introducing string for a block comment.
    every block comment is introduced with this string and is ended by
    the CommentEnd string

    property CommentBegin: string  -- default: sorry can't write it down here :-(
    this property contains the ending string for a block comment.

    property Keywords: TStringList  -- default: empty
    the keyword of the scanner are stored in the property Keywords. the
    scanner component sorts list of keywords automatical. if the scanner reads
    an identifier and the identifier is a member of the keywords it will result
    a token ttKeyword

    property KeywordsCaseSensitive: Boolean -- default: false
    if this property is true the compare if an identifier is made case.

    property SpecialChars: string  -- default: ''
    every special chars that results a ttSpecialChar token have to be entered
    in this string. the scanner component sorts the string automatical.

    property OnTokenRead: TTokenEvent
    this user defined event is called if a new token is read from the input
    stream. this event is called atfer the token is read and before it is stored
    in the internal list of the scanner component. if any application dependent
    changes before registering the new token are neccessary it is possible to
    change every part of the new token.


   properties and methods at runtime:

    procedure Analyze( Source: TStream )
    this is the main method taking a source stream to tokens. the
    number of read tokens is available via the property count. the read
    tokens are available in the array Token. before analyzing a new source stream
    the results of a previously analysis are deleted.

    procedure ClearTokenList;
    the token list produced by the stream analysis can be cleared by this
    method.

    procedure Restart
    a formerly stopped analysis goes on working

    property Count: Integer
    this property contains the number of token read by the method analyze.

    property Token[Index: Integer]
    this property gives an easy access to the available token. a little example
    shows the access:

        for i := 1 to Count do
          WorkWithToken( Token[i-1] );

    property Version: string
    this property contains the internal implementation version. maybe this is
    useful, all my self developed components have such a version control
    mechanism

}

{$B-}           // no complete boolean evaluation

unit LXScanner;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type

  // set type for the special chars
  TCharSet = set of Char;

  // enumeration with the possible result token
  TTokenType = ( ttComment, ttEof, ttError,
                 ttHexDecimal, ttIdentifier, ttInteger,
                 ttKeyword, ttReal, ttSpecialChar, ttString );

  // a token contains the token type, the belonging text and the position
  // within the source stream
  TLXToken = class
             Token:       TTokenType;   // token type
             Text:        string;       // representing text
             Position:    Integer;      // positition within the stream
             Row, Column: Integer;      // row and column within source stream
             Tag:         Integer;      // user information
           public
             procedure CopyFrom( SrcToken: TLXToken ); // copy contents from another token
           end;

  // this event type is called if a token from the input stream is read
  // - Token is the actual read token,
  // - AddToList determines if the token is added to the list of read tokens (default is true)
  // - Stop determines if the analysis is stopped now (default is false); a stopped analysis
  //   goes on with the method Restart
  TTokenEvent = procedure (Sender: TObject; Token: TLXToken; var AddToList, Stop: Boolean) of object;

  // decralation of the main scanner component
  TLXScanner = class(TComponent)
  private
    { Private-Decarations}
    CommentBlockPhase: Boolean;      // flag if a comment block reading phase is active
    TokenList:  TList;               // list of read token
    EAState:    Byte;                // condition of the state machine
    EAText:     string;              // string that belongs to a token
    EAToken:    TTokenType;          // recognized token
    EARow:      Integer;             // Row of the first token char
    EAColumn:   Integer;             // Column of the first token char
    EAPosition: Integer;             // Position of the first token char within the stream
    Eof:        Boolean;             // indicate if eof of stream is reached
    NextChar:   Char;                // next not processed char in source stream
    FIdentChars:      TCharSet;      // chars allowed within an identifier
    FAllowFigures:    Boolean;       // allow figures within identifiers
    FAllowIdentifier: Boolean;       // allow identifiers
    FCaseSensitive:   Boolean;       // detecting keywords case sensitive
    FCharacters:      TCharSet;      // allowed special chars
    FCommentLine:     string;        // introducing comment chars
    FCommentBegin:    string;        // introducing comment block begining string
    FCommentEnd:      string;        // introducing comment block ending string
    FKeywords:        TStringList;   // list of defined keywords
    FOnTokenRead: TTokenEvent;       // user defined event if a new token is read
    SourceStream: TStream;           // input stream for lexical analysis
    SourceY:  Integer;               // actual row within source stream
    SourceX:  Integer;               // actual column within source stream
    procedure EASwitch0( ch: Char ); // process a char at state 0 ( start)
    procedure EASwitch1( ch: Char ); // process a char at state 1
    procedure EASwitch3( ch: Char ); // process a char at state 3
    procedure EASwitch5( ch: Char ); // process a char at state 5
    procedure EASwitch7( ch: Char ); // process a char at state 7
    procedure EASwitch9( ch: Char ); // process a char at state 9
    procedure EASwitch11( ch: Char );// process a char at state 11
    procedure EASwitch13( ch: Char );// process a char at state 13
    procedure EASwitch14( ch: Char );// process a char at state 14
    procedure EASwitch16( ch: Char );// process a char at state 16
    procedure EASwitch18( ch: Char );// process a char at state 18
    function  EqualStr( First, Second: string ) : Boolean; // compare two strings depending on case sensitive set
    function  GetAdditionalChars: string;  // read method for property AdditinalChars
    function  GetCount: Integer;           // read method for property Count
    function  GetToken( Index: Integer ) : TLXToken;  // read method for property Token
    function  GetSpecialChars: string;     // read method for property SpecialChars
    function  GetVersion: string;          // read the internal version number
    function  IsKeyword( Value: string ) : Boolean;  // test if a string is a keyword
    function  LookAheadChar: Char;                   // get the net char without reading it
    function  LookAheadStr( Count: Integer) : string;// get the next count char without reading it
    procedure ProcessChar;                      // process the available char
    procedure ReadCh( var ch: Char );           // read a char from the source stream
    procedure ReadToken;                        // read the next token
    procedure SkipChars( Count: Integer );      // skip a number of chars
    procedure SetAdditionalChars( Value: string ); // write method for AdditionalChars
    procedure SetKeywords( Value: TStringList );   // write method for property Keywords
    procedure SetSpecialChars( Value: string );    // write method for SpecialChars
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;     // create the scanner component
    destructor  Destroy; override;                        // destroy the scanner component
    procedure Analyze( Source: TStream );                 // analyze the input file
    procedure ClearTokenList;                             // clear token list
    procedure Restart;                                    // restart a former broken analysis
    property Count: Integer read GetCount;                // number of found token
    property Token[Index: Integer] : TLXToken read GetToken;// array with found token
    property Version: string read GetVersion;             // internal implementation version
  published
    { Published-Deklarationen }
    property AdditionalChars: string read GetAdditionalChars write SetAdditionalChars;
    property AllowFigures: Boolean read FAllowFigures write FAllowFigures;
    property AllowIdentifier: Boolean read FAllowIdentifier write FAllowIdentifier;
    property CommentLine: string read FCommentLine write FCommentLine;
    property CommentBegin: string read FCommentBegin write FCommentBegin;
    property CommentEnd: string read FCommentEnd write FCommentEnd;
    property Keywords: TStringList read FKeywords write SetKeywords;
    property KeywordsCaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property SpecialChars: string read GetSpecialChars write SetSpecialChars;
    property OnTokenRead: TTokenEvent read FOnTokenRead write FOnTokenRead;
  end;

implementation

const
  cVersion:   string   = '1.06';
  WhiteSpace: TCharSet = [' ', #9, #10, #13];   // known white spaces


// copy a token contents from another token
procedure TLXToken.CopyFrom( SrcToken: TLXToken );
begin
  Token := SrcToken.Token;
  Text := SrcToken.Text;
  Position := SrcToken.Position;
  Row := SrcToken.Row;
  Column := SrcToken.Column;
  Tag := SrcToken.Tag;
end;

// this is create constructor of the scanner. no changes to the
// inherited create, only initialization of internal and external
// variables
constructor TLXScanner.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );       // create the class
  TokenList := TList.Create;        // create the list of read token
  FKeywords := TStringList.Create;  // create the list of keywords
  FKeywords.Sorted := true;         // sort the keywords
  FAllowFigures := true;            // default figures are allowed within identifiers
  FAllowIdentifier := true;         // default no identifier is allowed
  FCaseSensitive := false;          // default no case sensitive keyword compare
  FCharacters := [];                // default there are no special chars
  FCommentLine := '//';             // the default comment begin is '//'
  FCommentBegin := '{';             // the default comment block start mark is '{'
  FCommentEnd := '}';               // the default comment block end mark is '}'
  FIdentChars := ['a'..'z', 'A'..'Z']; // first all letters are allowed within identifiers
end;

// this is destructor of the scanner. it is neccessary to free the internal
// dynamic data structures
destructor TLXScanner.Destroy;
begin
  FKeywords.Free;     // deallocate the memory used by the list of keywords
  ClearTokenList;     // delete all saved token
  TokenList.Free;     // deallocate the memory used by the list of read token
  inherited Destroy;  // destroy the class
end;

// this is the main analysis method
procedure TLXScanner.Analyze( Source: TStream );
begin
  SourceStream := Source;               // assign the source stream
  SourceStream.Position := 0;           // set stream position to the beginning
  ClearTokenList;                       // delete old results
  SourceY := 1;                         // first row is 1
  SourceX := 1;                         // first column is 1
  CommentBlockPhase := false;           // the scanner is not in a commant block phase
  Restart;                              // from now it is only a restart
end;

// delete the old analysis results and deallocate the used memory
procedure TLXScanner.ClearTokenList;
var i: Integer;
begin
  for i:= TokenList.Count downto 1 do begin  // for all saved tokens
    TLXToken( TokenList.Items[i-1] ).Free;     // free the last token
    TokenList.Delete( i-1 );                 // delete the list entry
  end;
end;

// compare two strings depending of case sensitive operations
function TLXScanner.EqualStr( First, Second: string ) : Boolean;
begin
  if not FCaseSensitive then begin      // if no case sensitive compare
    First := Uppercase( First );        // only the uppercase strings are compared
    Second := Uppercase( Second );
  end;
  Result := First=Second;               // compare the given strings
end;

// internal the allowed chars for an identifier are stored in an set of char
// this method converts the set of char into a string
function TLXScanner.GetAdditionalChars: string;
var i: Integer;
begin
  Result := '';                                  // first there are no additional chars
  for i := 0 to 255 do begin                     // for all possible chars
    if (Chr(i) in FIdentChars) and               // if the char in in the set
       (not (Chr(i) in ['a'..'z'])) and          // and it's not a lower case letter
       (not (Chr(i) in ['A'..'Z']))  then begin  // an d not a higer case letter
      Result := Result + Chr(i);                 // add the char to the string
    end;
  end;
end;

// get the number of read token
function TLXScanner.GetCount: Integer;
begin
  Result := TokenList.Count; // read token are saved in internal list
end;

// get the already read token at index Index
function TLXScanner.GetToken( Index: Integer ) : TLXToken;
begin
  if (Index < 0 ) or (Index >= Count) then begin  // if the index is invalid
    Result := nil;                                // return nil
  end else begin
    Result := TokenList.Items[Index];             // else return the token
  end;
end;

function TLXScanner.GetVersion: string;
begin
  Result := cVersion;
end;

// internal the special char are stored in a set of char
// this method converts the set of char into a string
function TLXScanner.GetSpecialChars: string;
var i: Integer;
begin
  Result := '';                          // first there are no special chars
  for i := 0 to 255 do begin             // for all possible chars
    if Chr(i) in FCharacters then begin  // if the char is in the set
      Result := Result + Chr(i);         // add the char to the string
    end;
  end;
end;

// this method tests if a string is a keyword. the keywords are defined in
// the list Keywords
function TLXScanner.IsKeyword( Value: string ) : Boolean;
var KeyCompare: string;
    i:          Integer;
begin
  Result := false;                        // first the string is not a keyword
  for i := 1 to FKeywords.Count do begin  // for all defined keywords
    KeyCompare := FKeywords.Strings[i-1]; // get the keyword at index i-1
    if EqualStr( Value, KeyCompare) then begin  // if the two strings are equal
       Result := true;                          // the given string is a keyword
       Break;                                   // exit the for loop
    end;
  end;
end;

// get the net char without reading it
function  TLXScanner.LookAheadChar: Char;
var AheadStr: string;
begin
  AheadStr := LookAheadStr( 1 );  // simply get the next string with length 1
  if Length(AHeadStr) <> 1 then begin
    Result := #10;
  end else begin
    Result := AheadStr[1];        // get only the first char
  end;
end;

// get the next count char without reading it
function  TLXScanner.LookAheadStr( Count: Integer) : string;
var SavePos: LongInt;
    AheadArray: array[0..255] of char;
begin
  SavePos := SourceStream.Position;  // save the actual stream position
  try                                // maybe the end of stream is reached
    FillCHar( AheadArray, SizeOf(Aheadarray), 0 ); // fill the result array with #0
    SourceStream.ReadBuffer( AheadArray, Count );  // read the next count chars
    Result := StrPas( AheadArray );  // convert the result to a pascal string
  except
    on EReadError do begin           // if a read error occures
      Result := '';                  // the result string will be empty
    end;
  end;
  SourceStream.Position := SavePos;  // reset the stream position
end;

// this method reads a char from the source stream and adds it to the
// actual token text
procedure TLXScanner.ProcessChar;
var ch: Char;
begin
  ReadCh( ch );                 // read a char
  EAText := EAText + ch;        // add the char to the actual token text
  if (not Eof) and (ch in LeadBytes) then begin // if a lead byte is read
    ReadCh( ch );               // again read a char
    EAText := EAText + ch;      // and add the char to the actual token text
  end;
end;

// read a new char from the input stream
// the char #10 is used as global linefeed; MAC file has only #13 as linefeed,
// havn't they? Sorry!
// this procedure count the actual row and colum of the input stream.
procedure TLXScanner.ReadCh( var ch: Char );
begin
  try
    SourceStream.ReadBuffer( ch, SizeOf(ch) ); // read the next char
  except
    on EReadError do begin
      Eof := true;
      ch := #0;
    end;
  end;
  if not Eof then begin            // if not Eof the calculate row/column
    // if a combination #13#10 is detected (PC linefeed is cruel!)
    if (ch=#13) and (LookAheadChar = #10) then begin
      try
        SourceStream.ReadBuffer( ch, SizeOf(ch) ); // skip the first CR/LF char
      except
        on EReadError do begin                     // be careful of eof!
          Eof := true;
          ch := #10;                               // the result is sure a normal LF
        end;
      end;
    end;
    if (ch=#13) or (ch=#10) then begin  // if the read char is a linefeed
      Inc(SourceY, 1);                  // increment the row
      SourceX := 1;                     // next column is 1
    end else begin                      // if no lienfeed is found
      Inc(SourceX, 1);                  // increment the column
    end;
  end;
end;

// read the next token with a state machine
procedure TLXScanner.ReadToken;
begin
  if CommentBlockPhase then begin  // if the scanner is within a comment block phase
    EAState := 18;                 // the first state is 18
    EARow := SourceY;              // set the col, row and position if a comment block phase is active
    EAColumn := SourceX;
    EAPosition := SourceStream.Position;
  end else begin                   // else the scanner is in normal operation mode
    EAState := 0;                  // the first state is zero
  end;
  EAText := '';  // first the token text is empty
  if Eof then begin    // if the end of stream is reached
    EAToken := ttEof;  // create a ttEof token
  end else begin
    while true do begin            // endless loop for reading, leaved by a final state
      NextChar := LookAheadChar;   // get the net char without reading it
      case EAState of              // process the char in notice to the actual state
        0: EASwitch0( NextChar );
        1: EASwitch1( NextChar );
        3: EASwitch3( NextChar );
        5: EASwitch5( NextChar );
        7: EASwitch7( NextChar );
        9: EASwitch9( NextChar );
       11: EASwitch11( NextChar );
       13: EASwitch13( NextChar );
       14: EASwitch14( NextChar );
       16: EASwitch16( NextChar );
       18: EASwitch18( NextChar );
      end;
      // check if a final state is reached
      case EAState of
        2: begin      // final state 2 represents a read identifier
             EAToken := ttIdentifier;
             Break;
           end;
        4: begin     // final state 4 represents a read integer
             EAToken := ttInteger;
             Break;
           end;
        6: begin     // final state 6 represents a read real number
             EAToken := ttReal;
             Break;
           end;
        8: begin     // final state 8 represents a read string
             EAToken := ttString;
             Break;
           end;
       10: begin     // final state 10 represents a read special char
             EAToken := ttSpecialChar;
             Break;
           end;
       12: begin     // final state 12 represents a read comment
             EAToken := ttComment;
             Break;
           end;
       15: begin     // final state 15 represents a read hexadecimal number
             EAToken := ttHexdecimal;
             Break;
           end;
       98: begin     // final state 98 represents a lexical error
             EAToken := ttError;
             Break;
           end;
       99: begin     // final state 99 represents the end of the source stream
             EAToken := ttEOF;
             Break;
           end;
      end;
    end;
  end;
end;

// restart a fomerly broken analysis phase
procedure TLXScanner.Restart;
var NewToken:  TLXToken;             // the last read token
    ListToken: TLXToken;             // copy of the read token that is added to the list of token
    AddToList: Boolean;            // add a new token to the token list (result from user event)
    Stop:      Boolean;            // analysis break (result from user event)
begin
  Eof := false;                         // now end of stream is not yet reached
  Stop := False;                        // initialize abort flag
  NewToken := TLXToken.Create;            // create the token structure
  repeat                                // repeat until ttEOF Token is read
    ReadToken;                          // read the next token
    NewToken.Token := EAToken;          // save the read token
    NewToken.Text := EAText;            // save the belonging text
    NewToken.Row := EARow;              // save column
    NewToken.Column := EAColumn;        // save row
    NewToken.Position := EAPosition;    // save the position within the stream
    NewToken.Tag := 0;                  // initialize the user information
    // if an identifier is read and the belonging text is a keyword
    // then change the token type into ttKeyword
    if (NewToken.Token=ttIdentifier) and IsKeyword(NewToken.Text) then begin
      NewToken.Token := ttKeyword;
    end;
    // if an identifier is read and no identifiers are allowed then
    // the token type is changed to ttError
    if (NewToken.Token = ttIdentifier) and (not FAllowIdentifier) then begin
      NewToken.Token := ttError;
    end;
    AddToList := true;                  // default is add the new token to the list of tokens
    // if a user defined event is available this event is called before the
    // token is put in the tokenlist
    if Assigned( FOnTokenRead ) then begin
      FOnTokenRead( Self, NewToken, AddToList, Stop );
    end;
    if AddToList then begin
      ListToken := TLXToken.Create;      // create a new token for the list of tokens
      ListToken.CopyFrom( NewToken );  // copy the contents of the read token
      TokenList.Add( ListToken );      // put the token in the tokenlist
    end;
  until (EAToken = ttEof) or (Stop); // until ttEOF is read or abort flag is set
  NewToken.Free;
end;

// the user defines the additional chars for identifier in a string. this
// string must be converted into a set of char.
procedure TLXScanner.SetAdditionalChars( Value: string );
var i: Integer;
begin
  FIdentChars := ['a'..'z', 'A'..'Z'];        // first all letters are allowed
  for i := 1 to Length(Value) do begin        // for every char in the string
    FIdentChars := FIdentChars + [Value[i]];  // add the char to the set
  end;
end;

// this method seems to be unnecessary, but it is very important for
// the correct work of TStringList in the object inspector
procedure TLXScanner.SetKeywords( Value: TStringList );
begin
  FKeywords.Assign( Value );
end;

// the user defines the special char in a string. this string must be converted
// into a set of char. working with a set of char is much easier, but i
// do not want to implement a new property editor for die usage with the
// object inspector
procedure TLXScanner.SetSpecialChars( Value: string );
var i: Integer;
begin
  FCharacters := [];                          // first the set of char is empty
  for i := 1 to Length(Value) do begin        // for every char in the string
    FCharacters := FCharacters + [Value[i]];  // add the char to the set
  end;
end;

// skip the next count chars from the source stream
procedure TLXScanner.SkipChars( Count: Integer );
var i:  Integer;
    ch: Char;
begin
  for i := 1 to Count do begin
    ReadCh( ch );
  end;
end;

// the following methods are characterizing the internal state machine

// process a char if the state machine has the state 0
// state 0 is the starting state
procedure TLXScanner.EASwitch0( ch: Char );
begin
  if Eof then begin    // if the end of source stream is reached
    EAState := 99;     // switch to state 99
  end else begin
    if ch in FIdentChars then begin
      EAState := 1;
      EARow := SourceY;
      EAColumn := SourceX;
      EAPosition := SourceStream.Position;
      ProcessChar;
    end else begin
      case ch of
        '$'       : begin            // if a '$' is available switch to state 16
                      EAState := 16; // and try to read a hex number or a spacial char
                      EARow := SourceY;
                      EAColumn := SourceX;
                      EAPosition := SourceStream.Position;
                      ProcessChar;
                    end;
        '0'       : begin            // if a '0' is read switch to state 13
                      EAState := 13; // and try to read an integer, real or hex number
                      EARow := SourceY;
                      EAColumn := SourceX;
                      EAPosition := SourceStream.Position;
                      ProcessChar;
                    end;
        '1'..'9'  : begin           // if number is read switch to state 3
                      EAState := 3; // and try to read a integer or a floting point number
                      EARow := SourceY;
                      EAColumn := SourceX;
                      EAPosition := SourceStream.Position;
                      ProcessChar;
                    end;
        ''''      : begin           // if the char ' is read switch to state 7
                      EAState := 7; // and try to read a string limited by '
                      EARow := SourceY;
                      EAColumn := SourceX;
                      EAPosition := SourceStream.Position;
                      ReadCh( ch );
                    end;
        '"'       : begin           // if the char " is read switch to state 9
                      EAState := 9; // and try to read a string limited by "
                      EARow := SourceY;
                      EAColumn := SourceX;
                      EAPosition := SourceStream.Position;
                      ReadCh( ch );
                    end;
      else          begin
                      if ch in WhiteSpace then begin // if a white space is read
                        ReadCh( ch );        // read the next char
                      // if a comment beginning is defined and if the next chars corresend to
                      // the defined comment line begin
                      end else if (Length(FCommentLine) <> 0) and
                                  (EqualStr(LookAHeadStr(Length(FCommentLine)),  FCommentLine)) then begin
                        EAState := 11;             // switch to state 11
                        SkipChars( Length(FCommentLine ) );  // skip the comment line begin
                        EARow := SourceY;          // save row, column and position
                        EAColumn := SourceX;
                        EAPosition := SourceStream.Position;
                      // if a blockcomment beginning is defined and if the next chars corresend to
                      // the defined block comment beginning
                      end else if (Length(FCommentBegin) <> 0) and
                                  (EqualStr(LookAHeadStr(Length(FCommentBegin)),  FCommentBegin)) then begin
                        EAState := 18;             // switch to state 11
                        SkipChars( Length(FCommentBegin ) ); // skip the comment block begin
                        EARow := SourceY;          // save row, column and position
                        EAColumn := SourceX;
                        EAPosition := SourceStream.Position;
                      // if the actual char is a member of the special chars
                      end else if ch in FCharacters then begin
                        EAState := 10;             // switch to state 10
                        EARow := SourceY;          // save row, column and position
                        EAColumn := SourceX;
                        EAPosition := SourceStream.Position;
                        ProcessChar;               // process this char
                      // else an illegal char is read and this will cause an error
                      end else begin
                        EAState := 98;             // switch to state 98
                        EARow := SourceY;          // save row, column ans position
                        EAColumn := SourceX;
                        EAPosition := SourceStream.Position;
                        ProcessChar;               // process this char
                      end;
                    end;
      end;
    end;
  end;
end;

// process a char if the state machine has the state 1.
// in this state the state machines tries to read an identifier. an identifier
// consists of a leading char and any following number or char
procedure TLXScanner.EASwitch1( ch: Char );
begin
  if ch in FIdentChars then begin
    ProcessChar;         // every letter is a part of the identifier
  end else if (FAllowFigures) and (ch in ['0'..'9']) then begin
    ProcessChar;         // if allowed every figures is a part of the identifier
  end else begin
    EAState := 2;        // else switch to final state 2, identifier is complete
  end;
end;

// process a char if the state machine has the state 3.
// in this state a integer or a floating point number is read
procedure TLXScanner.EASwitch3( ch: Char );
begin
  case ch of
    '0'..'9'  : ProcessChar;    // if a number is read the char is processed
    '.'{,','}   : if LookAheadStr(2)[2] in ['0'..'9'] then begin
                  // if a '.' or a ',' is read and the following char is a figure
                  // the char is processed
                  ProcessChar;  // and the state is switched to state 5 in order
                  EAState := 5; // to read a floating point number
                end else begin
                  EAState := 4; // the state is switched to final state 4 (integer)
                end;
  else          EAState := 4;   // the state is switched to final state 4 (integer)
  end;
end;

// process a char if the state machine has the state 5.
// in this state floating point number is read
procedure TLXScanner.EASwitch5( ch: Char );
begin
  case ch of
    '0'..'9'  : ProcessChar    // if a number is read process the char
  else          EAState := 6;  // else the state is switched to final state 6
  end;
end;

// process a char if the state machine has the state 7
// in this state string enclosed in ' is read
procedure TLXScanner.EASwitch7( ch: Char );
begin
  case ch of
    #0, #10,                    // if a #0 (eof) or a linefeed char is read there is an
    #13     : EAState := 98;    // error because the string is not finished
    ''''    : begin             // if the final ' is read
                EAState := 8;   // switch to final state 8 and read the next char
                ReadCh( ch );
              end;
  else        ProcessChar;      // else the char is a member of the string
  end;
end;

// process a char if the state machine has the state 9
// in this state string enclosed in " is read
procedure TLXScanner.EASwitch9( ch: Char );
begin
  case ch of
    #0, #10,                    // if a #0 (eof) or a linefeed char is read there is an
    #13     : EAState := 98;    // error because the string is not finished
    '"'  : begin                // if the final " is read
             EAState := 8;      // switch to final state 8 and read the next char
             ReadCh( ch );
           end;
  else     ProcessChar;         // else the char is a member of the string
  end;
end;

// process a char if the state machine has the state 11
// in this state the state machines reads a comment line.
// a comment begins with the introducing user defined comment string. this
// introducing string is already by the state 0. every linefeed or carridge
// return will end the comment line
procedure TLXScanner.EASwitch11( ch: Char );
begin
  // is the introducing string read complete
  case ch of                     // every linefeed finishes the comment
     #10, #13 : begin
                  EAState := 12; // switch to final state 12
                  ReadCh( ch );  // read the next char
                  // delete every leading blank from the comment line
                  while (Length(EAText)<> 0) and (EAText[1] = ' ') do begin
                    System.Delete( EAText, 1, 1);
                  end;
                  // delete every last blank from the comment line
                  while (Length(EAText)<> 0) and (EAText[Length(EAText)] = ' ') do begin
                    System.Delete( EAText, Length(EAText), 1);
                  end;
                end;
  else     ProcessChar;  // if no linefeed is read add the char to the uncomplete comment line
  end;
end;

// process a char if the state machine has the state 13
// in this state a zero is already read and it is possible that it is
// an integer, a real or a hex number
procedure TLXScanner.EASwitch13( ch: Char );
begin
  case ch of
    'x', 'X': begin           // if a 'x' is read a hexnumer is found
               EAState := 14; // switch to state 14 to read rest of the hex number
               ProcessChar;
               EAText := '';  // clear the input text '0x' because this is not a part of the hex number
             end;
   '0'..'9': begin            // if another number is read it is an integer or
               EAState := 3;  // real number will follow
               ProcessChar;
             end;
   '.', ',': begin            // if a '.' or a ',' is read the char is processed
               ProcessChar;   // and the state is switched to state 5 in order
               EAState := 5;  // to read a floating point number
             end;
  else       EAState := 4;  // the state is switched to final state 4 ( single '0' read)
  end;
end;

// process a char if the state machine has the state 14
// in this state a hex number is read
procedure TLXScanner.EASwitch14( ch: Char );
begin
  case ch of
    'a'..'f',
    'A'..'F',
    '0'..'9' : ProcessChar;
  else         if '$' in FCharacters then begin // if $ is defined as a special char
                 SourceX := SourceX - Length(EAText); // correct the saved column
                 EAState := 10;                 // switch to state final 10, do not read next char!!
                 EAText := '$';                 // correct the read input text
                 SourceStream.Position := EAPosition + 1;  // nice try, but the there was no hex number
               end else begin
                 ProcessChar;   // another char without whitespace
                 EAState := 15; // the state is switched to final state 15, hex number is complete
               end;
  end;
end;

// process a char if the state machine has the state 14
// in this state a hex number is read
procedure TLXScanner.EASwitch16( ch: Char );
begin
  case ch of
    'a'..'f',                    // is an allowed hex char is read
    'A'..'F',
    '0'..'9' : begin
                 EAState := 14;  // switch to state 14 and read the complete hex number
                 EAText := '';   // clear the formerly read '$'
                 ProcessChar;
               end;
  else         begin
                 if '$' in FCharacters then begin // if $ is defined as a special char
                   EAState := 10;                 // switch to state final 10, do not read next char!!
                 end else begin
                   ProcessChar;     // if $ is not the first char of a hex number
                   EAState := 98;   // and no special char there is an error
                 end;
               end;
  end;
end;

// process a char if the state machine has the state 18
// in this state the state machines reads a comment block
// a comment begins with the introducing user defined comment block begin. this
// introducing string is already by the state 0. only the correspondign comment
// block end string will end the comment phase
procedure TLXScanner.EASwitch18( ch: Char );
begin
  // is the introducing string read complete
  // from now to the comment block end the scanner is in a comment block read phase
  CommentBlockPhase := true;
  case ch of                     // every linefeed finishes the comment
     #10, #13 : begin
                  EAState := 12; // switch to final state 12
                  ReadCh( ch );  // read the next char
                  // delete every leading blank from the comment line
                  while (Length(EAText)<> 0) and (EAText[1] = ' ') do begin
                    System.Delete( EAText, 1, 1);
                    Inc( EAColumn, 1 );
                  end;
                  // delete every last blank from the comment line
                  while (Length(EAText)<> 0) and (EAText[Length(EAText)] = ' ') do begin
                    System.Delete( EAText, Length(EAText), 1);
                  end;
                end;
  else          // if a blockcomment ending is defined and if the next chars correspond to
                // the defined block comment ending
                if (Length(FCommentEnd) <> 0) and
                   (EqualStr(LookAHeadStr(Length(FCommentEnd)),  FCommentEnd)) then begin
                  EAState := 12;                     // switch to final state 11
                  SkipChars( Length(FCommentEnd ) ); // skip the comment block begin
                  CommentBlockPhase := false;        // coment block phase has ended
                  while (Length(EAText)<> 0) and (EAText[1] = ' ') do begin
                    System.Delete( EAText, 1, 1);     // delete a leading blank
                    Inc( EAColumn, 1 );               // correct the column counter
                  end;
                  // delete every last blank from the comment line
                  while (Length(EAText)<> 0) and (EAText[Length(EAText)] = ' ') do begin
                    System.Delete( EAText, Length(EAText), 1);
                  end;
                end else begin
                  ProcessChar;  // if no linefeed is read add the char to the uncomplete comment line
                end;
  end;
end;

// register the component at the component palette
// perhaps you want to change the palette register name

end.
