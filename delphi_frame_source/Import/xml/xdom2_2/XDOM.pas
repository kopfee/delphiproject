unit XDOM;
//  Modified By HYL For Supporting GB Encoding

// XDOM 2.2.7
// Extended Document Object Model 2.2.7
// Delphi 3 Implementation
//
// Copyright (c) 2000 by Dieter Köhler
// ("http://www.philo.de/homepage.htm")
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

interface

uses
  Math, SysUtils, Classes;

type
  EDomException = class(Exception);

  EIndex_Size_Err = class(EdomException);
  EDomstring_Size_Err = class(EdomException);
  EHierarchy_Request_Err = class(EdomException);
  EWrong_Document_Err = class(EdomException);
  EInvalid_Character_Err = class(EdomException);
  ENo_Data_Allowed_Err = class(EdomException);
  ENo_Modification_Allowed_Err = class(EdomException);
  ENot_Found_Err = class(EdomException);
  ENot_Supported_Err = class(EdomException);
  EInuse_Attribute_Err = class(EdomException);
  EInvalid_State_Err = class(EdomException);
  ESyntax_Err = class(EdomException);
  EInvalid_Modification_Err = class(EdomException);
  ENamespace_Err = class(EdomException);
  EInvalid_Access_Err = class(EdomException);
  EInuse_Node_Err = class(EdomException);
  EInuse_AttributeDefinition_Err = class(EdomException);
  ENo_External_Entity_Allowed_Err = class(EdomException);
  EIllegal_Entity_Reference_Err = class(EdomException);
  EUnknown_Document_Format_Err = class(EdomException);

  EParserException = class(Exception);

  EParserMissingWhiteSpace_Err = class(EParserException);
  EParserMissingQuotationMark_Err = class(EParserException);
  EParserMissingEqualitySign_Err = class(EParserException);
  EParserDoubleEqualitySign_Err = class(EParserException);
  EParserInvalidElementName_Err = class(EParserException);
  EParserInvalidAttributeName_Err = class(EParserException);
  EParserInvalidAttributeValue_Err = class(EParserException);
  EParserDoubleAttributeName_Err = class(EParserException);
  EParserInvalidEntityName_Err = class(EParserException);
  EParserInvalidProcessingInstruction_Err = class(EParserException);
  EParserInvalidXmlDeclaration_Err = class(EParserException);
  EParserInvalidCharRef_Err = class(EParserException);
  EParserMissingStartTag_Err = class(EParserException);
  EParserInvalidEndTag_Err = class(EParserException);
  EParserInvalidCharacter_Err = class(EParserException);
  EParserNotInRoot_Err = class(EParserException);
  EParserDoubleRootElement_Err = class(EParserException);
  EParserRootNotFound_Err = class(EParserException);
  EParserWrongOrder_Err = class(EParserException);
  EParserInvalidDoctype_Err = class(EParserException);
  EParserInvalidTextDeclaration_Err = class(EParserException);

  EParserDoubleDoctype_Err = class(EParserInvalidDoctype_Err);
  EParserInvalidEntityDeclaration_Err = class(EParserInvalidDoctype_Err);
  EParserInvalidElementDeclaration_Err = class(EParserInvalidDoctype_Err);
  EParserInvalidAttributeDeclaration_Err = class(EParserInvalidDoctype_Err);
  EParserInvalidNotationDeclaration_Err = class(EParserInvalidDoctype_Err);
  EParserInvalidConditionalSection_Err = class(EParserInvalidDoctype_Err);

const
  XmlStrError1En = 'ERROR in line %d';
  XmlStrError1De = 'FEHLER in Zeile %d';
  XmlStrError2En = 'ERROR in line %d-%d';
  XmlStrError2De = 'FEHLER in Zeile %d-%d';
  XmlStrFatalError1En = 'FATAL ERROR in line %d';
  XmlStrFatalError1De = 'KRITISCHER FEHLER in Zeile %d';
  XmlStrFatalError2En = 'FATAL ERROR in line %d-%d';
  XmlStrFatalError2De = 'KRITISCHER FEHLER in Zeile %d-%d';
  XmlStrErrorDefaultEn = 'Invalid source-code';
  XmlStrErrorDefaultDe = 'Ungültiger Quellcode';
  XmlStrInvalidElementNameEn = 'Invalid element name';
  XmlStrInvalidElementNameDe = 'Ungültiger Element-Name';
  XmlStrDoubleRootElementEn ='Double root element';
  XmlStrDoubleRootElementDe ='Doppeltes Wurzel-Element';
  XmlStrRootNotFoundEn ='Declared root element not found';
  XmlStrRootNotFoundDe ='Deklariertes Wurzel-Element nicht gefunden';
  XmlStrDoubleDoctypeEn ='Double document type declaration';
  XmlStrDoubleDoctypeDe ='Doppelte Dokument-Typ-Deklaration';
  XmlStrInvalidAttributeNameEn = 'Invalid attribute name';
  XmlStrInvalidAttributeNameDe = 'Ungültiger Attribut-Name';
  XmlStrInvalidAttributeValueEn = 'Invalid attribute value';
  XmlStrInvalidAttributeValueDe = 'Ungültiger Attribut-Wert';
  XmlStrDoubleAttributeNameEn = 'Double attributename in one element';
  XmlStrDoubleAttributeNameDe = 'Doppelter Attributname in einem Element';
  XmlStrInvalidEntityNameEn = 'Invalid entity name';
  XmlStrInvalidEntityNameDe = 'Ungültiger Entity-Name';
  XmlStrInvalidProcessingInstructionEn = 'Invalid processing instruction target';
  XmlStrInvalidProcessingInstructionDe = 'Ungültiges Processing-Instruction-Ziel';
  XmlStrInvalidXmlDeclarationEn = 'Invalid XML declaration';
  XmlStrInvalidXmlDeclarationDe = 'Ungültige XML-Deklaration';
  XmlStrInvalidCharRefEn = 'Invalid character reference';
  XmlStrInvalidCharRefDe = 'Ungültige Zeichen-Referenz';
  XmlStrMissingQuotationmarksEn = 'Missing quotation marks';
  XmlStrMissingQuotationmarksDe = 'Fehlende Anführungszeichen';
  XmlStrMissingEqualitySignEn = 'Missing equality sign';
  XmlStrMissingEqualitySignDe = 'Fehlendes Gleichheitszeichen';
  XmlStrDoubleEqualitySignEn = 'Double equality sign';
  XmlStrDoubleEqualitySignDe = 'Doppeltes Gleichheitszeichen';
  XmlStrMissingWhiteSpaceEn = 'Missing white-space';
  XmlStrMissingWhiteSpaceDe = 'Fehlender Leerraum';
  XmlStrMissingStartTagEn = 'End-tag without start-tag';
  XmlStrMissingStartTagDe = 'End-Tag ohne Start-Tag';
  XmlStrInvalidEndTagEn = 'Invalid end-tag';
  XmlStrInvalidEndTagDe = 'Ungültiges End-Tag';
  XmlStrInvalidCharacterEn = 'Invalid character';
  XmlStrInvalidCharacterDe = 'Ungültiges Zeichen';
  XmlStrNotInRootEn = 'Character(s) outside the root-element';
  XmlStrNotInRootDe = 'Zeichen außerhalb des Wurzel-Elements';
  XmlStrInvalidDoctypeEn = 'Invalid doctype declaration';
  XmlStrInvalidDoctypeDe = 'Ungültige Dokumenttyp-Deklaration';
  xmlStrWrongOrderEn = 'Wrong order';
  xmlStrWrongOrderDe = 'Falsche Reihenfolge';
  xmlStrInvalidEntityDeclarationEn = 'Invalid entity declaration';
  xmlStrInvalidEntityDeclarationDe = 'Ungültige Entity-Deklaration';
  xmlStrInvalidElementDeclarationEn = 'Invalid element declaration';
  xmlStrInvalidElementDeclarationDe = 'Ungültige Element-Deklaration';
  XmlStrInvalidAttributeDeclarationEn = 'Invalid attribute declaration';
  XmlStrInvalidAttributeDeclarationDe = 'Ungültige Attribut-Deklaration';
  XmlStrInvalidNotationDeclarationEn = 'Invalid notation declaration';
  XmlStrInvalidNotationDeclarationDe = 'Ungültige Notations-Deklaration';
  XmlStrInvalidConditionalSectionEn = 'Invalid conditional section';
  XmlStrInvalidConditionalSectionDe = 'Ungültiger bedingter Abschnitt';
  XmlStrInvalidTextDeclarationEn = 'Invalid text declaration';
  XmlStrInvalidTextDeclarationDe = 'Ungültige Text-Deklaration';
  XmlStrDoubleEntityDeclWarningEn = 'Warning: Double entity declaration';
  XmlStrDoubleEntityDeclWarningDe = 'Warnung: Doppelte Entity-Deklaration';
  XmlStrDoubleNotationDeclWarningEn = 'Warning: Double notation declaration';
  XmlStrDoubleNotationDeclWarningDe = 'Warnung: Doppelte Notation-Deklaration';

type
  TDomNodeType = (ntUnknown,
                  ntElement_Node,
                  ntAttribute_Node,
                  ntText_Node,
                  ntCDATA_Section_Node,
                  ntEntity_Reference_Node,
                  ntEntity_Node,
                  ntProcessing_Instruction_Node,
                  ntXml_Declaration_Node,
                  ntComment_Node,
                  ntDocument_Node,
                  ntDocument_Type_Node,
                  ntDocument_Fragment_Node,
                  ntNotation_Node,
                  ntConditional_Section_Node,
                  ntParameter_Entity_Reference_Node,
                  ntParameter_Entity_Node,
                  ntEntity_Declaration_Node,
                  ntParameter_Entity_Declaration_Node,
                  ntElement_Type_Declaration_Node,
                  ntSequence_Particle_Node,
                  ntChoice_Particle_Node,
                  ntPcdata_Choice_Particle_Node,
                  ntElement_Particle_Node,
                  ntAttribute_List_Node,
                  ntAttribute_Definition_Node,
                  ntNametoken_Node,
                  ntText_Declaration_Node,
                  ntNotation_Declaration_Node,
                  ntExternal_Parsed_Entity_Node,
                  ntExternal_Parameter_Entity_Node,
                  ntExternal_Subset_Node,
                  ntInternal_Subset_Node);
                  // If you change this: show_all (see below) may
                  // have to be changed, too!

  TDomNodeTypeSet = set of TDomNodeType;

  TdomPieceType = (xmlProcessingInstruction,xmlXmlDeclaration,
                   xmlTextDeclaration,xmlComment,xmlCDATA,xmlPCDATA,
                   xmlDoctype,xmlStartTag,xmlEndTag,xmlEmptyElementTag,
                   xmlCharRef,xmlEntityRef,xmlParameterEntityRef,
                   xmlEntityDecl,xmlElementDecl,xmlAttributeDecl,
                   xmlNotationDecl,xmlCondSection,xmlCharacterError);

  TdomContentspecType = (ctEmpty,ctAny,ctMixed,ctChildren);

  TdomEncodingType = (etUTF8,etUTF16BE,etUTF16LE,etMBCS); // modified by HYL

  TdomFilterResult = (filter_accept,filter_reject,filter_skip);

  TdomWhatToShow = set of TDomNodeType;

const
  show_all: TdomWhatToShow = [ntElement_Node .. ntInternal_Subset_Node];

type

  TDomNode = class;
  TDomElement = class;
  TDomDocument = class;
  TdomDocumentType = class;
  TdomEntity = class;
  TdomParameterEntity = class;
  TdomEntityDeclaration = class;
  TdomParameterEntityDeclaration = class;
  TdomNotation = class;
  TdomNotationDeclaration = class;
  TdomNodeList = class;
  TdomAttrList = class;
  TdomAttrDefinition = class;

  TdomMediaList = class;

  TXmlSourceCodePiece = class;

  TdomDocumentClass = class of TdomDocument;

  PdomDocumentFormat = ^TdomDocumentFormat;

  TdomDocumentFormat = record
    DocumentClass: TdomDocumentClass;
    NamespaceUri:  wideString;
    QualifiedName:     wideString;
    next:          PdomDocumentFormat;
  end;

  TdomCustomStr = class
  private
    FActualLen: Integer;
    FCapacity: Integer;
    FContent: WideString;
  public
    constructor create;
    procedure addWideChar(const Ch: WideChar); virtual;
    procedure addWideString(const s: WideString);
    procedure reset;
    function  value: WideString; virtual;
    property  length: integer read FActualLen;
  end;

  TDomImplementation = class (TComponent)
  private
    FCreatedDocuments: TdomNodeList;
    FCreatedDocumentTypes: TdomNodeList;
    FCreatedDocumentsListing: TList;
    FCreatedDocumentTypesListing: TList;
    function getDocuments: TdomNodeList; virtual;
    function getDocumentTypes: TdomNodeList; virtual;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure FreeDocument(const doc: TdomDocument); virtual;
    procedure FreeDocumentType(const docType: TdomDocumentType); virtual;
    function hasFeature(const feature,
                              version: WideString): boolean; virtual;
    function createDocument(const name: WideString;
                                  doctype: TdomDocumentType): TdomDocument; virtual;
    function createDocumentNS(const namespaceURI,
                                    qualifiedName: WideString;
                                    doctype: TdomDocumentType): TdomDocument; virtual;
    function createDocumentType(const name,
                                      publicId,
                                      systemId: WideString): TdomDocumentType; virtual;
    function createDocumentTypeNS(const qualifiedName,
                                        publicId,
                                        systemId: WideString): TdomDocumentType; virtual;
    function GetDocumentClass(const aNamespaceUri,
                                    aQualifiedName: wideString): TdomDocumentClass; virtual;
    class procedure RegisterDocumentFormat(const aNamespaceUri,
                                                 aQualifiedName: wideString;
                                                 aDocumentClass: TdomDocumentClass); virtual;
    function SupportsDocumentFormat(const aNamespaceUri,
                                          aQualifiedName: wideString): boolean; virtual;
    class procedure UnregisterDocumentClass(const aDocumentClass: TdomDocumentClass); virtual;
    property documents: TdomNodeList read getDocuments;
    property documentTypes: TdomNodeList read getDocumentTypes;
  end;

  TdomNodeFilter = class
  public
    function acceptNode(const node: TdomNode): TdomFilterResult; virtual; abstract;
  end;

  TdomTreeWalker = class
  private
    FRoot: TdomNode;
    FCurrentNode: TdomNode;
    FExpandEntityReferences: boolean;
    FWhatToShow: TdomWhatToShow;
    FFilter: TdomNodeFilter;
    function GetCurrentNode: TdomNode; virtual;
    procedure SetCurrentNode(const Node: TdomNode); virtual;
    function GetExpandEntityReferences: boolean; virtual;
    function GetFilter: TdomNodeFilter; virtual;
    function GetRoot: TdomNode; virtual;
    function GetWhatToShow: TdomWhatToShow; virtual;
    function FindNextSibling(const OldNode: TdomNode): TdomNode; virtual;
    function FindPreviousSibling(const OldNode: TdomNode): TdomNode; virtual;
    function FindParentNode(const OldNode: TdomNode): TdomNode; virtual;
    function FindFirstChild(const OldNode: TdomNode): TdomNode; virtual;
    function FindLastChild(const OldNode: TdomNode): TdomNode; virtual;
    function FindNextNode(OldNode: TdomNode): TdomNode; virtual;
    function FindPreviousNode(const OldNode: TdomNode): TdomNode; virtual;
  public
    constructor create(const Root: TdomNode;
                       const WhatToShow: TdomWhatToShow;
                       const NodeFilter: TdomNodeFilter;
                       const EntityReferenceExpansion: boolean); virtual;
    function parentNode: TdomNode; virtual;
    function firstChild: TdomNode; virtual;
    function lastChild: TdomNode; virtual;
    function previousSibling: TdomNode; virtual;
    function nextSibling: TdomNode; virtual;
    function NextNode: TdomNode; virtual;
    function PreviousNode: TdomNode; virtual;
    property currentNode: TdomNode read GetCurrentNode write SetCurrentNode;
    property expandEntityReferences: boolean read GetExpandEntityReferences;
    property filter: TdomNodeFilter read GetFilter;
    property root: TdomNode read GetRoot;
    property whatToShow: TdomWhatToShow read GetWhatToShow;
  end;

  TdomPosition = (posBefore,posAfter);

  TdomNodeIterator = class
  private
    FRoot: TdomNode;
    FReferenceNode: TdomNode;
    FPosition: TdomPosition; // Position of the Iterator relativ to FReferenceNode
    FWhatToShow: TdomWhatToShow;
    FExpandEntityReferences: boolean;
    FFilter: TdomNodeFilter;
    FInvalid: boolean;
    procedure FindNewReferenceNode(const nodeToRemove: TdomNode); virtual; // To be called if the current FReferneceNode is being removed
    function GetExpandEntityReferences: boolean; virtual;
    function GetFilter: TdomNodeFilter; virtual;
    function GetRoot: TdomNode; virtual;
    function GetWhatToShow: TdomWhatToShow; virtual;
    function FindNextNode(OldNode: TdomNode): TdomNode; virtual;
    function FindPreviousNode(const OldNode: TdomNode): TdomNode; virtual;
  public
    constructor create(const Root: TdomNode;
                       const WhatToShow: TdomWhatToShow;
                       const NodeFilter: TdomNodeFilter;
                       const EntityReferenceExpansion: boolean); virtual;
    procedure detach; virtual;
    function NextNode: TdomNode; virtual;
    function PreviousNode: TdomNode; virtual;
    property expandEntityReferences: boolean read GetExpandEntityReferences;
    property filter: TdomNodeFilter read GetFilter;
    property root: TdomNode read GetRoot;
    property whatToShow: TdomWhatToShow read GetWhatToShow;
  end;

  TdomNodeList = class
  private
    FNodeList: TList;
    function GetLength: integer; virtual;
  protected
    function IndexOf(const Node: TdomNode): integer; virtual;
  public
    function Item(const index: integer): TdomNode; virtual;
    constructor Create(const NodeList: TList);
    property Length: integer read GetLength;
  end;

  TdomElementsNodeList = class(TdomNodeList)
  private
    FQueryName: WideString;
    FStartElement: TdomNode;
    function GetLength: integer; override;
  public
    function IndexOf(const Node: TdomNode): integer; override;
    function Item(const index: integer): TdomNode; override;
    constructor Create(const QueryName: WideString;
                       const StartElement: TdomNode); virtual;
  end;

  TdomElementsNodeListNS = class(TdomNodeList)
  private
    FQueryNamespaceURI: WideString;
    FQueryLocalName: WideString;
    FStartElement: TdomNode;
    function GetLength: integer; override;
  public
    function IndexOf(const Node: TdomNode): integer; override;
    function Item(const index: integer): TdomNode; override;
    constructor Create(const QueryNamespaceURI,
                             QueryLocalName: WideString;
                       const StartElement: TdomNode); virtual;
  end;

  TdomSpecialNodeList = class(TdomNodeList)
  private
    FAllowedNodeTypes: TDomNodeTypeSet;
    function GetLength: integer; override;
  protected
    function GetNamedIndex(const Name: WideString): integer; virtual;
    function GetNamedItem(const Name: WideString): TdomNode; virtual;
  public
    function IndexOf(const Node: TdomNode): integer; override;
    function Item(const index: integer): TdomNode; override;
    constructor Create(const NodeList: TList;
                       const AllowedNTs: TDomNodeTypeSet); virtual;
  end;

  TdomNamedNodeMap = class(TdomNodeList)
  private
    FOwner: TdomNode;     // The owner document.
    FOwnerNode: TdomNode; // The node to whom the map is attached to.
    FNamespaceAware: boolean;
    FAllowedNodeTypes: TDomNodeTypeSet;
    function getOwnerNode: TdomNode; virtual;
    function getNamespaceAware: boolean; virtual;
    procedure setNamespaceAware(const value: boolean); virtual;
  protected
    function RemoveItem(const Arg: TdomNode): TdomNode; virtual;
    function GetNamedIndex(const Name: WideString): integer; virtual;
  public
    constructor Create(const AOwner,
                             AOwnerNode: TdomNode;
                       const NodeList: TList;
                       const AllowedNTs: TDomNodeTypeSet); virtual;
    function GetNamedItem(const Name: WideString): TdomNode; virtual;
    function SetNamedItem(const Arg: TdomNode): TdomNode; virtual;
    function RemoveNamedItem(const Name: WideString): TdomNode; virtual;
    function GetNamedItemNS(const namespaceURI,
                                  LocalName: WideString): TdomNode; virtual;
    function SetNamedItemNS(const Arg: TdomNode): TdomNode; virtual;
    function RemoveNamedItemNS(const namespaceURI,
                                     LocalName: WideString): TdomNode; virtual;
  published
    property ownerNode: TdomNode read GetOwnerNode;
    property namespaceAware: boolean read GetNamespaceAware write SetNamespaceAware;
  end;

  TdomEntitiesNamedNodeMap = class(TdomNamedNodeMap)
  private
    procedure ResolveAfterAddition(const addedEntity: TdomEntity); virtual;
    procedure ResolveAfterRemoval(const removedEntity: TdomEntity); virtual;
  public
    function SetNamedItem(const Arg: TdomNode): TdomNode; override;
    function RemoveNamedItem(const Name: WideString): TdomNode; override;
    function SetNamedItemNS(const Arg: TdomNode): TdomNode; override;
    function RemoveNamedItemNS(const namespaceURI,
                                     LocalName: WideString): TdomNode; override;
  end;

  TdomNode = class
  private
    FNodeName: WideString;
    FNodeValue: WideString;
    FNamespaceURI: WideString;
    FNodeType: TdomNodeType;
    FNodeList: TdomNodeList;
    FNodeListing: TList;
    FDocument: TdomDocument;
    FParentNode: TdomNode;
    FIsReadonly: boolean;
    FAllowedChildTypes: set of TDomNodeType;
    procedure makeChildrenReadonly; virtual;
    function RefersToExternalEntity: boolean; virtual;
    function HasEntRef(const EntName: widestring): boolean; virtual;
    procedure addEntRefSubtree(const EntName: widestring); virtual;
    procedure removeEntRefSubtree(const EntName: widestring); virtual;
    function GetNodeName: WideString; virtual;
    function GetNodeValue: WideString; virtual;
    procedure SetNodeValue(const Value: WideString); virtual;
    function GetNodeType: TdomNodeType; virtual;
    function GetAttributes: TdomNamedNodeMap; virtual;
    function GetParentNode: TdomNode; virtual;
    function GetChildNodes: TdomNodeList; virtual;
    function GetFirstChild: TdomNode; virtual;
    function GetLastChild: TdomNode; virtual;
    function GetPreviousSibling: TdomNode; virtual;
    function GetNextSibling: TdomNode; virtual;
    function GetDocument: TdomDocument; virtual;
    function GetCode: WideString; virtual;
    function GetLocalName: WideString; virtual;
    function GetNamespaceURI: WideString; virtual;
    function GetPrefix: WideString; virtual;
    procedure SetPrefix(const value: WideString); virtual;
  public
    constructor Create(const AOwner: TdomDocument);
    destructor Destroy; override;
    procedure Clear; virtual;
    function InsertBefore(const newChild,
                                refChild: TdomNode): TdomNode; virtual;
    function ReplaceChild(const newChild,
                                oldChild: TdomNode): TdomNode; virtual;
    function RemoveChild(const oldChild: TdomNode): TdomNode; virtual;
    function AppendChild(const newChild: TdomNode): TdomNode; virtual;
    function HasChildNodes: boolean; virtual;
    function CloneNode(const deep: boolean): TdomNode; virtual;
    function IsAncestor(const AncestorNode: TdomNode): boolean; virtual;
    procedure GetLiteralAsNodes(const RefNode: TdomNode); virtual;
    procedure normalize; virtual;
    function supports(const feature,
                            version: WideString): boolean; virtual;
  published
    property Attributes:      TdomNamedNodeMap read GetAttributes;
    property ChildNodes:      TdomNodeList     read GetChildNodes;
    property Code:            WideString       read GetCode;
    property FirstChild:      TdomNode         read GetFirstChild;
    property LastChild:       TdomNode         read GetLastChild;
    property LocalName:       WideString       read GetLocalName;
    property NamespaceURI:    WideString       read GetNamespaceURI;
    property NextSibling:     TdomNode         read GetNextSibling;
    property NodeName:        WideString       read GetNodeName;
    property NodeType:        TdomNodeType     read GetNodeType;
    property NodeValue:       WideString       read GetNodeValue write SetNodeValue;
    property OwnerDocument:   TdomDocument     read GetDocument;
    property ParentNode:      TdomNode         read GetParentNode;
    property PreviousSibling: TdomNode         read GetPreviousSibling;
    property Prefix:          WideString       read GetPrefix write SetPrefix;
  end;

  TdomCharacterData = class (TdomNode)
  private
    function GetData: WideString; virtual;
    procedure SetData(const Value: WideString); virtual;
    function GetLength: integer; virtual;
  public
    constructor Create(const AOwner: TdomDocument); virtual;
    function SubstringData(const offset,
                                 count: integer):WideString; virtual;
    procedure AppendData(const arg: WideString); virtual;
    procedure InsertData(const offset: integer;
                         const arg: WideString); virtual;
    procedure DeleteData(const offset,
                               count: integer); virtual;
    procedure ReplaceData(const offset,
                                count: integer;
                          const arg: WideString); virtual;
  published
    property Data: WideString read GetData write SetData;
    property length: integer read GetLength;
  end;

  TdomAttr = class (TdomNode)
  private
    FOwnerElement: TdomElement;
    FSpecified: boolean;
    function GetName: WideString; virtual;
    function GetSpecified: boolean; virtual;
    function GetNodeValue: WideString; override;
    procedure SetNodeValue(const Value: WideString); override;
    function GetValue: WideString; virtual;
    procedure SetValue(const Value: WideString); virtual;
    function GetOwnerElement: TdomElement; virtual;
    function GetParentNode: TdomNode; override;
    function GetPreviousSibling: TdomNode; override;
    function GetNextSibling: TdomNode; override;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const NamespaceURI,
                             Name: WideString;
                       const Spcfd: boolean); virtual;
    procedure normalize; override;
  published
    property Name: WideString read GetName;
    property Specified: boolean read GetSpecified default false;
    property Value: WideString read GetValue write SetValue;
    property OwnerElement: TdomElement read GetOwnerElement;
  end;

  TdomElement = class (TdomNode)
  private
    FCreatedElementsNodeLists: TList;
    FCreatedElementsNodeListNSs: TList;
    FAttributeListing: TList;
    FAttributeList: TdomNamedNodeMap;
    procedure SetNodeValue(const Value: WideString); override;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const NamespaceURI,
                             TagName: WideString); virtual;
    destructor Destroy; override;
    function GetTagName: WideString; virtual;
    function GetAttributes: TdomNamedNodeMap; override;
    function GetAttribute(const Name: WideString): WideString; virtual;
    function SetAttribute(const Name,
                                Value: WideString): TdomAttr; virtual;
    function RemoveAttribute(const Name: WideString): TdomAttr; virtual;
    function GetAttributeNode(const Name: WideString): TdomAttr; virtual;
    function SetAttributeNode(const NewAttr: TdomAttr): TdomAttr; virtual;
    function RemoveAttributeNode(const OldAttr: TdomAttr): TdomAttr; virtual;
    function GetElementsByTagName(const Name: WideString): TdomNodeList; virtual;
    function GetAttributeNS(const namespaceURI,
                                  localName: WideString): WideString; virtual;
    function SetAttributeNS(const namespaceURI,
                                  qualifiedName,
                                  value: WideString): TdomAttr; virtual;
    function RemoveAttributeNS(const namespaceURI,
                                     localName: WideString): TdomAttr; virtual;
    function GetAttributeNodeNS(const namespaceURI,
                                      localName: WideString): TdomAttr; virtual;
    function SetAttributeNodeNS(const NewAttr: TdomAttr): TdomAttr; virtual;
    function GetElementsByTagNameNS(const namespaceURI,
                                          localName: WideString): TdomNodeList; virtual;
    function hasAttribute(const name: WideString): boolean; virtual;
    function hasAttributeNS(const namespaceURI,
                                  localName: WideString): boolean; virtual;
    procedure normalize; override;
  published
    property TagName: WideString read GetTagName;
  end;

  TdomText = class (TdomCharacterData)
  private
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument); override;
    function SplitText(const offset: integer): TdomText; virtual;
  end;

  TdomComment = class (TdomCharacterData)
  private
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument); override;
  end;

  TdomProcessingInstruction = class (TdomNode)
  private
    function GetTarget: WideString; virtual;
    function GetData: WideString; virtual;
    procedure SetData(const Value: WideString); virtual;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Targ: WideString); virtual;
  published
    property Target: WideString read GetTarget;
    property Data: WideString read GetData write SetData;
  end;

  TdomXmlDeclaration = class (TdomNode)
  private
    FStandalone: WideString;
    FEncodingDecl: WideString;
    FVersionNumber: WideString;
    function GetVersionNumber: WideString; virtual;
    function GetEncodingDecl: WideString; virtual;
    procedure SetEncodingDecl(const Value: WideSTring); virtual;
    function GetStandalone: WideString; virtual;
    procedure SetStandalone(const Value: WideSTring); virtual;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Version,
                             EncDl,
                             SdDl: WideString); virtual;
  published
    property VersionNumber: WideString read GetVersionNumber;
    property EncodingDecl: WideString read GetEncodingDecl write SetEncodingDecl;
    property SDDecl: WideString read GetStandalone write SetStandalone;
  end;

  TdomCDATASection = class (TdomText)
  private
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument); override;
  end;

  TdomCustomDocumentType = class (TdomNode)
  private
    FParameterEntitiesListing: TList;
    FAttributeListsListing: TList;
    FParameterEntitiesList: TdomNamedNodeMap;
    FAttributeListsList: TdomNamedNodeMap;
    function GetParameterEntities: TdomNamedNodeMap; virtual;
    function GetAttributeLists: TdomNamedNodeMap; virtual;
    procedure SetNodeValue(const Value: WideString); override;
  public
    constructor Create(const AOwner: TdomDocument);
    destructor Destroy; override;
  published
    property AttributeLists: TdomNamedNodeMap read GetAttributeLists;
    property ParameterEntities: TdomNamedNodeMap read GetParameterEntities;
  end;

  TdomExternalSubset = class (TdomCustomDocumentType)
  public
    constructor Create(const AOwner: TdomDocument); virtual;
    function CloneNode(const deep: boolean): TdomNode; override;
  end;

  TdomInternalSubset = class (TdomCustomDocumentType)
  public
    constructor Create(const AOwner: TdomDocument); virtual;
  end;

  TdomConditionalSection = class(TdomCustomDocumentType)
  private
   FIncluded: TdomNode;
   function  GetIncluded: TdomNode; virtual;
   function GetCode: WideString; override;
  protected
   function  SetIncluded(const node: TdomNode): TdomNode; virtual;
  public
    constructor Create(const AOwner: TdomDocument;
                       const IncludeStmt: WideString); virtual;
  published
    property Included: TdomNode read GetIncluded;
  end;

  TdomDocumentType = class (TdomCustomDocumentType)
  private
    FPublicId: WideString;
    FSystemId: WideString;
    FEntitiesListing: TList;
    FEntitiesList: TdomEntitiesNamedNodeMap;
    FNotationsListing: TList;
    FNotationsList: TdomNamedNodeMap;
    function analyzeEntityValue(const EntityValue: wideString): widestring; virtual;
    function GetEntities: TdomEntitiesNamedNodeMap; virtual;
    function GetName: WideString; virtual;
    function GetNotations: TdomNamedNodeMap; virtual;
    function GetPublicId: WideString; virtual;
    function GetSystemId: WideString; virtual;
    function GetExternalSubsetNode: TdomExternalSubset; virtual;
    function GetInternalSubsetNode: TdomInternalSubset; virtual;
    function GetInternalSubset: WideString; virtual;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             PubId,
                             SysId: WideString); virtual;
    destructor  destroy; override;
  published
    property Entities: TdomEntitiesNamedNodeMap read GetEntities;
    property ExternalSubsetNode: TdomExternalSubset read GetExternalSubsetNode;
    property InternalSubset: WideString read GetInternalSubset;
    property InternalSubsetNode: TdomInternalSubset read GetInternalSubsetNode;
    property Name: WideString read GetName;
    property Notations: TdomNamedNodeMap read GetNotations;
    property PublicId: WideString read GetPublicId;
    property SystemId: WideString read GetSystemId;
  end;

  TdomNotation = class (TdomNode)
  private
    FPublicId: WideString;
    FSystemId: WideString;
    function GetPublicId: WideString; virtual;
    function GetSystemId: WideString; virtual;
    procedure SetNodeValue(const Value: WideString); override;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             PubId,
                             SysId: WideString); virtual;
  published
    property PublicId: WideString read GetPublicId;
    property SystemId: WideString read GetSystemId;
  end;

  TdomNotationDeclaration = class (TdomNode)
  private
    FPublicId: WideString;
    FSystemId: WideString;
    function GetPublicId: WideString; virtual;
    function GetSystemId: WideString; virtual;
    procedure SetNodeValue(const Value: WideString); override;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             PubId,
                             SysId: WideString); virtual;
  published
    property PublicId: WideString read GetPublicId;
    property SystemId: WideString read GetSystemId;
  end;

  TdomCustomDeclaration = class (TdomNode)
  private
    function GetValue: WideString; virtual;
    procedure SetValue(const Value: WideString); virtual;
    procedure SetNodeValue(const Value: WideString); override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name: WideString);
  published
    property Value: WideString read GetValue write SetValue;
  end;

  TdomElementTypeDeclaration = class (TdomCustomDeclaration)
  private
    FContentspec: TdomContentspecType;
    function GetContentspec: TdomContentspecType; virtual;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name: WideString;
                       const Contspec: TdomContentspecType); virtual;
    function AppendChild(const newChild: TdomNode): TdomNode; override;
    function InsertBefore(const newChild,
                                refChild: TdomNode): TdomNode; override;
  published
    property Contentspec: TdomContentspecType read GetContentspec;
  end;

  TdomAttrList = class(TdomCustomDeclaration)
  private
    FAttDefListing: TList;
    FAttDefList: TdomNamedNodeMap;
    function GetAttributeDefinitions: TdomNamedNodeMap; virtual;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name: WideString); virtual;
    destructor Destroy; override;
    function RemoveAttributeDefinition(const Name: WideString): TdomAttrDefinition; virtual;
    function GetAttributeDefinitionNode(const Name: WideString): TdomAttrDefinition; virtual;
    function SetAttributeDefinitionNode(const NewAttDef: TdomAttrDefinition): boolean; virtual;
    function RemoveAttributeDefinitionNode(const OldAttDef: TdomAttrDefinition): TdomAttrDefinition; virtual;
  published
    property AttributeDefinitions: TdomNamedNodeMap read GetAttributeDefinitions;
  end;

  TdomAttrDefinition = class(TdomNode)
  private
    FAttributeType: WideString;
    FDefaultDeclaration: WideString;
    FParentAttributeList: TdomAttrList;
    function GetAttributeType: WideString; virtual;
    function GetDefaultDeclaration: WideString; virtual;
    function GetName: WideString; virtual;
    function GetParentAttributeList: TdomAttrList; virtual;
    procedure SetNodeValue(const Value: WideString); override;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             AttType,
                             DefaultDecl,
                             AttValue: WideString); virtual;
  published
    property AttributeType: WideString read GetAttributeType;
    property DefaultDeclaration: WideString read GetDefaultDeclaration;
    property Name: WideString read GetName;
    property ParentAttributeList: TdomAttrList read GetParentAttributeList;
  end;

  TdomNametoken = class (TdomNode)
  private
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name: WideString); virtual;
    procedure SetNodeValue(const Value: WideString); override;
  end;

  TdomParticle = class (TdomNode)
  private
    FFrequency: WideString;
    function  GetFrequency: WideString; virtual;
    procedure SetFrequency(const freq: WideString); virtual;
    procedure SetNodeValue(const Value: WideString); override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Freq: WideString);
  published
    property Frequency: WideString read GetFrequency;
  end;

  TdomSequenceParticle = class (TdomParticle)
  private
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Freq: WideString); virtual;
  end;

  TdomChoiceParticle = class (TdomParticle)
  private
    function getCode: WideString; override;
  public
    constructor create(const AOwner: TdomDocument;
                       const Freq: WideString); virtual;
  end;

  TdomPcdataChoiceParticle = class (TdomParticle)
  private
    function getCode: WideString; override;
    procedure SetFrequency(const freq: WideString); override;
  public
    constructor create(const AOwner: TdomDocument;
                       const Freq: WideString); virtual;
  end;

  TdomElementParticle = class (TdomParticle)
  private
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             Freq: WideString); virtual;
  end;

  TdomCustomEntity = class (TdomCustomDeclaration)
  private
    FPublicId: WideString;
    FSystemId: WideString;
    FIsInternalEntity: boolean;
    function GetIsInternalEntity: boolean; virtual;
    function GetPublicId: WideString; virtual;
    function GetSystemId: WideString; virtual;
    procedure SetValue(const Value: WideString); override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             PubId,
                             SysId: WideString);
    function InsertBefore(const newChild,
                                refChild: TdomNode): TdomNode; override;
    function ReplaceChild(const newChild,
                                oldChild: TdomNode): TdomNode; override;
    function AppendChild(const newChild: TdomNode): TdomNode; override;
  published
    property PublicId: WideString read GetPublicId;
    property SystemId: WideString read GetSystemId;
    property IsInternalEntity: boolean read GetIsInternalEntity;
  end;

  TdomExternalParsedEntity = class (TdomNode)
  public
    constructor Create(const AOwner: TdomDocument); virtual;
  end;

  TdomExternalParameterEntity = class (TdomNode)
  public
    constructor Create(const AOwner: TdomDocument); virtual;
  end;

  TdomEntity = class (TdomCustomEntity)
  private
    FNotationName: WideString;
    function GetNotationName: WideString; virtual;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             PubId,
                             SysId,
                             NotaName: WideString); virtual;
    function CloneNode(const deep: boolean): TdomNode; override;
    property NotationName: WideString read GetNotationName;
  end;

  TdomParameterEntity = class (TdomCustomEntity)
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             PubId,
                             SysId: WideString); virtual;
  end;

  TdomEntityDeclaration = class (TdomCustomEntity)
  private
    FNotationName: WideString;
    FExtParsedEnt: TdomExternalParsedEntity;
    function GetExtParsedEnt: TdomExternalParsedEntity; virtual;
    procedure SetExtParsedEnt(const Value: TdomExternalParsedEntity); virtual;
    function GetNotationName: WideString; virtual;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             EntityValue,
                             PubId,
                             SysId,
                             NotaName: WideString); virtual;
    property ExtParsedEnt: TdomExternalParsedEntity read GetExtParsedEnt write SetExtParsedEnt;
    property NotationName: WideString read GetNotationName;
  end;

  TdomParameterEntityDeclaration = class (TdomCustomEntity)
  private
    FExtParamEnt: TdomExternalParameterEntity;
    function GetCode: WideString; override;
    function GetExtParamEnt: TdomExternalParameterEntity; virtual;
    procedure SetExtParamEnt(const Value: TdomExternalParameterEntity); virtual;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name,
                             EntityValue,
                             PubId,
                             SysId: WideString); virtual;
    property ExtParamEnt: TdomExternalParameterEntity read GetExtParamEnt write SetExtParamEnt;
  end;

  TdomReference = class (TdomNode)
  private
    function GetDeclaration: TdomCustomEntity; virtual;
    procedure SetNodeValue(const Value: WideString); override;
    function GetNodeValue: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name: WideString); virtual;
  published
    property Declaration: TdomCustomEntity read GetDeclaration;
  end;

  TdomEntityReference = class (TdomReference)
  private
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name: WideString); override;
    function CloneNode(const deep: boolean): TdomNode; override;
  end;

  TdomParameterEntityReference = class (TdomReference)
  private
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Name: WideString); override;
  end;

  TdomTextDeclaration = class (TdomNode)
  private
    FEncodingDecl: WideString;
    FVersionNumber: WideString;
    function GetVersionNumber: WideString; virtual;
    function GetEncodingDecl: WideString; virtual;
    procedure SetEncodingDecl(const Value: WideSTring); virtual;
    function GetCode: WideString; override;
  public
    constructor Create(const AOwner: TdomDocument;
                       const Version,
                             EncDl: WideString); virtual;
  published
    property VersionNumber: WideString read GetVersionNumber;
    property EncodingDecl: WideString read GetEncodingDecl write SetEncodingDecl;
  end;

  TdomDocumentFragment = class (TdomNode)
  private
    procedure SetNodeValue(const Value: WideString); override;
  public
    constructor Create(const AOwner: TdomDocument); virtual;
  end;

  TdomDocument = class (TdomNode)
  private
    FCreatedNodes: TList;
    FCreatedNodeIterators: TList;
    FCreatedTreeWalkers: TList;
    FCreatedElementsNodeLists: TList;
    FCreatedElementsNodeListNSs: TList;
    FFilename: TFilename;
    function  ExpandEntRef(const Node: TdomEntityReference): boolean; virtual;
    function  GetFilename: TFilename; virtual;
    procedure SetFilename(const Value: TFilename); virtual;
    procedure FindNewReferenceNodes(const NodeToRemove: TdomNode); virtual;
    function  GetCodeAsString: String; virtual;
    function  GetCodeAsWideString: WideString; virtual;
    function  GetDoctype: TdomDocumentType; virtual;
    function  GetDocumentElement: TdomElement; virtual;
    function  GetXmlDeclaration: TdomXmlDeclaration; virtual;
    procedure SetNodeValue(const Value: WideString); override;
    function  GetCode: WideString; override;
  protected
    function IsHTML: boolean; virtual;
    function DuplicateNode(Node: TdomNode): TdomNode; virtual;
    procedure InitDoc(const TagName: wideString); virtual;
    procedure InitDocNS(const NamespaceURI,
                              QualifiedName: WideString); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; override;
    procedure ClearInvalidNodeIterators; virtual;
    function CreateElement(const TagName: WideString): TdomElement; virtual;
    function CreateElementNS(const NamespaceURI,
                                   QualifiedName: WideString): TdomElement; virtual;
    function CreateDocumentFragment: TdomDocumentFragment; virtual;
    function CreateText(const Data: WideString): TdomText; virtual;
    function CreateComment(const Data: WideString): TdomComment; virtual;
    function CreateConditionalSection(const IncludeStmt: WideString): TdomConditionalSection; virtual;
    function CreateCDATASection(const Data: WideString): TdomCDATASection; virtual;
    function CreateProcessingInstruction(const Targ,
                                               Data : WideString): TdomProcessingInstruction; virtual;
    function CreateXmlDeclaration(const Version,
                                        EncDl,
                                        SdDl: WideString): TdomXmlDeclaration; virtual;
    function CreateAttribute(const Name: WideString): TdomAttr; virtual;
    function CreateAttributeNS(const NamespaceURI,
                                     QualifiedName: WideString): TdomAttr; virtual;
    function CreateEntityReference(const Name: WideString): TdomEntityReference; virtual;
    function CreateParameterEntityReference(const Name: WideString): TdomParameterEntityReference; virtual;
    function CreateDocumentType(const Name,
                                      PubId,
                                      SysId: WideString): TdomDocumentType; virtual;
    function CreateNotation(const Name,
                                  PubId,
                                  SysId: WideString): TdomNotation; virtual;
    function CreateNotationDeclaration(const Name,
                                             PubId,
                                             SysId: WideString): TdomNotationDeclaration; virtual;
    function CreateEntity(const Name,
                                PubId,
                                SysId,
                                NotaName: WideString): TdomEntity; virtual;
    function CreateParameterEntity(const Name,
                                         PubId,
                                         SysId: WideString): TdomParameterEntity; virtual;
    function CreateEntityDeclaration(const Name,
                                           EntityValue,
                                           PubId,
                                           SysId,
                                           NotaName: WideString): TdomEntityDeclaration; virtual;
    function CreateParameterEntityDeclaration(const Name,
                                                    EntityValue,
                                                    PubId,
                                                    SysId: WideString): TdomParameterEntityDeclaration; virtual;
    function CreateElementTypeDeclaration(const Name: WideString;
                                          const Contspec: TdomContentspecType): TdomElementTypeDeclaration; virtual;
    function CreateSequenceParticle(const Freq: WideString): TdomSequenceParticle; virtual;
    function CreateChoiceParticle(const Freq: WideString): TdomChoiceParticle; virtual;
    function CreatePcdataChoiceParticle: TdomPcdataChoiceParticle; virtual;
    function CreateElementParticle(const Name,
                                         Freq: WideString): TdomElementParticle; virtual;
    function CreateAttributeList(const Name: WideString): TdomAttrList; virtual;
    function CreateAttributeDefinition(const Name,
                                             AttType,
                                             DefaultDecl,
                                             AttValue: WideString) : TdomAttrDefinition; virtual;
    function CreateNametoken(const Name: WideString): TdomNametoken; virtual;
    function CreateTextDeclaration(const Version,
                                         EncDl: WideString): TdomTextDeclaration; virtual;
    function CreateExternalParsedEntity: TdomExternalParsedEntity; virtual;
    function CreateExternalParameterEntity: TdomExternalParameterEntity; virtual;
    function CreateExternalSubset: TdomExternalSubset; virtual;
    function CreateInternalSubset: TdomInternalSubset; virtual;
    procedure FreeAllNodes(const Node: TdomNode); virtual;
    procedure FreeTreeWalker(const TreeWalker: TdomTreeWalker); virtual;
    function GetElementsById(const elementId: WideString): TdomElement; virtual;
    function GetElementsByTagName(const TagName: WideString): TdomNodeList; virtual;
    function GetElementsByTagNameNS(const namespaceURI,
                                          localName: WideString): TdomNodeList; virtual;
    function ImportNode(const importedNode: TdomNode;
                        const deep: boolean): TdomNode; virtual;
    function InsertBefore(const newChild,
                                refChild: TdomNode): TdomNode; override;
    function ReplaceChild(const newChild,
                                oldChild: TdomNode): TdomNode; override;
    function AppendChild(const newChild: TdomNode): TdomNode; override;
    function CreateNodeIterator(const root: TdomNode;
                                      whatToShow: TdomWhatToShow;
                                      nodeFilter: TdomNodeFilter;
                                      entityReferenceExpansion: boolean): TdomNodeIterator; virtual;
    function CreateTreeWalker(const root: TdomNode;
                                    whatToShow: TdomWhatToShow;
                                    nodeFilter: TdomNodeFilter;
                                    entityReferenceExpansion: boolean): TdomTreeWalker; virtual;
    property CodeAsString: string read GetCodeAsString;
    property CodeAsWideString: WideString read GetCodeAsWideString;
    property Doctype: TdomDocumentType read GetDoctype;
    property DocumentElement: TdomElement read GetDocumentElement;
    property Filename: TFilename read GetFilename write SetFilename;
    property XmlDeclaration: TdomXmlDeclaration read GetXmlDeclaration;
  end;

  TdomStyleSheet = class
  private
    function GetStyleSheetType: WideString; virtual; abstract;
    function GetDisabled: boolean; virtual; abstract;
    procedure SetDisabled(const value: boolean); virtual; abstract;
    function GetOwnerNode: TdomNode; virtual; abstract;
    function GetParentStyleSheet: TdomStyleSheet; virtual; abstract;
    function GetHref: WideString; virtual; abstract;
    function GetTitle: WideString; virtual; abstract;
    function GetMedia: TdomMediaList; virtual; abstract;
  public
    property StyleSheetType: WideString read GetStyleSheetType;
    property Disabled: boolean read GetDisabled write SetDisabled;
    property OwnerNode: TdomNode read GetOwnerNode;
    property ParentStyleSheet: TdomStyleSheet read GetParentStyleSheet;
    property Href: WideString read GetHref;
    property Title: WideString read GetTitle;
    property Media: TdomMediaList read GetMedia;
  end;

  TdomMediaList = class
  private
    function GetCssText: WideString; virtual; abstract;
    procedure SetCssText(const value: WideString); virtual; abstract;
    function GetLength: integer; virtual; abstract;
  public
    function Item(const index: integer): TdomStyleSheet; virtual; abstract;
    procedure Delete(const oldMedium: WideString); virtual; abstract;
    procedure Append(const newMedium: WideString); virtual; abstract;
    property Length: integer read GetLength;
    property CssText: WideString read GetCssText write SetCssText;
  end;

  TdomStyleSheetList = class
  private
    function GetLength: integer; virtual; abstract;
  public
    function Item(const index: integer): TdomStyleSheet; virtual; abstract;
    property Length: integer read GetLength;
  end;

  TdomDocumentStyle = class
  private
    function GetStyleSheets: TdomStyleSheetList; virtual; abstract;
  public
    property StyleSheets: TdomStyleSheetList read GetStyleSheets;
  end;

  TXmlSourceCode = class (TList)
  private
    procedure calculatePieceOffset(const startItem: integer); virtual;
    function  getNameOfFirstTag: wideString; virtual;
  public
    function  Add(Item: Pointer): Integer;
    procedure Clear; override; //virtual;
    procedure ClearAndFree; virtual;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function  GetPieceAtPos(pos: integer): TXmlSourceCodePiece;
    procedure Insert(Index: Integer; Item: Pointer);
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Pack;
    function  Remove(Item: Pointer): Integer;
    procedure Sort(Compare: TListSortCompare);
    property  NameOfFirstTag: wideString read getNameOfFirstTag;
  end;

  TXmlSourceCodePiece = class
  private
    FPieceType: TdomPieceType;
    Ftext: wideString;
    FOffset: integer;
    FOwner: TXmlSourceCode;
  public
    constructor Create(const pt: TdomPieceType); virtual;
    property pieceType: TdomPieceType read FPieceType;
    property text: WideString read Ftext write Ftext;
    property offset: integer read FOffset;
    property ownerSourceCode: TXmlSourceCode read FOwner;
  end;


{Parser}

  TXmlParserLanguage = (de,en);

type
  TXmlMemoryStream = class(TMemoryStream)
  public
    procedure SetPointer(Ptr: Pointer; Size: Longint);
  end;

  TXmlInputSource = class
  private
    FStream: TStream;
    FEncoding: TdomEncodingType;
    FPublicId: wideString;
    FSystemId: wideString;
  public
    constructor create(const Stream: TStream;
                       const PublicId,
                             SystemId: wideString;
                             defaultEncoding : TdomEncodingType); virtual;
    property Encoding: TdomEncodingType read FEncoding;
    property PublicId: wideString read FPublicId;
    property Stream: TStream read FStream;
    property SystemId: wideString read FSystemId;
  end;

  TXmlParserError = class
  private
    FErrorType: ShortString;
    FStartLine: integer;
    FEndLine: integer;
    FLanguage: TXmlParserLanguage;
    FSourceCodeText: WideString;
    function GetErrorStr: WideString;
    function GetErrorType: ShortString;
    function GetStartLine: integer;
    function GetEndLine: integer;
  public
    constructor Create(const ErrorType: ShortString;
                       const StartLine,
                             EndLine: integer;
                       const SourceCodeText: WideString;
                       const lang: TXmlParserLanguage); virtual;
    property ErrorStr: WideString read GetErrorStr;
    property ErrorType: ShortString read GetErrorType;
    property StartLine: integer read GetStartLine;
    property EndLine: integer read GetEndLine;
  end;

  TCustomParser = class (TComponent)
  private
    FLineNumber: longint;
    FErrorList: TList;
    FErrorStrings: TStringList;
    FLanguage: TXmlParserLanguage;
    FDOMImpl: TDomImplementation;
    FIntSubset: WideString; // Only for buffer storage while parsing a document
    FUseSpecifiedDocumentSC: boolean; // Internally used flag which indicates to write to FDocumentSC, FExternalSubsetSC or FInternalSubsetSC.
    FDocumentSC: TXmlSourceCode;
    FExternalSubsetSC: TXmlSourceCode;
    FInternalSubsetSC: TXmlSourceCode;
    FDefaultEncoding: TdomEncodingType;
    procedure SetDomImpl(const impl: TDomImplementation); virtual;
    function  GetDomImpl: TDomImplementation; virtual;
    procedure SetLanguage(const Lang: TXmlParserLanguage); virtual;
    function  GetLanguage: TXmlParserLanguage; virtual;
    function  GetErrorList: TList; virtual;
    function  GetErrorStrings: TStringList; virtual;
    procedure ClearErrorList; virtual;
    procedure XMLAnalyseAttrSequence(const Source: WideString;
                                     const Element: TdomElement;
                                     const FirstLineNumber,
                                           LastLineNumber: integer); virtual;
    function WriteXmlDeclaration(const Content: WideString;
                                 const FirstLineNumber,
                                       LastLineNumber: integer;
                                 const RefNode: TdomNode;
                                 const readonly: boolean): TdomXmlDeclaration; virtual;
    function WriteTextDeclaration(const Content: WideString;
                                  const FirstLineNumber,
                                        LastLineNumber: integer;
                                  const RefNode: TdomNode;
                                  const readonly: boolean): TdomTextDeclaration; virtual;
    function WriteProcessingInstruction(const Content: WideString;
                                        const FirstLineNumber,
                                              LastLineNumber: integer;
                                        const RefNode: TdomNode;
                                        const readonly: boolean): TdomNode; virtual;
    function WriteComment(const Content: WideString;
                          const FirstLineNumber,
                                LastLineNumber: integer;
                          const RefNode: TdomNode;
                          const readonly: boolean): TdomComment; virtual;
    function WriteCDATA(const Content: WideString;
                        const FirstLineNumber,
                              LastLineNumber: integer;
                        const RefNode: TdomNode;
                        const readonly: boolean): TdomCDATASection; virtual;
    function WritePCDATA(const Content: WideString;
                         const FirstLineNumber,
                               LastLineNumber: integer;
                         const RefNode: TdomNode;
                         const readonly: boolean): TdomText; virtual;
    function WriteStartTag(const Content: WideString;
                           const FirstLineNumber,
                                 LastLineNumber: integer;
                           const RefNode: TdomNode;
                           const readonly: boolean): TdomElement; virtual;
    function WriteEndTag(const Content: WideString;
                         const FirstLineNumber,
                               LastLineNumber: integer;
                         const RefNode: TdomNode): TdomElement; virtual;
    function WriteCharRef(const Content: WideString;
                          const FirstLineNumber,
                                LastLineNumber: integer;
                          const RefNode: TdomNode;
                          const readonly: boolean): TdomText; virtual;
    function WriteEntityRef(const Content: WideString;
                            const FirstLineNumber,
                                  LastLineNumber: integer;
                            const RefNode: TdomNode;
                            const readonly: boolean): TdomEntityReference; virtual;
    function WriteDoctype(const Content: WideString;
                          const FirstLineNumber,
                                LastLineNumber: integer;
                          const RefNode: TdomNode): TdomDocumentType; virtual;
    function WriteParameterEntityRef(const Content: WideString;
                                     const FirstLineNumber,
                                           LastLineNumber: integer;
                                     const RefNode: TdomNode;
                                     const readonly: boolean): TdomParameterEntityReference; virtual;
    function WriteEntityDeclaration(const Content: WideString;
                                    const FirstLineNumber,
                                          LastLineNumber: integer;
                                    const RefNode: TdomNode;
                                    const readonly: boolean): TdomCustomEntity; virtual;
    function WriteElementDeclaration(const Content: WideString;
                                     const FirstLineNumber,
                                           LastLineNumber: integer;
                                     const RefNode: TdomNode;
                                     const readonly: boolean): TdomElementTypeDeclaration; virtual;
    function WriteAttributeDeclaration(const Content: WideString;
                                       const FirstLineNumber,
                                             LastLineNumber: integer;
                                       const RefNode: TdomNode;
                                       const readonly: boolean): TdomAttrList; virtual;
    function WriteNotationDeclaration(const Content: WideString;
                                      const FirstLineNumber,
                                            LastLineNumber: integer;
                                      const RefNode: TdomNode;
                                      const readonly: boolean): TdomNotationDeclaration; virtual;
    function WriteConditionalSection(const Content: WideString;
                                     const FirstLineNumber,
                                           LastLineNumber: integer;
                                     const RefNode: TdomNode;
                                     const readonly: boolean): TdomConditionalSection; virtual;
    procedure InsertMixedContent(const RefNode: TdomNode;
                                 const ContentSpec: WideString;
                                 const readonly: boolean); virtual;
    procedure InsertChildrenContent(const RefNode: TdomNode;
                                    const ContentSpec: WideString;
                                    const readonly: boolean); virtual;
    procedure InsertNotationTypeContent(const RefNode: TdomNode;
                                        const ContentSpec: WideString;
                                        const readonly: boolean); virtual;
    procedure InsertEnumerationContent(const RefNode: TdomNode;
                                       const ContentSpec: WideString;
                                       const readonly: boolean); virtual;
    procedure FindNextAttDef(const Decl: WideString;
                               var Name,
                                   AttType,
                                   Bracket,
                                   DefaultDecl,
                                   AttValue,
                                   Rest: WideString); virtual;
    procedure DocToXmlSourceCode(const InputSource :TXmlInputSource;
                                 const Source: TXmlSourceCode);
    procedure ExtDtdToXmlSourceCode(const InputSource :TXmlInputSource;
                                    const Source: TXmlSourceCode);
    procedure IntDtdToXmlSourceCode(const InputSource :TXmlInputSource;
                                    const Source: TXmlSourceCode);
  protected
    function  NormalizeLineBreaks(const source :WideString): WideString; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property  DOMImpl: TDomImplementation read GetDomImpl write SetDomImpl;
    property  Language: TXmlParserLanguage read GetLanguage write SetLanguage default en;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure DocMemoryToDom(const Ptr: Pointer;
                             const Size: Longint;
                             const RefNode: TdomNode;
                             const readonly: boolean); virtual;
    procedure DocSourceCodeToDom(const DocSourceCode: TXmlSourceCode;
                                 const RefNode: TdomNode;
                                 const readonly: boolean); virtual;
    procedure DocStreamToDom(const Stream: TStream;
                             const RefNode: TdomNode;
                             const readonly: boolean); virtual;
    procedure DocStringToDom(const Str: string;
                             const RefNode: TdomNode;
                             const readonly: boolean); virtual;
    procedure DocWideStringToDom(      Str: WideString;
                                 const RefNode: TdomNode;
                                 const readonly: boolean); virtual;
    procedure ExtDtdMemoryToDom(const Ptr: Pointer;
                                const Size: Longint;
                                const RefNode: TdomNode;
                                const readonly: boolean); virtual;
    procedure ExtDtdSourceCodeToDom(const ExtDtdSourceCode: TXmlSourceCode;
                                    const RefNode: TdomNode;
                                    const readonly: boolean); virtual;
    procedure ExtDtdStreamToDom(const Stream: TStream;
                                const RefNode: TdomNode;
                                const readonly: boolean); virtual;
    procedure ExtDtdStringToDom(const Str: string;
                                const RefNode: TdomNode;
                                const readonly: boolean); virtual;
    procedure ExtDtdWideStringToDom(      Str: WideString;
                                    const RefNode: TdomNode;
                                    const readonly: boolean); virtual;
    procedure IntDtdMemoryToDom(const Ptr: Pointer;
                                const Size: Longint;
                                const RefNode: TdomNode;
                                const readonly: boolean); virtual;
    procedure IntDtdSourceCodeToDom(const IntDtdSourceCode: TXmlSourceCode;
                                    const RefNode: TdomNode;
                                    const readonly: boolean); virtual;
    procedure IntDtdStreamToDom(const Stream: TStream;
                                const RefNode: TdomNode;
                                const readonly: boolean); virtual;
    procedure IntDtdStringToDom(const Str: string;
                                const RefNode: TdomNode;
                                const readonly: boolean); virtual;
    procedure IntDtdWideStringToDom(      Str: WideString;
                                    const RefNode: TdomNode;
                                    const readonly: boolean); virtual;
    property ErrorList: TList read GetErrorList;
    property ErrorStrings: TStringList read GetErrorStrings;
    property DocumentSC: TXmlSourceCode read FDocumentSC write FDocumentSC;
    property ExternalSubsetSC: TXmlSourceCode read FExternalSubsetSC write FExternalSubsetSC;
    property InternalSubsetSC: TXmlSourceCode read FInternalSubsetSC write FInternalSubsetSC;
    // add by hyl
    property DefaultEncoding : TdomEncodingType read FDefaultEncoding write FDefaultEncoding default etMBCS;
  end;

  TParserEvent = procedure(         Sender: TObject;
                           const  PublicId,
                                  SystemId: WideString;
                             var extSubset: WideString) of object;

  TXmlToDomParser = class (TCustomParser)
  private
    FOnExternalSubset: TParserEvent;
  public
    function FileToDom(const filename: TFileName): TdomDocument; virtual;
  published
    property OnExternalSubset: TParserEvent read FOnExternalSubset write FOnExternalSubset;
    property DOMImpl;
    property Language;
  end;

function XMLExtractPrefix(const qualifiedName: wideString): wideString;
function XMLExtractLocalName(const qualifiedName: wideString): wideString;

function IsXmlChar(const S: WideChar): boolean;
function IsXmlWhiteSpace(const S: WideChar): boolean;
function IsXmlLetter(const S: WideChar): boolean;
function IsXmlBaseChar(const S: WideChar): boolean;
function IsXmlIdeographic(const S: WideChar): boolean;
function IsXmlCombiningChar(const S: WideChar): boolean;
function IsXmlDigit(const S: WideChar): boolean;
function IsXmlExtender(const S: WideChar): boolean;
function IsXmlNameChar(const S: WideChar): boolean;
function IsXmlPubidChar(const S: WideChar): boolean;

function IsXmlS(const S: WideString): boolean;
function IsXmlName(const S: WideString): boolean;
function IsXmlNames(const S: WideString): boolean;
function IsXmlNmtoken(const S: WideString): boolean;
function IsXmlNmtokens(const S: WideString): boolean;
function IsXmlCharRef(const S: WideString): boolean;
function IsXmlEntityRef(const S: WideString): boolean;
function IsXmlPEReference(const S: WideString): boolean;
function IsXmlReference(const S: WideString): boolean;
function IsXmlEntityValue(const S: WideString): boolean;
function IsXmlAttValue(const S: WideString): boolean;
function IsXmlSystemLiteral(const S: WideString): boolean;
function IsXmlPubidLiteral(const S: WideString): boolean;
function IsXmlCharData(const S: WideString): boolean;
function IsXmlPITarget(const S: WideString): boolean;
function IsXmlVersionNum(const S: WideString): boolean;
function IsXmlEncName(const S: WideString): boolean;
function IsXmlStringType(const S: WideString): boolean;
function IsXmlTokenizedType(const S: WideString): boolean;

function IsXmlNCNameChar(const s: WideChar): boolean;
function IsXmlNCName(const S: WideString): boolean;
function IsXmlDefaultAttName(const S: WideString): boolean;
function IsXmlPrefixedAttName(const S: WideString): boolean;
function IsXmlNSAttName(const S: WideString): boolean;
function IsXmlLocalPart(const S: WideString): boolean;
function IsXmlPrefix(const S: WideString): boolean;
function IsXmlQName(const S: WideString): boolean;

function XmlIntToCharRef(const value: integer): wideString;
function XmlCharRefToInt(const S: WideString): integer;
function XmlCharRefToStr(const S: WideString): WideString;
function XmlStrToCharRef(const S: WideString): WideString;
function UTF8ToUTF16BEStr(const s: string): WideString;
function UTF16BEToUTF8Str(const ws: WideString): string;
function Utf16HighSurrogate(const value: integer): WideChar;
function Utf16LowSurrogate(const value: integer): WideChar;
function Utf16SurrogateToInt(const highSurrogate, lowSurrogate: WideChar): integer;
function IsUtf16HighSurrogate(const S: WideChar): boolean;
function IsUtf16LowSurrogate(const S: WideChar): boolean;

procedure Register;

procedure XMLAnalysePCDATA(Source: widestring;
                           var Lines: TStringList);

procedure XMLAnalyseTag(const Source: WideString;
                        var TagName,
                            AttribSequence: WideString);

procedure XMLAnalyseEntityDef(    Source: WideString;
                              var EntityValue,
                                  SystemLiteral,
                                  PubidLiteral,
                                  NDataName: WideString;
                              var Error: boolean);

procedure XMLAnalyseNotationDecl(const Decl: WideString;
                                   var SystemLiteral,
                                       PubidLiteral: WideString;
                                   var Error: boolean);

procedure XMLIsolateQuote(    Source: WideString;
                          var content,
                              rest: WideString;
                          var QuoteType: WideChar;
                          var Error: boolean);

function XMLTrunc(const Source: WideString): WideString;

procedure XMLTruncAngularBrackets(const Source: WideString;
                                    var content: WideString;
                                    var Error: boolean);

procedure XMLTruncRoundBrackets(const Source: WideString;
                                  var content: WideString;
                                  var Error: boolean);

function XMLAnalysePubSysId(const PublicId,
                                  SystemId,
                                  NotaName: WideString): WideString;

var
  domDocumentFormatList: PdomDocumentFormat = nil;

// add by hyl
function ReadWideCharFromMBCSStream(Stream:TStream):WideChar;
// end add

implementation

// add by hyl
function ReadWideCharFromMBCSStream(Stream:TStream):WideChar;
var
  achar : char;
  astr : string;
  awidechar : array[0..1] of widechar;
begin
  Stream.ReadBuffer(achar,1);
  if ord(achar)>=$80 then
  begin
    astr := achar;
    Stream.ReadBuffer(achar,1);
    astr := astr + achar;
    StringToWideChar(astr,@awidechar,sizeof(awidechar));
    result:= awidechar[0];
  end else
  begin
    result:=wideChar(ord(achar));
  end;
end;
// end add

procedure Register;
begin
  RegisterComponents('XML',[TDomImplementation,TXmlToDomParser]);
end;


procedure XMLAnalysePCDATA(Source: widestring;
                           var Lines: TStringList);
{'Source': Die PCDATA-Sequenz, die analysiert werden soll.
 'Lines':  Gibt den Inhalt von PCDATA in einzelnen Zeilen
           zurück, so daß in einer Zeile entweder nur Leerraum
           steht oder überhaupt kein Leerraum.}
var
  i: integer;
  Line: string;
begin
  i:= 0;
  Lines.clear;
  while (i<length(Source)) do
  begin

    {No White-space?}
    Line:= '';
    while (i<length(Source)) do
    begin
      inc(i);
      if IsXmlWhiteSpace(Source[i]) then begin dec(i); break; end;
      Line:= concat(Line,Source[i]);
    end;
    if Line <> '' then Lines.Add(Line);

    {White-space?}
    Line:= '';
    while (i<length(Source)) do
    begin
      inc(i);
      if not IsXmlWhiteSpace(Source[i]) then begin dec(i); break; end;
      Line:= concat(Line,Source[i]);
    end;
    if Line <> '' then Lines.Add(Line);

  end;
end;

procedure XmlAnalyseTag(const Source: WideString;
                        var TagName,
                            AttribSequence: Widestring);
// 'Source': The tag, to be analyzed.
// 'TagName': Returns the namen of the tag.
// 'AttribSequence': Returns the Attributes, if existing.
var
  i,j,sourceLength : integer;
begin
  sourceLength:= length(Source);  // buffer storage to increase performance

  // Evaluate TagName:
  i:= 1;
  while i <= sourceLength do begin
    if IsXmlWhiteSpace(Source[i]) then break;
    inc(i);
  end;

  TagName:= copy(Source,1,i-1);

  // Evaluate Attributes:
  while i < sourceLength do begin
    inc(i);
    if not IsXmlWhiteSpace(Source[i]) then break;
  end;
  j:= length(Source);
  while j > i do begin
    if not IsXmlWhiteSpace(Source[j]) then break;
    dec(j);
  end;

  AttribSequence:= copy(Source,i,j-i+1);
end;

procedure XMLAnalyseEntityDef(    Source: WideString;
                              var EntityValue,
                                  SystemLiteral,
                                  PubidLiteral,
                                  NDataName: WideString;
                              var Error: boolean);
// 'Source': The entity definition to be analyzed.
// 'EntityValue','SystemLiteral','PubidLiteral','NDataName':
//    Return the respective values, if declared.
// 'Error': Returns 'true', if the entity definition is not well-formed.
var
  i : integer;
  SingleQuote,DoubleQuote,QuoteType: WideChar;
  rest, intro, SystemLit, PubidLit, dummy: WideString;
begin
  EntityValue:= '';
  SystemLiteral:= '';
  SystemLit:= '';
  PubidLiteral:= '';
  PubidLit:= '';
  NDataName:= '';
  intro:= '';
  Error:= false;
  if Length(Source) < 2 then begin Error:= true; exit; end;
  SingleQuote:= chr(39); // Code of '.
  DoubleQuote:= chr(34); // Code of ".

  // Remove leading white space:
  i:= 1;
  while (i<=length(Source)) do begin
    if not IsXmlWhiteSpace(Source[i]) then break;
    inc(i);
  end;
  if i >= Length(Source) then begin Error:= true; exit; end;
  dummy:= copy(Source,i,Length(Source)-i+1);
  Source:= dummy; // Necessary, because of Delphi's problem when copying WideStrings.
  if (Source[1] = SingleQuote) or (Source[1] = DoubleQuote) then begin
    XMLIsolateQuote(Source,EntityValue,rest,QuoteType,Error);
    if Error then exit;
    if rest <> '' then begin Error:= true; exit; end;
    if not IsXmlEntityValue(concat(WideString(QuoteType),EntityValue,WideString(QuoteType)))
      then begin Error:= true; exit; end;
  end else begin
    intro:= copy(Source,1,6);
    if (intro = 'SYSTEM') or (intro = 'PUBLIC') then begin
      Dummy:= copy(Source,7,Length(Source)-6);
      Source:= dummy; // Necessary, because of Delphi's problem when copying WideStrings.
      if Source = '' then begin Error:= true; exit; end;
      if not IsXmlWhiteSpace(Source[1]) then begin Error:= true; exit; end;

      if (intro = 'SYSTEM') then begin
        XMLIsolateQuote(Source,SystemLit,Source,QuoteType,Error);
        if Error then exit;
        if not IsXmlSystemLiteral(concat(WideString(QuoteType),SystemLit,WideString(QuoteType)))
          then begin Error:= true; exit; end;
      end else begin
        XMLIsolateQuote(Source,PubidLit,Source,QuoteType,Error);
        if Error then exit;
        if not IsXmlPubidLiteral(concat(WideString(QuoteType),PubidLit,WideString(QuoteType)))
          then begin Error:= true; exit; end;
        XMLIsolateQuote(Source,SystemLit,Source,QuoteType,Error);
        if Error then exit;
        if not IsXmlSystemLiteral(concat(WideString(QuoteType),SystemLit,WideString(QuoteType)))
          then begin Error:= true; exit; end;
      end;

      if Source <> '' then begin
        if copy(Source,1,5) = 'NDATA' then begin
          dummy:= copy(Source,6,Length(Source)-5);
          Source:= XmlTrunc(dummy); // Necessary, because of Delphi's problem when copying WideStrings.
          if IsXmlName(Source)
            then NDataName:= Source
            else begin Error:= true; exit; end;
        end else begin Error:= true; exit; end;
      end;

    end else begin Error:= true; exit; end;
    SystemLiteral:= SystemLit;
    PubidLiteral:= PubidLit;
  end; {if (Source[1] ... }
end;


procedure XMLAnalyseNotationDecl(const Decl: WideString;
                                   var SystemLiteral,
                                       PubidLiteral: WideString;
                                   var Error: boolean);
// 'Source': The notation declaration to be analyzed.
// 'SystemLiteral','PubidLiteral','NDataName':
//    Return the respective values, if declared.
// 'Error': Returns 'true', if the notation declaration is not well-formed.
var
  QuoteType: WideChar;
  intro, SystemLit, PubidLit, dummy, Source: WideString;
begin
  SystemLiteral:= '';
  SystemLit:= '';
  PubidLiteral:= '';
  PubidLit:= '';
  intro:= '';
  Error:= false;
  if Length(Decl) < 2 then begin Error:= true; exit; end;

  Source:= XMLTrunc(Decl);
  intro:= copy(Source,1,6);

  if (intro<>'SYSTEM') and (intro<>'PUBLIC') then begin Error:= true; exit; end;

  Dummy:= copy(Source,7,Length(Source)-6);
  Source:= dummy; // Necessary, because of Delphi's problem when copying WideStrings.
  if Source = '' then begin Error:= true; exit; end;
  if not IsXmlWhiteSpace(Source[1]) then begin Error:= true; exit; end;

  if (intro = 'SYSTEM') then begin
    XMLIsolateQuote(Source,SystemLit,dummy,QuoteType,Error);
    if Error then exit;
    if dummy <> '' then begin Error:= true; exit; end;
    if not IsXmlSystemLiteral(concat(WideString(QuoteType),SystemLit,WideString(QuoteType)))
      then begin Error:= true; exit; end;
  end else begin
    XMLIsolateQuote(Source,PubidLit,dummy,QuoteType,Error);
    Source:= dummy;
    if Error then exit;
    if not IsXmlPubidLiteral(concat(WideString(QuoteType),PubidLit,WideString(QuoteType)))
      then begin Error:= true; exit; end;
    if Source <> '' then begin
      if not IsXmlSystemLiteral(Source) then begin Error:= true; exit; end;
      SystemLit:= copy(Source,2,length(Source)-2);
    end;
  end;

  SystemLiteral:= SystemLit;
  PubidLiteral:= PubidLit;
end;

function XMLTrunc(const Source: WideString): WideString;
// This function removes all white space at the beginning
// or end of 'Source'.
var
  i: integer;
begin
  Result:= '';
  i:= 1;
  while (i <= length(Source)) do begin
    if not IsXmlWhiteSpace(Source[i]) then break;
    inc(i);
  end;
  if i > Length(Source) then exit;
  Result:= copy(Source,i,Length(Source)-i+1);
  i:= length(Result);
  while i > 0 do begin
    if not IsXmlWhiteSpace(Result[i]) then break;
    dec(i);
  end;
  if i = 0
    then Result:= ''
    else Result:= copy(Result,1,i);
end;

procedure XMLTruncAngularBrackets(const Source: WideString;
                                    var content: WideString;
                                    var Error: boolean);
{Die Prozedur entfernt evtl. vorhandenen White-Space am Anfang und
 Ende von 'Source', prüft dann, ob der verbleibende WideString durch
 eckige KLammern -- '[' und ']' -- eingerahmt wird. Ist dies der Fall,
 wird der Klammer-Inhalt in 'content' zurückgegeben und 'Error' wird
 auf 'false' gesetzt. Ist dies nicht der Fall, gibt 'content' einen leeren
 WideString ('') zurück und 'Error' wird auf 'true' gesetzt.}
var
  BracketStr: WideString;
begin
  content:= '';
  BracketStr:= XMLTrunc(Source);
  if length(BracketStr) < 2 then begin Error:= true; exit; end;
  if (BracketStr[1] <> '[') or (BracketStr[length(BracketStr)] <> ']')
    then Error:= true
    else begin
      content:= copy(BracketStr,2,Length(BracketStr)-2);
      Error:= false;
    end;
end;

procedure XMLTruncRoundBrackets(const Source: WideString;
                                  var content: WideString;
                                  var Error: boolean);
{Die Prozedur entfernt evtl. vorhandenen White-Space am Anfang und Ende
 von 'Source', prüft dann, ob der verbleibende WideString durch runde
 KLammern -- '(' und ')' -- eingerahmt wird. Ist dies der Fall, wird vom
 Klammer-Inhalt erneut evtl. vorhandener Leerraum am Anfang und Ende
 entfernt und das Ergebnis in 'content' zurückgegeben sowie 'Error' auf
 'false' gesetzt. Ist dies nicht der Fall, gibt 'content' einen leeren
 WideString ('') zurück und 'Error' wird auf 'true' gesetzt.}
var
  BracketStr: WideString;
begin
  content:= '';
  BracketStr:= XMLTrunc(Source);
  if length(BracketStr) < 2 then begin Error:= true; exit; end;
  if (BracketStr[1] <> '(') or (BracketStr[length(BracketStr)] <> ')')
    then Error:= true
    else begin
      content:= XMLTrunc(copy(BracketStr,2,Length(BracketStr)-2));
      Error:= false;
    end;
end;

procedure XMLIsolateQuote(    Source: WideString;
                          var content,
                              rest: WideString;
                          var QuoteType: WideChar;
                          var Error: boolean);
{Analysiert einen WideString ('Source'):  Führender White-Space wird
 abgeschnitten, danach wird ein in einfache oder doppelte Anführungs-
 zeichen gesetzter Text (der auch leer sein kann) erwartet, dessen Inhalt
 in 'content' zurückgegeben wird.  'QuoteType' gibt den Wert der
 Anführungszeichen zurück (#39; für einfache und #34; für doppelte
 Anführungszeichen).  Wird nach dem Entfernen des führenden White-Spaces
 kein Anführungszeichen gefunden oder fehlt das korrespondierende
 Schlußzeichen, wird die Routine abgebrochen und 'Error = true' zurück-
 gegeben. Anschließend wird überprüft, ob dirket nach dem Schlußzeichen
 etwas anderes als White-Space folgt (bzw. der WideString zuende ist).
 Falls etwas anderes folgt, wird 'Error = true' zurückgegeben. Falls
 nicht, wird bis zum nächsten Nicht-White-Space-Zeichen gesucht und der
 Rest des WideStrings in 'rest' zurückgegeben. Für alle Fälle, in denen
 'Error = true' zurückgegebn wird, werden 'content' und 'rest' als leer
 ('') und 'QuoteType' als #0; zurückgegeben.}
var
  i,quotepos: integer;
  SingleQuote,DoubleQuote: WideChar;
  dummy: WideString;
begin
  content:= '';
  rest:= '';
  QuoteType:= #0;
  if Length(Source) < 2 then begin Error:= true; exit; end;
  SingleQuote:= #39; {Code für ein einfaches Anführungszeichen (').}
  DoubleQuote:= #34; {Code für ein doppeltes Anführungszeichen (").}
  Error:= false;

  {White-space am Anfang entfernen:}
  i:= 1;
  while (i <= length(Source)) do begin
    if not IsXmlWhiteSpace(Source[i]) then break;
    inc(i);
  end;
  if i >= Length(Source) then begin Error:= true; exit; end;
  Dummy:= copy(Source,i,Length(Source)-i+1);
  Source:= dummy; {Diese umständliche Zuweisung ist wegen Delphi-Problem von WideStrings bei copy nötig}
  if (Source[1] <> SingleQuote) and (Source[1] <> DoubleQuote)
    then begin Error:= true; exit; end;
  QuoteType:= Source[1];
  Dummy:= Copy(Source,2,Length(Source)-1);
  Source:= dummy; {Diese umständliche Zuweisung ist wegen Delphi-Problem von WideStrings bei copy nötig}
  QuotePos:= Pos(WideString(QuoteType),Source);
  if QuotePos = 0 then begin Error:= true; exit; end;
  if Length(Source) > QuotePos then
    if not IsXmlWhiteSpace(Source[QuotePos+1])
      then begin QuoteType:= #0; Error:= true; exit; end;
  content:= Copy(Source,1,QuotePos-1);
  {White-Space nach dem Anführungszeichen-Abschnitt entfernen:}
  i:= QuotePos + 1;
  while (i <= length(Source)) do begin
    if not IsXmlWhiteSpace(Source[i]) then break;
    inc(i);
  end;
  if i <= Length(Source) then rest:= copy(Source,i,Length(Source)-i+1);
end;

function XMLAnalysePubSysId(const PublicId,
                                  SystemId,
                                  NotaName: WideString): WideString;
var
  sQuote,dQuote,SystemIdContent,PublicIdContent: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  Result:= '';
  if not IsXmlName(NotaName)
    then EConvertError.CreateFmt('%S is not a valid NotaName value.',[NotaName]);;
  if IsXMLSystemLiteral(concat(dQuote,SystemId,dQuote))
    then SystemIdContent:= concat(dQuote,SystemId,dQuote)
    else if IsXMLSystemLiteral(concat(sQuote,SystemId,sQuote))
      then SystemIdContent:= concat(sQuote,SystemId,sQuote)
      else EConvertError.CreateFmt('%S is not a valid SystemId value.',[SystemId]);;
  if IsXMLPubidLiteral(concat(dQuote,PublicId,dQuote))
    then PublicIdContent:= concat(dQuote,PublicId,dQuote)
    else if IsXMLPubidLiteral(concat(sQuote,PublicId,sQuote))
      then PublicIdContent:= concat(sQuote,PublicId,sQuote)
      else EConvertError.CreateFmt('%S is not a valid PublicId value.',[PublicId]);;
  if PublicId = '' then begin
    if SystemId = '' then begin
      Result:= concat(Result,WideString(' SYSTEM "" '));
    end else begin
      Result:= concat(Result,WideString(' SYSTEM '),SystemIdContent,WideString(' '));
    end;
  end else begin
    if SystemId = '' then begin
      Result:= concat(Result,WideString(' PUBLIC '),PublicIdContent,WideString(' '));
    end else begin
      Result:= concat(Result,WideString(' PUBLIC '),PublicIdContent,WideString(' '),SystemIdContent,WideString(' '));
    end;
  end; {if ...}
  if NotaName <> ''
   then Result:= concat(Result,WideString('NDATA '),NotaName,WideString(' '));
end;

function HasCircularReference(const Entity: TdomNode): boolean;
{Result = 'false': Es liegt keine zirkuläre Referenz vor.
 Result = 'true': Es liegt eine zirkuläre Referenz vor.}
var
  EntityList1,EntityList2,EntityList3: TList;
  EntityDec: TdomCustomEntity;
  i,j: integer;
begin
  Result:= false;
  if not assigned(Entity) then exit;
  if not ( (Entity.nodetype = ntEntity_Node)
           or (Entity.nodetype = ntParameter_Entity_Node) ) then exit;

  EntityList1:= TList.create;
  EntityList2:= TList.create;
  EntityList3:= TList.create;
  try
    EntityList1.clear;
    EntityList2.clear;
    EntityList3.clear;
    EntityList1.Add(Entity);

    while EntityList1.Count > 0 do begin
      for i:= 0 to EntityList1.Count -1 do begin
        for j:= 0 to TdomNode(EntityList1[i]).ChildNodes.Length -1 do
          case TdomNode(EntityList1[i]).ChildNodes.item(j).NodeType of
            ntEntity_Reference_Node,ntParameter_Entity_Reference_Node: begin
              EntityDec:= (TdomNode(EntityList1[i]).ChildNodes.item(j) as TdomReference).Declaration;
              if assigned(EntityDec) then begin
                if EntityList3.IndexOf(EntityDec) > -1 then begin
                  Result:= true;
                  exit;
                end;
                if EntityList2.IndexOf(EntityDec) = -1
                  then EntityList2.Add(EntityDec);
              end; {if assigned ...}
            end; {ntEntity_Reference_Node}
          end; {case ...}
      end; {for i:= 0 ...}
      EntityList1.clear;
      for i:= 0 to EntityList2.Count -1 do begin
        EntityList1.add(EntityList2[i]);
        EntityList3.Add(EntityList2[i]);
      end;
      EntityList2.clear;
    end; {while ...}

  finally
    EntityList1.free;
    EntityList2.free;
    EntityList3.free;
  end;
end;

function XMLExtractPrefix(const qualifiedName: wideString): wideString;
var
  colonpos: integer;
  prefix,localpart: WideString;
begin
  prefix:= '';
  colonpos:= pos(':',qualifiedName);
  if colonpos = 0
    then localpart:= qualifiedName
    else begin
      prefix:= copy(qualifiedName,1,length(qualifiedName)-colonpos);
      localpart:= copy(qualifiedName,colonpos+1,length(qualifiedName)-colonpos);
      if not IsXmlPrefix(prefix)
        then raise EInvalid_Character_Err.create('Invalid character error.');
  end;
  if not IsXmlLocalPart(localpart)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  result:= prefix;
end;

function XMLExtractLocalName(const qualifiedName: wideString): wideString;
var
  colonpos: integer;
  prefix,localpart: WideString;
begin
  colonpos:= pos(':',qualifiedName);
  if colonpos = 0
    then localpart:= qualifiedName
    else begin
      prefix:= copy(qualifiedName,1,length(qualifiedName)-colonpos);
      localpart:= copy(qualifiedName,colonpos+1,length(qualifiedName)-colonpos);
      if not IsXmlPrefix(prefix)
        then raise EInvalid_Character_Err.create('Invalid character error.');
  end;
  if not IsXmlLocalPart(localpart)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  result:= localpart;
end;

function IsXmlChar(const S: WideChar): boolean;
begin
  Case Word(S) of
    $0009,$000A,$000D,$0020..$D7FF,$E000..$FFFD, // Unicode below $FFFF
    $D800..$DBFF, // High surrogate of Unicode character [$10000..$10FFFF]
    $DC00..$DFFF: // Low surrogate of Unicode character [$10000..$10FFFF]
    result:= true;
  else
    result:= false;
  end;
end;

function IsXmlWhiteSpace(const S: WideChar): boolean;
begin
  Case Word(S) of
    $0009,$000A,$000D,$0020:
    result:= true;
  else
    result:= false;
  end;
end;

function IsXmlLetter(const S: WideChar): boolean;
begin
  Result:= IsXmlIdeographic(S) or IsXmlBaseChar(S);
end;

function IsXmlBaseChar(const S: WideChar): boolean;
begin
  Case Word(S) of
    $0041..$005a,$0061..$007a,$00c0..$00d6,$00d8..$00f6,$00f8..$00ff,
    $0100..$0131,$0134..$013E,$0141..$0148,$014a..$017e,$0180..$01c3,
    $01cd..$01f0,$01f4..$01f5,$01fa..$0217,$0250..$02a8,$02bb..$02c1,
    $0386,$0388..$038a,$038c,$038e..$03a1,$03a3..$03ce,$03D0..$03D6,
    $03DA,$03DC,$03DE,$03E0,$03E2..$03F3,$0401..$040C,$040E..$044F,
    $0451..$045C,$045E..$0481,$0490..$04C4,$04C7..$04C8,$04CB..$04CC,
    $04D0..$04EB,$04EE..$04F5,$04F8..$04F9,$0531..$0556,$0559,
    $0561..$0586,$05D0..$05EA,$05F0..$05F2,$0621..$063A,$0641..$064A,
    $0671..$06B7,$06BA..$06BE,$06C0..$06CE,$06D0..$06D3,$06D5,
    $06E5..$06E6,$0905..$0939,$093D,$0958..$0961,$0985..$098C,
    $098F..$0990,$0993..$09A8,$09AA..$09B0,$09B2,$09B6..$09B9,
    $09DC..$09DD,$09DF..$09E1,$09F0..$09F1,$0A05..$0A0A,$0A0F..$0A10,
    $0A13..$0A28,$0A2A..$0A30,$0A32..$0A33,$0A35..$0A36,$0A38..$0A39,
    $0A59..$0A5C,$0A5E,$0A72..$0A74,$0A85..$0A8B,$0A8D,$0A8F..$0A91,
    $0A93..$0AA8,$0AAA..$0AB0,$0AB2..$0AB3,$0AB5..$0AB9,$0ABD,$0AE0,
    $0B05..$0B0C,$0B0F..$0B10,$0B13..$0B28,$0B2A..$0B30,$0B32..$0B33,
    $0B36..$0B39,$0B3D,$0B5C..$0B5D,$0B5F..$0B61,$0B85..$0B8A,
    $0B8E..$0B90,$0B92..$0B95,$0B99..$0B9A,$0B9C,$0B9E..$0B9F,
    $0BA3..$0BA4,$0BA8..$0BAA,$0BAE..$0BB5,$0BB7..$0BB9,$0C05..$0C0C,
    $0C0E..$0C10,$0C12..$0C28,$0C2A..$0C33,$0C35..$0C39,$0C60..$0C61,
    $0C85..$0C8C,$0C8E..$0C90,$0C92..$0CA8,$0CAA..$0CB3,$0CB5..$0CB9,
    $0CDE,$0CE0..$0CE1,$0D05..$0D0C,$0D0E..$0D10,$0D12..$0D28,
    $0D2A..$0D39,$0D60..$0D61,$0E01..$0E2E,$0E30,$0E32..$0E33,
    $0E40..$0E45,$0E81..$0E82,$0E84,$0E87..$0E88,$0E8A,$0E8D,
    $0E94..$0E97,$0E99..$0E9F,$0EA1..$0EA3,$0EA5,$0EA7,$0EAA..$0EAB,
    $0EAD..$0EAE,$0EB0,$0EB2..$0EB3,$0EBD,$0EC0..$0EC4,$0F40..$0F47,
    $0F49..$0F69,$10A0..$10C5,$10D0..$10F6,$1100,$1102..$1103,
    $1105..$1107,$1109,$110B..$110C,$110E..$1112,$113C,$113E,$1140,
    $114C,$114E,$1150,$1154..$1155,$1159,$115F..$1161,$1163,$1165,
    $1167,$1169,$116D..$116E,$1172..$1173,$1175,$119E,$11A8,$11AB,
    $11AE..$11AF,$11B7..$11B8,$11BA,$11BC..$11C2,$11EB,$11F0,$11F9,
    $1E00..$1E9B,$1EA0..$1EF9,$1F00..$1F15,$1F18..$1F1D,$1F20..$1F45,
    $1F48..$1F4D,$1F50..$1F57,$1F59,$1F5B,$1F5D,$1F5F..$1F7D,
    $1F80..$1FB4,$1FB6..$1FBC,$1FBE,$1FC2..$1FC4,$1FC6..$1FCC,
    $1FD0..$1FD3,$1FD6..$1FDB,$1FE0..$1FEC,$1FF2..$1FF4,$1FF6..$1FFC,
    $2126,$212A..$212B,$212E,$2180..$2182,$3041..$3094,$30A1..$30FA,
    $3105..$312C,$AC00..$d7a3:
    result:= true;
  else
    result:= false;
  end;
end;

function IsXmlIdeographic(const S: WideChar): boolean;
begin
  Case Word(S) of
    $4E00..$9FA5,$3007,$3021..$3029:
    result:= true;
  else
    result:= false;
  end;
end;

function IsXmlCombiningChar(const S: WideChar): boolean;
begin
  Case Word(S) of
    $0300..$0345,$0360..$0361,$0483..$0486,$0591..$05A1,$05A3..$05B9,
    $05BB..$05BD,$05BF,$05C1..$05C2,$05C4,$064B..$0652,$0670,
    $06D6..$06DC,$06DD..$06DF,$06E0..$06E4,$06E7..$06E8,$06EA..$06ED,
    $0901..$0903,$093C,$093E..$094C,$094D,$0951..$0954,$0962..$0963,
    $0981..$0983,$09BC,$09BE,$09BF,$09C0..$09C4,$09C7..$09C8,
    $09CB..$09CD,$09D7,$09E2..$09E3,$0A02,$0A3C,$0A3E,$0A3F,
    $0A40..$0A42,$0A47..$0A48,$0A4B..$0A4D,$0A70..$0A71,$0A81..$0A83,
    $0ABC,$0ABE..$0AC5,$0AC7..$0AC9,$0ACB..$0ACD,$0B01..$0B03,$0B3C,
    $0B3E..$0B43,$0B47..$0B48,$0B4B..$0B4D,$0B56..$0B57,$0B82..$0B83,
    $0BBE..$0BC2,$0BC6..$0BC8,$0BCA..$0BCD,$0BD7,$0C01..$0C03,
    $0C3E..$0C44,$0C46..$0C48,$0C4A..$0C4D,$0C55..$0C56,$0C82..$0C83,
    $0CBE..$0CC4,$0CC6..$0CC8,$0CCA..$0CCD,$0CD5..$0CD6,$0D02..$0D03,
    $0D3E..$0D43,$0D46..$0D48,$0D4A..$0D4D,$0D57,$0E31,$0E34..$0E3A,
    $0E47..$0E4E,$0EB1,$0EB4..$0EB9,$0EBB..$0EBC,$0EC8..$0ECD,
    $0F18..$0F19,$0F35,$0F37,$0F39,$0F3E,$0F3F,$0F71..$0F84,
    $0F86..$0F8B,$0F90..$0F95,$0F97,$0F99..$0FAD,$0FB1..$0FB7,$0FB9,
    $20D0..$20DC,$20E1,$302A..$302F,$3099,$309A:
    result:= true;
  else
    result:= false;
  end;
end;

function IsXmlDigit(const S: WideChar): boolean;
begin
  Case Word(S) of
    $0030..$0039,$0660..$0669,$06F0..$06F9,$0966..$096F,$09E6..$09EF,
    $0A66..$0A6F,$0AE6..$0AEF,$0B66..$0B6F,$0BE7..$0BEF,$0C66..$0C6F,
    $0CE6..$0CEF,$0D66..$0D6F,$0E50..$0E59,$0ED0..$0ED9,$0F20..$0F29:
    result:= true;
  else
    result:= false;
  end;
end;

function IsXmlExtender(const S: WideChar): boolean;
begin
  Case Word(S) of
    $00B7,$02D0,$02D1,$0387,$0640,$0E46,$0EC6,$3005,$3031..$3035,
    $309D..$309E,$30FC..$30FE:
    result:= true;
  else
    result:= false;
  end;
end;

function IsXmlNameChar(const S: WideChar): boolean;
begin
  if IsXmlLetter(S) or IsXmlDigit(S) or IsXmlCombiningChar(S)
    or IsXmlExtender(S) or (S='.') or (S='-') or (S='_') or (S=':')
    then Result:= true
    else Result:= false;
end;

function IsXmlPubidChar(const S: WideChar): boolean;
begin
  if (S=#$20) or (S=#$D) or (S=#$A) or
     ((S>='a') and (S<='z')) or
     ((S>='A') and (S<='Z')) or
     ((S>='0') and (S<='9')) or
     (S='-') or (S=#$27) or (S='(') or (S=')') or (S='+') or (S=',') or
     (S='.') or (S='/') or (S=':') or (S='=') or (S='?') or (S=';') or
     (S='!') or (S='*') or (S='#') or (S='@') or (S='$') or (S='_') or
     (S='%')
    then Result:= true
    else Result:= false;
end;

function IsXmlS(const S: WideString): boolean;
var
  i: integer;
begin
  Result:= true;
  if Length(S) = 0 then begin Result:= false; exit; end;
  for i:= 1 to length(S) do
    if not IsXmlWhiteSpace((PWideChar(S)+i-1)^)
      then begin Result:= false; exit; end;
end;

function IsXmlName(const S: WideString): boolean;
var
  i: integer;
begin
  Result:= true;
  if Length(S) = 0 then begin Result:= false; exit; end;
  if not ( IsXmlLetter(PWideChar(S)^)
           or (PWideChar(S)^ = '_')
           or (PWideChar(S)^ = ':')   )
    then begin Result:= false; exit; end;
  for i:= 2 to length(S) do
    if not IsXmlNameChar((PWideChar(S)+i-1)^)
      then begin Result:= false; exit; end;
end;

function IsXmlNames(const S: WideString): boolean;
var
  i,j: integer;
  piece: WideString;
begin
  Result:= true;
  if Length(S) = 0 then begin Result:= false; exit; end;
  if IsXmlWhiteSpace(S[length(S)]) then begin Result:= false; exit; end;
  i:= 0;
  j:= 1;
  while i < length(S) do begin
    inc(i);
    if IsXmlWhiteSpace(S[i]) or (i = length(S)) then begin
      if i = length(S)
        then piece:= XmlTrunc(copy(S,j,i+1-j))
        else begin
          piece:= XmlTrunc(copy(S,j,i-j));
          j:= i+1;
          while IsXmlWhiteSpace(S[j]) do inc(j);
          i:= j;
        end;
      if not IsXmlName(piece) then begin Result:= false; exit; end;
    end; {if ...}
  end; {while ...}
end;

function IsXmlNmtoken(const S: WideString): boolean;
var
  i: integer;
begin
  Result:= true;
  if Length(S) = 0 then begin Result:= false; exit; end;
  for i:= 1 to length(S) do
    if not IsXmlNameChar((PWideChar(S)+i-1)^)
      then begin Result:= false; exit; end;
end;

function IsXmlNmtokens(const S: WideString): boolean;
var
  i,j: integer;
  piece: WideString;
begin
  Result:= true;
  if Length(S) = 0 then begin Result:= false; exit; end;
  if IsXmlWhiteSpace(S[length(S)]) then begin Result:= false; exit; end;
  i:= 0;
  j:= 1;
  while i < length(S) do begin
    inc(i);
    if IsXmlWhiteSpace(S[i]) or (i = length(S)) then begin
      if i = length(S)
        then piece:= XmlTrunc(copy(S,j,i+1-j))
        else begin
          piece:= XmlTrunc(copy(S,j,i-j));
          j:= i+1;
          while IsXmlWhiteSpace(S[j]) do inc(j);
          i:= j;
        end;
      if not IsXmlNmtoken(piece) then begin Result:= false; exit; end;
    end; {if ...}
  end; {while ...}
end;

function IsXmlCharRef(const S: WideString): boolean;
var
  i: integer;
  SChar: widechar;
begin
  Result:= true;
  if copy(S,length(S),1) <> ';' then begin result:= false; exit; end;
  if copy(S,1,3) = '&#x' then begin
    if Length(S) < 5 then begin Result:= false; exit; end;
    for i:= 4 to length(S)-1 do begin
      SChar:= WideChar((PWideChar(S)+i-1)^);
      if not ( (SChar >= '0') and (SChar <= '9') )
         and not ( (SChar >= 'a') and (SChar <= 'f') )
         and not ( (SChar >= 'A') and (SChar <= 'F') )
        then begin Result:= false; exit; end;
    end;
  end else begin
    if Length(S) < 4 then begin Result:= false; exit; end;
    if copy(S,1,2) <> '&#' then begin Result:= false; exit; end;
    for i:= 3 to length(S)-1 do begin
      SChar:= WideChar((PWideChar(S)+i-1)^);
      if not ( (SChar >= '0') and (SChar <= '9') )
        then begin Result:= false; exit; end;
    end;
  end;
end;

function IsXmlEntityRef(const S: WideString): boolean;
begin
  if pos('&',S) <> 1 then begin result:= false; exit; end;
  if copy(S,length(S),1) <> ';' then begin result:= false; exit; end;
  Result:= IsXmlName(copy(S,2,length(S)-2));
end;

function IsXmlPEReference(const S: WideString): boolean;
begin
  if pos('%',S) <> 1 then begin result:= false; exit; end;
  if copy(S,length(S),1) <> ';' then begin result:= false; exit; end;
  Result:= IsXmlName(copy(S,2,length(S)-2));
end;

function IsXmlReference(const S: WideString): boolean;
begin
  if IsXmlEntityRef(s) or IsXmlCharRef(s)
    then result:= true
    else result:= false;
end;

function IsXmlEntityValue(const S: WideString): boolean;
var
  i,j,indexpos: integer;
  SChar, SChar2, ForbittenQuote, sQuote, dQuote: widechar;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  Result:= true;
  if Length(S) < 2 then begin Result:= false; exit; end;
  if (S[length(S)] = sQuote) and (S[1] = sQuote) {single quotes}
    then ForbittenQuote:= sQuote
    else if (S[length(S)] = dQuote) and (S[1] = dQuote) {double quotes}
      then ForbittenQuote:= dQuote
      else begin Result:= false; exit; end;

  i:= 2;
  while i < length(S) do begin
    SChar:= WideChar((PWideChar(S)+i-1)^);
    if IsUtf16LowSurrogate(sChar) then begin Result:= false; exit; end;
    if IsUtf16HighSurrogate(SChar) then begin
      if i+1 = length(s) then begin Result:= false; exit; end;
      inc(i);
      SChar:= WideChar((PWideChar(S)+i-1)^);
      if not IsUtf16LowSurrogate(SChar) then begin Result:= false; exit; end;
    end;
    if not IsXmlChar(sChar) then begin Result:= false; exit; end;
    if SChar = ForbittenQuote then begin Result:= false; exit; end;
    if SChar = '%' then begin {PEReference?}
      indexpos:= -1;
      for j:= i+1 to length(S)-1 do begin
        SChar2:= WideChar((PWideChar(S)+j-1)^);
        if SChar2 = ';' then begin indexpos:= j; break; end;
      end;
      if indexpos = -1 then begin Result:= false; exit; end;
      if not IsXmlPEReference(copy(S,i,j-i+1)) then begin Result:= false; exit; end;
      i:= j;
    end;
    if SChar = '&' then begin {Reference?}
      indexpos:= -1;
      for j:= i+1 to length(S)-1 do begin
        SChar2:= WideChar((PWideChar(S)+j-1)^);
        if SChar2 = ';' then begin indexpos:= j; break; end;
      end;
      if indexpos = -1 then begin Result:= false; exit; end;
      if not IsXmlReference(copy(S,i,j-i+1)) then begin Result:= false; exit; end;
      i:= j;
    end;
    inc(i);
  end;
end;

function IsXmlAttValue(const S: WideString): boolean;
var
  i,j,indexpos: integer;
  SChar, SChar2, ForbittenQuote, sQuote, dQuote: widechar;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  Result:= true;
  if Length(S) < 2 then begin Result:= false; exit; end;
  if (S[length(S)] = sQuote) and (S[1] = sQuote) {single quotes}
    then ForbittenQuote:= sQuote
    else if (S[length(S)] = dQuote) and (S[1] = dQuote) {double quotes}
      then ForbittenQuote:= dQuote
      else begin Result:= false; exit; end;

  i:= 2;
  while i < length(S) do begin
    SChar:= WideChar((PWideChar(S)+i-1)^);
    if IsUtf16LowSurrogate(sChar) then begin Result:= false; exit; end;
    if IsUtf16HighSurrogate(SChar) then begin
      if i+1 = length(s) then begin Result:= false; exit; end;
      inc(i);
      SChar:= WideChar((PWideChar(S)+i-1)^);
      if not IsUtf16LowSurrogate(SChar) then begin Result:= false; exit; end;
    end;
    if not IsXmlChar(sChar) then begin Result:= false; exit; end;
    if SChar = ForbittenQuote then begin Result:= false; exit; end;
    if SChar = '<' then begin Result:= false; exit; end;
    if SChar = '&' then begin {Reference?}
      indexpos:= -1;
      for j:= i+1 to length(S)-1 do begin
        SChar2:= WideChar((PWideChar(S)+j-1)^);
        if SChar2 = ';' then begin indexpos:= j; break; end;
      end;
      if indexpos = -1 then begin Result:= false; exit; end;
      if not IsXmlReference(copy(S,i,j-i+1)) then begin Result:= false; exit; end;
      i:= j;
    end;
    inc(i);
  end;
end;

function IsXmlSystemLiteral(const S: WideString): boolean;
var
  i: integer;
  SChar, ForbittenQuote, sQuote, dQuote: widechar;
begin
  Result:= true;
  sQuote:= #$0027;
  dQuote:= '"';
  if Length(S) < 2 then begin Result:= false; exit; end;
  if (S[length(S)] = sQuote) and (S[1] = sQuote) {single quotes}
    then ForbittenQuote:= sQuote
    else if (S[length(S)] = dQuote) and (S[1] = dQuote) {double quotes}
      then ForbittenQuote:= dQuote
      else begin Result:= false; exit; end;

  i:= 1;
  while i < length(S)-1 do begin
    inc(i);
    SChar:= WideChar((PWideChar(S)+i-1)^);
    if IsUtf16LowSurrogate(sChar) then begin Result:= false; exit; end;
    if IsUtf16HighSurrogate(SChar) then begin
      if i+1 = length(s) then begin Result:= false; exit; end;
      inc(i);
      SChar:= WideChar((PWideChar(S)+i-1)^);
      if not IsUtf16LowSurrogate(SChar) then begin Result:= false; exit; end;
    end;
    if not IsXmlChar(sChar) then begin Result:= false; exit; end;
    if SChar = ForbittenQuote then begin Result:= false; exit; end;
  end;
end;

function IsXmlPubidLiteral(const S: WideString): boolean;
var
  i: integer;
  SChar, ForbittenQuote,sQuote, dQuote: widechar;
begin
  Result:= true;
  sQuote:= #$0027;
  dQuote:= '"';
  if Length(S) < 2 then begin Result:= false; exit; end;
  if (S[length(S)] = sQuote) and (S[1] = sQuote) {single quotes}
    then ForbittenQuote:= sQuote
    else if (S[length(S)] = dQuote) and (S[1] = dQuote) {double quotes}
      then ForbittenQuote:= dQuote
      else begin Result:= false; exit; end;

  i:= 1;
  while i < length(S)-1 do begin
    inc(i);
    SChar:= WideChar((PWideChar(S)+i-1)^);
    if IsUtf16LowSurrogate(sChar) then begin Result:= false; exit; end;
    if IsUtf16HighSurrogate(SChar) then begin
      if i+1 = length(s) then begin Result:= false; exit; end;
      inc(i);
      SChar:= WideChar((PWideChar(S)+i-1)^);
      if not IsUtf16LowSurrogate(SChar) then begin Result:= false; exit; end;
    end;
    if not IsXmlChar(sChar) then begin Result:= false; exit; end;
    if SChar = ForbittenQuote then begin Result:= false; exit; end;
    if not IsXmlPubidChar(SChar) then begin Result:= false; exit; end;
  end;
end;

function IsXmlCharData(const S: WideString): boolean;
var
  i: integer;
  SChar: wideChar;
begin
  Result:= true;
  if pos(']]>',S) > 0 then begin result:= false; exit; end;
  i:= 0;
  while i < length(S)-1 do begin
    inc(i);
    SChar:= S[i];
    if IsUtf16LowSurrogate(sChar) then begin Result:= false; exit; end;
    if IsUtf16HighSurrogate(SChar) then begin
      if i = length(s) then begin Result:= false; exit; end;
      inc(i);
      SChar:= S[i];
      if not IsUtf16LowSurrogate(SChar) then begin Result:= false; exit; end;
    end;
    if not IsXmlChar(sChar) then begin Result:= false; exit; end;
    if SChar = '<' then begin Result:= false; exit; end;
    if SChar = '&' then begin Result:= false; exit; end;
  end;
end;

function IsXmlPITarget(const S: WideString): boolean;
begin
  Result:= IsXmlName(S);
  if length(S) = 3 then
    if ((S[1] = 'X') or (S[1] = 'x')) and
       ((S[2] = 'M') or (S[2] = 'm')) and
       ((S[3] = 'L') or (S[3] = 'l'))
      then Result:= false;
end;

function IsXmlVersionNum(const S: WideString): boolean;
var
  SChar: widechar;
  i: integer;
begin
  Result:= true;
  if Length(S) = 0 then begin Result:= false; exit; end;
  for i:=1 to length(S) do begin
    SChar:= S[i];
    if not ( ((SChar >= 'a') and (SChar <= 'z')) or
             ((SChar >= 'A') and (SChar <= 'Z')) or
             ((SChar >= '0') and (SChar <= '9')) or
             (SChar = '_') or (SChar = '.') or
             (SChar = ':') or (SChar = '-')  )
      then Result:= false; exit;
  end;
end;

function IsXmlEncName(const S: WideString): boolean;
var
  SChar: widechar;
  i: integer;
begin
  Result:= true;
  if Length(S) = 0 then begin Result:= false; exit; end;
  SChar:= S[1];
  if not ( ((SChar >= 'a') and (SChar <= 'z')) or
           ((SChar >= 'A') and (SChar <= 'Z')) )
    then Result:= false; exit;

  for i:=2 to length(S) do begin
    SChar:= S[i];
    if not ( ((SChar >= 'a') and (SChar <= 'z')) or
             ((SChar >= 'A') and (SChar <= 'Z')) or
             ((SChar >= '0') and (SChar <= '9')) or
             (SChar = '.') or (SChar = '_') or (SChar = '-')  )
      then Result:= false; exit;
  end;
end;

function IsXmlStringType(const S: WideString): boolean;
begin
  if S = 'CDATA'
    then Result:= true
    else Result:= false;
end;

function IsXmlTokenizedType(const S: WideString): boolean;
begin
  if (S='ID') or (S='IDREF') or (S='IDREFS') or (S='ENTITY') or
     (S='ENTITIES') or (S='NMTOKEN') or (S='NMTOKENS')
    then Result:= true
    else Result:= false;
end;

function IsXmlNCNameChar(const s: WideChar): boolean;
begin
  if IsXmlLetter(S) or IsXmlDigit(S) or IsXmlCombiningChar(S)
    or IsXmlExtender(S) or (S='.') or (S='-') or (S='_')
    then Result:= true
    else Result:= false;
end;

function IsXmlNCName(const S: WideString): boolean;
var
  i: integer;
begin
  Result:= true;
  if Length(S) = 0 then begin Result:= false; exit; end;
  if not ( IsXmlLetter(PWideChar(S)^)
           or (PWideChar(S)^ = '_')   )
    then begin Result:= false; exit; end;
  for i:= 2 to length(S) do
    if not IsXmlNCNameChar(S[i])
      then begin Result:= false; exit; end;
end;

function IsXmlDefaultAttName(const S: WideString): boolean;
begin
  if S='xmls'
    then Result:= true
    else Result:= false;
end;

function IsXmlPrefixedAttName(const S: WideString): boolean;
var
  piece: WideString;
begin
  if copy(S,1,6) = 'xmlns:' then begin
    piece:= copy(S,7,length(S)-6);
    Result:= IsXmlNCName(piece);
  end else Result:= false;
end;

function IsXmlNSAttName(const S: WideString): boolean;
begin
  Result:= (IsXmlPrefixedAttName(S) or IsXmlDefaultAttName(S));
end;

function IsXmlLocalPart(const S: WideString): boolean;
begin
  Result:= IsXmlNCName(S);
end;

function IsXmlPrefix(const S: WideString): boolean;
begin
  Result:= IsXmlNCName(S);
end;

function IsXmlQName(const S: WideString): boolean;
var
  colonpos: integer;
  prefix,localpart: WideString;
begin
  colonpos:= pos(':',S);
  if colonpos = 0
    then result:= IsXmlLocalPart(S)
    else begin
      prefix:= copy(S,1,length(S)-colonpos);
      localpart:= copy(S,colonpos+1,length(S)-colonpos);
      result:= IsXmlPrefix(prefix) and IsXmlLocalPart(localpart);
  end;
end;

function XmlIntToCharRef(const value: integer): wideString;
begin
  Result:= concat('&#',intToStr(value),';');
end;

function XmlCharRefToInt(const S: WideString): integer;
var
  value: word;
begin
  if not IsXmlCharRef(S)
    then raise EConvertError.CreateFmt('%S is not a valid XmlCharRef value.',[S]);
  if S[3] = 'x'
    then Result:= StrToInt(concat('$',copy(S,4,length(S)-4))) // Hex
    else Result:= StrToInt(copy(S,3,length(S)-3));            // Dec
  if Result > $10FFFF
    then raise EConvertError.CreateFmt('%S is not a valid XmlCharRef value.',[S]);
  if Result < $10000 then begin
    Value:= Result;
    if not IsXmlChar(WideChar(value))
      then raise EConvertError.CreateFmt('%S is not a valid XmlCharRef value.',[S]);
  end;
end;

function XmlCharRefToStr(const S: WideString): WideString;
var
  value: integer;
  smallValue: word;
begin
  value:= XmlCharRefToInt(S);
  if value < $10000 then begin
    smallValue:= value;
    Result:= WideString(WideChar(smallValue));
  end else
    Result:= concat(WideString(Utf16HighSurrogate(value)),
                    WideString(Utf16LowSurrogate(value)));
end;

function XmlStrToCharRef(const S: WideString): WideString;
var
  SChar,LowSur: widechar;
  i: integer;
begin
  Result:= '';
  i:= 0;
  while i < length(S)-1 do begin
    inc(i);
    SChar:= S[i];
    if not isXmlChar(SChar)
      then raise EConvertError.CreateFmt('String contains invalid character %S.',[S]);
    if isUtf16LowSurrogate(SChar)
      then raise EConvertError.CreateFmt('Low surrogate %S without high surrogate.',[S]);
    if IsUtf16HighSurrogate(SChar) then begin
      if i+1 = length(s)
        then raise EConvertError.CreateFmt('High surrogate %S without low surrogate at end of string.',[S]);
      inc(i);
      lowSur:= S[i];
      if not IsUtf16LowSurrogate(lowSur)
        then raise EConvertError.CreateFmt('High surrogate %S without low surrogate.',[S]);
      Result:= concat(result,XmlIntToCharRef(Utf16SurrogateToInt(SChar,lowSur)));
    end else begin
      Result:= concat(result,XmlIntToCharRef(ord(SChar)));
    end;
  end; {for ...}
end;

function UTF8ToUTF16BEStr(const s: string): WideString;
// Converts a UTF-8 string into a UTF-16 WideString;
// The widestring starts with a Byte Order Mark.
// No special conversions (e.g. on line breaks) and
// no XML-char checking are done.
// - This function was provided by Ernst van der Pols -
const
  MaxCode: array[1..6] of integer = ($7F,$7FF,$FFFF,$1FFFFF,$3FFFFFF,$7FFFFFFF);
var
  i, j, CharSize, mask, ucs4: integer;
  c, first: char;
begin
  SetLength(Result,Length(s)+1); // assume no or little above-ASCII-chars
  j:=1;                          // keep track of actual length
  Result[j]:=WideChar($FEFF);    // start with BOM
  i:=0;
  while i<length(s) do
  begin
    Inc(i); c:=s[i];
    if ord(c)>=$80 then         // UTF-8 sequence
    begin
      CharSize:=1;
      first:=c; mask:=$40; ucs4:=ord(c);
      if (ord(c) and $C0<>$C0) then
        raise EConvertError.CreateFmt('Invalid UTF-8 sequence %2.2X',[ord(c)]);
      while (mask and ord(first)<>0) do
      begin
        // read next character of stream
        if i=length(s) then
          raise EConvertError.CreateFmt('Aborted UTF-8 sequence "%s"',[Copy(s,i-CharSize,CharSize)]);
        Inc(i); c:=s[i];
        if (ord(c) and $C0<>$80) then
          raise EConvertError.CreateFmt('Invalid UTF-8 sequence $%2.2X',[ord(c)]);
        ucs4:=(ucs4 shl 6) or (ord(c) and $3F); // add bits to result
        Inc(CharSize);  // increase sequence length
        mask:=mask shr 1;       // adjust mask
      end;
      if (CharSize>6) then      // no 0 bit in sequence header 'first'
        raise EConvertError.CreateFmt('Invalid UTF-8 sequence "%s"',[Copy(s,i-CharSize,CharSize)]);
      ucs4:=ucs4 and MaxCode[CharSize]; // dispose of header bits
      // check for invalid sequence as suggested by RFC2279
      if ((CharSize>1) and (ucs4<=MaxCode[CharSize-1])) then
        raise EConvertError.CreateFmt('Invalid UTF-8 encoding "%s"',[Copy(s,i-CharSize,CharSize)]);
      // convert non-ASCII UCS-4 to UTF-16 if possible
      case ucs4 of
      $00000080..$0000D7FF,$0000E000..$0000FFFD:
        begin
          Inc(j); Result[j]:=WideChar(ord(c));
        end;
      $0000D800..$0000DFFF,$0000FFFE,$0000FFFF:
        raise EConvertError.CreateFmt('Invalid UCS-4 character $%8.8X',[ucs4]);
      $00010000..$0010FFFF:
        begin
          // add high surrogate to content as if it was processed earlier
          Inc(j); Result[j]:=Utf16HighSurrogate(ucs4);  // assign high surrogate
          Inc(j); Result[j]:=Utf16LowSurrogate(ucs4);   // assign low surrogate
        end;
      else // out of UTF-16 range
        raise EConvertError.CreateFmt('Cannot convert $%8.8X to UTF-16',[ucs4]);
      end;
    end
    else        // ASCII char
    begin
      Inc(j); Result[j]:=WideChar(ord(c));
    end;
  end;
  SetLength(Result,j); // set to correct length
end;

function UTF16BEToUTF8Str(const ws: WideString): string;
// Converts a UTF-16BE widestring into a UTF-8 encoded string
// (and expands LF to CR+LF). The implementation is optimized
// for code that contains mainly ASCII characters (<=#$7F) and
// little above ASCII-chars. The buffer for the Result is set
// to the widestrings-length. With each non-ASCII character the
// Result-buffer is expanded (by the Insert-function), which leads
// to performance problems when one processes e.g. mainly Japanese
// documents.
// - This function was provided by Ernst van der Pols -
var i, j: integer;
    ucs4: integer;
    wc: WideChar;
    s: string;

  function UCS4CodeToUTF8String(code: integer): string;
  const
    MaxCode: array[0..5] of integer = ($7F,$7FF,$FFFF,$1FFFFF,$3FFFFFF,$7FFFFFFF);
    FirstOctet: array[0..5] of byte = (0,$C0,$E0,$F0,$F8,$FC);
  var
    mo, i: integer;
  begin
    mo:=0;			// get number of octets
    while ((code>MaxCode[mo]) and (mo<5)) do Inc(mo);
    SetLength(Result,mo+1);	// set result to correct length
    for i:=mo+1 downto 2 do	// fill octets from rear end
    begin
      Result[i]:=char($80 or (code and $3F));
      code:=code shr 6;
    end;				// fill first octet
    Result[1]:=char(FirstOctet[mo] or code);
  end;

begin
  SetLength(Result,Length(ws)); // assume no above-ASCII-chars
  j:=0;	// keep track of actual length
  i:=0;
  if ws[1] = #$feff then inc(i);  // Test for BOM
  while i<length(ws) do
  begin
    Inc(i);
    wc:=ws[i];
    case word(wc) of
    $0020..$007F,$0009,$000D:	// plain ASCII
      begin
	Inc(j);
	Result[j]:=Char(wc);
      end;
    $000A:	// LF --> CR+LF
      begin
	Inc(j); Result[j]:=Chr(13);
	Inc(j); System.Insert(Chr(10),Result,j);
      end;
    $D800..$DBFF:	// high surrogate
      begin
	inc(i);
	if (i<length(ws)) and (word(ws[i])>=$DC00) and (word(ws[i])<=$DFFF) then
	begin
	  ucs4:=Utf16SurrogateToInt(wc,ws[i]);
	  s:=UCS4CodeToUTF8String(ucs4);
	  System.Insert(s,Result,j+1);
	  Inc(j,Length(s));
	end
	else
	  raise EConvertError.CreateFmt('High surrogate %4.4X without low surrogate.',[word(wc)]);
      end;
    $DC00..$DFFF:	// low surrogate
      begin
	inc(i);
	if (i<length(ws)) and (word(ws[i])>=$D800) and (word(ws[i])<=$DBFF) then
	begin
	  ucs4:=Utf16SurrogateToInt(ws[i],wc);
	  s:=UCS4CodeToUTF8String(ucs4);
	  System.Insert(s,Result,j+1);
	  Inc(j,Length(s));
	end
	else
	  raise EConvertError.CreateFmt('Low surrogate %4.4X without high surrogate.',[word(wc)]);
      end;
    $0080..$D7FF,$E000..$FFFD:
      begin
	s:=UCS4CodeToUTF8String(word(wc));
	System.Insert(s,Result,j+1);
	Inc(j,Length(s));
      end;
    end;
  end;
  if Length(ws)<>j then
    SetLength(Result,j); // set to correct length
end;

function Utf16HighSurrogate(const value: integer): WideChar;
var
  value2: word;
begin
  value2:= ($D7C0 + ( value shr 10 ));
  Result:= WideChar(value2);
end;

function Utf16LowSurrogate(const value: integer): WideChar;
var
  value2: word;
begin
  value2:= ($DC00 XOR (value AND $3FF));
  Result:= WideChar(value2);
end;

function Utf16SurrogateToInt(const highSurrogate, lowSurrogate: WideChar): integer;
begin
  Result:=  ( (word(highSurrogate) -  $D7C0) shl 10 )
          + (  word(lowSurrogate) XOR $DC00  );
end;

function IsUtf16HighSurrogate(const S: WideChar): boolean;
begin
  Case Word(S) of
    $D800..$DBFF: result:= true;
  else
    result:= false;
  end;
end;

function IsUtf16LowSurrogate(const S: WideChar): boolean;
begin
  Case Word(S) of
    $DC00..$DFFF: result:= true;
  else
    result:= false;
  end;
end;



//++++++++++++++++++++++++++ TdomCustomStr +++++++++++++++++++++++++++++
constructor TdomCustomStr.create;
begin
  reset;
end;

procedure TdomCustomStr.addWideChar(const Ch: WideChar);
begin
  if FActualLen = FCapacity then begin  // Grow
    FCapacity:= FCapacity + FCapacity div 4;
    SetLength(FContent,FCapacity);
  end;
  Inc(FActualLen);
  FContent[FActualLen]:= Ch;
end;

procedure TdomCustomStr.AddWideString(const s: WideString);
var
  i,l: integer;
begin
  l:= system.length(s);
  while FActualLen+l > FCapacity do begin  // Grow
    FCapacity:= FCapacity + FCapacity div 4;
    SetLength(Fcontent,FCapacity);
  end;
  Inc(FActualLen,l);
  for i:= 1 to l do
    FContent[FActualLen-l+i]:= WideChar(s[i]);
end;

procedure TdomCustomStr.reset;
begin
  FCapacity:= 64;
  SetLength(FContent,FCapacity);
  FActualLen:= 0;
end;

function TdomCustomStr.value: WideString;
begin
  Result:= Copy(FContent,1,FActualLen);
end;



//+++++++++++++++++++++++ TdomImplementation ++++++++++++++++++++++++++
constructor TdomImplementation.Create(aOwner: TComponent);
begin
  inherited create(aOwner);
  FCreatedDocumentsListing:= TList.create;
  FCreatedDocuments:= TdomNodeList.create(FCreatedDocumentsListing);
  FCreatedDocumentTypesListing:= TList.create;
  FCreatedDocumentTypes:= TdomNodeList.create(FCreatedDocumentTypesListing);
end;

destructor TdomImplementation.Destroy;
begin
  clear;
  FCreatedDocumentsListing.free;
  FCreatedDocuments.free;
  FCreatedDocumentTypesListing.free;
  FCreatedDocumentTypes.free;
  inherited destroy;
end;

procedure TdomImplementation.clear;
var
  i: integer;
begin
  for i:= 0 to FCreatedDocumentsListing.count-1 do begin
    TdomDocument(FCreatedDocumentsListing[i]).clear; // destroys all child nodes, nodeIterators and treeWalkers
    TdomDocument(FCreatedDocumentsListing[i]).free;
    FCreatedDocumentsListing[i]:= nil;
  end;
  FCreatedDocumentsListing.pack;
  FCreatedDocumentsListing.Capacity:= FCreatedDocumentsListing.Count;

  for i:= 0 to FCreatedDocumentTypesListing.count-1 do begin
    TdomDocumentType(FCreatedDocumentTypesListing[i]).free;
    FCreatedDocumentTypesListing[i]:= nil;
  end;
  FCreatedDocumentTypesListing.pack;
  FCreatedDocumentTypesListing.Capacity:= FCreatedDocumentTypesListing.Count;
end;

procedure TdomImplementation.FreeDocument(const doc: TdomDocument);
var
  index: integer;
begin
  index:= FCreatedDocumentsListing.IndexOf(doc);
  if index = -1
    then raise ENot_Found_Err.create('Document not found error.');
  // destroys all child nodes, nodeIterators and treeWalkers:
  doc.clear;
  // free the document itself:
  FCreatedDocumentsListing.Delete(index);
  doc.free;
end;

procedure TdomImplementation.FreeDocumentType(const docType: TdomDocumentType);
var
  index: integer;
begin
  index:= FCreatedDocumentTypesListing.IndexOf(docType);
  if index = -1
    then raise ENot_Found_Err.create('DocumentType not found error.');
  FCreatedDocumentTypesListing.delete(index);
  docType.free;
end;

function TdomImplementation.getDocuments: TdomNodeList;
begin
  Result:= FCreatedDocuments;
end;

function TdomImplementation.getDocumentTypes: TdomNodeList;
begin
  Result:= FCreatedDocumentTypes;
end;

function TdomImplementation.HasFeature(const feature,
                                             version: WideString): boolean;
var
  VersionStr: string;
begin
  Result:= false;
  VersionStr:= WideCharToString(PWideChar(feature));
  if (WideCharToString(PWideChar(version))='1.0')
    or (WideCharToString(PWideChar(version))='')
  then begin
    if (CompareText(VersionStr,'XML')=0)
       then Result:= true;
  end else begin
    if (WideCharToString(PWideChar(version))='2.0')
      then begin
        if (CompareText(VersionStr,'XML')=0)
           then Result:= true;
        if (CompareText(VersionStr,'TRAVERSAL')=0)
           then Result:= true;
    end; {if ...}
  end; {if ... else ...}
end;

function TdomImplementation.createDocument(const name: WideString;
                                                 doctype: TdomDocumentType): TdomDocument;
begin
  if assigned(doctype) then
    if documentTypes.IndexOf(doctype) = -1
      then raise EWrong_Document_Err.create('Wrong document error.');
  if not IsXmlName(name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if SupportsDocumentFormat('',name)
    then Result:= GetDocumentClass('',name).create
    else Result:= TdomDocument.Create;
  FCreatedDocumentsListing.add(Result);
  if assigned(doctype) then begin
    FCreatedDocumentTypes.FNodeList.Remove(doctype);
    doctype.FDocument:= Result;
    Result.AppendChild(doctype);
  end;
  Result.InitDoc(name);
end;

function TdomImplementation.createDocumentNS(const namespaceURI,
                                                   qualifiedName: WideString;
                                                   doctype: TdomDocumentType): TdomDocument;
var
  prfx: WideString;
begin
  if assigned(doctype) then
    if documentTypes.IndexOf(doctype) = -1
      then raise EWrong_Document_Err.create('Wrong document error.');
  if not IsXmlName(QualifiedName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlQName(QualifiedName)
    then raise ENamespace_Err.create('Namespace error.');
  prfx:= XMLExtractPrefix(QualifiedName);
  if ( ((prfx = 'xmlns') or (QualifiedName = 'xmlns'))
    and not (NamespaceURI ='http://www.w3.org/2000/xmlns/') )
      then raise ENamespace_Err.create('Namespace error.');
  if (NamespaceURI = '') and (prfx <> '')
    then raise ENamespace_Err.create('Namespace error.');
  if (prfx = 'xml') and (NamespaceURI <> 'http://www.w3.org/XML/1998/namespace')
    then raise ENamespace_Err.create('Namespace error.');
  if SupportsDocumentFormat(namespaceURI,qualifiedName)
    then Result:= GetDocumentClass(namespaceURI,qualifiedName).create
    else Result:= TdomDocument.Create;
  FCreatedDocuments.FNodeList.add(Result);
  if assigned(doctype) then begin
    FCreatedDocumentTypes.FNodeList.Remove(doctype);
    doctype.FDocument:= Result;
    Result.AppendChild(doctype);
  end;
  Result.InitDocNS(namespaceURI,qualifiedName);
end;

function TdomImplementation.createDocumentType(const name,
                                                     publicId,
                                                     systemId: WideString): TdomDocumentType;
begin
  if not IsXmlName(name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  Result:= TdomDocumentType.Create(nil,name,publicId,systemId);
  FCreatedDocumentTypes.FNodeList.add(Result);
end;

function TdomImplementation.createDocumentTypeNS(const qualifiedName,
                                                       publicId,
                                                       systemId: WideString): TdomDocumentType;
begin
  if not IsXmlName(QualifiedName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlQName(QualifiedName)
    then raise ENamespace_Err.create('Namespace error.');
  Result:= TdomDocumentType.Create(nil,qualifiedName,publicId,systemId);
  FCreatedDocumentTypes.FNodeList.add(Result);
end;

function TdomImplementation.GetDocumentClass(const aNamespaceUri,
                                                   aQualifiedName: wideString): TdomDocumentClass;
var
  aDocFormat: PdomDocumentFormat;
begin
  aDocFormat := domDocumentFormatList;
  while aDocFormat <> nil do
    with aDocFormat^ do begin
      if (aNamespaceUri = NamespaceUri) and (aQualifiedName = QualifiedName) then begin
        Result:= DocumentClass;
        exit;
      end else aDocFormat := next;
    end;
  raise EUnknown_Document_Format_Err.create('Unknown document format yet');
end;

class procedure TdomImplementation.RegisterDocumentFormat(const aNamespaceUri,
                                                                aQualifiedName: wideString;
                                                                aDocumentClass: TdomDocumentClass);
var
  newRec: PdomDocumentFormat;
begin
  new(newRec);
  with newRec^ do begin
    documentClass:= aDocumentClass;
    NamespaceUri:= aNamespaceUri;
    QualifiedName:= aQualifiedName;
    next:= domDocumentFormatList;
  end;
  domDocumentFormatList:= newRec;
end;

function TdomImplementation.SupportsDocumentFormat(const aNamespaceUri,
                                                         aQualifiedName: wideString): boolean;
var
  aDocFormat: PdomDocumentFormat;
begin
  Result:= false;
  aDocFormat := domDocumentFormatList;
  while aDocFormat <> nil do
    with aDocFormat^ do begin
      if (aNamespaceUri = NamespaceUri) and (aQualifiedName = QualifiedName) then begin
        Result:= true;
        exit;
      end else aDocFormat := next;
    end;
end;

class procedure TdomImplementation.UnregisterDocumentClass(const aDocumentClass: TdomDocumentClass);
var
  aDocFormat,oldRec,previous: PdomDocumentFormat;
begin
  previous:= nil;
  aDocFormat := domDocumentFormatList;
  while aDocFormat <> nil do
    with aDocFormat^ do begin
      if aDocumentClass = DocumentClass then begin
        oldRec:= aDocFormat;
        if assigned(previous)
          then previous.next:= next
          else domDocumentFormatList := next;
        previous:= aDocFormat;
        aDocFormat := next;
        Dispose(oldRec);
      end else begin
        previous:= aDocFormat;
        aDocFormat := next;
      end;
    end; {with ...}
end;



//++++++++++++++++++++++++++++ TdomTreeWalker +++++++++++++++++++++++++++++++
constructor TdomTreeWalker.create(const Root: TdomNode;
                                  const WhatToShow: TdomWhatToShow;
                                  const NodeFilter: TdomNodeFilter;
                                  const EntityReferenceExpansion: boolean);
begin
  if not assigned(Root)
    then raise ENot_Supported_Err.create('Not supported error.');
  inherited create;
  FWhatToShow:= WhatToShow;
  FFilter:= NodeFilter;
  FExpandEntityReferences:= EntityReferenceExpansion;
  FRoot:= Root;
  FCurrentNode:= Root;
end;

function TdomTreeWalker.GetCurrentNode: TdomNode;
begin
  Result:= FCurrentNode;
end;

procedure TdomTreeWalker.SetCurrentNode(const Node: TdomNode);
begin
  if not assigned(Node)
    then raise ENot_Supported_Err.create('Not supported error.');
  FCurrentNode:= Node;
end;

function TdomTreeWalker.GetExpandEntityReferences: boolean;
begin
  Result:= FExpandEntityReferences;
end;

function TdomTreeWalker.GetFilter: TdomNodeFilter;
begin
  Result:= FFilter;
end;

function TdomTreeWalker.GetRoot: TdomNode;
begin
  Result:= FRoot;
end;

function TdomTreeWalker.GetWhatToShow: TdomWhatToShow;
begin
  Result:= FWhatToShow;
end;

function TdomTreeWalker.FindNextSibling(const OldNode: TdomNode): TdomNode;
var
  accept: TdomFilterResult;
  newNode: TdomNode;
begin
  Result:= nil;
  if oldNode = root then exit;
  newNode:= oldNode.NextSibling;
  if assigned(newNode) then begin
    if newNode.NodeType in FWhatToShow then begin
      if assigned(FFilter)
        then accept:= FFilter.acceptNode(newNode)
        else accept:= filter_accept;
    end else accept:= filter_skip;
    case accept of
      filter_reject:
        Result:= FindNextSibling(newNode);
      filter_skip:
        begin
          Result:= FindFirstChild(newNode);
          if not assigned(result)
            then Result:= FindNextSibling(newNode);
        end;
      filter_accept:
        Result:= newNode;
    end; {case ...}
  end else begin
    if not assigned(oldNode.parentNode)
      then begin result:= nil; exit; end; // TreeWalker.root not found!
    if oldNode.parentNode.NodeType in FWhatToShow then begin
      if assigned(FFilter)
        then accept:= FFilter.acceptNode(oldNode.parentNode)
        else accept:= filter_accept;
    end else accept:= filter_skip;
    case accept of
      filter_reject, filter_skip:
        Result:= FindNextSibling(oldNode.parentNode);
      filter_accept:
        Result:= nil;
    end; {case ...}
  end;
end;

function TdomTreeWalker.FindPreviousSibling(const OldNode: TdomNode): TdomNode;
var
  accept: TdomFilterResult;
  newNode: TdomNode;
begin
  Result:= nil;
  if OldNode = root then exit;
  newNode:= oldNode.PreviousSibling;
  if assigned(newNode) then begin
    if newNode.NodeType in FWhatToShow then begin
      if assigned(FFilter)
        then accept:= FFilter.acceptNode(newNode)
        else accept:= filter_accept;
    end else accept:= filter_skip;
    case accept of
      filter_reject:
        Result:= FindPreviousSibling(newNode);
      filter_skip:
        begin
          Result:= FindLastChild(newNode);
          if not assigned(result)
            then Result:= FindPreviousSibling(newNode);
        end;
      filter_accept:
        Result:= newNode;
    end; {case ...}
  end else begin
    if not assigned(oldNode.parentNode)
      then begin result:= nil; exit; end; // TreeWalker.root not found!
    if oldNode.parentNode.NodeType in FWhatToShow then begin
      if assigned(FFilter)
        then accept:= FFilter.acceptNode(oldNode.parentNode)
        else accept:= filter_accept;
    end else accept:= filter_skip;
    case accept of
      filter_reject, filter_skip:
        Result:= FindPreviousSibling(oldNode.parentNode);
      filter_accept:
        Result:= nil;
    end; {case ...}
  end;
end;

function TdomTreeWalker.FindParentNode(const OldNode: TdomNode): TdomNode;
var
  accept: TdomFilterResult;
begin
  Result:= nil;
  if OldNode = root then exit;
  Result:= OldNode.ParentNode;
  if not assigned(Result)
    then begin result:= nil; exit; end; // TreeWalker.root not found!
  if Result.NodeType in FWhatToShow then begin
    if assigned(FFilter)
      then accept:= FFilter.acceptNode(Result)
      else accept:= filter_accept;
  end else accept:= filter_skip;
  case accept of
    filter_reject, filter_skip:
      Result:= FindParentNode(Result);
  end;
end;

function TdomTreeWalker.FindFirstChild(const OldNode: TdomNode): TdomNode;
var
  newNode: TdomNode;
  accept: TdomFilterResult;
begin
  Result:= nil;
  newNode:= OldNode.FirstChild;
  if assigned(newNode) then begin
    if newNode.NodeType in FWhatToShow then begin
      if assigned(FFilter)
        then accept:= FFilter.acceptNode(newNode)
        else accept:= filter_accept;
    end else accept:= filter_skip;
    case accept of
      filter_reject:
        Result:= FindNextSibling(newNode);
      filter_skip:
        begin
          Result:= FindFirstChild(newNode);
          if not assigned(result)
            then Result:= FindNextSibling(newNode);
        end;
      filter_accept:
        Result:= newNode;
    end; {case ...}
  end;
end;

function TdomTreeWalker.FindLastChild(const OldNode: TdomNode): TdomNode;
var
  newNode: TdomNode;
  accept: TdomFilterResult;
begin
  Result:= nil;
  newNode:= OldNode.LastChild;
  if assigned(newNode) then begin
    if newNode.NodeType in FWhatToShow then begin
      if assigned(FFilter)
        then accept:= FFilter.acceptNode(newNode)
        else accept:= filter_accept;
    end else accept:= filter_skip;
    case accept of
      filter_reject:
        Result:= FindPreviousSibling(newNode);
      filter_skip:
        begin
          Result:= FindLastChild(newNode);
          if not assigned(result)
            then Result:= FindPreviousSibling(newNode);
        end;
      filter_accept:
        Result:= newNode;
    end; {case ...}
  end;
end;

function TdomTreeWalker.FindNextNode(OldNode: TdomNode): TdomNode;
var
  newNode: TdomNode;
begin
  Result:= FindFirstChild(oldNode);
  if OldNode = root then exit;
  if not assigned(Result)
    then Result:= FindNextSibling(oldNode);
  while not assigned(Result) do begin
    newNode:= FindParentNode(oldNode);
    if not assigned(newNode) then exit;  // No next node.
    Result:= FindNextSibling(newNode);
    oldNode:= newNode;
  end;
end;

function TdomTreeWalker.FindPreviousNode(const OldNode: TdomNode): TdomNode;
var
  newNode: TdomNode;
begin
  Result:= nil;
  if OldNode = root then exit;
  Result:= FindPreviousSibling(oldNode);
  if assigned(Result) then begin
    newNode:= FindLastChild(Result);
    if assigned(newNode) then result:= newNode;
  end else
    result:= FindParentNode(oldNode);
end;

function TdomTreeWalker.parentNode: TdomNode;
begin
  Result:= FindParentNode(FCurrentNode);
  if assigned(Result) then FCurrentNode:= Result;
end;

function TdomTreeWalker.firstChild: TdomNode;
begin
  Result:= FindFirstChild(FCurrentNode);
  if assigned(Result) then FCurrentNode:= Result;
end;

function TdomTreeWalker.lastChild: TdomNode;
begin
  Result:= FindLastChild(FCurrentNode);
  if assigned(Result) then FCurrentNode:= Result;
end;

function TdomTreeWalker.previousSibling: TdomNode;
begin
  Result:= FindPreviousSibling(FCurrentNode);
  if assigned(Result) then FCurrentNode:= Result;
end;

function TdomTreeWalker.nextSibling: TdomNode;
begin
  Result:= FindNextSibling(FCurrentNode);
  if assigned(Result) then FCurrentNode:= Result;
end;

function TdomTreeWalker.previousNode: TdomNode;
begin
  Result:= FindPreviousNode(FCurrentNode);
  if assigned(Result) then FCurrentNode:= Result;
end;

function TdomTreeWalker.nextNode: TdomNode;
begin
  Result:= FindNextNode(FCurrentNode);
  if assigned(Result) then FCurrentNode:= Result;
end;



//++++++++++++++++++++++++++++ TdomNodeIterator +++++++++++++++++++++++++++++++
constructor TdomNodeIterator.create(const Root: TdomNode;
                                    const WhatToShow: TdomWhatToShow;
                                    const nodeFilter: TdomNodeFilter;
                                    const EntityReferenceExpansion: boolean);
begin
  if not assigned(Root)
    then raise ENot_Supported_Err.create('Not supported error.');
  inherited create;
  FRoot:= root;
  FWhatToShow:= WhatToShow;
  FFilter:= NodeFilter;
  FReferenceNode:= Root;
  FInvalid:= false;
  FPosition:= posBefore;
end;

procedure TdomNodeIterator.FindNewReferenceNode(const nodeToRemove: TdomNode);
var
  newRefNode: TdomNode;
  newPosition: TdomPosition;
begin
  newRefNode:= nil;
  newPosition:= FPosition;
  case FPosition of
    posBefore: begin
      newRefNode:= nodeToRemove.NextSibling;
      if not assigned(newRefNode) then begin
        newRefNode:= FindPreviousNode(nodeToRemove);
        newPosition:= posAfter;
      end;
    end;
    posAfter: begin
      newRefNode:= nodeToRemove.NextSibling;
      if not assigned(newRefNode) then begin
        newRefNode:= FindPreviousNode(nodeToRemove);
        newPosition:= posBefore;
      end;
    end;
  end; {case ...}
  if assigned(newRefNode) then begin
    FReferenceNode:= newRefNode;
    FPosition:= newPosition;
  end;
end;

function TdomNodeIterator.GetExpandEntityReferences: boolean;
begin
  Result:= FExpandEntityReferences;
end;

function TdomNodeIterator.GetFilter: TdomNodeFilter;
begin
  Result:= FFilter;
end;

function TdomNodeIterator.GetRoot: TdomNode;
begin
  Result:= FRoot;
end;

function TdomNodeIterator.GetWhatToShow: TdomWhatToShow;
begin
  Result:= FWhatToShow;
end;

procedure TdomNodeIterator.detach;
begin
  FReferenceNode:= nil;
  FInvalid:= true;
end;

function TdomNodeIterator.FindNextNode(OldNode: TdomNode): TdomNode;
var
  newNode: TdomNode;
begin
  with OldNode do
    if HasChildNodes
      then result:= FirstChild
      else result:= NextSibling;
  while not assigned(Result) do begin
    newNode:= oldNode.ParentNode;
    if not assigned(newNode) then exit;  // No next node.
    Result:= newNode.NextSibling;
    oldNode:= newNode;
  end;
end;

function TdomNodeIterator.FindPreviousNode(const OldNode: TdomNode): TdomNode;
var
  newNode: TdomNode;
begin
  with OldNode do begin
    result:= PreviousSibling;
    if assigned(result) then begin
      newNode:= result;
      while assigned(newNode) do begin
        result:= newNode;
        newNode:= newNode.LastChild;
      end;
    end else result:= ParentNode;
  end;
end;

function TdomNodeIterator.NextNode: TdomNode;
var
  accept: TdomFilterResult;
  newNode: TdomNode;
begin
  newNode:= nil;
  if FInvalid
    then raise EInvalid_State_Err.create('Invalid state error.');
  case FPosition of
    posBefore: begin
      FPosition:= posAfter;
      newNode:= FReferenceNode;
    end;
    posAfter: begin
      newNode:= FindNextNode(FReferenceNode);
    end;
  end;
  repeat
    accept:= filter_accept;
    if assigned(newNode) then begin
      if newNode.NodeType in FWhatToShow then begin
        if assigned(FFilter)
          then accept:= FFilter.acceptNode(newNode);
      end else accept:= filter_skip;
      if not (accept = filter_accept)
        then newNode:= FindNextNode(newNode);
    end;
  until accept = filter_accept;
  if assigned(newNode) then
    if not (newNode.IsAncestor(root) or (newNode = root)) then
      if (FReferenceNode.IsAncestor(root) or (FReferenceNode = root)) then newNode:= nil;
  if assigned(newNode) then FReferenceNode:= newNode;
  Result:= newNode;
end;

function TdomNodeIterator.PreviousNode: TdomNode;
var
  accept: TdomFilterResult;
  newNode: TdomNode;
begin
  newNode:= nil;
  if FInvalid
    then raise EInvalid_State_Err.create('Invalid state error.');
  case FPosition of
    posBefore: begin
      newNode:= FindPreviousNode(FReferenceNode);
    end;
    posAfter: begin
      FPosition:= posBefore;
      newNode:= FReferenceNode;
    end;
  end;
  repeat
    accept:= filter_accept;
    if assigned(newNode) then begin
      if newNode.NodeType in FWhatToShow then begin
        if assigned(FFilter)
          then accept:= FFilter.acceptNode(newNode);
      end else accept:= filter_skip;
      if not (accept = filter_accept)
        then newNode:= FindPreviousNode(newNode);
    end;
  until accept = filter_accept;
  if assigned(newNode) then
    if not (newNode.IsAncestor(root) or (newNode = root)) then
      if (FReferenceNode.IsAncestor(root) or (FReferenceNode = root)) then newNode:= nil;
  if assigned(newNode) then FReferenceNode:= newNode;
  Result:= newNode;
end;



//++++++++++++++++++++++++++++ TdomNodeList +++++++++++++++++++++++++++++++
constructor TdomNodeList.Create(const NodeList: TList);
begin
  inherited create;
  FNodeList:= NodeList;
end;

function TdomNodeList.GetLength: integer;
begin
  Result:= FNodeList.count;
end;

function TdomNodeList.IndexOf(const Node: TdomNode): integer;
begin
  Result:= FNodeList.IndexOf(Node);
end;

function TdomNodeList.Item(const index: integer): TdomNode;
begin
  if (index < 0) or (index + 1 > FNodeList.count)
    then Result:= nil
    else Result:= TdomNode(FNodeList.Items[index]);
end;



//++++++++++++++++++++++++ TdomElementsNodeList ++++++++++++++++++++++++++
constructor TdomElementsNodeList.Create(const QueryName: WideString;
                                        const StartElement: TdomNode);
begin
  inherited Create(nil);
  FQueryName:= QueryName;
  FStartElement:= StartElement;
end;

function TdomElementsNodeList.GetLength: integer;
var
  AktNode,NewNode: TdomNode;
  Level: integer;
begin
  Result:= 0;
  if not assigned(FStartElement) then exit;
  Level:= 0;
  AktNode:= FStartElement;
  if AktNode.NodeType = ntElement_Node then
    if (AktNode.NodeName = FQueryName) or (FQueryName = '*') then
      inc(Result);
  repeat
    if AktNode.HasChildNodes
      then begin NewNode:= AktNode.FirstChild; inc(Level); end
      else NewNode:= AktNode.NextSibling;
    while not assigned(NewNode) do begin
      dec(Level);
      if Level < 1 then break;
      AktNode:= AktNode.ParentNode;
      NewNode:= AktNode.NextSibling;
    end;
    if Level < 1 then break;
    AktNode:= NewNode;
    if AktNode.NodeType = ntElement_Node then
      if (AktNode.NodeName = FQueryName) or (FQueryName = '*') then
        inc(Result);
  until Level < 1;
end;

function TdomElementsNodeList.IndexOf(const Node: TdomNode): integer;
var
  AktNode,NewNode: TdomNode;
  Level,i: integer;
begin
  Result:= -1;
  if not assigned(FStartElement) then exit;
  if not (Node is TdomNode) then exit;
  if Node.NodeType <> ntElement_Node then exit;
  i:= -1;
  Level:= 0;
  AktNode:= FStartElement;
  repeat
    if AktNode.HasChildNodes
      then begin NewNode:= AktNode.FirstChild; inc(Level); end
      else NewNode:= AktNode.NextSibling;
    while not assigned(NewNode) do begin
      dec(Level);
      if Level < 1 then break;
      AktNode:= AktNode.ParentNode;
      NewNode:= AktNode.NextSibling;
    end;
    if Level < 1 then break;
    AktNode:= NewNode;
    if AktNode.NodeType = ntElement_Node then
      if (AktNode.NodeName = FQueryName) or (FQueryName = '*') then begin
        inc(i);
        if AktNode = Node then begin Result:= i; break; end;
      end;
  until Level < 1;
end;

function TdomElementsNodeList.Item(const index: integer): TdomNode;
var
  AktNode,NewNode: TdomNode;
  Level,i: integer;
begin
  Result:= nil;
  if not assigned(FStartElement) then exit;
  if (index < 0) then exit;
  i:= -1;
  Level:= 0;
  AktNode:= FStartElement;
  repeat
    if AktNode.HasChildNodes
      then begin NewNode:= AktNode.FirstChild; inc(Level); end
      else NewNode:= AktNode.NextSibling;
    while not assigned(NewNode) do begin
      dec(Level);
      if Level < 1 then break;
      AktNode:= AktNode.ParentNode;
      NewNode:= AktNode.NextSibling;
    end;
    if Level < 1 then break;
    AktNode:= NewNode;
    if AktNode.NodeType = ntElement_Node then
      if (AktNode.NodeName = FQueryName) or (FQueryName = '*') then begin
        inc(i);
        if i = index then begin Result:= AktNode; break; end;
      end;
  until Level < 1;
end;



//+++++++++++++++++++++TdomElementsNodeListNS ++++++++++++++++++++++++++
constructor TdomElementsNodeListNS.Create(const QueryNamespaceURI,
                                                QueryLocalName: WideString;
                                          const StartElement: TdomNode);
begin
  inherited Create(nil);
  FQueryNamespaceURI:= QueryNamespaceURI;
  FQueryLocalName:= QueryLocalName;
  FStartElement:= StartElement;
end;

function TdomElementsNodeListNS.GetLength: integer;
var
  AktNode,NewNode: TdomNode;
  Level: integer;
begin
  Result:= 0;
  if not assigned(FStartElement) then exit;
  Level:= 0;
  AktNode:= FStartElement;
  repeat
    if AktNode.HasChildNodes
      then begin NewNode:= AktNode.FirstChild; inc(Level); end
      else NewNode:= AktNode.NextSibling;
    while not assigned(NewNode) do begin
      dec(Level);
      if Level < 1 then break;
      AktNode:= AktNode.ParentNode;
      NewNode:= AktNode.NextSibling;
    end;
    if Level < 1 then break;
    AktNode:= NewNode;
    if AktNode.NodeType = ntElement_Node then
      if ((AktNode.namespaceURI = FQueryNamespaceURI) or (FQueryNamespaceURI = '*'))
        and ((AktNode.localName = FQueryLocalName) or (FQueryLocalName = '*'))
          then inc(Result);
  until Level < 1;
end;

function TdomElementsNodeListNS.IndexOf(const Node: TdomNode): integer;
var
  AktNode,NewNode: TdomNode;
  Level,i: integer;
begin
  Result:= -1;
  if not assigned(FStartElement) then exit;
  if not (Node is TdomNode) then exit;
  if Node.NodeType <> ntElement_Node then exit;
  i:= -1;
  Level:= 0;
  AktNode:= FStartElement;
  repeat
    if AktNode.HasChildNodes
      then begin NewNode:= AktNode.FirstChild; inc(Level); end
      else NewNode:= AktNode.NextSibling;
    while not assigned(NewNode) do begin
      dec(Level);
      if Level < 1 then break;
      AktNode:= AktNode.ParentNode;
      NewNode:= AktNode.NextSibling;
    end;
    if Level < 1 then break;
    AktNode:= NewNode;
    if AktNode.NodeType = ntElement_Node then
      if ((AktNode.namespaceURI = FQueryNamespaceURI) or (FQueryNamespaceURI = '*'))
        and ((AktNode.localName = FQueryLocalName) or (FQueryLocalName = '*'))
          then begin
            inc(i);
            if AktNode = Node then begin Result:= i; break; end;
          end;
  until Level < 1;
end;

function TdomElementsNodeListNS.Item(const index: integer): TdomNode;
var
  AktNode,NewNode: TdomNode;
  Level,i: integer;
begin
  Result:= nil;
  if not assigned(FStartElement) then exit;
  if (index < 0) then exit;
  i:= -1;
  Level:= 0;
  AktNode:= FStartElement;
  repeat
    if AktNode.HasChildNodes
      then begin NewNode:= AktNode.FirstChild; inc(Level); end
      else NewNode:= AktNode.NextSibling;
    while not assigned(NewNode) do begin
      dec(Level);
      if Level < 1 then break;
      AktNode:= AktNode.ParentNode;
      NewNode:= AktNode.NextSibling;
    end;
    if Level < 1 then break;
    AktNode:= NewNode;
    if AktNode.NodeType = ntElement_Node then
      if ((AktNode.namespaceURI = FQueryNamespaceURI) or (FQueryNamespaceURI = '*'))
        and ((AktNode.localName = FQueryLocalName) or (FQueryLocalName = '*'))
          then begin
            inc(i);
            if i = index then begin Result:= AktNode; break; end;
          end;
  until Level < 1;
end;



//++++++++++++++++++++++++ TdomSpecialNodeList ++++++++++++++++++++++++++
constructor TdomSpecialNodeList.Create(const NodeList: TList;
                                       const AllowedNTs: TDomNodeTypeSet);
begin
  inherited Create(NodeList);
  FAllowedNodeTypes:= AllowedNTs;
end;

function TdomSpecialNodeList.GetLength: integer;
var
  i: integer;
begin
  Result:= 0;
  for i:= 0 to FNodeList.count-1 do
    if TdomNode(FNodeList[i]).NodeType in FAllowedNodeTypes
      then inc(Result);
end;

function TdomSpecialNodeList.IndexOf(const Node: TdomNode): integer;
var
  i: integer;
begin
  Result:= -1;
  if not (Node.NodeType in FAllowedNodeTypes) then exit;
  for i:= 0 to FNodeList.count-1 do begin
    if TdomNode(FNodeList[i]).NodeType in FAllowedNodeTypes
      then inc(Result);
    if TdomNode(FNodeList[i]) = Node
      then begin Result:= i; break; end;
  end;
end;

function TdomSpecialNodeList.Item(const index: integer): TdomNode;
var
  i,j: integer;
begin
  Result:= nil;
  j:= -1;
  if (index < 0) or (index > FNodeList.count-1) then exit;
  for i:= 0 to FNodeList.count-1 do begin
    if TdomNode(FNodeList[i]).NodeType in FAllowedNodeTypes
      then inc(j);
    if j = index then begin Result:= TdomNode(FNodeList[i]); break; end;
  end;
end;

function TdomSpecialNodeList.GetNamedIndex(const Name: WideString): integer;
var
  i,j: integer;
begin
  result:= -1;
  j:= -1;
  for i:= 0 to FNodeList.count-1 do
    if TdomNode(FNodeList[i]).NodeType in FAllowedNodeTypes then begin
      inc(j);
      if (TdomNode(FNodeList[i]).NodeName = Name)
        then begin Result:= j; break; end;
    end;
end;

function TdomSpecialNodeList.GetNamedItem(const Name: WideString): TdomNode;
var
  i: integer;
begin
  result:= nil;
  for i:= 0 to FNodeList.count-1 do
    if (TdomNode(FNodeList[i]).NodeName = Name)
      and (TdomNode(FNodeList[i]).NodeType in FAllowedNodeTypes) then begin
      Result:= TdomNode(FNodeList[i]);
      break;
    end;
end;


//+++++++++++++++++++++++++ TdomNamedNodeMap +++++++++++++++++++++++++++++
constructor TdomNamedNodeMap.Create(const AOwner,
                                          AOwnerNode: TdomNode;
                                    const NodeList: TList;
                                    const AllowedNTs: TDomNodeTypeSet);
begin
  inherited create(NodeList);
  FOwner:= AOwner;
  FOwnerNode:= AOwnerNode;
  FAllowedNodeTypes:= AllowedNTs;
  FNamespaceAware:= false;
end;

function TdomNamedNodeMap.getOwnerNode: TdomNode;
begin
  Result:= FOwnerNode;
end;

function TdomNamedNodeMap.getNamespaceAware: boolean;
begin
  Result:= FNamespaceAware;
end;

procedure TdomNamedNodeMap.setNamespaceAware(const value: boolean);
begin
  if FNodeList.count > 0
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  FNamespaceAware:= value;
end;

function TdomNamedNodeMap.RemoveItem(const Arg: TdomNode): TdomNode;
begin
  if FNodeList.IndexOf(Arg) = -1
    then raise ENot_Found_Err.create('Node not found error.');
  Result:= Arg;
  FNodeList.Remove(Arg);
  Result.FParentNode:= nil;
end;

function TdomNamedNodeMap.GetNamedIndex(const Name: WideString): integer;
var
  i: integer;
begin
  if FNamespaceAware then raise ENamespace_Err.create('Namespace error.');
  result:= -1;
  for i:= 0 to FNodeList.count-1 do
    if (TdomNode(FNodeList[i]).NodeName = Name)
      and (TdomNode(FNodeList[i]).NodeType in FAllowedNodeTypes) then begin
      Result:= i;
      break;
    end;
end;

function TdomNamedNodeMap.GetNamedItem(const Name: WideString): TdomNode;
var
  i: integer;
begin
  if FNamespaceAware then raise ENamespace_Err.create('Namespace error.');
  result:= nil;
  for i:= 0 to FNodeList.count-1 do
    if (TdomNode(FNodeList[i]).NodeName = Name)
      and (TdomNode(FNodeList[i]).NodeType in FAllowedNodeTypes) then begin
      Result:= TdomNode(FNodeList[i]);
      break;
    end;
end;

function TdomNamedNodeMap.SetNamedItem(const Arg: TdomNode): TdomNode;
begin
  if FNamespaceAware then raise ENamespace_Err.create('Namespace error.');
  if FOwner.OwnerDocument <> Arg.OwnerDocument
    then raise EWrong_Document_Err.create('Wrong document error.');
  if not (Arg.NodeType in FAllowedNodeTypes)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  if assigned(arg.parentNode)
    then raise EInuse_Node_Err.create('Inuse node error.');
  if arg.NodeType = ntAttribute_Node
    then if assigned((arg as TdomAttr).OwnerElement)
      then if (arg as TdomAttr).OwnerElement <> FOwnerNode
        then raise EInuse_Attribute_Err.create('Inuse attribute error.');
  if assigned(GetNamedItem(Arg.NodeName))
    then Result:= RemoveNamedItem(Arg.NodeName)
    else Result:= nil;
  FNodeList.Add(Arg);
  arg.FParentNode:= nil;
  if (arg.NodeType = ntAttribute_Node)
    and (FOwnerNode.NodeType = ntElement_Node)
    then (arg as TdomAttr).FownerElement:= TdomElement(FOwnerNode);
end;

function TdomNamedNodeMap.RemoveNamedItem(const Name: WideString): TdomNode;
begin
  if FNamespaceAware then raise ENamespace_Err.create('Namespace error.');
  Result:= GetNamedItem(Name);
  if not assigned(Result)
    then raise ENot_Found_Err.create('Node not found error.');
  FNodeList.Remove(Result);
  if Result.NodeType = ntAttribute_Node
    then (Result as TdomAttr).FownerElement:= nil;
end;

function TdomNamedNodeMap.GetNamedItemNS(const namespaceURI,
                                               localName: WideString): TdomNode;
var
  i: integer;
begin
  if not FNamespaceAware then raise ENamespace_Err.create('Namespace error.');
  result:= nil;
  for i:= 0 to FNodeList.count-1 do
    if (TdomNode(FNodeList[i]).namespaceURI = namespaceURI)
      and (TdomNode(FNodeList[i]).localName = localName)
      and (TdomNode(FNodeList[i]).NodeType in FAllowedNodeTypes) then begin
      Result:= TdomNode(FNodeList[i]);
      break;
    end;
end;

function TdomNamedNodeMap.SetNamedItemNS(const arg: TdomNode): TdomNode;
begin
  if not FNamespaceAware then raise ENamespace_Err.create('Namespace error.');
  if FOwner.OwnerDocument <> Arg.OwnerDocument
    then raise EWrong_Document_Err.create('Wrong document error.');
  if not (Arg.NodeType in FAllowedNodeTypes)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  if assigned(arg.parentNode)
    then raise EInuse_Node_Err.create('Inuse node error.');
  if arg.NodeType = ntAttribute_Node
    then if assigned((arg as TdomAttr).OwnerElement)
      then if (arg as TdomAttr).OwnerElement <> FOwnerNode
        then raise EInuse_Attribute_Err.create('Inuse attribute error.');
  if assigned(GetNamedItem(Arg.NodeName))
    then Result:= RemoveNamedItem(Arg.NodeName)
    else Result:= nil;
  FNodeList.Add(Arg);
  if (arg.NodeType = ntAttribute_Node)
    and (FOwnerNode.NodeType = ntElement_Node)
    then (arg as TdomAttr).FownerElement:= TdomElement(FOwnerNode);
end;

function TdomNamedNodeMap.RemoveNamedItemNS(const namespaceURI,
                                                  localName: WideString): TdomNode;
begin
  if not FNamespaceAware then raise ENamespace_Err.create('Namespace error.');
  Result:= GetNamedItemNS(namespaceURI,localName);
  if not assigned(Result)
    then raise ENot_Found_Err.create('Node not found error.');
  FNodeList.Remove(Result);
  if Result.NodeType = ntAttribute_Node
    then (Result as TdomAttr).FownerElement:= nil;
end;



//+++++++++++++++++++++++++ TdomEntitiesNamedNodeMap +++++++++++++++++++++++++++++
procedure TdomEntitiesNamedNodeMap.ResolveAfterAddition(const addedEntity: TdomEntity);
var
  EntityName: wideString;
  i: integer;
  oldChild: TdomNode;
begin
  if not assigned(addedEntity) then exit;
  EntityName:= addedEntity.NodeName;
  for i:= 0 to pred(FNodeList.Count) do
    if TdomNode(FNodeList[i]).NodeName <> EntityName
      then addedEntity.addEntRefSubtree(TdomNode(FNodeList[i]).NodeName);

  // Test for circular reference:
  with addedEntity do begin
    if HasEntRef(nodeName) then begin
      while HasChildNodes do begin
        FirstChild.FIsReadonly:= false;
        oldChild:= RemoveChild(FirstChild);
        OwnerDocument.FreeAllNodes(oldChild);
      end; {while ...}
      raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
    end; {if ...}
  end; {with ...}

  for i:= 0 to pred(FNodeList.Count) do
    TdomEntity(FNodeList[i]).addEntRefSubtree(EntityName);
end;

procedure TdomEntitiesNamedNodeMap.ResolveAfterRemoval(const removedEntity: TdomEntity);
var
  EntityName: wideString;
  i: integer;
begin
  if not assigned(removedEntity) then exit;
  EntityName:= removedEntity.NodeName;
  for i:= 0 to pred(FNodeList.Count) do
    TdomEntity(FNodeList[i]).removeEntRefSubtree(EntityName);
end;

function TdomEntitiesNamedNodeMap.SetNamedItem(const Arg: TdomNode): TdomNode;
begin
  result:= inherited SetNamedItem(Arg);
  try
    ResolveAfterAddition(Arg as TdomEntity);
  except
    RemoveNamedItem(Arg.nodeName);
    raise;
  end;
end;

function TdomEntitiesNamedNodeMap.RemoveNamedItem(const Name: WideString): TdomNode;
begin
  result:= inherited RemoveNamedItem(Name);
  if assigned(result)
    then ResolveAfterRemoval(result as TdomEntity);
end;

function TdomEntitiesNamedNodeMap.SetNamedItemNS(const Arg: TdomNode): TdomNode;
begin
  result:= inherited SetNamedItemNS(Arg);
  ResolveAfterAddition(Arg as TdomEntity);
end;

function TdomEntitiesNamedNodeMap.RemoveNamedItemNS(const namespaceURI,
                                                          LocalName: WideString): TdomNode;
begin
  result:= inherited RemoveNamedItemNS(namespaceURI,LocalName);
  if assigned(result)
    then ResolveAfterRemoval(result as TdomEntity);
end;



//++++++++++++++++++++++++++++++ TdomNode +++++++++++++++++++++++++++++++++
constructor TdomNode.Create(const AOwner: TdomDocument);
begin
  inherited create;
  FDocument:= AOwner;
  FParentNode:= nil;
  FNodeListing:= TList.create;
  FNodeList:= TdomNodeList.create(FNodeListing);
  FNodeName:= '';
  FNodeValue:= '';
  FNamespaceURI:= '';
  FNodeType:= ntUnknown;
  FIsReadonly:= false;
  FAllowedChildTypes:= [ntElement_Node,
                        ntText_Node,
                        ntCDATA_Section_Node,
                        ntEntity_Reference_Node,
                        ntParameter_Entity_Reference_Node,
                        ntProcessing_Instruction_Node,
                        ntXml_Declaration_Node,
                        ntComment_Node,
                        ntDocument_Type_Node,
                        ntConditional_Section_Node,
                        ntDocument_Fragment_Node,
                        ntElement_Type_Declaration_Node,
                        ntAttribute_List_Node,
                        ntEntity_Declaration_Node,
                        ntParameter_Entity_Declaration_Node,
                        ntNotation_Node,
                        ntNotation_Declaration_Node,
                        ntExternal_Subset_Node,
                        ntInternal_Subset_Node];
end;

destructor TdomNode.Destroy;
begin
  FNodeListing.free;
  FNodeList.free;
  inherited destroy;
end;

procedure TdomNode.Clear;
var
  i: integer;
  List1: TList;
begin
  if FIsReadonly
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  List1:= TList.create;
  List1.clear;
  try
    for i:= 0 to ChildNodes.Length -1 do
      if not ChildNodes.item(i).FIsReadonly then
        List1.Add(ChildNodes.item(i));
    for i:= 0 to List1.count -1 do begin
      RemoveChild(TdomNode(List1[i]));
      OwnerDocument.FreeAllNodes(TdomNode(List1[i]));
    end;
  finally
    List1.free;
  end;
end;

procedure TdomNode.makeChildrenReadonly;
var
  i: integer;
begin
  with childnodes do
    for i:= 0 to pred(length) do
      with item(i) do begin
        item(i).FisReadonly:= true;
        item(i).makeChildrenReadonly;
      end;
end;

function TdomNode.RefersToExternalEntity: boolean;
var
  i: integer;
  node: TdomNode;
begin
  result:= false;
  for i:= 0 to pred(childnodes.length) do begin
    node:= childnodes.item(i);
    if node.nodeType = ntEntity_Reference_Node then
      if not TdomEntity(node).IsInternalEntity
        then result:= true
        else if node.RefersToExternalEntity then begin result:= true; exit; end;
  end; {for ...}
end;

function TdomNode.HasEntRef(const EntName: widestring): boolean;
var
  i: integer;
begin
  result:= false;
  for i:= 0 to pred(childnodes.length) do
    with childnodes.item(i) do
      if (nodeType = ntEntity_Reference_Node)
          and (nodeName = EntName)
        then result:= true
        else if HasEntRef(EntName) then begin result:= true; exit; end;
end;

procedure TdomNode.addEntRefSubtree(const EntName: widestring);
var
  i: integer;
begin
  for i:= 0 to pred(childnodes.length) do begin
    if (childnodes.item(i).nodeType = ntEntity_Reference_Node)
      and (childnodes.item(i).nodeName = EntName) then begin
      OwnerDocument.ExpandEntRef(childnodes.item(i) as TdomEntityReference);
    end; {if ...}
    childnodes.item(i).addEntRefSubtree(EntName);
  end; {for ...}
end;

procedure TdomNode.removeEntRefSubtree(const EntName: widestring);
var
  i: integer;
  oldChild: TdomNode;
begin
  for i:= 0 to pred(childnodes.length) do
    with childnodes.item(i) do
      if (nodeType = ntEntity_Reference_Node)
          and (nodeName = EntName)
      then begin
        while HasChildNodes do begin
          FirstChild.FIsReadonly:= false;
          oldChild:= RemoveChild(FirstChild);
          OwnerDocument.FreeAllNodes(oldChild);
        end;
      end else removeEntRefSubtree(EntName);
end;

function TdomNode.GetNodeName: WideString;
begin
  Result:= FNodeName;
end;

function TdomNode.GetNodeValue: WideString;
begin
  Result:= FNodeValue;
end;

procedure TdomNode.SetNodeValue(const Value: WideString);
begin
  FNodeValue:= Value;
end;

function TdomNode.GetNodeType: TdomNodeType;
begin
  Result:= FNodeType;
end;

function TdomNode.GetAttributes: TdomNamedNodeMap;
begin
  Result:= nil;
end;

function TdomNode.GetParentNode: TdomNode;
begin
  Result:= FParentNode;
end;

function TdomNode.GetDocument: TdomDocument;
begin
  Result:= FDocument;
end;

function TdomNode.GetCode: WideString;
var
  i: integer;
begin
  Result:= '';
  for i:= 0 to ChildNodes.Length -1 do
    Result:= concat(Result,ChildNodes.item(i).Code);
end;

function TdomNode.GetLocalName: WideString;
var
  colonpos: integer;
begin
  Result:= '';
  if (FNodeType in [ntElement_Node,ntAttribute_Node])
    and IsXmlQName(FNodeName) then begin
    colonpos:= pos(':',FNodeName);
    result:= copy(FNodeName,colonpos+1,length(FNodeName)-colonpos);
  end;
end;

function TdomNode.GetNamespaceURI: WideString;
begin
  Result:= FNamespaceURI;
end;

function TdomNode.GetPrefix: WideString;
var
  colonpos: integer;
begin
  Result:= '';
  if (FNodeType in [ntElement_Node,ntAttribute_Node])
    and IsXmlQName(FNodeName) then begin
    colonpos:= pos(':',FNodeName);
    result:= copy(FNodeName,1,length(FNodeName)-colonpos);
  end;
end;

procedure TdomNode.SetPrefix(const value: WideString);
begin
  if not IsXmlQName(NodeName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlName(value)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlPrefix(value)
    then raise ENamespace_Err.create('Namespace error.');
  if NamespaceURI = ''
    then raise ENamespace_Err.create('Namespace error.');
  if (value = 'xml')
    and not(NamespaceURI = 'http://www.w3.org/XML/1998/namespace')
    then raise ENamespace_Err.create('Namespace error.');
  if (value = 'xmlns')
    and not (NamespaceURI ='http://www.w3.org/2000/xmlns/')
      then raise ENamespace_Err.create('Namespace error.');
  if (NodeName = 'xmlns') and (self.NodeType = ntAttribute_Node)
    then raise ENamespace_Err.create('Namespace error.');
  FNodeName:= concat(value,':',localName);
end;

function TdomNode.GetChildNodes: TdomNodeList;
begin
  Result:= FNodeList;
end;

function TdomNode.GetFirstChild: TdomNode;
begin
  if FNodeListing.count = 0
    then Result:= nil
    else Result:= TdomNode(FNodeListing.First);
end;

function TdomNode.GetLastChild: TdomNode;
begin
  if FNodeListing.count = 0
    then Result:= nil
    else Result:= TdomNode(FNodeListing.Last);
end;

function TdomNode.GetPreviousSibling: TdomNode;
begin
  if assigned(ParentNode)
    then Result:= ParentNode.ChildNodes.Item(ParentNode.ChildNodes.IndexOf(Self)-1)
    else Result:= nil;
end;

function TdomNode.GetNextSibling: TdomNode;
begin
  if assigned(ParentNode)
    then Result:= ParentNode.ChildNodes.Item(ParentNode.ChildNodes.IndexOf(Self)+1)
    else Result:= nil;
end;

function TdomNode.InsertBefore(const newChild,
                                     refChild: TdomNode): TdomNode;
begin
  if not (newChild.NodeType in FAllowedChildTypes)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  if OwnerDocument <> newChild.OwnerDocument
    then raise EWrong_Document_Err.create('Wrong document error.');
  {Auf Zirkularität prüfen:}
  if IsAncestor(newChild)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  if FIsReadonly
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  if assigned(newChild.ParentNode)
    then if newChild.ParentNode.FIsReadonly
      then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  if assigned(refChild) then
    if FNodeListing.IndexOf(refChild) = -1
      then raise ENot_Found_Err.create('Node not found error.');
  Result:= newChild;
 {refChild kann übrigens nie ein TdomDocumentFragment sein (die
  folgende While-Schleife bricht in solch einem Fall mit einer
  'ENot_Found_Err'-Fehlermeldung ab), da ein solches nie in
  FNodeListing eingefügt werden kann, da bei einem
  entsprechenden Versuch immer nur die Child-Nodes des
  TdomDocumentFragment eingfügt werden würden.}
  if NewChild is TdomDocumentFragment
    then while NewChild.HasChildNodes do
      InsertBefore(newChild.ChildNodes.Item(0),refChild)
    else begin
      if newChild = refChild then exit;
      if assigned(newChild.parentNode) then newChild.parentNode.RemoveChild(newChild);
      if assigned(refChild)
        then FNodeListing.Insert(FNodeListing.IndexOf(refChild),newChild)
        else FNodeListing.Add(newChild);
      NewChild.FParentNode:= self;
    end;
end;

function TdomNode.ReplaceChild(const newChild,
                                     oldChild: TdomNode): TdomNode;
var
  refChild: TdomNode;
begin
  if not (newChild.NodeType in FAllowedChildTypes)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  if OwnerDocument <> newChild.OwnerDocument
    then raise EWrong_Document_Err.create('Wrong document error.');
  {Auf Zirkularität prüfen:}
  if IsAncestor(newChild)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  if FIsReadonly
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  if assigned(newChild.ParentNode)
    then if newChild.ParentNode.FIsReadonly
      then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  if FNodeListing.IndexOf(oldChild) = -1
    then raise ENot_Found_Err.create('Node not found error.');
  Result:= oldChild;
  if newChild = oldChild then exit;
  if assigned(newChild.parentNode) then newChild.parentNode.RemoveChild(newChild);
  refChild:= oldChild.NextSibling;
  RemoveChild(oldChild);
  if assigned(refChild)
    then InsertBefore(newChild,refChild)
    else AppendChild(newChild);
end;

function TdomNode.RemoveChild(const oldChild: TdomNode): TdomNode;
begin
  if FIsReadonly
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  if FNodeListing.IndexOf(oldChild) = -1
    then raise ENot_Found_Err.create('Node not found error.');
  OwnerDocument.FindNewReferenceNodes(oldChild);
  Result:= oldChild;
  FNodeListing.Remove(oldChild);
  OldChild.FParentNode:= nil;
end;

function TdomNode.AppendChild(const newChild: TdomNode): TdomNode;
begin
  if not (newChild.NodeType in FAllowedChildTypes)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  if OwnerDocument <> newChild.OwnerDocument
    then raise EWrong_Document_Err.create('Wrong document error.');
  {Auf Zirkularität prüfen:}
  if IsAncestor(newChild)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  if FIsReadonly
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  if assigned(newChild.ParentNode)
    then if newChild.ParentNode.FIsReadonly
      then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  Result:= newChild;
  if NewChild is TdomDocumentFragment then
    while NewChild.HasChildNodes do
      AppendChild(newChild.ChildNodes.Item(0))
  else begin
    if assigned(newChild.parentNode) then newChild.parentNode.RemoveChild(newChild);
    FNodeListing.Add(newChild);
    NewChild.FParentNode:= self;
  end;
end;

function TdomNode.HasChildNodes: boolean;
begin
  if FNodeListing.count = 0
    then result:= false
    else result:= true;
end;

function TdomNode.CloneNode(const deep: boolean): TdomNode;
var
  newChildNode: TdomNode;
  i: integer;
begin
  Result:= OwnerDocument.DuplicateNode(self);
  if deep then for i:= 0 to ChildNodes.Length-1 do
  begin
    newChildNode:= ChildNodes.Item(i).CloneNode(true);
    Result.AppendChild(newChildNode);
  end;
end;

function TdomNode.IsAncestor(const AncestorNode: TdomNode): boolean;
var
  NewAncestor: TdomNode;
  List1: TList;
begin
  Result:= false;
  NewAncestor:= ParentNode;
  List1:= TList.create;
  List1.clear;
  try
    while assigned(NewAncestor) do begin
      {Ciculation test:}
      if List1.IndexOf(NewAncestor) > -1
        then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      List1.Add(NewAncestor);
      if NewAncestor = AncestorNode then begin Result:= true; break; end;
      NewAncestor:= NewAncestor.ParentNode;
    end;
  finally
    List1.free;
  end;
end;

procedure TdomNode.GetLiteralAsNodes(const RefNode: TdomNode);
var
  i: integer;
  newNode: TdomNode;
  EntDecl: TdomCustomEntity;
begin
  {Auf Zirkularität prüfen:}
  if self = RefNode
     then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  for i:= 0 to ChildNodes.Length -1 do
    case ChildNodes.item(i).NodeType of
      ntEntity_Reference_Node,ntParameter_Entity_Reference_Node: begin
      {xxx auf Zirkularität prüfen! xxx}
      EntDecl:= (ChildNodes.item(i) as TdomReference).Declaration;
      if not assigned(EntDecl)
        then raise ENot_Found_Err.create('Entity declaration not found error.');
      if EntDecl.IsInternalEntity then EntDecl.GetLiteralAsNodes(RefNode);
      end;
    else
      begin
        newNode:= OwnerDocument.DuplicateNode(ChildNodes.item(i));
        RefNode.AppendChild(newNode);
        ChildNodes.item(i).GetLiteralAsNodes(newNode);
      end;
    end; {case ...}
end;

procedure TdomNode.normalize;
var
  i: integer;
begin
  for i:= 0 to ChildNodes.Length-1 do
    ChildNodes.Item(i).normalize;
end;

function TdomNode.supports(const feature,
                                 version: WideString): boolean;
var
  VersionStr: string;
begin
  Result:= false;
  VersionStr:= WideCharToString(PWideChar(feature));
  if (WideCharToString(PWideChar(version))='1.0')
    or (WideCharToString(PWideChar(version))='')
  then begin
    if (CompareText(VersionStr,'XML')=0)
       then Result:= true;
  end else begin
    if (WideCharToString(PWideChar(version))='2.0')
      then begin
        if (CompareText(VersionStr,'XML')=0)
           then Result:= true;
    end; {if ...}
  end; {if ... else ...}
end;


//+++++++++++++++++++++++++ TdomCharacterData ++++++++++++++++++++++++++++
constructor TdomCharacterData.create(const AOwner: TdomDocument);
begin
  FAllowedChildTypes:= [];
  inherited create(AOwner);
end;

function TdomCharacterData.GetData: WideString;
begin
  Result:= NodeValue;
end;

procedure TdomCharacterData.SetData(const Value: WideString);
begin
  NodeValue:= Value;
end;

function TdomCharacterData.GetLength: integer;
begin
  Result:= System.Length(Data);
end;

function TdomCharacterData.SubstringData(const offset,
                                               count: integer):WideString;
var
  len: integer;
begin
  if(offset < 0) or (offset > Length) or (count < 0)
    then raise EIndex_Size_Err.create('Index size error.');
  {Sicherstellen, daß mit count und offset die Länge des WideStrings
  nicht überschritten wird:}
  len:= Length-Offset;
  if count < len then len:= count;
  SetString(Result,PWideChar(Data)+Offset,len);
end;

procedure TdomCharacterData.AppendData(const arg: WideString);
begin
  Data:= concat(Data,Arg);
end;

procedure TdomCharacterData.InsertData(const offset: integer;
                                       const arg: WideString);
begin
  ReplaceData(offset,0,arg);
end;

procedure TdomCharacterData.DeleteData(const offset,
                                             count: integer);
begin
  ReplaceData(offset,count,'');
end;

procedure TdomCharacterData.ReplaceData(const offset,
                                              count: integer;
                                        const arg: WideString);
var
  len: integer;
  Data1,Data2:WideString;
begin
  if(offset < 0) or (offset > Length) or (count < 0)
    then raise EIndex_Size_Err.create('Index size error.');
  {Sicherstellen, daß mit count und offset die Länge des WideStrings
  nicht überschritten wird:}
  len:= Length-Offset;
  if count < len then len:= count;
  Data1:= SubstringData(0,offset);
  Data2:= SubstringData(offset+len,Length-offset-len);
  Data:= concat(Data1,arg,Data2);
end;



//+++++++++++++++++++++++++++ TdomAttr ++++++++++++++++++++++++++++++
constructor TdomAttr.Create(const AOwner: TdomDocument;
                            const NamespaceURI,
                                  Name: WideString;
                            const Spcfd: boolean);
var
  colonpos: integer;
  prefix: WideString;
begin
  if not IsXmlName(Name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if (NamespaceURI <> '') then begin
    if not IsXmlQName(Name) then raise ENamespace_Err.create('Namespace error.');
    colonpos:= pos(':',Name);
    if colonpos > 0 then begin
      prefix:= copy(Name,1,length(Name)-colonpos);
      if (prefix = 'xml') and (NamespaceURI <> 'http://www.w3.org/XML/1998/namespace')
        then raise ENamespace_Err.create('Namespace error.');
      if (prefix = 'xmlns') and (NamespaceURI <> '')
        then raise ENamespace_Err.create('Namespace error.');
    end;
  end;
  inherited Create(AOwner);
  FNodeName:= Name;
  FNodeValue:= '';
  FNodeType:= ntAttribute_Node;
  FOwnerElement:= nil;
  FSpecified:= Spcfd;
  FAllowedChildTypes:= [ntText_Node,
                        ntEntity_Reference_Node,
                        ntDocument_Fragment_Node];
end;

procedure TdomAttr.normalize;
var
  PrevNode, CurrentNode: TdomNode;
  i: integer;
begin
  {normalize text:}
  PrevNode:=nil;
  i:=ChildNodes.Length;
  while i>0 do
  begin
    Dec(i);
    CurrentNode:=ChildNodes.Item(i);
    if (CurrentNode.NodeType = ntText_Node) then
      begin
         if (Assigned(PrevNode)) and (PrevNode.NodeType = ntText_Node) then
         begin
            (CurrentNode as TdomText).AppendData((PrevNode as TdomText).Data);
            removeChild(PrevNode);
            PrevNode.OwnerDocument.FreeAllNodes(PrevNode);
         end;
      end
    else  // no text node, then normalize
      CurrentNode.normalize;
    PrevNode:=CurrentNode;
  end;
end;

function TdomAttr.GetName: WideString;
begin
  Result:= NodeName;
end;

function TdomAttr.GetSpecified: boolean;
begin
  Result:= FSpecified;
end;

function TdomAttr.GetNodeValue: WideString;
begin
  Result:= GetValue;
end;

procedure TdomAttr.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;

function TdomAttr.GetValue: WideString;
var
  i: integer;
  EntityDec: TdomCustomEntity;
begin
  Result:='';
  for i:= 0 to ChildNodes.Length -1 do
    case ChildNodes.item(i).NodeType of
      ntText_Node:
        Result:= Concat(Result,(ChildNodes.item(i) as TdomText).Data);
      ntEntity_Reference_Node: begin
        EntityDec:= (ChildNodes.item(i) as TdomEntityReference).Declaration;
        if assigned(EntityDec)
          then Result:= Concat(Result,EntityDec.Value);
      end;
    end;
end;

procedure TdomAttr.SetValue(const Value: WideString);
var
  ValueNode: TdomNode;
begin
  clear;
  if Value <> '' then begin
    ValueNode:= OwnerDocument.CreateText(Value);
    AppendChild(ValueNode);
  end;
end;

function TdomAttr.GetOwnerElement: TdomElement;
begin
  Result:= FOwnerElement;
end;

function TdomAttr.GetParentNode: TdomNode;
begin
  Result:= nil;
end;

function TdomAttr.GetPreviousSibling: TdomNode;
begin
  Result:= nil;
end;

function TdomAttr.GetNextSibling: TdomNode;
begin
  Result:= nil;
end;

function TdomAttr.GetCode: WideString;
begin
  if specified
    then Result:= concat(NodeName,WideString('="'),inherited GetCode,WideString('"'))
    else Result:= '';
end;

//++++++++++++++++++++++++++++ TdomElement ++++++++++++++++++++++++++++++++
constructor TdomElement.Create(const AOwner: TdomDocument;
                               const NamespaceURI,
                                     TagName: WideString);
begin
  if not IsXmlName(TagName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner);
  FNodeName:= TagName;
  FNodeValue:= '';
  FNodeType:= ntElement_Node;
  FAttributeListing:= TList.create;
  FCreatedElementsNodeLists:= TList.create;
  FCreatedElementsNodeListNSs:= TList.create;
  FAttributeList:= TdomNamedNodeMap.create(AOwner,self,FAttributeListing,[ntAttribute_Node]);
  FAllowedChildTypes:= [ntElement_Node,
                        ntText_Node,
                        ntCDATA_Section_Node,
                        ntEntity_Reference_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node,
                        ntDocument_Fragment_Node];
end;

destructor TdomElement.Destroy;
var
  i: integer;
begin
  FAttributeList.free;
  FAttributeListing.free;
  for i := 0 to FCreatedElementsNodeLists.Count - 1 do
    TdomElementsNodeList(FCreatedElementsNodeLists[i]).free;
  for i := 0 to FCreatedElementsNodeListNSs.Count - 1 do
    TdomElementsNodeListNS(FCreatedElementsNodeListNSs[i]).free;
  FCreatedElementsNodeLists.free;
  FCreatedElementsNodeListNSs.free;
  inherited Destroy;
end;

procedure TdomElement.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;

function TdomElement.GetCode: WideString;
var
  i: integer;
begin
  Result:= concat(WideString('<'),NodeName);
  for i:= 0 to Attributes.length -1 do
    if (Attributes.Item(i) as TdomAttr).specified
      then Result:= concat(Result,WideString(' '),Attributes.Item(i).code);
  Result:= concat(Result,WideString('>'),inherited GetCode,WideString('</'),NodeName,WideString('>'));
end;

function TdomElement.GetTagName: WideString;
begin
  Result:= NodeName;
end;

function TdomElement.GetAttributes: TdomNamedNodeMap;
begin
  Result:= FAttributeList;
end;

function TdomElement.GetAttribute(const Name: WideString): WideString;
begin
  if Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  if not assigned(GetAttributeNode(Name))
    then Result:= ''
    else Result:= (Attributes.GetNamedItem(Name) as TdomAttr).Value;
end;

function TdomElement.SetAttribute(const Name,
                                        Value: WideString): TdomAttr;
var
  Attr: TdomAttr;
begin
  if Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  Attr:= GetAttributeNode(Name);
  if assigned(Attr) then begin
    Attr.Value:= Value;
    Result:= nil;
  end else begin
    Result:= OwnerDocument.CreateAttribute(Name);
    Result.Value:= Value;
    SetAttributeNode(Result);
  end;
end;

function TdomElement.RemoveAttribute(const Name: WideString): TdomAttr;
begin
  if Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  if not assigned(GetAttributeNode(Name))
    then ENot_Found_Err.create('Node not found error.');
  Result:= RemoveAttributeNode(GetAttributeNode(Name));
end;

function TdomElement.GetAttributeNode(const Name: WideString): TdomAttr;
begin
  if Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  Result:= TdomAttr(Attributes.GetNamedItem(Name));
end;

function TdomElement.SetAttributeNode(const NewAttr: TdomAttr): TdomAttr;
var
  OldAttr: TdomAttr;
begin
  if Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  if OwnerDocument <> NewAttr.OwnerDocument
    then raise EWrong_Document_Err.create('Wrong document error.');
  if assigned(NewAttr.parentNode) and not (NewAttr.OwnerElement = self)
    then raise EInuse_Attribute_Err.create('Inuse attribute error.');
  Result:= nil;
  if not (NewAttr.OwnerElement = self) then begin
    OldAttr:= (Attributes.GetNamedItem(NewAttr.Name) as TdomAttr);
    if assigned(OldAttr) then Result:= RemoveAttributeNode(OldAttr);
    Attributes.SetNamedItem(NewAttr);
  end;
end;

function TdomElement.RemoveAttributeNode(const OldAttr: TdomAttr): TdomAttr;
begin
  if Attributes.indexof(OldAttr) = -1
    then raise ENot_Found_Err.create('Node not found error.');
  Attributes.RemoveItem(OldAttr);
  OldAttr.FOwnerElement:= nil;
  Result:= OldAttr;
end;

function TdomElement.GetElementsByTagName(const Name: WideString): TdomNodeList;
var
  i: integer;
begin
  for i:= 0 to FCreatedElementsNodeLists.Count - 1 do
    if TdomElementsNodeList(FCreatedElementsNodeLists[i]).FQueryName = Name
      then begin Result:= TdomElementsNodeList(FCreatedElementsNodeLists[i]); exit; end;
  Result:= TdomElementsNodeList.Create(Name,self);
  FCreatedElementsNodeLists.add(Result);
end;

function TdomElement.GetAttributeNS(const namespaceURI,
                                          localName: WideString): WideString;
begin
  if not Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  if not assigned(GetAttributeNodeNS(namespaceURI,localName))
    then Result:= ''
    else Result:= (Attributes.GetNamedItemNS(namespaceURI,localName) as TdomAttr).Value;
end;

function TdomElement.SetAttributeNS(const namespaceURI,
                                          qualifiedName,
                                          value: WideString): TdomAttr;
var
  Attr: TdomAttr;
  prfx, localname: Widestring;
begin
  if not Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  if not IsXmlName(QualifiedName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlQName(QualifiedName)
    then raise ENamespace_Err.create('Namespace error.');
  prfx:= XMLExtractPrefix(QualifiedName);
  if ( ((prfx = 'xmlns') or (QualifiedName = 'xmlns'))
    and not (NamespaceURI ='http://www.w3.org/2000/xmlns/') )
      then raise ENamespace_Err.create('Namespace error.');
  if (NamespaceURI = '') and (prfx <> '')
    then raise ENamespace_Err.create('Namespace error.');
  if (prfx = 'xml') and (NamespaceURI <> 'http://www.w3.org/XML/1998/namespace')
    then raise ENamespace_Err.create('Namespace error.');
  localname:= XMLExtractLocalName(qualifiedName);
  Attr:= GetAttributeNodeNS(namespaceURI,localName);
  if assigned(Attr) then begin
    Attr.FNodeName:= qualifiedName;
    Attr.Value:= Value;
    Result:= nil;
  end else begin
    Result:= OwnerDocument.CreateAttributeNS(namespaceURI,qualifiedName);
    Result.Value:= Value;
    SetAttributeNodeNS(Result);
  end;
end;

function TdomElement.RemoveAttributeNS(const namespaceURI,
                                             localName: WideString): TdomAttr;
begin
  if not Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  if not assigned(GetAttributeNodeNS(namespaceURI,localName))
    then ENot_Found_Err.create('Node not found error.');
  Result:= RemoveAttributeNode(GetAttributeNodeNS(namespaceURI,localName));
end;

function TdomElement.GetAttributeNodeNS(const namespaceURI,
                                              localName: WideString): TdomAttr;
begin
  if not Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  Result:= TdomAttr(Attributes.GetNamedItemNS(namespaceURI,localName));
end;

function TdomElement.SetAttributeNodeNS(const NewAttr: TdomAttr): TdomAttr;
var
  OldAttr: TdomAttr;
begin
  if not Attributes.NamespaceAware
    then raise ENamespace_Err.create('Namespace error.');
  if OwnerDocument <> NewAttr.OwnerDocument
    then raise EWrong_Document_Err.create('Wrong document error.');
  if assigned(NewAttr.parentNode) and not (NewAttr.OwnerElement = self)
    then raise EInuse_Attribute_Err.create('Inuse attribute error.');
  Result:= nil;
  if not (NewAttr.OwnerElement = self) then begin
    OldAttr:= (Attributes.GetNamedItemNS(NewAttr.namespaceURI,NewAttr.localName) as TdomAttr);
    if assigned(OldAttr) then Result:= RemoveAttributeNode(OldAttr);
    Attributes.SetNamedItemNS(NewAttr);
  end;
end;

function TdomElement.GetElementsByTagNameNS(const namespaceURI,
                                                  localName: WideString): TdomNodeList;
var
  i: integer;
  nl: TdomElementsNodeListNS;
begin
  for i:= 0 to FCreatedElementsNodeListNSs.Count - 1 do begin
    nl:= TdomElementsNodeListNS(FCreatedElementsNodeListNSs[i]);
    if (nl.FQueryNamespaceURI = namespaceURI) and (nl.FQueryLocalName = localName)
      then begin Result:= nl; exit; end;
  end;
  Result:= TdomElementsNodeListNS.Create(namespaceURI,localName,self);
  FCreatedElementsNodeListNSs.add(Result);
end;

function TdomElement.hasAttribute(const name: WideString): boolean;
begin
  Result:= assigned(Attributes.GetNamedItem(Name));
end;

function TdomElement.hasAttributeNS(const namespaceURI,
                                          localName: WideString): boolean;
begin
  Result:= assigned(Attributes.GetNamedItemNS(namespaceURI,localName));
end;

procedure TdomElement.normalize;
var
  PrevNode, CurrentNode: TdomNode;
  i: integer;
begin
  {normalize text:}
  PrevNode:=nil;
  i:=ChildNodes.Length;
  while i>0 do
  begin
    Dec(i);
    CurrentNode:=ChildNodes.Item(i);
    if (CurrentNode.NodeType = ntText_Node) then
      begin
         if (Assigned(PrevNode)) and (PrevNode.NodeType = ntText_Node) then
         begin
            (CurrentNode as TdomText).AppendData((PrevNode as TdomText).Data);
            removeChild(PrevNode);
            PrevNode.OwnerDocument.FreeAllNodes(PrevNode);
         end;
      end
    else  // no text node, then normalize
      CurrentNode.normalize;
    PrevNode:=CurrentNode;
  end;

  {normalize attributes:}
  for i:= 0 to attributes.Length-1 do
    attributes.item(i).normalize;
end;


//+++++++++++++++++++++++++++++ TdomText +++++++++++++++++++++++++++++++++
constructor TdomText.create(const AOwner: TdomDocument);
begin
  inherited Create(AOwner);
  FNodeName:= '#text';
  FNodeValue:= '';
  FNodeType:= ntText_Node;
end;

function TdomText.GetCode: WideString;
var
  i,l: integer;
  content: TdomCustomStr;
begin
  content:= TdomCustomStr.create;
  try
    l:= system.length(FNodeValue);
    for i:= 1 to l do
      case Word((PWideChar(FNodeValue[i]))) of
        60: content.addWideString(WideString('&#60;'));
        62: content.addWideString(WideString('&#62;'));
        38: content.addWideString(WideString('&#38;'));
        39: content.addWideString(WideString('&#39;'));
        34: content.addWideString(WideString('&#34;'));
      else
        content.addWideChar(WideChar(FNodeValue[i]));
      end;
    Result:= content.value;
  finally
    content.free;
  end;
end;

function TdomText.SplitText(const offset: integer): TdomText;
begin
  if(offset < 0) or (offset > Length)
    then raise EIndex_Size_Err.create('Index size error.');
  Result:= OwnerDocument.CreateText(SubstringData(offset,length-offset));
  DeleteData(offset,length-offset);
  if assigned(ParentNode) then ParentNode.InsertBefore(Result,self.NextSibling);
end;



//++++++++++++++++++++++++++++ TdomComment +++++++++++++++++++++++++++++++
constructor TdomComment.Create(const AOwner: TdomDocument);
begin
  inherited Create(AOwner);
  FNodeName:= '#comment';
  FNodeValue:= '';
  FNodeType:= ntComment_Node;
end;

function TdomComment.GetCode: WideString;
begin
  Result:= concat(WideString('<!--'),FNodeValue,WideString('-->'));
end;



//+++++++++++++++++++++ TdomProcessingInstruction +++++++++++++++++++++++++
constructor TdomProcessingInstruction.Create(const AOwner: TdomDocument;
                                             const Targ: WideString);
begin
  if not IsXmlPITarget(Targ)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner);
  FNodeName:= Targ;
  FNodeValue:= '';
  FNodeType:= ntProcessing_Instruction_Node;
  FAllowedChildTypes:= [];
end;

function TdomProcessingInstruction.GetTarget: WideString;
begin
  Result:= FNodeName;
end;

function TdomProcessingInstruction.GetData: WideString;
begin
  Result:= FNodeValue;
end;

procedure TdomProcessingInstruction.SetData(const Value: WideString);
begin
  FNodeValue:= Value;
end;

function TdomProcessingInstruction.GetCode: WideString;
begin
  Result:= concat(WideString('<?'),NodeName,WideString(' '),NodeValue,WideString('?>'));
end;



//++++++++++++++++++++++++ TdomXmlDeclaration ++++++++++++++++++++++++++
constructor TdomXmlDeclaration.Create(const AOwner: TdomDocument;
                                      const Version,
                                            EncDl,
                                            SdDl: WideString);
begin
  if not (IsXmlEncName(EncDl) or (EncDl = ''))
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not ((SdDl = 'yes') or (SdDl = 'no') or (SdDl = ''))
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlVersionNum(Version)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner);
  FVersionNumber:= Version;
  FEncodingDecl:= EncDl;
  FStandalone:= SdDl;
  FNodeName:= '#xml-declaration';
  FNodeValue:= '';
  FNodeType:= ntXml_Declaration_Node;
  FAllowedChildTypes:= [];
end;

function TdomXmlDeclaration.GetVersionNumber: WideString;
begin
  Result:= FVersionNumber;
end;

function TdomXmlDeclaration.GetEncodingDecl: WideString;
begin
  Result:= FEncodingDecl;
end;

procedure TdomXmlDeclaration.SetEncodingDecl(const Value: WideString);
begin
  if not (IsXmlEncName(Value) or (Value = ''))
    then raise EInvalid_Character_Err.create('Invalid character error.');
  FEncodingDecl:= Value;
end;

function TdomXmlDeclaration.GetStandalone: WideString;
begin
  Result:= FStandalone;
end;

procedure TdomXmlDeclaration.SetStandalone(const Value: WideString);
begin
  if not ((Value = 'yes') or (Value = 'no') or (Value = ''))
    then raise EInvalid_Character_Err.create('Invalid character error.');
  FStandalone:= Value;
end;

function TdomXmlDeclaration.GetCode: WideString;
begin
  Result:= concat(WideString('<?xml version="'),VersionNumber,WideString('"'));
  if EncodingDecl <> ''
    then Result:= concat(Result,WideString(' encoding="'),EncodingDecl,WideString('"'));
  if SDDecl <> ''
    then Result:= concat(Result,WideString(' standalone="'),SDDecl,WideString('"'));
  Result:= concat(Result,WideString('?>'));
end;



//++++++++++++++++++++++++++ TdomCDATASection +++++++++++++++++++++++++++++
constructor TdomCDATASection.Create(const AOwner: TdomDocument);
begin
  inherited Create(AOwner);
  FNodeName:= '#cdata-section';
  FNodeValue:= '';
  FNodeType:= ntCDATA_Section_Node;
end;

function TdomCDATASection.GetCode: WideString;
begin
  Result:= concat(WideString('<![CDATA['),FNodeValue,WideString(']]>'));
end;



//++++++++++++++++++++++ TdomCustomDocumentType ++++++++++++++++++++++++
constructor TdomCustomDocumentType.Create(const AOwner: TdomDocument);
begin
  inherited Create(AOwner);
  FNodeValue:= '';
  FParameterEntitiesListing:= TList.create;
  FAttributeListsListing:= TList.create;
  FParameterEntitiesList:= TdomNamedNodeMap.create(AOwner,self,FParameterEntitiesListing,[ntParameter_Entity_Node]);
  FAttributeListsList:= TdomNamedNodeMap.create(AOwner,self,FAttributeListsListing,[ntAttribute_List_Node]);
  FAllowedChildTypes:= [];
end;

destructor TdomCustomDocumentType.Destroy;
begin
  FParameterEntitiesListing.free;
  FAttributeListsListing.free;
  FParameterEntitiesList.free;
  FAttributeListsList.free;
  inherited Destroy;
end;

procedure TdomCustomDocumentType.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;

function TdomCustomDocumentType.GetParameterEntities: TdomNamedNodeMap;
begin
  Result:= FParameterEntitiesList;
end;

function TdomCustomDocumentType.GetAttributeLists: TdomNamedNodeMap;
begin
  Result:= FAttributeListsList;
end;



//++++++++++++++++++++++++++ TdomDocumentType +++++++++++++++++++++++++++++
constructor TdomDocumentType.Create(const AOwner: TdomDocument;
                                    const Name,
                                          PubId,
                                          SysId: WideString);
begin
  inherited Create(AOwner);
  FNodeName:= Name;
  FPublicId:= PubId;
  FSystemId:= SysId;
  FNodeType:= ntDocument_Type_Node;
  FAllowedChildTypes:= [ntExternal_Subset_Node,
                        ntInternal_Subset_Node];
  self.AppendChild(AOwner.CreateInternalSubset);
  self.AppendChild(AOwner.CreateExternalSubset);
  FEntitiesListing:= TList.create;
  FEntitiesList:= TdomEntitiesNamedNodeMap.create(AOwner,self,FEntitiesListing,[ntEntity_Node]);
  FNotationsListing:= TList.create;
  FNotationsList:= TdomNamedNodeMap.create(AOwner,self,FNotationsListing,[ntNotation_Node]);
  FIsReadonly:= true;
end;

destructor TdomDocumentType.Destroy;
begin
  FEntitiesListing.free;
  FEntitiesList.free;
  FNotationsListing.free;
  FNotationsList.free;
  inherited Destroy;
end;

function TdomDocumentType.analyzeEntityValue(const EntityValue: wideString): widestring;
var
  i,j: integer;
  RefEndFound: boolean;
  ReplaceText,EntName: wideString;
  Entity: TdomNode;
begin
  Result:= EntityValue;
  i:= 0;
  while i < length(Result) do begin
    inc(i);
    if result[i] = '%' then begin
      j:= 0;
      RefEndFound:= false;
      while i+j < length(result) do begin
        inc(j);
        if result[i+j] = ';' then begin
          RefEndFound:= true;
          EntName:= copy(result,i+1,j-1);
          Entity:= ParameterEntities.GetNamedItem(EntName);
          if assigned(Entity)
            then ReplaceText:= Entity.nodevalue
            else raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
          delete(result,i,j+1);
          insert(ReplaceText,Result,i);
          i:= i-1;
          break;
        end; {if ...}
      end; {while ...}
      if not RefEndFound
        then raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
    end else if result[i] = '&' then begin
      j:= 0;
      RefEndFound:= false;
      while i+j < length(result) do begin
        inc(j);
        if result[i+j] = ';' then begin
          RefEndFound:= true;
          if result[i+1] = '#' then begin
            ReplaceText:= XmlCharRefToStr(copy(result,i,j+1));
            delete(result,i,j+1);
            insert(ReplaceText,Result,i);
            i:= i+length(ReplaceText)-1;
          end; {if ...}
          break;
        end; {if ...}
      end; {while ...}
      if not RefEndFound
        then raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
    end; {if ... else ...}
  end; {while ...}
end;

function TdomDocumentType.GetCode: WideString;
var
  IntSubs: WideString;
begin
  Result:= concat(WideString('<!DOCTYPE '),NodeName,WideString(' '));
  if (PublicId <> '') or (SystemId <> '')
    then Result:= concat(Result,XMLAnalysePubSysId(PublicId,SystemId,''));
  IntSubs:= InternalSubset;  // To increase performance buffer store the internal subset.
  if length(IntSubs) > 0
    then Result:= concat(Result,WideString('['),IntSubs,
                         WideString(WideChar(10)),WideString(']'));
  Result:= concat(result,WideString('>'));
end;

function TdomDocumentType.GetEntities: TdomEntitiesNamedNodeMap;
begin
  Result:= FEntitiesList;
end;

function TdomDocumentType.GetExternalSubsetNode: TdomExternalSubset;
var
  Child: TdomNode;
begin
  Result:= nil;
  Child:= GetFirstChild;
  while assigned(Child) do begin
    if Child.NodeType = ntExternal_Subset_Node then begin
      Result:= (Child as TdomExternalSubset);
      break;
    end;
    Child:= Child.NextSibling;
  end;
end;

function TdomDocumentType.GetInternalSubsetNode: TdomInternalSubset;
var
  Child: TdomNode;
begin
  Result:= nil;
  Child:= GetFirstChild;
  while assigned(Child) do begin
    if Child.NodeType = ntInternal_Subset_Node then begin
      Result:= (Child as TdomInternalSubset);
      break;
    end;
    Child:= Child.NextSibling;
  end;
end;

function TdomDocumentType.GetInternalSubset: WideString;
var
  i: integer;
  S: WideString;
begin
  Result:= '';
  for i:= 0 to InternalSubsetNode.childnodes.length-1 do begin
    S:= InternalSubsetNode.ChildNodes.Item(i).code;
    if S <> '' then Result:= concat(Result,WideString(WideChar(10)),S);
  end;
end;

function TdomDocumentType.GetName: WideString;
begin
  Result:= NodeName;
end;

function TdomDocumentType.GetNotations: TdomNamedNodeMap;
begin
  Result:= FNotationsList;
end;

function TdomDocumentType.GetPublicId: WideString;
begin
  Result:= FPublicId;
end;

function TdomDocumentType.GetSystemId: WideString;
begin
  Result:= FSystemId;
end;



//+++++++++++++++++++++++ TdomExternalSubset ++++++++++++++++++++++++++
constructor TdomExternalSubset.Create(const AOwner: TdomDocument);
begin
  inherited create(AOwner);
  FNodeName:= '#external-subset';
  FNodeType:= ntExternal_Subset_Node;
  FAllowedChildTypes:= [ntParameter_Entity_Reference_Node,
                        ntElement_Type_Declaration_Node,
                        ntAttribute_List_Node,
                        ntEntity_Declaration_Node,
                        ntText_Declaration_Node,
                        ntParameter_Entity_Declaration_Node,
                        ntNotation_Declaration_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node,
                        ntConditional_Section_Node];
end;

function TdomExternalSubset.CloneNode(const deep: boolean): TdomNode;
begin
  result:= inherited cloneNode(deep);
  makeChildrenReadonly;
end;



//+++++++++++++++++++++++ TdomInternalSubset ++++++++++++++++++++++++++
constructor TdomInternalSubset.Create(const AOwner: TdomDocument);
begin
  inherited create(AOwner);
  FNodeName:= '#internal-subset';
  FNodeType:= ntInternal_Subset_Node;
  FAllowedChildTypes:= [ntParameter_Entity_Reference_Node,
                        ntElement_Type_Declaration_Node,
                        ntAttribute_List_Node,
                        ntEntity_Declaration_Node,
                        ntParameter_Entity_Declaration_Node,
                        ntNotation_Declaration_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node];
end;



//+++++++++++++++++++++ TdomConditionalSection ++++++++++++++++++++++++
constructor TdomConditionalSection.Create(const AOwner: TdomDocument;
                                          const IncludeStmt: WideString);
var
  IncludeNode: TdomNode;
begin
  if not ( IsXmlPEReference(IncludeStmt)
           or (IncludeStmt = 'INCLUDE')
           or (IncludeStmt = 'IGNORE') ) then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited create(AOwner);
  FNodeName:= '#conditional-section';
  FNodeType:= ntConditional_Section_Node;
  if (IncludeStmt = 'INCLUDE') or (IncludeStmt = 'IGNORE')
    then IncludeNode:= OwnerDocument.CreateText(IncludeStmt)
    else IncludeNode:= OwnerDocument.CreateParameterEntityReference(copy(IncludeStmt,2,length(IncludeStmt)-2));
  SetIncluded(IncludeNode);
  FAllowedChildTypes:= [ntParameter_Entity_Reference_Node,
                        ntElement_Type_Declaration_Node,
                        ntAttribute_List_Node,
                        ntEntity_Declaration_Node,
                        ntParameter_Entity_Declaration_Node,
                        ntNotation_Declaration_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node,
                        ntConditional_Section_Node];
end;

function  TdomConditionalSection.GetIncluded: TdomNode;
begin
  Result:= FIncluded;
end;

function TdomConditionalSection.GetCode: WideString;
var
  i: integer;
  S: WideString;
begin
  Result:= concat(WideString('<![ '),Included.Code,WideString(' ['),WideString(WideChar(10)));
  for i:= 0 to childnodes.length-1 do begin
    S:= ChildNodes.Item(i).code;
    if S <> '' then Result:= concat(Result,S,WideString(WideChar(10)));
  end;
  Result:= concat(Result,WideString(']]>'));
end;

function TdomConditionalSection.SetIncluded(const Node: TdomNode): TdomNode;
var
  Error: boolean;
begin
  case Node.NodeType of
    ntText_Node:
      if (Node.NodeValue = 'INCLUDE') or (Node.NodeValue = 'IGNORE')
        then error:= false
        else error:= true;
    ntParameter_Entity_Reference_Node:
      error:= false;
  else
    error:= true;
  end; {case ...}
  if Error then raise EInvalid_Character_Err.create('Invalid character error.');
  Result:= FIncluded;
  FIncluded:= Node;
end;



//++++++++++++++++++++++++++ TdomNotation ++++++++++++++++++++++++++++++
constructor TdomNotation.Create(const AOwner: TdomDocument;
                                const Name,
                                      PubId,
                                      SysId: WideString);
var
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  if not IsXmlName(Name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if ( not ( IsXMLSystemLiteral(concat(dQuote,SystemId,dQuote)) or
    IsXMLSystemLiteral(concat(sQuote,SysId,sQuote)) ) )
    and ( not ( IsXMLPubidLiteral(concat(dQuote,PublicId,dQuote)) or
    IsXMLPubidLiteral(concat(sQuote,PubId,sQuote)) ) )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner);
  FNodeName:= Name;
  FNodeValue:= '';
  FPublicId:= PubId;
  FSystemId:= SysId;
  FNodeType:= ntNotation_Node;
  FAllowedChildTypes:= [];
end;

procedure TdomNotation.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;

function TdomNotation.GetCode: WideString;
begin
  Result:= '';
end;

function TdomNotation.GetPublicId: WideString;
begin
  Result:= FPublicId;
end;

function TdomNotation.GetSystemId: WideString;
begin
  Result:= FSystemId;
end;




//++++++++++++++++++++ TdomNotationDeclaration +++++++++++++++++++++++++
constructor TdomNotationDeclaration.Create(const AOwner: TdomDocument;
                                           const Name,
                                                 PubId,
                                                 SysId: WideString);
var
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  if not IsXmlName(Name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if ( not ( IsXMLSystemLiteral(concat(dQuote,SystemId,dQuote)) or
    IsXMLSystemLiteral(concat(sQuote,SysId,sQuote)) ) )
    and ( not ( IsXMLPubidLiteral(concat(dQuote,PublicId,dQuote)) or
    IsXMLPubidLiteral(concat(sQuote,PubId,sQuote)) ) )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner);
  FNodeName:= Name;
  FNodeValue:= '';
  FPublicId:= PubId;
  FSystemId:= SysId;
  FNodeType:= ntNotation_Declaration_Node;
  FAllowedChildTypes:= [];
end;

procedure TdomNotationDeclaration.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;

function TdomNotationDeclaration.GetCode: WideString;
begin
  Result:= concat(WideString('<!NOTATION '),NodeName,WideString(' '),XMLAnalysePubSysId(PublicId,SystemId,''),WideString('>'));
end;

function TdomNotationDeclaration.GetPublicId: WideString;
begin
  Result:= FPublicId;
end;

function TdomNotationDeclaration.GetSystemId: WideString;
begin
  Result:= FSystemId;
end;



//++++++++++++++++++++++ TdomCustomDeclaration +++++++++++++++++++++++++
constructor TdomCustomDeclaration.Create(const AOwner: TdomDocument;
                                         const Name: WideString);
begin
  if not IsXmlName(Name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner);
  FNodeName:= Name;
  FAllowedChildTypes:= [ntElement_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node,
                        ntText_Node,
                        ntCDATA_Section_Node,
                        ntEntity_Reference_Node,
                        ntParameter_Entity_Reference_Node,
                        ntDocument_Fragment_Node];
end;

function TdomCustomDeclaration.GetValue: WideString;
var
  i: integer;
begin
  Result:='';
  for i:= 0 to ChildNodes.Length -1 do
    Result:= concat(Result,ChildNodes.item(i).code);
end;

procedure TdomCustomDeclaration.SetValue(const Value: WideString);
var
  ValueNode: TdomNode;
begin
  clear;
  if Value <> '' then begin
    ValueNode:= OwnerDocument.CreateText(Value);
    AppendChild(ValueNode);
  end;
end;

procedure TdomCustomDeclaration.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;



//++++++++++++++++++ TdomElementTypeDeclaration ++++++++++++++++++++++++
constructor TdomElementTypeDeclaration.Create(const AOwner: TdomDocument;
                                              const Name: WideString;
                                              const Contspec: TdomContentspecType);
begin
  inherited create(AOwner,Name);
  FNodeType:= ntElement_Type_Declaration_Node;
  FContentspec:= Contspec;
  case Contspec of
    ctEmpty,ctAny: FAllowedChildTypes:= [];
    ctMixed:       FAllowedChildTypes:= [ntPcdata_Choice_Particle_Node];
    ctChildren:    FAllowedChildTypes:= [ntSequence_Particle_Node,
                                         ntChoice_Particle_Node,
                                         ntElement_Particle_Node];
  end;
end;

function TdomElementTypeDeclaration.GetContentspec: TdomContentspecType;
begin
  Result:= FContentspec;
end;

function TdomElementTypeDeclaration.GetCode: WideString;
begin
  if (contentspec <> ctEmpty) and (contentspec <> ctAny) and not hasChildNodes
    then raise ENot_Supported_Err.create('Not supported error.');
  Result:= concat(WideString('<!ELEMENT '),NodeName,WideString(' '));
  case ContentSpec of
    ctEmpty: Result:= concat(Result,WideString('EMPTY '));
    ctAny:   Result:= concat(Result,WideString('ANY '));
    ctMixed, ctChildren: Result:= concat(Result,ChildNodes.Item(0).Code);
  end; {case ...}
  Result:= concat(Result,WideString('>'));
end;

function TdomElementTypeDeclaration.AppendChild(const newChild: TdomNode): TdomNode;
begin
  if (contentspec = ctEmpty) or (contentspec = ctAny)
    or (hasChildNodes and (FirstChild <> newChild))
      then raise ENot_Supported_Err.create('Not supported error.');
  result:= inherited AppendChild(newChild);
end;

function TdomElementTypeDeclaration.InsertBefore(const newChild,
                                                       refChild: TdomNode): TdomNode;
begin
  if (contentspec = ctEmpty) or (contentspec = ctAny)
    or (hasChildNodes and (FirstChild <> newChild))
      then raise ENot_Supported_Err.create('Not supported error.');
  result:= inherited InsertBefore(newChild,refChild);
end;



//++++++++++++++++++++++ TdomAttrList +++++++++++++++++++++++++++++
constructor TdomAttrList.Create(const AOwner: TdomDocument;
                                const Name: WideString);
begin
  inherited Create(AOwner,Name);
  FNodeType:= ntAttribute_List_Node;
  FAttDefListing:= TList.create;
  FAttDefList:= TdomNamedNodeMap.create(AOwner,self,FAttDefListing,[ntAttribute_Definition_Node]);
  FAllowedChildTypes:= [];
end;

destructor TdomAttrList.Destroy;
begin
  FAttDefList.free;
  FAttDefListing.free;
  inherited Destroy;
end;

function TdomAttrList.GetAttributeDefinitions: TdomNamedNodeMap;
begin
  Result:= FAttDefList;
end;

function TdomAttrList.GetCode: WideString;
var
  i: integer;
begin
  Result:= concat(WideString('<!ATTLIST '),NodeName);
  if AttributeDefinitions.length > 0 then Result:= concat(Result,WideString(WideChar(10)));
  for i:= 0 to AttributeDefinitions.length -1 do begin
    Result:= concat(Result,WideString(WideChar(9)),AttributeDefinitions.item(i).Code);
    if i < AttributeDefinitions.length -1 then Result:= concat(Result,WideString(WideChar(10)));
  end;
  Result:= concat(Result,WideString('>'));
end;

function TdomAttrList.RemoveAttributeDefinition(const Name: WideString): TdomAttrDefinition;
begin
  if not assigned(GetAttributeDefinitionNode(Name))
    then ENot_Found_Err.create('Node not found error.');
  Result:= RemoveAttributeDefinitionNode(GetAttributeDefinitionNode(Name));
end;

function TdomAttrList.GetAttributeDefinitionNode(const Name: WideString): TdomAttrDefinition;
begin
  Result:= TdomAttrDefinition(AttributeDefinitions.GetNamedItem(Name));
end;

function TdomAttrList.SetAttributeDefinitionNode(const NewAttDef: TdomAttrDefinition): boolean;
begin
  if OwnerDocument <> NewAttDef.OwnerDocument
    then raise EWrong_Document_Err.create('Wrong document error.');
  if assigned(NewAttDef.parentNode) and not (NewAttDef.ParentAttributeList = self)
    then raise EInuse_AttributeDefinition_Err.create('Inuse attribute definition error.');
  Result:= true;
  if not (NewAttDef.ParentAttributeList = self) then
    if assigned((AttributeDefinitions.GetNamedItem(NewAttDef.NodeName) as TdomAttrDefinition))
      then Result:= false
    else begin
      AttributeDefinitions.SetNamedItem(NewAttDef);
      NewAttDef.FParentAttributeList:= self;
    end;
end;

function TdomAttrList.RemoveAttributeDefinitionNode(const OldAttDef: TdomAttrDefinition): TdomAttrDefinition;
begin
  if AttributeDefinitions.indexof(OldAttDef) = -1
    then raise ENot_Found_Err.create('Node not found error.');
  AttributeDefinitions.RemoveItem(OldAttDef);
  OldAttDef.FParentAttributeList:= nil;
  Result:= OldAttDef;
end;



//++++++++++++++++++++ TdomAttrDefinition +++++++++++++++++++++++++
constructor TdomAttrDefinition.Create(const AOwner: TdomDocument;
                                      const Name,
                                            AttType,
                                            DefaultDecl,
                                            AttValue: WideString);
var
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  if not IsXmlName(Name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not ( (AttType='') or (AttType='NOTATION') or
    IsXmlStringType(AttType) or IsXmlTokenizedType(AttType) )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not ( (DefaultDecl = '#REQUIRED') or (DefaultDecl = '#IMPLIED') or
           (DefaultDecl = '#FIXED') or (DefaultDecl = '') )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if ((DefaultDecl = '#REQUIRED') or (DefaultDecl = '#IMPLIED'))
    and (AttValue <> '')
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if ((DefaultDecl = '#FIXED') or (DefaultDecl = ''))
    and (AttValue = '')
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not ( IsXMLAttValue(concat(dQuote,AttValue,dQuote)) or
    IsXMLAttValue(concat(sQuote,AttValue,sQuote)) )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited create(AOwner);
  FNodeName:= Name;
  FAttributeType:= AttType;
  FDefaultDeclaration:= DefaultDecl;
  FNodeValue:= AttValue;
  FNodeType:= ntAttribute_Definition_Node;
  FParentAttributeList:= nil;
  FAllowedChildTypes:= [];
  if AttType = '' then FAllowedChildTypes:= [ntNametoken_Node];
  if AttType = 'NOTATION' then FAllowedChildTypes:= [ntElement_Particle_Node];
end;

function TdomAttrDefinition.GetAttributeType: WideString;
begin
  Result:= FAttributeType;
end;

function TdomAttrDefinition.GetDefaultDeclaration: WideString;
begin
  Result:= FDefaultDeclaration;
end;

function TdomAttrDefinition.GetName: WideString;
begin
  Result:= NodeName;
end;

function TdomAttrDefinition.GetParentAttributeList: TdomAttrList;
begin
  Result:= FParentAttributeList;
end;

procedure TdomAttrDefinition.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;

function TdomAttrDefinition.GetCode: WideString;
var
  i: integer;
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  Result:= concat(Name,WideString(WideChar(9)));
  if AttributeType <> '' then Result:= concat(Result,AttributeType,WideString(WideChar(9)));
  if HasChildNodes then begin
    Result:= concat(Result,WideString('('));
    for i:= 0 to ChildNodes.Length -1 do begin
      if i > 0 then Result:= concat(Result,WideString(' | '));
      Result:= concat(Result,ChildNodes.item(i).code);
    end;
    Result:= concat(Result,WideString(')'));
  end;
  if DefaultDeclaration <> ''
    then Result:= concat(Result,WideString(WideChar(9)),DefaultDeclaration);
  if (DefaultDeclaration = '') or (DefaultDeclaration = '#FIXED') then
    if Pos(dQuote,NodeValue) > 0
      then Result:= concat(Result,WideString(WideChar(9)),sQuote,NodeValue,sQuote)
      else Result:= concat(Result,WideString(WideChar(9)),dQuote,NodeValue,dQuote);
end;



//++++++++++++++++++++++++ TdomNametoken +++++++++++++++++++++++++++++++
constructor TdomNametoken.Create(const AOwner: TdomDocument;
                                 const Name: WideString);
begin
  if not IsXmlNmtoken(Name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited create(AOwner);
  FNodeName:= Name;
  FNodeType:= ntNametoken_Node;
  FAllowedChildTypes:= [];
end;

function TdomNametoken.GetCode: WideString;
begin
  Result:= NodeName;
end;

procedure TdomNametoken.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;



//+++++++++++++++++++++++++ TdomParticle +++++++++++++++++++++++++++++++
constructor TdomParticle.Create(const AOwner: TdomDocument;
                                const Freq: WideString);
begin
  if not ( (Freq = '') or (Freq = '?') or (Freq = '*') or (Freq = '+') )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited create(AOwner);
  FNodeType:= ntUnknown;
  FAllowedChildTypes:= [];
  FFrequency:= Freq;
end;

function TdomParticle.GetFrequency: WideString;
begin
  Result:= FFrequency;
end;

procedure TdomParticle.SetFrequency(const freq: WideString);
begin
  if not ( (Freq = '') or (Freq = '?') or (Freq = '*') or (Freq = '+') )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  FFrequency:= Freq;
end;

procedure TdomParticle.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;



//++++++++++++++++++++++ TdomSequenceParticle ++++++++++++++++++++++++++
constructor TdomSequenceParticle.Create(const AOwner: TdomDocument;
                                        const Freq: WideString);
begin
  inherited create(AOwner,Freq);
  FNodeName:= '#sequence-particle';
  FNodeType:= ntSequence_Particle_Node;
  FAllowedChildTypes:= [ntSequence_Particle_Node,
                        ntChoice_Particle_Node,
                        ntElement_Particle_Node];
end;

function TdomSequenceParticle.GetCode: WideString;
var
  i: integer;
begin
  if not HasChildNodes
    then raise ENot_Supported_Err.create('Not supported error.');
  Result:= '(';
  for i:= 0 to childnodes.length-1 do begin
    if i > 0 then Result:= concat(Result,WideString(', '));
    Result:= concat(Result,ChildNodes.item(i).code);
  end;
  Result:= concat(Result,WideString(')'),Frequency);
end;



//++++++++++++++++++++++ TdomChoiceParticle ++++++++++++++++++++++++++++
constructor TdomChoiceParticle.create(const AOwner: TdomDocument;
                                      const Freq: WideString);
begin
  inherited create(AOwner,Freq);
  FNodeName:= '#choice-particle';
  FNodeType:= ntChoice_Particle_Node;
  FAllowedChildTypes:= [ntSequence_Particle_Node,
                        ntChoice_Particle_Node,
                        ntElement_Particle_Node];
end;

function TdomChoiceParticle.getCode: WideString;
var
  i: integer;
begin
  if not HasChildNodes
    then raise ENot_Supported_Err.create('Not supported error.');
  Result:= '(';
  for i:= 0 to childnodes.length-1 do begin
    if i > 0 then Result:= concat(Result,WideString(' | '));
    Result:= concat(Result,ChildNodes.item(i).code);
  end;
  Result:= concat(Result,WideString(')'),Frequency);
end;



//+++++++++++++++++++ TdomPcdataChoiceParticle +++++++++++++++++++++++++
constructor TdomPcdataChoiceParticle.create(const AOwner: TdomDocument;
                                            const Freq: WideString);
begin
  if Freq <> '*'
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited create(AOwner,Freq);
  FNodeName:= '#pcdata-choice-particle';
  FNodeType:= ntPcdata_Choice_Particle_Node;
  FAllowedChildTypes:= [ntElement_Particle_Node];
end;

function TdomPcdataChoiceParticle.getCode: WideString;
var
  i: integer;
begin
  Result:= '( #PCDATA';
  for i:= 0 to childnodes.length-1 do begin
    Result:= concat(Result,WideString(' | '),ChildNodes.item(i).code);
  end;
  Result:= concat(Result,WideString(' )'),Frequency);
end;

procedure TdomPcdataChoiceParticle.SetFrequency(const freq: WideString);
begin
  if Freq <> '*'
    then raise EInvalid_Character_Err.create('Invalid character error.');
  FFrequency:= Freq;
end;



//++++++++++++++++++++++ TdomElementParticle +++++++++++++++++++++++++++
constructor TdomElementParticle.Create(const AOwner: TdomDocument;
                                       const Name,
                                             Freq: WideString);
begin
  if not IsXmlName(Name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited create(AOwner,Freq);
  FNodeName:= Name;
  FNodeType:= ntElement_Particle_Node;
  FAllowedChildTypes:= [];
end;

function TdomElementParticle.GetCode: WideString;
begin
  Result:= concat(NodeName,Frequency);
end;



//++++++++++++++++++++++++ TdomCustomEntity ++++++++++++++++++++++++++++
constructor TdomCustomEntity.Create(const AOwner: TdomDocument;
                                    const Name,
                                          PubId,
                                          SysId: WideString);
var
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  if not ( IsXMLSystemLiteral(concat(dQuote,SysId,dQuote)) or
           IsXMLSystemLiteral(concat(sQuote,SysId,sQuote))    )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not ( IsXMLPubidLiteral(concat(dQuote,PubId,dQuote)) or
           IsXMLPubidLiteral(concat(sQuote,PubId,sQuote))     )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner,Name);
  FPublicId:= PubId;
  FSystemId:= SysId;
  if (PubId = '') and (SysId = '')
    then FIsInternalEntity:= true
    else FIsInternalEntity:= false;
end;

procedure TdomCustomEntity.SetValue(const Value: WideString);
begin
  if (PublicId <> '') or (SystemId <> '')
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  inherited SetValue(Value);
end;

function TdomCustomEntity.InsertBefore(const newChild,
                                             refChild: TdomNode): TdomNode;
begin
  if (PublicId <> '') or (SystemId <> '')
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  Result:= inherited InsertBefore(newChild,refChild);
end;

function TdomCustomEntity.ReplaceChild(const newChild,
                                             oldChild: TdomNode): TdomNode;
begin
  if (PublicId <> '') or (SystemId <> '')
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  Result:= inherited ReplaceChild(newChild,oldChild);
end;

function TdomCustomEntity.AppendChild(const newChild: TdomNode): TdomNode;
begin
  if (PublicId <> '') or (SystemId <> '')
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  Result:= inherited AppendChild(newChild);
end;

function TdomCustomEntity.GetPublicId: WideString;
begin
  Result:= FPublicId;
end;

function TdomCustomEntity.GetSystemId: WideString;
begin
  Result:= FSystemId;
end;

function TdomCustomEntity.GetIsInternalEntity: boolean;
begin
  Result:= FIsInternalEntity;
end;



//+++++++++++++++++++++ TdomExternalParsedEntity +++++++++++++++++++++++
constructor TdomExternalParsedEntity.Create(const AOwner: TdomDocument);
begin
  inherited Create(AOwner);
  FNodeName:= '#external-parsed-entity';
  FNodeType:= ntExternal_Parsed_Entity_Node;
  FAllowedChildTypes:= [ntElement_Node,
                        ntText_Node,
                        ntCDATA_Section_Node,
                        ntEntity_Reference_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node,
                        ntDocument_Fragment_Node];
end;



//+++++++++++++++++++ TdomExternalParameterEntity ++++++++++++++++++++++
constructor TdomExternalParameterEntity.Create(const AOwner: TdomDocument);
begin
  inherited Create(AOwner);
  FNodeName:= '#external-parameter-entity';
  FNodeType:= ntExternal_Parameter_Entity_Node;
  FAllowedChildTypes:= [ntParameter_Entity_Reference_Node,
                        ntElement_Type_Declaration_Node,
                        ntAttribute_List_Node,
                        ntEntity_Declaration_Node,
                        ntParameter_Entity_Declaration_Node,
                        ntNotation_Declaration_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node,
                        ntConditional_Section_Node];
end;



//+++++++++++++++++++++++++++ TdomEntity +++++++++++++++++++++++++++++++++
constructor TdomEntity.Create(const AOwner: TdomDocument;
                              const Name,
                                    PubId,
                                    SysId,
                                    NotaName: WideString);
begin
  inherited Create(AOwner,Name,PubId,SysId);
  FNotationName:= notaName;
  FNodeType:= ntEntity_Node;
end;

function TdomEntity.CloneNode(const deep: boolean): TdomNode;
begin
  result:= inherited cloneNode(deep);
  makeChildrenReadonly;
end;

function TdomEntity.GetNotationName: WideString;
begin
  Result:= FNotationName;
end;



//++++++++++++++++++++++ TdomParameterEntity +++++++++++++++++++++++++++
constructor TdomParameterEntity.Create(const AOwner: TdomDocument;
                                       const Name,
                                             PubId,
                                             SysId: WideString);
begin
  inherited Create(AOwner,Name,PubId,SysId);
  FNodeType:= ntParameter_Entity_Node;
end;



//++++++++++++++++++++++ TdomEntityDeclaration +++++++++++++++++++++++++
constructor TdomEntityDeclaration.Create(const AOwner: TdomDocument;
                              const Name,
                                    EntityValue,
                                    PubId,
                                    SysId,
                                    NotaName: WideString);
var
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  if not (IsXMLName(NotaName) or (NotaName = '') )
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if (EntityValue <> '') then begin
    if not ( IsXmlEntityValue(concat(dQuote,SystemId,dQuote)) or
             IsXmlEntityValue(concat(sQuote,SysId,sQuote)) )
      then raise EInvalid_Character_Err.create('Invalid character error.');
    if not ( (PubId = '') and (SysId = '') and (NotaName = '') )
      then raise EInvalid_Character_Err.create('Invalid character error.');
  end;
  inherited Create(AOwner,Name,PubId,SysId);
  FNotationName:= notaName;
  FNodeType:= ntEntity_Declaration_Node;
  FNodeValue:= EntityValue;
  FExtParsedEnt:= nil;
  FAllowedChildTypes:= [];
end;

function TdomEntityDeclaration.GetExtParsedEnt: TdomExternalParsedEntity;
begin
  Result:= FExtParsedEnt;
end;

procedure TdomEntityDeclaration.SetExtParsedEnt(const Value: TdomExternalParsedEntity);
begin
  if IsInternalEntity and assigned(Value)
    then raise ENo_External_Entity_Allowed_Err.create('No external entity allowed error.');
  FExtParsedEnt:= Value;
end;

function TdomEntityDeclaration.GetNotationName: WideString;
begin
  Result:= FNotationName;
end;

function TdomEntityDeclaration.GetCode: WideString;
var
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  Result:= concat(WideString('<!ENTITY '),NodeName,WideString(' '));
  if (PublicId = '') and (SystemId = '') then begin
    if Pos(dQuote,NodeValue) > 0
      then Result:= concat(Result,WideString(WideChar(9)),sQuote,NodeValue,sQuote)
      else Result:= concat(Result,WideString(WideChar(9)),dQuote,NodeValue,dQuote);
  end else Result:= concat(Result,XMLAnalysePubSysId(PublicId,SystemId,NotationName));
  Result:= concat(Result,WideString('>'));
end;


//+++++++++++++++++ TdomParameterEntityDeclaration +++++++++++++++++++++
constructor TdomParameterEntityDeclaration.Create(const AOwner: TdomDocument;
                                                  const Name,
                                                        EntityValue,
                                                        PubId,
                                                        SysId: WideString);
var
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  if (EntityValue <> '') then begin
    if not ( IsXmlEntityValue(concat(dQuote,SystemId,dQuote)) or
             IsXmlEntityValue(concat(sQuote,SysId,sQuote)) )
      then raise EInvalid_Character_Err.create('Invalid character error.');
    if not ( (PubId = '') and (SysId = '') )
      then raise EInvalid_Character_Err.create('Invalid character error.');
  end;
  inherited Create(AOwner,Name,PubId,SysId);
  FNodeType:= ntParameter_Entity_Declaration_Node;
  FNodeValue:= EntityValue;
  FExtParamEnt:= nil;
  FAllowedChildTypes:= [];
end;

function TdomParameterEntityDeclaration.GetCode: WideString;
var
  sQuote, dQuote: WideString;
begin
  sQuote:= #$0027;
  dQuote:= '"';
  Result:= concat(WideString('<!ENTITY % '),NodeName,WideString(' '));
  if (PublicId = '') and (SystemId = '') then begin
    if Pos(dQuote,NodeValue) > 0
      then Result:= concat(Result,WideString(WideChar(9)),sQuote,NodeValue,sQuote)
      else Result:= concat(Result,WideString(WideChar(9)),dQuote,NodeValue,dQuote);
  end else Result:= concat(Result,XMLAnalysePubSysId(PublicId,SystemId,''));
  Result:= concat(Result,WideString('>'));
end;

function TdomParameterEntityDeclaration.GetExtParamEnt: TdomExternalParameterEntity;
begin
  Result:= FExtParamEnt;
end;

procedure TdomParameterEntityDeclaration.SetExtParamEnt(const Value: TdomExternalParameterEntity);
begin
  if IsInternalEntity and assigned(Value)
    then raise ENo_External_Entity_Allowed_Err.create('No external entity allowed error.');
  FExtParamEnt:= Value;
end;



//++++++++++++++++++++++++++ TdomReference ++++++++++++++++++++++++++++
constructor TdomReference.Create(const AOwner: TdomDocument;
                                 const Name: WideString);
begin
  if not IsXmlName(Name)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner);
  FNodeName:= Name;
  FNodeValue:= '';
  FNodeType:= ntUnknown;
  FAllowedChildTypes:= [];
end;

procedure TdomReference.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;

function TdomReference.GetNodeValue: WideString;
begin
  if assigned(Declaration)
    then Result:= Declaration.value
    else Result:='';
end;

function TdomReference.GetDeclaration: TdomCustomEntity;
begin
  Result:= nil;
  if assigned(OwnerDocument.Doctype) then begin
    if self.NodeType = ntEntity_Reference_Node
      then Result:= (OwnerDocument.Doctype.Entities.GetNamedItem(NodeName) as TdomEntity);
    if self.NodeType = ntParameter_Entity_Reference_Node
      then Result:= (OwnerDocument.Doctype.ParameterEntities.GetNamedItem(NodeName) as TdomParameterEntity);
  end;
end;



//++++++++++++++++++++++++ TdomEntityReference +++++++++++++++++++++++++
constructor TdomEntityReference.Create(const AOwner: TdomDocument;
                                       const Name: WideString);
begin
  inherited Create(AOwner,Name);
  FNodeType:= ntEntity_Reference_Node;
  FAllowedChildTypes:= [ntElement_Node,
                        ntText_Node,
                        ntCDATA_Section_Node,
                        ntEntity_Reference_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node,
                        ntDocument_Fragment_Node];
end;

function TdomEntityReference.GetCode: WideString;
begin
  Result:= concat(WideString('&'),NodeName,WideString(';'))
end;

function TdomEntityReference.CloneNode(const deep: boolean): TdomNode;
begin
  result:= inherited cloneNode(deep);
  makeChildrenReadonly;
end;



//+++++++++++++++++++ TdomParameterEntityReference +++++++++++++++++++++
constructor TdomParameterEntityReference.Create(const AOwner: TdomDocument;
                                                const Name: WideString);
begin
  inherited Create(AOwner,Name);
  FNodeType:= ntParameter_Entity_Reference_Node;
  FAllowedChildTypes:= [ntParameter_Entity_Reference_Node,
                        ntElement_Type_Declaration_Node,
                        ntAttribute_List_Node,
                        ntEntity_Declaration_Node,
                        ntParameter_Entity_Declaration_Node,
                        ntNotation_Declaration_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node];
end;

function TdomParameterEntityReference.GetCode: WideString;
begin
  Result:= concat(WideString('%'),NodeName,WideString(';'))
end;



//+++++++++++++++++++++++ TdomTextDeclaration ++++++++++++++++++++++++++
constructor TdomTextDeclaration.Create(const AOwner: TdomDocument;
                                       const Version,
                                             EncDl: WideString);
begin
  if not IsXmlEncName(EncDl)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not (IsXmlVersionNum(Version) or (Version = ''))
    then raise EInvalid_Character_Err.create('Invalid character error.');
  inherited Create(AOwner);
  FVersionNumber:= Version;
  FEncodingDecl:= EncDl;
  FNodeName:= '#text-declaration';
  FNodeValue:= '';
  FNodeType:= ntText_Declaration_Node;
  FAllowedChildTypes:= [];
end;

function TdomTextDeclaration.GetVersionNumber: WideString;
begin
  Result:= FVersionNumber;
end;

function TdomTextDeclaration.GetEncodingDecl: WideString;
begin
  Result:= FEncodingDecl;
end;

procedure TdomTextDeclaration.SetEncodingDecl(const Value: WideSTring);
begin
  if not (IsXmlEncName(Value) or (Value = ''))
    then raise EInvalid_Character_Err.create('Invalid character error.');
  FEncodingDecl:= Value;
end;

function TdomTextDeclaration.GetCode: WideString;
begin
  Result:= '<?xml';
  if VersionNumber <> ''
    then  Result:= concat(Result,WideString(' version="'),VersionNumber,WideString('"'));
  Result:= concat(Result,WideString(' encoding="'),EncodingDecl,WideString('"'));
  Result:= concat(Result,WideString('?>'));
end;



//++++++++++++++++++++++++ TdomDocumentFragment +++++++++++++++++++++++++++
constructor TdomDocumentFragment.Create(const AOwner: TdomDocument);
begin
  inherited Create(AOwner);
  FNodeName:= '#document-fragment';
  FNodeValue:= '';
  FNodeType:= ntDocument_Fragment_Node;
end;

procedure TdomDocumentFragment.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;



//++++++++++++++++++++++++++++ TdomDocument +++++++++++++++++++++++++++++++
constructor TdomDocument.Create;
begin
  inherited Create(self);
  FNodeName:= '#document';
  FNodeValue:= '';
  FNodeType:= ntDocument_Node;
  FFilename:= '';
  FCreatedNodes:= TList.create;
  FCreatedNodeIterators:= TList.create;
  FCreatedTreeWalkers:= TList.create;
  FCreatedElementsNodeLists:= TList.create;
  FCreatedElementsNodeListNSs:= TList.create;
  FAllowedChildTypes:= [ntElement_Node,
                        ntProcessing_Instruction_Node,
                        ntComment_Node,
                        ntDocument_Type_Node,
                        ntDocument_Fragment_Node,
                        ntXml_Declaration_Node];
end;

destructor TdomDocument.Destroy;
begin
  clear;
  FCreatedNodes.Free;
  FCreatedNodeIterators.Free;
  FCreatedTreeWalkers.Free;
  FCreatedElementsNodeLists.free;
  FCreatedElementsNodeListNSs.free;
  inherited destroy;
end;

function TdomDocument.ExpandEntRef(const Node: TdomEntityReference): boolean;
var
  oldChild,newChildNode: TdomNode;
  newText: TdomText;
  RefEntity: TdomEntity;
  i: integer;
  previousStatus: boolean;
begin
  result:= false;
  if Node.OwnerDocument <> Self
    then raise EWrong_Document_Err.create('Wrong document error.');
  if not (Node.NodeType in [ntEntity_Node,ntEntity_Reference_Node])
    then raise ENot_Supported_Err.create('Not supported error.');
  with Node do begin
    while HasChildNodes do begin
      FirstChild.FIsReadonly:= false;
      oldChild:= RemoveChild(FirstChild);
      FreeAllNodes(oldChild);
      result:= true;
    end;
    if nodeName = 'lt' then begin
      newText:= OwnerDocument.CreateText(#60);
      AppendChild(newText);
      result:= true;
    end else
    if nodeName = 'gt' then begin
      newText:= OwnerDocument.CreateText(#62);
      AppendChild(newText);
      result:= true;
    end else
    if nodeName = 'amp' then begin
      newText:= OwnerDocument.CreateText(#38);
      AppendChild(newText);
      result:= true;
    end else
    if nodeName = 'apos' then begin
      newText:= OwnerDocument.CreateText(#39);
      AppendChild(newText);
      result:= true;
    end else
    if nodeName = 'quot' then begin
      newText:= OwnerDocument.CreateText(#34);
      AppendChild(newText);
      result:= true;
    end else
    if assigned(Doctype) then begin
      RefEntity:= TdomEntity(Doctype.entities.GetNamedItem(nodeName));
      if assigned(RefEntity) then begin
        if RefEntity.NotationName <> ''
          then raise EIllegal_Entity_Reference_Err.Create('Illegal entity reference error.');
        previousStatus:= Node.FIsReadonly;
        Node.FIsReadonly:= false;
        try
          for i:= 0 to RefEntity.ChildNodes.Length-1 do begin
            newChildNode:= RefEntity.ChildNodes.Item(i).CloneNode(true);
            Node.AppendChild(newChildNode);
          end; {for ...}
        finally
          Node.FIsReadonly:= previousStatus;
        end;
        result:= true;
      end; {if ...}
    end; {if ...}
    node.makeChildrenReadonly;
  end; {with ...}
end;

procedure TdomDocument.SetNodeValue(const Value: WideString);
begin
  raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
end;

function TdomDocument.GetCode: WideString;
var
  i: integer;
begin
  Result:= '';
  for i:= 0 to ChildNodes.Length -1 do
    Result:= concat(Result,ChildNodes.item(i).Code,WideString(WideChar(10)));
end;

function TdomDocument.GetCodeAsString: String;
begin
  if assigned(XmlDeclaration)
    then XmlDeclaration.EncodingDecl:='UTF-8';
  Result:=UTF16BEToUTF8Str(Code);
end;

function TdomDocument.GetCodeAsWideString: WideString;
begin
  if assigned(XmlDeclaration)
    then XmlDeclaration.EncodingDecl:= 'UTF-16';
  Result:= concat(wideString(#$feff),Code);
end;

function TdomDocument.GetFilename: TFilename;
begin
  Result:= FFilename;
end;

procedure TdomDocument.SetFilename(const Value: TFilename);
begin
  FFilename:= Value;
end;

procedure TdomDocument.FindNewReferenceNodes(const NodeToRemove: TdomNode);
var
  i: integer;
  refNode, refRoot: TdomNode;
begin
  for i:= 0 to FCreatedNodeIterators.count-1 do begin
    refNode:= TdomNodeIterator(FCreatedNodeIterators[i]).FReferenceNode;
    if  (refNode = NodeToRemove) or refNode.IsAncestor(NodeToRemove) then begin
      refRoot:= TdomNodeIterator(FCreatedNodeIterators[i]).root;
      if NodeToRemove.IsAncestor(refRoot)
        then TdomNodeIterator(FCreatedNodeIterators[i]).FindNewReferenceNode(NodeToRemove);
    end;
  end;
end;

procedure TdomDocument.clear;
var
  i : integer;
begin
  FNodeListing.clear;
  for i := 0 to FCreatedNodes.Count - 1 do
    TdomNode(FCreatedNodes[i]).free;
  FCreatedNodes.Clear;
  for i := 0 to FCreatedNodeIterators.Count - 1 do
    TdomNodeIterator(FCreatedNodeIterators[i]).free;
  FCreatedNodeIterators.Clear;
  for i := 0 to FCreatedTreeWalkers.Count - 1 do
    TdomTreeWalker(FCreatedTreeWalkers[i]).Free;
  FCreatedTreeWalkers.Clear;
  for i := 0 to FCreatedElementsNodeLists.Count - 1 do
    TdomElementsNodeList(FCreatedElementsNodeLists[i]).free;
  FCreatedElementsNodeLists.Clear;
  for i := 0 to FCreatedElementsNodeListNSs.Count - 1 do
    TdomElementsNodeListNS(FCreatedElementsNodeListNSs[i]).free;
  FCreatedElementsNodeListNSs.Clear;
end;

procedure TdomDocument.ClearInvalidNodeIterators;
var
  i: integer;
begin
  for i:= 0 to FCreatedNodeIterators.count-1 do
  if TdomNodeIterator(FCreatedNodeIterators[i]).FInvalid then begin
    TdomNodeIterator(FCreatedNodeIterators[i]).free;
    FCreatedNodeIterators[i]:= nil;
  end;
  FCreatedNodeIterators.pack;
  FCreatedNodeIterators.Capacity:= FCreatedNodeIterators.Count;
end;

function TdomDocument.IsHTML: boolean;
{Returns 'True', if the document is HTML.}
var
  Root: TdomElement;
  NameStr: string;
begin
  Result:= false;
  Root:= GetDocumentElement;
  if assigned(Root) then begin
    NameStr:= WideCharToString(PWideChar(Root.TagName));
    if CompareText(NameStr,'HTML') = 0 then result:= true;
  end;
end;

function TdomDocument.DuplicateNode(Node: TdomNode): TdomNode;
{Creates a new node of the same type and properties than 'Node', except
 that the new node has no parent and no child nodes.}
var
  i: integer;
  newChild: TdomNode;
begin
  Result:= nil;
  case Node.NodeType of
    ntUnknown:
      raise ENot_Supported_Err.create('Not supported error.');
    ntElement_Node:
      begin
        Result:= CreateElement((Node as TdomElement).NodeName);
        Result.FNodeValue:= FNodeValue;
        {duplicate attributes:} {xxx nur specified duplizieren! xxx}
        for i:= 0 to (Node as TdomElement).Attributes.Length-1 do begin
          NewChild:= DuplicateNode((Node as TdomElement).Attributes.Item(i));
          (Result as TdomElement).SetAttributeNode((NewChild as TdomAttr));
        end;
      end;
    ntAttribute_Node:
      begin
        Result:= CreateAttribute((Node as TdomAttr).NodeName);
        Result.FNodeValue:= FNodeValue;
        {duplicate the text of the attribute node:}
        for i:= 0 to Node.ChildNodes.Length-1 do begin
          newChild:= DuplicateNode(Node.ChildNodes.Item(i));
          Result.AppendChild(newChild);
        end;
      end;
    ntText_Node:
      Result:= CreateText((Node as TdomText).Data);
    ntCDATA_Section_Node:
      Result:= CreateCDATASection((Node as TdomCDATASection).Data);
    ntEntity_Reference_Node:
      begin
        Result:= CreateEntityReference((Node as TdomEntityReference).NodeName);
        Result.FNodeValue:= FNodeValue;
      end;
    ntParameter_Entity_Reference_Node:
      begin
        Result:= CreateParameterEntityReference((Node as TdomParameterEntityReference).NodeName);
        Result.FNodeValue:= FNodeValue;
      end;
    ntEntity_Node:
      Result:= CreateEntity((Node as TdomEntity).NodeName,
                            (Node as TdomEntity).PublicId,
                            (Node as TdomEntity).SystemId,
                            (Node as TdomEntity).NotationName);
    ntParameter_Entity_Node:
      Result:= CreateParameterEntity((Node as TdomParameterEntity).NodeName,
                                     (Node as TdomParameterEntity).PublicId,
                                     (Node as TdomParameterEntity).SystemId);
    ntEntity_Declaration_Node:
      Result:= CreateEntityDeclaration((Node as TdomEntityDeclaration).NodeName,
                                       (Node as TdomEntityDeclaration).NodeValue,
                                       (Node as TdomEntityDeclaration).PublicId,
                                       (Node as TdomEntityDeclaration).SystemId,
                                       (Node as TdomEntityDeclaration).NotationName);
    ntParameter_Entity_Declaration_Node:
      Result:= CreateParameterEntityDeclaration((Node as TdomParameterEntityDeclaration).NodeName,
                                                (Node as TdomParameterEntityDeclaration).NodeValue,
                                                (Node as TdomParameterEntityDeclaration).PublicId,
                                                (Node as TdomParameterEntityDeclaration).SystemId);
    ntProcessing_Instruction_Node:
        Result:= CreateProcessingInstruction((Node as TdomProcessingInstruction).Target,
                                             (Node as TdomProcessingInstruction).Data);
    ntXml_Declaration_Node:
      Result:= CreateXmlDeclaration((Node as TdomXmlDeclaration).VersionNumber,
                                    (Node as TdomXmlDeclaration).EncodingDecl,
                                    (Node as TdomXmlDeclaration).SdDecl);
    ntComment_Node:
      Result:= CreateComment((Node as TdomComment).Data);
    ntConditional_Section_Node:
      case (Node as TdomConditionalSection).Included.NodeType of
        ntText_Node:
          Result:= CreateConditionalSection(((Node as TdomConditionalSection).Included as TdomText).NodeValue);
        ntParameter_Entity_Reference_Node:
          Result:= CreateConditionalSection(((Node as TdomConditionalSection).Included as TdomParameterEntityReference).NodeName);
      end;
    ntDocument_Node:
      Result:= TdomDocument.Create;
    ntDocument_Type_Node:
      Result:= CreateDocumentType((Node as TdomDocumentType).NodeName,
                                  (Node as TdomDocumentType).PublicId,
                                  (Node as TdomDocumentType).SystemId);
    ntDocument_Fragment_Node:
      Result:= CreateDocumentFragment;
    ntNotation_Node:
      Result:= CreateNotation((Node as TdomNotation).NodeName,
                              (Node as TdomNotation).PublicId,
                              (Node as TdomNotation).SystemId);
    ntNotation_Declaration_Node:
      Result:= CreateNotationDeclaration((Node as TdomNotationDeclaration).NodeName,
                                         (Node as TdomNotationDeclaration).PublicId,
                                         (Node as TdomNotationDeclaration).SystemId);
    ntElement_Type_Declaration_Node:
      Result:= CreateElementTypeDeclaration((Node as TdomElementTypeDeclaration).NodeName,
                                            (Node as TdomElementTypeDeclaration).contentspec);
    ntSequence_Particle_Node:
      Result:= CreateSequenceParticle((Node as TdomSequenceParticle).Frequency);
    ntPcdata_Choice_Particle_Node:
      Result:= CreatePcdataChoiceParticle;
    ntChoice_Particle_Node:
      Result:= CreateChoiceParticle((Node as TdomChoiceParticle).Frequency);
    ntElement_Particle_Node:
      Result:= CreateElementParticle((Node as TdomChoiceParticle).NodeName,
                                     (Node as TdomChoiceParticle).Frequency);
    ntAttribute_List_Node: begin
      Result:= CreateAttributeList((Node as TdomAttrList).NodeName);
      {duplicate attribute definitions:}
      for i:= 0 to (Node as TdomAttrList).AttributeDefinitions.Length-1 do begin
        NewChild:= DuplicateNode((Node as TdomAttrList).AttributeDefinitions.Item(i));
        (Result as TdomAttrList).SetAttributeDefinitionNode((NewChild as TdomAttrDefinition));
      end;
      end;
    ntAttribute_Definition_Node: begin
      Result:= CreateAttributeDefinition((Node as TdomAttrDefinition).NodeName,
                                         (Node as TdomAttrDefinition).AttributeType,
                                         (Node as TdomAttrDefinition).DefaultDeclaration,
                                         (Node as TdomAttrDefinition).NodeValue);
      {duplicate the children of the attribute definition node:}
      for i:= 0 to Node.ChildNodes.Length-1 do begin
        newChild:= DuplicateNode(Node.ChildNodes.Item(i));
        Result.AppendChild(newChild);
      end;
      end;
    ntNametoken_Node:
      Result:= CreateNametoken((Node as TdomNametoken).NodeName);
    ntText_Declaration_Node:
      Result:= CreateTextDeclaration((Node as TdomTextDeclaration).VersionNumber,
                                     (Node as TdomTextDeclaration).EncodingDecl);
    ntExternal_Parsed_Entity_Node:
      Result:= CreateExternalParsedEntity;
    ntExternal_Parameter_Entity_Node:
      Result:= CreateExternalParameterEntity;
    ntExternal_Subset_Node:
      Result:= CreateExternalSubset;
    ntInternal_Subset_Node:
      Result:= CreateInternalSubset;
  end;
end;

procedure TdomDocument.InitDoc(const TagName: wideString);
begin
  if not IsXmlName(TagName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if assigned (DocumentElement)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  AppendChild(CreateElement(TagName));
end;

procedure TdomDocument.InitDocNS(const NamespaceURI,
                                       QualifiedName: WideString);
var
  prfx: WideString;
begin
  if not IsXmlName(QualifiedName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlQName(QualifiedName)
    then raise ENamespace_Err.create('Namespace error.');
  prfx:= XMLExtractPrefix(QualifiedName);
  if ( ((prfx = 'xmlns') or (QualifiedName = 'xmlns'))
    and not (NamespaceURI ='http://www.w3.org/2000/xmlns/') )
      then raise ENamespace_Err.create('Namespace error.');
  if (NamespaceURI = '') and (prfx <> '')
    then raise ENamespace_Err.create('Namespace error.');
  if (prfx = 'xml') and (NamespaceURI <> 'http://www.w3.org/XML/1998/namespace')
    then raise ENamespace_Err.create('Namespace error.');
  if assigned (DocumentElement)
    then raise EHierarchy_Request_Err.create('Hierarchy request error.');
  AppendChild(CreateElementNS(namespaceURI,qualifiedName));
end;

function TdomDocument.GetDoctype: TdomDocumentType;
var
  Child: TdomNode;
begin
  Result:= nil;
  Child:= GetFirstChild;
  while assigned(Child) do begin
    if Child.NodeType = ntDocument_Type_Node then begin
      Result:= (Child as TdomDocumentType);
      break;
    end;
    Child:= Child.NextSibling;
  end;
end;

function TdomDocument.GetDocumentElement: TdomElement;
var
  Child: TdomNode;
begin
  Result:= nil;
  Child:= GetFirstChild;
  while assigned(Child) do begin
    if Child.NodeType = ntElement_Node then begin
      Result:= (Child as TdomElement);
      break;
    end;
    Child:= Child.NextSibling;
  end;
end;

function TdomDocument.GetXmlDeclaration: TdomXmlDeclaration;
begin
  Result:= nil;
  if HasChildNodes then
    if FirstChild.NodeType = ntXml_Declaration_Node
      then Result:= (FirstChild as TdomXmlDeclaration);
end;

function TdomDocument.CreateElement(const TagName: WideString): TdomElement;
begin
  Result:= TdomElement.Create(self,'',Tagname);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateElementNS(const NamespaceURI,
                                            QualifiedName: WideString): TdomElement;
var
  prfx: Widestring;
begin
  if not IsXmlName(QualifiedName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlQName(QualifiedName)
    then raise ENamespace_Err.create('Namespace error.');
  prfx:= XMLExtractPrefix(QualifiedName);
  if ( ((prfx = 'xmlns') or (QualifiedName = 'xmlns'))
    and not (NamespaceURI ='http://www.w3.org/2000/xmlns/') )
      then raise ENamespace_Err.create('Namespace error.');
  if (NamespaceURI = '') and (prfx <> '')
    then raise ENamespace_Err.create('Namespace error.');
  if (prfx = 'xml') and (NamespaceURI <> 'http://www.w3.org/XML/1998/namespace')
    then raise ENamespace_Err.create('Namespace error.');
  Result:= TdomElement.Create(self,NamespaceURI,QualifiedName);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateDocumentFragment: TdomDocumentFragment;
begin
  Result:= TdomDocumentFragment.Create(self);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateText(const Data: WideString): TdomText;
begin
  Result:= TdomText.Create(self);
  Result.Data:= Data;
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateComment(const Data: WideString): TdomComment;
begin
  Result:= TdomComment.Create(self);
  Result.Data:= Data;
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateConditionalSection(const IncludeStmt: WideString): TdomConditionalSection;
begin
  Result:= TdomConditionalSection.Create(self,IncludeStmt);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateCDATASection(const Data: WideString): TdomCDATASection;
begin
  Result:= TdomCDATASection.Create(self);
  Result.Data:= Data;
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateProcessingInstruction(const Targ,
                                                        Data : WideString): TdomProcessingInstruction;
begin
  Result:= TdomProcessingInstruction.Create(self,Targ);
  Result.Data:= Data;
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateXmlDeclaration(const Version,
                                                 EncDl,
                                                 SdDl: WideString): TdomXmlDeclaration;
begin
  Result:= TdomXmlDeclaration.Create(self,Version,EncDl,SdDl);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateAttribute(const Name: WideString): TdomAttr;
begin
  Result:= TdomAttr.Create(self,'',Name,true);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateAttributeNS(const NamespaceURI,
                                              QualifiedName: WideString): TdomAttr;
var
  prfx: WideString;
begin
  if not IsXmlName(QualifiedName)
    then raise EInvalid_Character_Err.create('Invalid character error.');
  if not IsXmlQName(QualifiedName)
    then raise ENamespace_Err.create('Namespace error.');
  prfx:= XMLExtractPrefix(QualifiedName);
  if ( ((prfx = 'xmlns') or (QualifiedName = 'xmlns'))
    and not (NamespaceURI ='http://www.w3.org/2000/xmlns/') )
      then raise ENamespace_Err.create('Namespace error.');
  if (NamespaceURI = '') and (prfx <> '')
    then raise ENamespace_Err.create('Namespace error.');
  if (prfx = 'xml') and (NamespaceURI <> 'http://www.w3.org/XML/1998/namespace')
    then raise ENamespace_Err.create('Namespace error.');
  Result:= TdomAttr.Create(self,NamespaceURI,QualifiedName,true);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateEntityReference(const Name: WideString): TdomEntityReference;
begin
  Result:= TdomEntityReference.Create(self,Name);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateParameterEntityReference(const Name: WideString): TdomParameterEntityReference;
begin
  Result:= TdomParameterEntityReference.Create(self,Name);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateDocumentType(const Name,
                                               PubId,
                                               SysId: WideString): TdomDocumentType;
begin
  Result:= TdomDocumentType.Create(self,Name,PubId,SysId);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateNotation(const Name,
                                           PubId,
                                           SysId: WideString): TdomNotation;
begin
  Result:= TdomNotation.Create(self,Name,PubId,SysId);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateNotationDeclaration(const Name,
                                                      PubId,
                                                      SysId: WideString): TdomNotationDeclaration;
begin
  Result:= TdomNotationDeclaration.Create(self,Name,PubId,SysId);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateEntity(const Name,
                                         PubId,
                                         SysId,
                                         NotaName: WideString): TdomEntity;
begin
  Result:= TdomEntity.Create(self,Name,PubId,SysId,NotaName);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateParameterEntity(const Name,
                                                  PubId,
                                                  SysId: WideString): TdomParameterEntity;
begin
  Result:= TdomParameterEntity.Create(self,Name,PubId,SysId);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateEntityDeclaration(const Name,
                                                    EntityValue,
                                                    PubId,
                                                    SysId,
                                                    NotaName: WideString): TdomEntityDeclaration;
begin
  Result:= TdomEntityDeclaration.Create(self,Name,EntityValue,PubId,SysId,NotaName);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateParameterEntityDeclaration(const Name,
                                                             EntityValue,
                                                             PubId,
                                                             SysId: WideString): TdomParameterEntityDeclaration;
begin
  Result:= TdomParameterEntityDeclaration.Create(self,Name,EntityValue,PubId,SysId);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateElementTypeDeclaration(const Name: WideString;
                                                   const Contspec: TdomContentspecType): TdomElementTypeDeclaration;
begin
  Result:= TdomElementTypeDeclaration.Create(self,Name,Contspec);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateSequenceParticle(const Freq: WideString): TdomSequenceParticle;
begin
  Result:= TdomSequenceParticle.Create(self,Freq);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateChoiceParticle(const Freq: WideString): TdomChoiceParticle;
begin
  Result:= TdomChoiceParticle.Create(self,Freq);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreatePcdataChoiceParticle: TdomPcdataChoiceParticle;
begin
  Result:= TdomPcdataChoiceParticle.Create(self,'*');
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateElementParticle(const Name,
                                                  Freq: WideString): TdomElementParticle;
begin
  Result:= TdomElementParticle.Create(self,Name,Freq);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateAttributeList(const Name: WideString): TdomAttrList;
begin
  Result:= TdomAttrList.Create(self,Name);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateAttributeDefinition(const Name,
                                                      AttType,
                                                      DefaultDecl,
                                                      AttValue: WideString) : TdomAttrDefinition;
begin
  Result:= TdomAttrDefinition.Create(self,Name,AttType,DefaultDecl,AttValue);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateNametoken(const Name: WideString): TdomNametoken;
begin
  Result:= TdomNametoken.Create(self,Name);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateTextDeclaration(const Version,
                                                  EncDl: WideString): TdomTextDeclaration;
begin
  Result:= TdomTextDeclaration.Create(self,Version,EncDl);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateExternalParsedEntity: TdomExternalParsedEntity;
begin
  Result:= TdomExternalParsedEntity.Create(self);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateExternalParameterEntity: TdomExternalParameterEntity;
begin
  Result:= TdomExternalParameterEntity.Create(self);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateExternalSubset: TdomExternalSubset;
begin
  Result:= TdomExternalSubset.Create(self);
  FCreatedNodes.add(Result);
end;

function TdomDocument.CreateInternalSubset: TdomInternalSubset;
begin
  Result:= TdomInternalSubset.Create(self);
  FCreatedNodes.add(Result);
end;

procedure TdomDocument.FreeAllNodes(const Node: TdomNode);
var
  index: integer;
  oldChild: TdomNode;
  oldAttr: TdomAttr;
  oldAttrDef: TdomAttrDefinition;
begin
  if not assigned(Node) then exit;
  if Node.OwnerDocument <> Self
    then raise EWrong_Document_Err.create('Wrong document error.');
  if Node = Self
    then raise ENo_Modification_Allowed_Err.create('No modification allowed error.');
  if assigned(Node.ParentNode)
    then raise EInuse_Node_Err.create('Inuse node error.');
  if Node.NodeType = ntAttribute_Node then
    if assigned((Node as TdomAttr).OwnerElement)
      then raise EInuse_Attribute_Err.create('Inuse attribute error.');
  if Node.NodeType = ntAttribute_Definition_Node then
    if assigned((Node as TdomAttrDefinition).ParentAttributeList)
      then raise EInuse_AttributeDefinition_Err.create('Inuse attribute definition error.');
  while node.HasChildNodes do begin
    node.FirstChild.FIsReadonly:= false;
    oldChild:= node.RemoveChild(node.FirstChild);
    node.OwnerDocument.FreeAllNodes(oldChild);
  end;
  case Node.NodeType of
    ntElement_Node:
    while Node.Attributes.Length > 0 do begin
      oldAttr:= (node.Attributes.item(0) as TdomAttr);
      oldAttr.FIsReadonly:= false;
      (Node as TdomElement).RemoveAttributeNode(oldAttr);
      node.OwnerDocument.FreeAllNodes(oldAttr);
    end;
    ntAttribute_List_Node:
    while (Node as TdomAttrList).AttributeDefinitions.Length > 0 do begin
      oldAttrDef:= ((Node as TdomAttrList).AttributeDefinitions.item(0) as TdomAttrDefinition);
      oldAttrDef.FIsReadonly:= false;
      (Node as TdomAttrList).RemoveAttributeDefinitionNode(oldAttrDef);
      node.OwnerDocument.FreeAllNodes(oldAttrDef);
    end;
  end; {case ...}
  index:= FCreatedNodes.IndexOf(Node);
  Node.free;
  FCreatedNodes.Delete(index);
end;

procedure TdomDocument.FreeTreeWalker(const TreeWalker: TdomTreeWalker);
var
  TreeWalkerIndex: integer;
begin
  if not assigned(TreeWalker) then exit;
  TreeWalkerIndex:= FCreatedTreeWalkers.IndexOf(TreeWalker);
  if TreeWalkerIndex = -1
    then raise EWrong_Document_Err.create('Wrong document error.');
  TdomTreeWalker(FCreatedTreeWalkers[TreeWalkerIndex]).free;
  FCreatedTreeWalkers.Delete(TreeWalkerIndex);
end;

function TdomDocument.GetElementsById(const elementId: WideString): TdomElement;
begin
  result:= nil;
end;

function TdomDocument.GetElementsByTagName(const TagName: WideString): TdomNodeList;
var
  i: integer;
begin
  for i:= 0 to FCreatedElementsNodeLists.Count - 1 do
    if TdomElementsNodeList(FCreatedElementsNodeLists[i]).FQueryName = TagName
      then begin Result:= TdomElementsNodeList(FCreatedElementsNodeLists[i]); exit; end;
  Result:= TdomElementsNodeList.Create(TagName,self);
  FCreatedElementsNodeLists.add(Result);
end;

function TdomDocument.GetElementsByTagNameNS(const namespaceURI,
                                                   localName: WideString): TdomNodeList;
var
  i: integer;
  nl: TdomElementsNodeListNS;
begin
  for i:= 0 to FCreatedElementsNodeListNSs.Count - 1 do begin
    nl:= TdomElementsNodeListNS(FCreatedElementsNodeListNSs[i]);
    if (nl.FQueryNamespaceURI = namespaceURI) and (nl.FQueryLocalName = localName)
      then begin Result:= nl; exit; end;
  end;
  Result:= TdomElementsNodeListNS.Create(namespaceURI,localName,self);
  FCreatedElementsNodeListNSs.add(Result);
end;

function TdomDocument.ImportNode(const importedNode: TdomNode;
                                 const deep: boolean): TdomNode;
var
  newChildNode: TdomNode;
  i: integer;
begin
  if (importedNode.NodeType in [ntDocument_Node,ntDocument_Type_Node])
    then raise ENot_Supported_Err.create('Not supported error.');
  Result:= DuplicateNode(importedNode);
  if deep then for i:= 0 to importedNode.ChildNodes.Length-1 do
  begin
    newChildNode:= ImportNode(importedNode.ChildNodes.Item(i),true);
    Result.AppendChild(newChildNode);
  end;
end;

function TdomDocument.InsertBefore(const newChild,
                                         refChild: TdomNode): TdomNode;
begin
  case newChild.NodeType of
    ntElement_Node: begin
      if assigned(DocType) then begin
        if DocType.NodeName <> newChild.NodeName
          then raise EInvalid_Character_Err.create('Invalid character error.');
        if ChildNodes.IndexOf(DocType) >= ChildNodes.IndexOf(refChild)
          then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      end;
      if assigned(DocumentElement)
        then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      Result:= inherited InsertBefore(newChild,refChild);
      end;
    ntDocument_Type_Node: begin
      if assigned(DocumentElement) then begin
        if DocumentElement.NodeName <> newChild.NodeName
          then raise EInvalid_Character_Err.create('Invalid character error.');
        if ChildNodes.IndexOf(DocumentElement) < ChildNodes.IndexOf(refChild)
          then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      end;
      if assigned(DocType)
        then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      Result:= inherited InsertBefore(newChild,refChild);
      end;
    ntXml_Declaration_Node:
      if (FirstChild = refChild) and (refChild.nodeType <> ntXml_Declaration_Node)
        then Result:= inherited InsertBefore(newChild,refChild)
        else raise EHierarchy_Request_Err.create('Hierarchy request error.');
    ntProcessing_Instruction_Node,ntComment_Node,ntDocument_Fragment_Node:
      Result:= inherited InsertBefore(newChild,refChild);
  else
    raise EHierarchy_Request_Err.create('Hierarchy request error.');
  end;
end;

function TdomDocument.ReplaceChild(const newChild,
                                         oldChild: TdomNode): TdomNode;
begin
  case newChild.NodeType of
    ntElement_Node: begin
      if assigned(DocumentElement) and (DocumentElement <> oldChild)
        then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      if assigned(DocType) then
        if DocType.NodeName <> newChild.NodeName
          then raise EInvalid_Character_Err.create('Invalid character error.');
      Result:= inherited ReplaceChild(newChild,oldChild);
      end;
    ntDocument_Type_Node: begin
      if assigned(DocType) and (DocType <> oldChild)
        then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      if assigned(DocumentElement)
        then if DocumentElement.NodeName <> newChild.NodeName
          then raise EInvalid_Character_Err.create('Invalid character error.');
      Result:= inherited ReplaceChild(newChild,oldChild);
      end;
    ntXml_Declaration_Node:
      if (FirstChild = oldChild)
        then Result:= inherited ReplaceChild(newChild,oldChild)
        else raise EHierarchy_Request_Err.create('Hierarchy request error.');
    ntProcessing_Instruction_Node,ntComment_Node,
    ntDocument_Fragment_Node:
      Result:= inherited ReplaceChild(newChild,oldChild);
  else
    raise EHierarchy_Request_Err.create('Hierarchy request error.');
  end;
end;

function TdomDocument.AppendChild(const newChild: TdomNode): TdomNode;
begin
  case newChild.NodeType of
    ntElement_Node: begin
      if assigned(DocumentElement)
        then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      Result:= inherited AppendChild(newChild);
      end;
    ntDocument_Type_Node: begin
      if assigned(Doctype) or assigned(DocumentElement)
        then raise EHierarchy_Request_Err.create('Hierarchy request error.');
      Result:= inherited AppendChild(newChild);
      end;
    ntXml_Declaration_Node:
      if HasChildNodes
        then raise EHierarchy_Request_Err.create('Hierarchy request error.')
        else Result:= inherited AppendChild(newChild);
    ntProcessing_Instruction_Node,ntComment_Node,
    ntDocument_Fragment_Node:
      Result:= inherited AppendChild(newChild);
  else
    raise EHierarchy_Request_Err.create('Hierarchy request error.');
  end;
end;

function TdomDocument.CreateNodeIterator(const root: TdomNode;
                                               whatToShow: TdomWhatToShow;
                                               nodeFilter: TdomNodeFilter;
                                               entityReferenceExpansion: boolean): TdomNodeIterator;
begin
  Result:= TdomNodeIterator.Create(root,whatToShow,nodeFilter,entityReferenceExpansion);
  FCreatedNodeIterators.add(Result);
end;

function TdomDocument.CreateTreeWalker(const root: TdomNode;
                                             whatToShow: TdomWhatToShow;
                                             nodeFilter: TdomNodeFilter;
                                             entityReferenceExpansion: boolean): TdomTreeWalker;
begin;
  Result:= TdomTreeWalker.Create(root,whatToShow,nodeFilter,entityReferenceExpansion);
  FCreatedTreeWalkers.add(Result);
end;



// +++++++++++++++++++++++++++ TXmlSourceCode ++++++++++++++++++++++++++
procedure TXmlSourceCode.calculatePieceOffset(const startItem: integer);
var
  os, i: integer;
begin
  if (startItem < count) and (startItem >= 0) then begin
    if startItem = 0
      then os:= 0
      else begin
        if not assigned(Items[startItem-1])
          then begin
            pack;
            exit;
          end else with TXmlSourceCodePiece(Items[startItem-1]) do
            os:= FOffset + length(FText);
      end;
    for i:= startItem to count -1 do
      if not assigned(Items[i])
        then begin
          pack;
          exit;
        end else with TXmlSourceCodePiece(Items[i]) do begin
          FOffset:= os;
          os:= os + length(FText);
        end;
  end; {if ...}
end;

function TXmlSourceCode.getNameOfFirstTag: wideString;
var
  i,j,k: integer;
begin
  Result:= '';
  for i:= 0 to count -1 do
    if assigned(Items[i]) then
      with TXmlSourceCodePiece(Items[i]) do
        if (pieceType = xmlStartTag) or (pieceType = xmlEmptyElementTag) then begin
          if pieceType = xmlStartTag
            then k:= length(text)-1
            else k:= length(text)-2;
          j:= 1;
          while j < k do begin
            inc(j);
            if IsXmlWhiteSpace(text[j]) then break;
            Result:= concat(Result,WideString(WideChar(text[j])));
          end;
          exit;
        end;
end;

function TXmlSourceCode.Add(Item: Pointer): Integer;
begin
  if assigned(Item) then begin
    if not assigned(TXmlSourceCodePiece(Item).FOwner)
      then TXmlSourceCodePiece(Item).FOwner:= self
      else Error('Inuse source code piece error.',-1);
  end else Error('Item not assigned error.',-1);
  Result:= inherited Add(Item);
  calculatePieceOffset(Result);
end;

procedure TXmlSourceCode.Clear;
var
  i: integer;
begin
  for i:= 0 to count -1 do
    if assigned(Items[i]) then
      with TXmlSourceCodePiece(Items[i]) do begin
        FOffset:= 0;
        FOwner:= nil;
      end;
  inherited clear;
end;

procedure TXmlSourceCode.ClearAndFree;
var
  i: integer;
begin
  for i:= 0 to count -1 do
    if assigned(Items[i]) then TXmlSourceCodePiece(Items[i]).free;
  inherited clear;
end;

procedure TXmlSourceCode.Delete(Index: Integer);
begin
  if assigned(Items[index]) then
    with TXmlSourceCodePiece(Items[index]) do begin
      FOffset:= 0;
      FOwner:= nil;
    end;
  inherited delete(index);
  calculatePieceOffset(Index);
end;

procedure TXmlSourceCode.Exchange(Index1, Index2: Integer);
var
  nr: integer;
begin
  nr:= MinIntValue([Index1,Index2]);
  inherited Exchange(Index1,Index2);
  calculatePieceOffset(nr);
end;

function TXmlSourceCode.GetPieceAtPos(pos: integer): TXmlSourceCodePiece;
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
// xxx   This search is not optimized.  Anybody out there, who   xxx
// xxx   wants to do it?  Please email me: service@philo.de.     xxx
// xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
var
  i: integer;
begin
  Result:= nil;
  if pos < 1 then exit;
  for i:= 0 to count -1 do
    if not assigned(Items[i]) then begin
      pack;
      Result:= GetPieceAtPos(pos);
    end else with TXmlSourceCodePiece(Items[i]) do begin
      if (FOffset + length(FText)) >= pos then begin
        Result:= TXmlSourceCodePiece(Items[i]);
        exit;
      end;
    end;
end;

procedure TXmlSourceCode.Insert(Index: Integer; Item: Pointer);
begin
  if assigned(Item) then begin
    if not assigned(TXmlSourceCodePiece(Item).FOwner)
      then TXmlSourceCodePiece(Item).FOwner:= self
      else Error('Inuse source code piece error.',-1);
  end else Error('Item not assigned error.',-1);
  inherited Insert(Index,item);
  calculatePieceOffset(index);
end;

procedure TXmlSourceCode.Move(CurIndex, NewIndex: Integer);
var
  nr: integer;
begin
  nr:= MinIntValue([CurIndex,NewIndex]);
  inherited Move(CurIndex, NewIndex);
  calculatePieceOffset(nr);
end;

procedure TXmlSourceCode.Pack;
begin
  inherited pack;
  calculatePieceOffset(0);
end;

function TXmlSourceCode.Remove(Item: Pointer): Integer;
var
  nr: integer;
begin
  nr:= IndexOf(Item);
  result:= inherited Remove(Item);
  if assigned(Items[nr]) then
    with TXmlSourceCodePiece(Item) do begin
      FOffset:= 0;
      FOwner:= nil;
    end;
  calculatePieceOffset(nr);
end;

procedure TXmlSourceCode.Sort(Compare: TListSortCompare);
begin
  inherited Sort(Compare);
  calculatePieceOffset(0);
end;



// ++++++++++++++++++++++++ TXmlSourceCodePiece ++++++++++++++++++++++++
constructor TXmlSourceCodePiece.Create(const pt: TdomPieceType);
begin
  FPieceType:= pt;
  Ftext:= '';
  FOffset:= 0;
  FOwner:= nil;
end;



// ++++++++++++++++++++++++++ TXmlInputSource ++++++++++++++++++++++++++
constructor TXmlInputSource.create(const Stream: TStream;
                                   const PublicId,
                                         SystemId: wideString;
                                         defaultEncoding : TdomEncodingType);
var
  Str1: WideChar;
begin
  FStream:= Stream;
  FPublicId:= PublicId;
  FSystemId:= SystemId;

  // Determine the encoding type:
  FStream.seek(0,soFromBeginning);
  FStream.ReadBuffer(Str1,2);
  if ord(str1) = $feff then begin
    FEncoding:= etUTF16BE
  end else begin
    if ord(str1) = $fffe then begin
      FEncoding:= etUTF16LE
    end else begin
      //FEncoding:= etUTF8;
      FEncoding:=defaultEncoding; // modified by hyl
      FStream.seek(0,soFromBeginning);
    end;
  end;
end;



// ++++++++++++++++++++++++++ TXmlParserError ++++++++++++++++++++++++++
constructor TXmlParserError.Create(const ErrorType: ShortString;
                                   const StartLine,
                                         EndLine: integer;
                                   const SourceCodeText: WideString;
                                   const lang: TXmlParserLanguage);
begin
  FErrorType:= ErrorType;
  FStartLine:= StartLine;
  FEndLine:= EndLine;
  FSourceCodeText:= SourceCodeText;
  FLanguage:= lang;
  inherited create;
end;

function TXmlParserError.GetErrorStr: WideString;
var
  ErrorStr1,ErrorStr,XmlStrDefault: string;
  XmlStrInvalidElementName,XmlStrDoubleRootElement,
  XmlStrRootNotFound,XmlStrDoubleDoctype,
  XmlStrInvalidAttributeName,XmlStrInvalidAttributeValue,
  XmlStrDoubleAttributeName,XmlStrInvalidEntityName,XmlStrInvalidProcessingInstruction,
  XmlStrInvalidXmlDeclaration,XmlStrInvalidCharRef,
  XmlStrMissingQuotationmarks,XmlStrMissingEqualitySign,
  XmlStrDoubleEqualitySign,XmlStrMissingWhiteSpace,
  XmlStrMissingStartTag,XmlStrInvalidEndTag,
  XmlStrInvalidCharacter,XmlStrNotInRoot,
  XmlStrInvalidDoctype,XmlStrWrongOrder,
  XmlStrInvalidEntityDeclaration,XmlStrInvalidElementDeclaration,
  XmlStrInvalidAttributeDeclaration,XmlStrInvalidNotationDeclaration,
  XmlStrInvalidConditionalSection,xmlStrInvalidTextDeclaration,
  XmlStrDoubleEntityDeclWarning,XmlStrDoubleNotationDeclWarning: string;
  XmlStrError1,XmlStrError2,XmlStrFatalError1,XmlStrFatalError2: string;
begin
  Result:= '';
  ErrorStr:= '';

  if FLanguage = de then begin
    XmlStrDefault:= XmlStrErrorDefaultDe;
    XmlStrError1:= XmlStrError1De;
    XmlStrError2:= XmlStrError2De;
    XmlStrFatalError1:= XmlStrFatalError1De;
    XmlStrFatalError2:= XmlStrFatalError2De;
    XmlStrInvalidElementName:= XmlStrInvalidElementNameDe;
    XmlStrDoubleRootElement:= XmlStrDoubleRootElementDe;
    XmlStrRootNotFound:= XmlStrRootNotFoundDe;
    XmlStrDoubleDoctype:= XmlStrDoubleDoctypeDe;
    XmlStrInvalidAttributeName:= XmlStrInvalidAttributeNameDe;
    XmlStrInvalidAttributeValue:= XmlStrInvalidAttributeValueDe;
    XmlStrDoubleAttributeName:= XmlStrDoubleAttributeNameDe;
    XmlStrInvalidEntityName:= XmlStrInvalidEntityNameDe;
    XmlStrInvalidProcessingInstruction:= XmlStrInvalidProcessingInstructionDe;
    XmlStrInvalidXmlDeclaration:= XmlStrInvalidXmlDeclarationDe;
    XmlStrInvalidCharRef:= XmlStrInvalidCharRefDe;
    XmlStrMissingQuotationmarks:= XmlStrMissingQuotationmarksDe;
    XmlStrMissingEqualitySign:= XmlStrMissingEqualitySignDe;
    XmlStrDoubleEqualitySign:= XmlStrDoubleEqualitySignDe;
    XmlStrMissingWhiteSpace:= XmlStrMissingWhiteSpaceDe;
    XmlStrMissingStartTag:= XmlStrMissingStartTagDe;
    XmlStrInvalidEndTag:= XmlStrInvalidEndTagDe;
    XmlStrInvalidCharacter:= XmlStrInvalidCharacterDe;
    XmlStrNotInRoot:= XmlStrNotInRootDe;
    XmlStrInvalidDoctype:= XmlStrInvalidDoctypeDe;
    XmlStrWrongOrder:= XmlStrWrongOrderDe;
    XmlStrInvalidEntityDeclaration:= XmlStrInvalidEntityDeclarationDe;
    XmlStrInvalidElementDeclaration:= XmlStrInvalidElementDeclarationDe;
    XmlStrInvalidAttributeDeclaration:= XmlStrInvalidAttributeDeclarationDe;
    XmlStrInvalidNotationDeclaration:= XmlStrInvalidNotationDeclarationDe;
    XmlStrInvalidConditionalSection:= XmlStrInvalidConditionalSectionDe;
    XmlStrInvalidTextDeclaration:= XmlStrInvalidTextDeclarationDe;
    XmlStrDoubleEntityDeclWarning:= XmlStrDoubleEntityDeclWarningDe;
    XmlStrDoubleNotationDeclWarning:= XmlStrDoubleNotationDeclWarningDe;
  end else begin
    XmlStrDefault:= XmlStrErrorDefaultEn;
    XmlStrError1:= XmlStrError1En;
    XmlStrError2:= XmlStrError2En;
    XmlStrFatalError1:= XmlStrFatalError1En;
    XmlStrFatalError2:= XmlStrFatalError2En;
    XmlStrInvalidElementName:= XmlStrInvalidElementNameEn;
    XmlStrDoubleRootElement:= XmlStrDoubleRootElementEn;
    XmlStrRootNotFound:= XmlStrRootNotFoundEn;
    XmlStrDoubleDoctype:= XmlStrDoubleDoctypeEn;
    XmlStrInvalidAttributeName:= XmlStrInvalidAttributeNameEn;
    XmlStrInvalidAttributeValue:= XmlStrInvalidAttributeValueEn;
    XmlStrDoubleAttributeName:= XmlStrDoubleAttributeNameEn;
    XmlStrInvalidEntityName:= XmlStrInvalidEntityNameEn;
    XmlStrInvalidProcessingInstruction:= XmlStrInvalidProcessingInstructionEn;
    XmlStrInvalidXmlDeclaration:= XmlStrInvalidXmlDeclarationEn;
    XmlStrInvalidCharRef:= XmlStrInvalidCharRefEn;
    XmlStrMissingQuotationmarks:= XmlStrMissingQuotationmarksEn;
    XmlStrMissingEqualitySign:= XmlStrMissingEqualitySignEn;
    XmlStrDoubleEqualitySign:= XmlStrDoubleEqualitySignEn;
    XmlStrMissingWhiteSpace:= XmlStrMissingWhiteSpaceEn;
    XmlStrMissingStartTag:= XmlStrMissingStartTagEn;
    XmlStrInvalidEndTag:= XmlStrInvalidEndTagEn;
    XmlStrInvalidCharacter:= XmlStrInvalidCharacterEn;
    XmlStrNotInRoot:= XmlStrNotInRootEn;
    XmlStrInvalidDoctype:= XmlStrInvalidDoctypeEn;
    XmlStrWrongOrder:= XmlStrWrongOrderEn;
    XmlStrInvalidEntityDeclaration:= XmlStrInvalidEntityDeclarationEn;
    XmlStrInvalidElementDeclaration:= XmlStrInvalidElementDeclarationEn;
    XmlStrInvalidAttributeDeclaration:= XmlStrInvalidAttributeDeclarationEn;
    XmlStrInvalidNotationDeclaration:= XmlStrInvalidNotationDeclarationEn;
    XmlStrInvalidConditionalSection:= XmlStrInvalidConditionalSectionEn;
    XmlStrInvalidTextDeclaration:= XmlStrInvalidTextDeclarationEn;
    XmlStrDoubleEntityDeclWarning:= XmlStrDoubleEntityDeclWarningEn;
    XmlStrDoubleNotationDeclWarning:= XmlStrDoubleNotationDeclWarningEn;
  end;

  if FErrorType = 'EParserRootNotFound_Err' {Gültigkeitsbeschränkung verletzt}
    then begin
      if FStartLine = FEndLine
        then FmtStr(ErrorStr1,XmlStrError1,[FStartLine])
        else FmtStr(ErrorStr1,XmlStrError2,[FStartLine,FEndLine]);
    end else begin{Wohlgeformtheitsbeschränkung verletzt}
      if FStartLine = FEndLine
        then FmtStr(ErrorStr1,XmlStrFatalError1,[FStartLine])
        else FmtStr(ErrorStr1,XmlStrFatalError2,[FStartLine,FEndLine]);
    end;

  ErrorStr:= concat(ErrorStr1,' -- ',XmlStrDefault);
  if FErrorType = 'EParserInvalidElementName_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidElementName);
  if FErrorType = 'EParserDoubleRootElement_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrDoubleRootElement);
  if FErrorType = 'EParserRootNotFound_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrRootNotFound);
  if FErrorType = 'EParserDoubleDoctype_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrDoubleDoctype);
  if FErrorType = 'EParserInvalidAttributeName_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidAttributeName);
  if FErrorType = 'EParserInvalidAttributeValue_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidAttributeValue);
  if FErrorType = 'EParserDoubleAttributeName_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrDoubleAttributeName);
  if FErrorType = 'EParserInvalidEntityName_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidEntityName);
  if FErrorType = 'EParserInvalidProcessingInstruction_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidProcessingInstruction);
  if FErrorType = 'EParserInvalidXmlDeclaration_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidXmlDeclaration);
  if FErrorType = 'EParserInvalidCharRef_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidCharRef);
  if FErrorType = 'EParserMissingQuotationMark_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrMissingQuotationmarks);
  if FErrorType = 'EParserMissingEqualitySign_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrMissingEqualitySign);
  if FErrorType = 'EParserDoubleEqualitySign_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrDoubleEqualitySign);
  if FErrorType = 'EParserMissingWhiteSpace_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrMissingWhiteSpace);
  if FErrorType = 'EParserMissingStartTag_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrMissingStartTag);
  if FErrorType = 'EParserInvalidEndTag_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidEndTag);
  if FErrorType = 'EParserInvalidCharacter_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidCharacter);
  if FErrorType = 'EParserNotInRoot_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrNotInRoot);
  if FErrorType = 'EParserInvalidDoctype_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidDoctype);
  if FErrorType = 'EParserWrongOrder_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrWrongOrder);
  if FErrorType = 'EParserInvalidEntityDeclaration_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidEntityDeclaration);
  if FErrorType = 'EParserInvalidElementDeclaration_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidElementDeclaration);
  if FErrorType = 'EParserInvalidAttributeDeclaration_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidAttributeDeclaration);
  if FErrorType = 'EParserInvalidNotationDeclaration_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidNotationDeclaration);
  if FErrorType = 'EParserInvalidConditionalSection_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidConditionalSection);
  if FErrorType = 'EParserInvalidTextDeclaration_Err'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrInvalidTextDeclaration);

  if FErrorType = 'Double_Entity_Decl_Warning'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrDoubleEntityDeclWarning);
  if FErrorType = 'Double_Notation_Decl_Warning'
    then ErrorStr:= concat(ErrorStr1,' -- ',XmlStrDoubleNotationDeclWarning);

  if FSourceCodeText = ''
    then Result:= concat(ErrorStr,'.')
    else Result:= concat(ErrorStr,': ',FSourceCodeText);
end;

function TXmlParserError.GetErrorType: ShortString;
begin
  Result:= FErrorType;
end;

function TXmlParserError.GetStartLine: integer;
begin
  Result:= FStartLine;
end;

function TXmlParserError.GetEndLine: integer;
begin
  Result:= FEndLine;
end;



// ++++++++++++++++++++++++++ TXmlMemoryStream +++++++++++++++++++++++++
procedure TXmlMemoryStream.SetPointer(Ptr: Pointer; Size: Longint);
begin
  inherited SetPointer(Ptr,Size);
end;



// +++++++++++++++++++++++++++ TCustomParser ++++++++++++++++++++++++++
constructor TCustomParser.Create(aOwner: TComponent);
begin
  Inherited Create(aOwner);
  FLineNumber:= 0;
  FErrorList:= TList.create;
  FErrorStrings:= TStringList.create;
  FLanguage:= en;
  FIntSubset:= '';
  FDOMImpl:= nil;
  FDocumentSC:= nil;
  FUseSpecifiedDocumentSC:= true;
  FDefaultEncoding:=etMBCS;
end;

destructor TCustomParser.Destroy;
begin
  ClearErrorList;
  FErrorList.free;
  FErrorStrings.free;
  inherited Destroy;
end;

procedure TCustomParser.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation = opRemove) and (AComponent = FDomImpl)
    then FDomImpl:= nil;
end;

procedure TCustomParser.SetDomImpl(const impl: TDomImplementation);
begin
  FDOMImpl:= impl;
  if impl <> nil then impl.FreeNotification(Self);
end;

function TCustomParser.GetDomImpl: TDomImplementation;
begin
  Result:= FDOMImpl;
end;

procedure TCustomParser.SetLanguage(const Lang: TXmlParserLanguage);
begin
  FLanguage:= Lang;
end;

function TCustomParser.GetLanguage: TXmlParserLanguage;
begin
  Result:= FLanguage;
end;

function TCustomParser.GetErrorList: TList;
begin
  Result:= FErrorList;
end;

function TCustomParser.GetErrorStrings: TStringList;
var
  i: integer;
begin
  FErrorStrings.clear;
  for i:= 0 to FErrorList.count -1 do
    FErrorStrings.Add(TXmlParserError(FErrorList[i]).ErrorStr);
  Result:=  FErrorStrings;
end;

procedure TCustomParser.ClearErrorList;
{Löscht alle Objekte von FErrorList.}
var
  i: integer;
begin
  for i := 0 to (FErrorList.Count - 1) do
    TdomNode(FErrorList[i]).Free;
  FErrorList.Clear;
end;

function TCustomParser.NormalizeLineBreaks(const source :WideString): WideString;
const
  CR: WideChar  = #13;
  LF: WideChar  = #10;
  CRLF: WideString = #13#10;
var
  nPos: integer;
begin
  Result:= source;

  // CR+LF --> LF
  repeat
    nPos := Pos(CRLF, Result);
    if nPos > 0 then
      Delete(Result, nPos, 1);
  until nPos = 0;

  // CR --> LF
  repeat
    nPos := Pos(CR, Result);
    if nPos > 0 then
      Result[nPos] := LF;
  until nPos = 0;
end;

procedure TCustomParser.XMLAnalyseAttrSequence(const Source: WideString;
                                               const Element: TdomElement;
                                               const FirstLineNumber,
                                                     LastLineNumber: integer);
// 'Source':  The attribute sequence to be analyzed.
// 'Element': The TdomElement node to which the attributes as
//            TdomAttr nodes will be added.
const
  SingleQuote: WideChar = #39; // code of '
  DoubleQuote: WideChar = #34; // code of "
var
  i,j : integer;
  name,value,v,text,CharacRef: WideString;
  QuoteType: WideChar;
  IsEntity,EqualSign,WhiteSpace: boolean;
  Attri: TdomAttr;
begin
  WhiteSpace:= true;
  QuoteType:= 'x';

  i:= 0;
  while (i<length(Source)) do
  begin

    if not WhiteSpace
      then raise EParserMissingWhiteSpace_Err.create('Missing white-space error.');

    if i < length(Source) then begin
      Name:= '';
      while (i<length(Source)) do
      begin
        if IsXmlWhiteSpace(Source[i+1]) or (Source[i+1] = '=') then break;
        inc(i);
        Name:= concat(Name,WideString(Source[i]));
      end;

      EqualSign:= false;
      while (i<length(Source)) do
      begin
        inc(i);
        if not (IsXmlWhiteSpace(Source[i]) or (Source[i] = '=')) then
        begin
          if ((Source[i] = SingleQuote) or (Source[i] = DoubleQuote)) then begin
            if not EqualSign
              then raise EParserMissingEqualitySign_Err.create('Missing equality sign error.');
            QuoteType:= Source[i];
            break;
          end else raise EParserMissingQuotationMark_Err.create('Missing quotation mark error.');
        end else
          if Source[i] = '=' then
            if EqualSign
              then raise EParserDoubleEqualitySign_Err.create('Double equality sign error.')
              else EqualSign:= true;
      end;

      Value:='';
      while (i<length(Source)) do
      begin
        inc(i);
        if Source[i] = QuoteType then break;
        Value:= concat(Value,WideString(Source[i]));
      end;

      {Ungültiger Attributname?:}
      if not IsXmlName(Name)
        then raise EParserInvalidAttributeName_Err.create('Invalid attribute name error.');

      {Fehlendes Schlußzeichen?:}
      if Source[i] <> QuoteType
        then raise EParserMissingQuotationMark_Err.create('Missing quotation mark error.');

      {Attributname zweimal vergeben?:}
      if assigned(Element.Attributes.GetNamedItem(Name))
        then raise EParserDoubleAttributeName_Err.create('Double attribute name error.');

      if pos('&',Value) = 0 then begin
        {Ungültiger Attributwert?:}
        if not IsXmlCharData(Value)
          then raise EParserInvalidAttributeValue_Err.create('Invalid attribute value error.');
        Element.SetAttribute(Name,Value)
      end else begin
        Attri:= Element.OwnerDocument.CreateAttribute(Name);
        Element.SetAttributeNode(Attri);
        IsEntity:= false;
        text:= '';
        for j:= 1 to Length(value) do begin
          if IsEntity then begin
            if Value[j] = ';' then begin
              if text[1] = '#' then begin {CharRef}
              try
                CharacRef:= concat(WideString('&'),text,WideString(';'));
                v:= XmlCharRefToStr(CharacRef);
                if Attri.LastChild is TdomText
                  then (Attri.LastChild as TdomText).appendData(v)
                  else Attri.AppendChild(Element.OwnerDocument.CreateText(v));
              except
                on EConvertError do
                  raise EParserInvalidCharRef_Err.create('Invalid character reference error.');
              end; {try}
              end else begin
                if not IsXmlName(text)
                  then raise EParserInvalidAttributeValue_Err.create('Invalid attribute value error.');
                Attri.AppendChild(Element.OwnerDocument.CreateEntityReference(text));
              end;
              text:= '';
              IsEntity:= false;
            end else Text:= concat(text,WideString(Value[j]));
          end else begin
            if Value[j] = '&' then begin
              if text <> '' then begin
                {Ungültiger Attributwert?:}
                if not IsXmlCharData(text)
                  then raise EParserInvalidAttributeValue_Err.create('Invalid attribute value error.');
                Attri.AppendChild(Element.OwnerDocument.CreateText(text));
              end;
              text:= '';
              IsEntity:= true;
            end else Text:= concat(text,WideString(Value[j]));
          end; {if ...}
        end; {for ...}
        {Ungültiger Attributwert?:}
        if IsEntity
          then raise EParserInvalidAttributeValue_Err.create('Invalid attribute value error.');
        if text <> '' then Attri.AppendChild(Element.OwnerDocument.CreateText(text));
      end; {if ...}

    end; {if i < length(Source)}

    {White-space?}
    WhiteSpace:= false;
    while (i<length(Source)) do
    begin
      inc(i);
      if not IsXmlWhiteSpace(Source[i])
        then begin dec(i); break; end
        else WhiteSpace:= true;
    end;

  end; {while (i<length(Source))}
end;

function TCustomParser.WriteXmlDeclaration(const Content: WideString;
                                           const FirstLineNumber,
                                                 LastLineNumber: integer;
                                           const RefNode: TdomNode;
                                           const readonly: boolean): TdomXmlDeclaration;
var
  version,encoding,standalone,TargetName,AttribSequence: Widestring;
  VersionAttr,EncodingAttr,StandaloneAttr: TdomAttr;
  VersionIndex,EncodingIndex,StandaloneIndex: integer;
  NewElement: TdomElement;
begin
  Result:= nil;
  XMLAnalyseTag(content,TargetName,AttribSequence);
  if TargetName <> 'xml'
    then raise EParserInvalidXmlDeclaration_Err.create('Invalid xml-declaration error.');
  if RefNode.HasChildNodes
    then raise EParserWrongOrder_Err.create('Wrong order error.');
  NewElement:= RefNode.OwnerDocument.CreateElement('dummy');
  try
    XMLAnalyseAttrSequence(AttribSequence,NewElement,FirstLineNumber,LastLineNumber);
    with NewElement.Attributes do begin
      VersionAttr:= (GetNamedItem('version') as TdomAttr);
      EncodingAttr:= (GetNamedItem('encoding') as TdomAttr);
      StandaloneAttr:= (GetNamedItem('standalone') as TdomAttr);
      VersionIndex:= GetNamedIndex('version');
      EncodingIndex:= GetNamedIndex('encoding');
      StandaloneIndex:= GetNamedIndex('standalone');
      if (VersionIndex <> 0)
        or (EncodingIndex > 1)
        or ((Length > 1) and (EncodingIndex = -1) and (StandaloneIndex = -1))
        or ((Length > 2) and ((EncodingIndex = -1) or (StandaloneIndex = -1)))
        or (Length > 3)
        or (not assigned(VersionAttr))
        then raise EParserInvalidXmlDeclaration_Err.create('Invalid xml-declaration error.');
    end; {with ...}
    version:= VersionAttr.Value;
    if assigned(EncodingAttr)
      then encoding:= EncodingAttr.Value
      else encoding:= '';
    if assigned(standaloneAttr)
      then standalone:= StandaloneAttr.Value
      else Standalone:= '';

    try
      Result:= RefNode.OwnerDocument.CreateXmlDeclaration(version,encoding,Standalone);
      try
        RefNode.AppendChild(Result);
        Result.FIsReadonly:= readonly;
      except
        if assigned(Result.ParentNode)
          then Result.ParentNode.RemoveChild(Result);
        RefNode.OwnerDocument.FreeAllNodes(Result);
        raise;
      end; {try ...}
    except
      raise EParserInvalidXmlDeclaration_Err.create('Invalid xml-declaration error.');
    end; {try ...}

  finally
    RefNode.OwnerDocument.FreeAllNodes(NewElement);
  end; {try ...}
end;

function TCustomParser.WriteTextDeclaration(const Content: WideString;
                                            const FirstLineNumber,
                                                  LastLineNumber: integer;
                                            const RefNode: TdomNode;
                                            const readonly: boolean): TdomTextDeclaration;
var
  version,encoding,TargetName,AttribSequence: Widestring;
  VersionAttr,EncodingAttr: TdomAttr;
  VersionIndex,EncodingIndex: integer;
  NewElement: TdomElement;
begin
  Result:= nil;
  XMLAnalyseTag(content,TargetName,AttribSequence);
  if TargetName <> 'xml' 
    then raise EParserInvalidTextDeclaration_Err.create('Invalid text-declaration error.');
  if RefNode.HasChildNodes
    then raise EParserWrongOrder_Err.create('Wrong order error.');
  NewElement:= RefNode.OwnerDocument.CreateElement('dummy');
  try
    XMLAnalyseAttrSequence(AttribSequence,NewElement,FirstLineNumber,LastLineNumber);
    with NewElement.Attributes do begin
      VersionAttr:= (GetNamedItem('version') as TdomAttr);
      EncodingAttr:= (GetNamedItem('encoding') as TdomAttr);
      VersionIndex:= GetNamedIndex('version');
      EncodingIndex:= GetNamedIndex('encoding');
      if (assigned(VersionAttr) and ((VersionIndex <> 0) or (EncodingIndex <> 1) or (Length > 2)))
        or ( (not assigned(VersionAttr)) and ( (EncodingIndex <> 0) or (Length > 1)))
        then raise EParserInvalidTextDeclaration_Err.create('Invalid text-declaration error.');
    end; {with ...}
    if assigned(VersionAttr)
      then version:= VersionAttr.Value
      else version:= '';
    encoding:= EncodingAttr.Value;

    try
      Result:= RefNode.OwnerDocument.CreateTextDeclaration(version,encoding);
      try
        RefNode.AppendChild(Result);
        Result.FIsReadonly:= readonly;
      except
        if assigned(Result.ParentNode)
          then Result.ParentNode.RemoveChild(Result);
        RefNode.OwnerDocument.FreeAllNodes(Result);
        raise;
      end; {try ...}
    except
      raise EParserInvalidTextDeclaration_Err.create('Invalid text-declaration error.');
    end; {try ...}

  finally
    RefNode.OwnerDocument.FreeAllNodes(NewElement);
  end; {try ...}
end;

function TCustomParser.WriteProcessingInstruction(const Content: WideString;
                                                  const FirstLineNumber,
                                                        LastLineNumber: integer;
                                                  const RefNode: TdomNode;
                                                  const readonly: boolean): TdomNode;
var
  TargetName,AttribSequence: Widestring;
begin
  XMLAnalyseTag(content,TargetName,AttribSequence);
  if TargetName = 'xml'
    then raise EParserInvalidProcessingInstruction_Err.create('Invalid processing instruction error.');
  try
    Result:= RefNode.OwnerDocument.CreateProcessingInstruction(TargetName,AttribSequence);
    try
      RefNode.AppendChild(Result);
      Result.FIsReadonly:= readonly;
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      raise;
    end;
  except
    raise EParserInvalidProcessingInstruction_Err.create('Invalid processing instruction error.');
  end;
end;

function TCustomParser.WriteComment(const Content: WideString;
                                    const FirstLineNumber,
                                          LastLineNumber: integer;
                                    const RefNode: TdomNode;
                                    const readonly: boolean): TdomComment;
begin
  try
    Result:= RefNode.OwnerDocument.CreateComment(content);
    try
      RefNode.AppendChild(Result);
      Result.FIsReadonly:= readonly;
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      raise;
    end; {try ...}
  except
    raise EParserInvalidCharacter_Err.create('Invalid character error.');
  end; {try ...}
end;

function TCustomParser.WriteCDATA(const Content: WideString;
                                  const FirstLineNumber,
                                        LastLineNumber: integer;
                                  const RefNode: TdomNode;
                                  const readonly: boolean): TdomCDATASection;
begin
  try
    Result:= RefNode.OwnerDocument.CreateCDATASection(content);
    try
      RefNode.AppendChild(Result);
      Result.FIsReadonly:= readonly;
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      raise;
    end; {try ...}
  except
    raise EParserInvalidCharacter_Err.create('Invalid character error.');
  end; {try ...}
end;

function TCustomParser.WritePCDATA(const Content: WideString;
                                   const FirstLineNumber,
                                         LastLineNumber: integer;
                                   const RefNode: TdomNode;
                                   const readonly: boolean): TdomText;
begin
  result:= nil;
  if RefNode.NodeType = ntDocument_Node then
    if IsXmlS(content)
      then exit
      else raise EParserInvalidCharacter_Err.create('Invalid character error.');
  if RefNode.LastChild is TdomText
    then (RefNode.LastChild as TdomText).appendData(content)
    else begin
      try
        Result:= RefNode.OwnerDocument.CreateText(content);
        try
          RefNode.AppendChild(Result);
          Result.FIsReadonly:= readonly;
        except
          if assigned(Result.ParentNode)
            then Result.ParentNode.RemoveChild(Result);
          RefNode.OwnerDocument.FreeAllNodes(Result);
          raise;
        end; {try ...}
      except
        raise EParserInvalidCharacter_Err.create('Invalid character error.');
      end; {try ...}
   end;
end;

function TCustomParser.WriteStartTag(const Content: WideString;
                                     const FirstLineNumber,
                                           LastLineNumber: integer;
                                     const RefNode: TdomNode;
                                     const readonly: boolean): TdomElement;
var
  TagName,AttribSequence: Widestring;
begin
  XMLAnalyseTag(content,TagName,AttribSequence);
  if not IsXmlName(TagName) then
    raise EParserInvalidElementName_Err.create('Invalid element name error.');
  if (RefNode.NodeType = ntDocument_Node) then 
    if assigned((RefNode as TdomDocument).DocumentElement)
      then raise EParserDoubleRootElement_Err.create('Double root element error.');
  try
    Result:= RefNode.OwnerDocument.CreateElement(TagName);
    try
      XMLAnalyseAttrSequence(AttribSequence,Result,FirstLineNumber,LastLineNumber);
      RefNode.AppendChild(Result);
      Result.FIsReadonly:= readonly;
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      raise;
    end; {try ...}
  except
    raise EParserMissingStartTag_Err.create('Invalid start tag error.');
  end; {try ...}
end;

function TCustomParser.WriteEndTag(const Content: WideString;
                                   const FirstLineNumber,
                                         LastLineNumber: integer;
                                   const RefNode: TdomNode): TdomElement;
var
  TagName,AttribSequence: Widestring;
begin
  if not (RefNode.nodeType = ntElement_Node)
    then raise EParserMissingStartTag_Err.create('Missing start tag error.');
  XMLAnalyseTag(content,TagName,AttribSequence);
  if AttribSequence <> ''
    then raise EParserInvalidEndTag_Err.create('Invalid end tag error.');
  if TagName <> RefNode.NodeName
    then raise EParserMissingStartTag_Err.create('Missing start tag error.');
  Result:= (RefNode as TdomElement);
end;

function TCustomParser.WriteCharRef(const Content: WideString;
                                    const FirstLineNumber,
                                          LastLineNumber: integer;
                                    const RefNode: TdomNode;
                                    const readonly: boolean): TdomText;
var
  value: wideString;
begin
  Result:= nil;
  try
    Value:= XmlCharRefToStr(content);
  except
    on EConvertError do
      raise EParserInvalidCharRef_Err.create('Invalid character reference error.');
  end;

  if RefNode.LastChild is TdomText
    then (RefNode.LastChild as TdomText).appendData(value)
    else begin
      try
        Result:= RefNode.OwnerDocument.CreateText(value);
        try
          RefNode.AppendChild(Result);
          Result.FIsReadonly:= readonly;
        except
          if assigned(Result.ParentNode)
            then Result.ParentNode.RemoveChild(Result);
          RefNode.OwnerDocument.FreeAllNodes(Result);
          raise;
        end; {try ...}
      except
        raise EParserInvalidCharacter_Err.create('Invalid character error.');
      end; {try ...}
    end;
end;

function TCustomParser.WriteEntityRef(const Content: WideString;
                                      const FirstLineNumber,
                                            LastLineNumber: integer;
                                      const RefNode: TdomNode;
                                      const readonly: boolean): TdomEntityReference;
var
  EntityName: WideString;
begin
  EntityName:= copy(content,2,length(content)-2);
  try
    Result:= RefNode.OwnerDocument.CreateEntityReference(EntityName);
    try
      RefNode.AppendChild(Result);
      Result.FIsReadonly:= readonly;
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      raise;
    end; {try ...}
  except
    raise EParserInvalidEntityName_Err.create('Invalid entity name error.');
  end; {try ...}
end;

function TCustomParser.WriteDoctype(const Content: WideString;
                                    const FirstLineNumber,
                                          LastLineNumber: integer;
                                    const RefNode: TdomNode): TdomDocumentType;
var
  DeclAnfg: integer;
  ExternalId,intro,name,SystemLiteral,PubidLiteral: WideString;
  NakedContent,data,dummy1,dummy2: WideString;
  Error, dummy: boolean;
begin
  if (RefNode.NodeType <> ntDocument_Node)
    or assigned((RefNode as TdomDocument).DocumentElement)
    then raise EParserWrongOrder_Err.create('Wrong order declaration error.');
  if assigned((RefNode as TdomDocument).Doctype)
    then raise EParserDoubleDoctype_Err.create('Double doctype declaration error.');
  if (copy(content,1,9) <> '<!DOCTYPE')
    or (content[length(content)] <> '>')
    or (not isXmlWhiteSpace(content[10]))
    then raise EParserInvalidDoctype_Err.create('invalid doctype declaration error.');
  NakedContent:= XmlTrunc(copy(content,11,length(content)-11));
  DeclAnfg:= Pos(WideString('['),NakedContent);
  if DeclAnfg = 0 then begin
    intro:= NakedContent;
    Data:= '';
  end else begin
    intro:= copy(NakedContent,1,DeclAnfg-1);
    dummy1:= copy(NakedContent,DeclAnfg,length(NakedContent)-DeclAnfg+1);
    XMLTruncAngularBrackets(dummy1,data,error); {Diese umständliche Zuweisung ist wegen Delphi-Problem von WideStrings bei copy nötig}
    if error then raise EParserInvalidDoctype_Err.create('invalid doctype declaration error.');
  end; {if ...}

  XMLAnalyseTag(intro,Name,ExternalId);
  if not IsXmlName(Name)
    then raise EParserInvalidDoctype_Err.create('invalid doctype declaration error.');

  dummy1:= XmlTrunc(ExternalId);
  ExternalId:= dummy1; {Diese umständliche Zuweisung ist wegen der Verwendung von WideStrings nötig}
  if ExternalId <> '' then begin
    XMLAnalyseEntityDef(ExternalId,dummy1,SystemLiteral,PubidLiteral,dummy2,Error);
    if Error or (dummy1 <> '') or (dummy2 <> '')
      then raise EParserInvalidDoctype_Err.create('invalid doctype declaration error.');
  end; {if ...}

  try
    Result:= RefNode.OwnerDocument.CreateDocumentType(Name,PubidLiteral,SystemLiteral);
    FIntSubset:= Data;
  except
    raise EParserInvalidDoctype_Err.create('invalid doctype declaration error.');
  end; {try ...}

  try
    dummy:= Result.FIsReadonly;
    Result.FIsReadonly:= false;
    RefNode.AppendChild(Result);
    Result.FIsReadonly:= dummy;
  except
    if assigned(Result.ParentNode)
      then Result.ParentNode.RemoveChild(Result);
    RefNode.OwnerDocument.FreeAllNodes(Result);
    raise EParserInvalidDoctype_Err.create('invalid doctype declaration error.');
  end; {try ...}
end;

function TCustomParser.WriteParameterEntityRef(const Content: WideString;
                                               const FirstLineNumber,
                                                     LastLineNumber: integer;
                                               const RefNode: TdomNode;
                                               const readonly: boolean): TdomParameterEntityReference;
var
  EntityName: WideString;
  ParEnt: TdomNode;
  PreviousFlagValue: boolean;
begin
  EntityName:= copy(content,2,length(content)-2);
  try
    Result:= RefNode.OwnerDocument.CreateParameterEntityReference(EntityName);
    try
      RefNode.AppendChild(Result);
      ParEnt:= RefNode.OwnerDocument.Doctype.ParameterEntities.GetNamedItem(EntityName);
      if not assigned(ParEnt)
        then raise EParserInvalidEntityName_Err.create('Invalid entity name error.');
      PreviousFlagValue:= FUseSpecifiedDocumentSC;
      FUseSpecifiedDocumentSC:= false;
      IntDtdWideStringToDom(concat(' ',ParEnt.FNodeValue,' '),Result,true); // xxx problems with external subset
      FUseSpecifiedDocumentSC:= PreviousFlagValue;
      Result.FIsReadonly:= readonly;
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      raise;
    end; {try ...}
  except
    raise EParserInvalidEntityName_Err.create('Invalid entity name error.');
  end; {try ...}
end;

function TCustomParser.WriteEntityDeclaration(const Content: WideString;
                                              const FirstLineNumber,
                                                    LastLineNumber: integer;
                                              const RefNode: TdomNode;
                                              const readonly: boolean): TdomCustomEntity;
var
  DeclCorpus,DeclName,EntityDef,EntityValue,SystemLiteral,PubidLiteral,NDataName: WideString;
  DeclTypus: TDomNodeType;
  dummy,analyzedEV: WideString;
  Error: boolean;
  newEntity: TdomEntity;
  newParameterEntity: TdomParameterEntity;
begin
  result:= nil;
  newEntity:= nil;
  if (copy(content,1,8) <> '<!ENTITY')
    or (content[length(content)] <> '>')
    or (length(content) < 14)
    or (not IsXmlWhiteSpace(content[9]))
    then raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
  DeclCorpus:= XMLTrunc(copy(content,10,length(content)-10));
  if DeclCorpus[1] = '%' then begin
    if not IsXmlWhiteSpace(DeclCorpus[2])
      then raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
    dummy:= XMLTrunc(copy(DeclCorpus,2,length(DeclCorpus)-1));
    DeclCorpus:= dummy;
    DeclTypus:= ntParameter_Entity_Declaration_Node;
  end else DeclTypus:= ntEntity_Declaration_Node;
  XMLAnalyseTag(DeclCorpus,DeclName,EntityDef);
  if not IsXmlName(DeclName)
    then raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
  XMLAnalyseEntityDef(EntityDef,EntityValue,SystemLiteral,PubidLiteral,NDataName,Error);
  if Error then raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
  if (DeclTypus = ntParameter_Entity_Declaration_Node) and (NDataName <> '')
    then raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');

  try
    if (DeclTypus = ntEntity_Declaration_Node) then begin
      Result:= RefNode.OwnerDocument.CreateEntityDeclaration(DeclName,EntityValue,PubidLiteral,SystemLiteral,NDataName);
      try
        with RefNode.OwnerDocument do begin
          if assigned(Doctype.Entities.GetNamedItem(DeclName)) then
            FErrorList.Add(TXmlParserError.Create('Double_Entity_Decl_Warning',LastLineNumber,LastLineNumber,DeclName,Language))
          else begin
            newEntity:= CreateEntity(DeclName,PubidLiteral,SystemLiteral,NDataName);
            If Result.IsInternalEntity
              then DocWideStringToDom(EntityValue,newEntity,true);
            Doctype.Entities.SetNamedItem(newEntity);
          end;
        end;
        RefNode.AppendChild(Result);
        Result.FIsReadonly:= readonly;
      except
        if assigned(newEntity)
          then RefNode.OwnerDocument.FreeAllNodes(newEntity);
        raise;
      end; {try ...}
    end else begin
      Result:= RefNode.OwnerDocument.CreateParameterEntityDeclaration(DeclName,EntityValue,PubidLiteral,SystemLiteral);
      with RefNode.OwnerDocument do begin
        if assigned(Doctype.ParameterEntities.GetNamedItem(DeclName)) then
          FErrorList.Add(TXmlParserError.Create('Double_Entity_Decl_Warning',LastLineNumber,LastLineNumber,DeclName,Language))
        else begin
          newParameterEntity:= CreateParameterEntity(DeclName,PubidLiteral,SystemLiteral);
          Doctype.ParameterEntities.SetNamedItem(newParameterEntity);
          If Result.IsInternalEntity then begin
            analyzedEV:= RefNode.OwnerDocument.Doctype.analyzeEntityValue(EntityValue);
            newParameterEntity.FNodeValue:= analyzedEV;
          end;
        end;
      end;
      RefNode.AppendChild(Result);
    end;
  except
    if assigned(result) then begin
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      refNode.OwnerDocument.FreeAllNodes(Result);
    end;
    raise EParserInvalidEntityDeclaration_Err.create('Invalid entity declaration error.');
  end; {try ...}
end;

function TCustomParser.WriteElementDeclaration(const Content: WideString;
                                               const FirstLineNumber,
                                                     LastLineNumber: integer;
                                               const RefNode: TdomNode;
                                               const readonly: boolean): TdomElementTypeDeclaration;
var
  DeclCorpus,DeclName,ContentSpec: WideString;
  dummy: WideString;
  ContspecType: TdomContentspecType;
begin
  if length(content) < 16
    then raise EParserInvalidElementDeclaration_Err.create('Invalid element declaration error.');
  if (copy(content,1,9) <> '<!ELEMENT')
     or (content[length(content)] <> '>')
     or (not IsXmlWhiteSpace(content[10]))
    then raise EParserInvalidElementDeclaration_Err.create('Invalid element declaration error.');

  DeclCorpus:= XMLTrunc(copy(content,11,length(content)-11));
  XMLAnalyseTag(DeclCorpus,DeclName,ContentSpec);
  if not IsXmlName(DeclName)
    then raise EParserInvalidElementDeclaration_Err.create('Invalid element declaration error.');

  dummy:= XMLTrunc(ContentSpec);
  ContentSpec:= dummy;
  ContspecType:= ctChildren;
  if ContentSpec = 'EMPTY'
    then ContspecType:= ctEmpty
    else if ContentSpec = 'ANY'
      then ContspecType:= ctAny
      else if pos('#PCDATA',ContentSpec) > 0
        then ContspecType:= ctMixed;
  try
    Result:= RefNode.OwnerDocument.CreateElementTypeDeclaration(DeclName,ContspecType);
    try
      RefNode.AppendChild(Result);
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      raise;
    end; {try ...}
  except
    raise EParserInvalidElementDeclaration_Err.create('Invalid element declaration error.');
  end; {try ...}
  try
    case ContspecType of
      ctMixed: InsertMixedContent(Result,ContentSpec,readonly);
      ctChildren: InsertChildrenContent(Result,ContentSpec,readonly);
    end; {case ...}
  except
    RefNode.RemoveChild(Result);
    RefNode.OwnerDocument.FreeAllNodes(Result);
    raise EParserInvalidElementDeclaration_Err.create('Invalid element declaration error.');
  end; {try ...}
  Result.FIsReadonly:= readonly;
end;

function TCustomParser.WriteAttributeDeclaration(const Content: WideString;
                                                 const FirstLineNumber,
                                                       LastLineNumber: integer;
                                                 const RefNode: TdomNode;
                                                 const readonly: boolean): TdomAttrList;
var
  DeclCorpus,DeclName,ContentSpec: WideString;
  dummy,AttDefName,AttType,Bracket,DefaultDecl,AttValue,Rest: WideString;
  newAttDef: TdomAttrDefinition;
  SucessfullyWriten: boolean;
begin
  if length(Content) < 12
    then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
  if (copy(Content,1,9) <> '<!ATTLIST')
     or (Content[length(Content)] <> '>')
     or (not IsXmlWhiteSpace(Content[10]))
    then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');

  DeclCorpus:= XMLTrunc(copy(Content,11,length(Content)-11));
  XMLAnalyseTag(DeclCorpus,DeclName,ContentSpec);
  if not IsXmlName(DeclName)
    then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');

  try
    Result:= RefNode.OwnerDocument.CreateAttributeList(DeclName);
    try
      RefNode.AppendChild(Result);
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      raise;
    end; {try ...}
  except
    raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
  end; {try ...}

  dummy:= XMLTrunc(ContentSpec);
  ContentSpec:= dummy;

  while ContentSpec <> '' do begin
    FindNextAttDef(ContentSpec,AttDefName,AttType,Bracket,
                   DefaultDecl,AttValue,Rest);
    try
      newAttDef:= RefNode.OwnerDocument.CreateAttributeDefinition(AttDefName,AttType,DefaultDecl,AttValue);
      try
        if Bracket <> ''
          then if AttType = 'NOTATION'
            then InsertNotationTypeContent(newAttDef,Bracket,readonly)
            else InsertEnumerationContent(newAttDef,Bracket,readonly);
      except
        RefNode.OwnerDocument.FreeAllNodes(newAttDef);
        raise;
      end; {try ...}
    except
      raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    end; {try ...}

    SucessfullyWriten:= Result.SetAttributeDefinitionNode(newAttDef);
    if not SucessfullyWriten then RefNode.OwnerDocument.FreeAllNodes(newAttDef); {Schon Attribute mit demselben Namen vorhanden, dann nicht einfügen, sondern wieder löschen.}
    ContentSpec:= Rest;
  end; {while ...}
  Result.FIsReadonly:= readonly;
end;

function TCustomParser.WriteNotationDeclaration(const Content: WideString;
                                                const FirstLineNumber,
                                                      LastLineNumber: integer;
                                                const RefNode: TdomNode;
                                                const readonly: boolean): TdomNotationDeclaration;
var
  DeclCorpus,DeclName,ContentSpec,SystemLiteral,PubidLiteral: WideString;
  Error: boolean;
  newNotation: TdomNotation;
begin
  newNotation:= nil;
  if length(Content) < 22
    then raise EParserInvalidNotationDeclaration_Err.create('Invalid notation declaration error.');
  if (copy(Content,1,10) <> '<!NOTATION')
     or (Content[length(Content)] <> '>')
     or (not IsXmlWhiteSpace(Content[11]))
    then raise EParserInvalidNotationDeclaration_Err.create('Invalid notation declaration error.');
  DeclCorpus:= XMLTrunc(copy(Content,12,length(Content)-12));
  XMLAnalyseTag(DeclCorpus,DeclName,ContentSpec);
  if not IsXmlName(DeclName)
    then raise EParserInvalidNotationDeclaration_Err.create('Invalid notation declaration error.');
  XMLAnalyseNotationDecl(ContentSpec,SystemLiteral,PubidLiteral,Error);
  if Error then raise EParserInvalidNotationDeclaration_Err.create('Invalid notation declaration error.');
  try
    Result:= RefNode.OwnerDocument.CreateNotationDeclaration(DeclName,PubidLiteral,SystemLiteral);
    try
      with RefNode.OwnerDocument do begin
        if assigned(Doctype.Notations.GetNamedItem(DeclName)) then
          FErrorList.Add(TXmlParserError.Create('Double_Notation_Decl_Warning',LastLineNumber,LastLineNumber,DeclName,Language))
        else begin
          newNotation:= CreateNotation(DeclName,PubidLiteral,SystemLiteral);
          Doctype.Notations.SetNamedItem(newNotation);
        end;
      end;
      RefNode.AppendChild(Result);
      Result.FIsReadonly:= readonly;
    except
      if assigned(Result.ParentNode)
        then Result.ParentNode.RemoveChild(Result);
      RefNode.OwnerDocument.FreeAllNodes(Result);
      if assigned(newNotation.ParentNode) then
          RefNode.OwnerDocument.Doctype.Notations.removeItem(newNotation);
      if assigned(newNotation)
        then RefNode.OwnerDocument.FreeAllNodes(newNotation);
      raise;
    end; {try ...}
  except
    raise EParserInvalidNotationDeclaration_Err.create('Invalid notation declaration error.');
  end; {try ...}
end;

function TCustomParser.WriteConditionalSection(const Content: WideString;
                                               const FirstLineNumber,
                                                     LastLineNumber: integer;
                                               const RefNode: TdomNode;
                                               const readonly: boolean): TdomConditionalSection;
var
  declaration: WideString;
  IncludeStmt: WideString;
  i,nr1,nr2: longint;
begin
  nr1:= 0;
  nr2:= 0;
  for i:= 1 to length(content) do begin
    if content[i] = '[' then begin
      if nr1 = 0 then nr1:= i else nr2:= i;
    end;
    if nr2 > 0 then break;
  end;
  if nr2 = 0 then raise EParserInvalidConditionalSection_Err.create('invalid conditional section error.');
  if (copy(content,1,3) <> '<![') then raise EParserInvalidConditionalSection_Err.create('invalid conditional section error.');
  if (copy(content,length(content)-2,3) <> ']]>') then raise EParserInvalidConditionalSection_Err.create('invalid conditional section error.');

  IncludeStmt:= XmlTrunc(copy(content,4,nr2-4));
  if not ( IsXmlPEReference(IncludeStmt)
           or (IncludeStmt = 'INCLUDE')
           or (IncludeStmt = 'IGNORE') ) then raise EParserInvalidConditionalSection_Err.create('invalid conditional section error.');

  declaration:= XmlTrunc(copy(content,nr2+1,length(content)-nr2-3));

  try
    Result:= RefNode.OwnerDocument.CreateConditionalSection(IncludeStmt);
  except
    raise EParserInvalidConditionalSection_Err.create('invalid conditional section error.');
  end; {try ...}

  try
    if (IncludeStmt = 'INCLUDE') and (declaration <> '')
      then ExtDtdWideStringToDom(declaration,Result,readonly);
  except
    RefNode.OwnerDocument.FreeAllNodes(Result);
    raise;
  end; {try ...}

  try
    RefNode.AppendChild(Result);
    Result.FIsReadonly:= readonly;
  except
    if assigned(Result.ParentNode)
      then Result.ParentNode.RemoveChild(Result);
    RefNode.OwnerDocument.FreeAllNodes(Result);
    raise EParserInvalidConditionalSection_Err.create('invalid conditional section error.');
  end; {try ...}
end;

procedure TCustomParser.InsertMixedContent(const RefNode: TdomNode;
                                           const ContentSpec: WideString;
                                           const readonly: boolean);
var
  freq, dummy, content,piece: WideString;
  separator: integer;
  Error: boolean;
  newNode: TdomNode;
begin
  content:= XMLTrunc(ContentSpec);
  Freq:= '';
  if (content[length(content)] = '*') then begin
    Freq:= '*';
    dummy:= copy(content,1,length(content)-1);
    content:= dummy;
  end;
  XMLTruncRoundBrackets(content,dummy,Error);
  if Error or (dummy = '')
    then raise EParserException.create('Parser error.');
  content:= dummy;
  newNode:= RefNode.AppendChild(RefNode.OwnerDocument.CreatePcdataChoiceParticle);
  newNode.FIsReadonly:= readonly;
  if content = '#PCDATA' then exit;
  if freq = '' then raise EParserException.create('Parser error.');
  separator:= pos(WideString('|'),content);
  if separator = 0 then raise EParserException.create('Parser error.');
  dummy:= XMLTrunc(copy(content,separator+1,length(content)-separator));
  content:= dummy;
  while content <> '' do begin
    separator:= pos(WideString('|'),content);
    if separator = 0 then begin
      piece:= content;
      content:= '';
    end else begin
      piece:= XMLTrunc(copy(content,1,separator-1));
      dummy:= XMLTrunc(copy(content,separator+1,length(content)-separator));
      content:= dummy;
      if content = '' then raise EParserException.create('Parser error.');
    end; {if ...}
    if not IsXmlName(piece) then raise EParserException.create('Parser error.');
    newNode.AppendChild(newNode.OwnerDocument.CreateElementParticle(piece,''));
    newNode.FIsReadonly:= readonly;
  end; {while ...}
end;

procedure TCustomParser.InsertChildrenContent(const RefNode: TdomNode;
                                              const ContentSpec: WideString;
                                              const readonly: boolean);
var
  piece,dummy,content,freq: WideString;
  SeparatorChar: WideChar;
  j,i,bracketNr: integer;
  newNode: TdomNode;
  Error: boolean;
begin
  content:= XMLTrunc(ContentSpec);
  Freq:= '';
  if (content[length(content)] = '?') or
     (content[length(content)] = '*') or
     (content[length(content)] = '+') then begin
    Freq:= content[length(content)];
    dummy:= copy(content,1,length(content)-1);
    content:= dummy;
  end;
  XMLTruncRoundBrackets(content,dummy,Error);
  if Error or (dummy = '')
    then raise EParserException.create('Parser error.');
  content:= dummy;

  bracketNr:= 0;
  SeparatorChar:= ',';
  for i:= 1 to length(content) do begin
    if (content[i] = ',') and (bracketNr = 0) then begin
      SeparatorChar:= ',';
      break;
    end; {if ...}
    if (content[i] = '|') and (bracketNr = 0) then begin
      SeparatorChar:= '|';
      break;
    end; {if ...}
    if content[i] = '(' then inc(bracketNr);
    if content[i] = ')' then begin
      if bracketNr = 0 then raise EParserException.create('Parser error.');
      dec(bracketNr);
    end;
  end; {for ...}

  if SeparatorChar = ','
    then newNode:= RefNode.AppendChild(RefNode.OwnerDocument.CreateSequenceParticle(Freq))
    else newNode:= RefNode.AppendChild(RefNode.OwnerDocument.CreateChoiceParticle(Freq));
  newNode.FIsReadonly:= readonly;

  bracketNr:= 0;
  i:= 0;
  j:= 1;
  while i < length(content) do begin
    inc(i);
    if content[i] = '(' then inc(bracketNr);
    if content[i] = ')' then begin
      if bracketNr = 0 then raise EParserException.create('Parser error.');
      dec(bracketNr);
    end;
    if ((content[i] = SeparatorChar) and (bracketNr = 0)) or
       (i = length(content)) then begin
      if bracketNr > 0 then raise EParserException.create('Parser error.');
      if i = length(content)
        then piece:= XmlTrunc(copy(content,j,i+1-j))
        else piece:= XmlTrunc(copy(content,j,i-j));
      j:= i+1;

      if piece[1] = '(' then begin
        InsertChildrenContent(NewNode,piece,readonly);
      end else begin
        Freq:= '';
        if (piece[length(piece)] = '?') or
           (piece[length(piece)] = '*') or
           (piece[length(piece)] = '+') then begin
          Freq:= piece[length(piece)];
          dummy:= copy(piece,1,length(piece)-1);
          piece:= dummy;
        end;
        if not IsXmlName(piece)
          then raise EParserException.create('Parser error.');
        NewNode.AppendChild(RefNode.OwnerDocument.CreateElementParticle(piece,Freq));
        newNode.FIsReadonly:= readonly;
      end; {if ...}

    end; {if ...}
  end; {while ...}

end;

procedure TCustomParser.InsertNotationTypeContent(const RefNode: TdomNode;
                                                  const ContentSpec: WideString;
                                                  const readonly: boolean);
var
  dummy,content,piece: WideString;
  separator: integer;
  Error: boolean;
  newNode: TdomNode;
begin
  XMLTruncRoundBrackets(ContentSpec,content,Error);
  if Error then raise EParserException.create('Parser error.');
  while content <> '' do begin
    separator:= pos(WideString('|'),content);
    if separator = 0 then begin
      piece:= content;
      content:= '';
    end else begin
      piece:= XMLTrunc(copy(content,1,separator-1));
      dummy:= XMLTrunc(copy(content,separator+1,length(content)-separator));
      content:= dummy;
      if content = '' then raise EParserException.create('Parser error.');
    end; {if ...}
    if not IsXmlName(piece) then raise EParserException.create('Parser error.');
    newNode:= RefNode.AppendChild(RefNode.OwnerDocument.CreateElementParticle(piece,''));
    newNode.FIsReadonly:= readonly;
  end; {while ...}
end;

procedure TCustomParser.InsertEnumerationContent(const RefNode: TdomNode;
                                                 const ContentSpec: WideString;
                                                 const readonly: boolean);
var
  dummy,content,piece: WideString;
  separator: integer;
  Error: boolean;
  newNode: TdomNode;
begin
  XMLTruncRoundBrackets(ContentSpec,content,Error);
  if Error then raise EParserException.create('Parser error.');
  while content <> '' do begin
    separator:= pos(WideString('|'),content);
    if separator = 0 then begin
      piece:= content;
      content:= '';
    end else begin
      piece:= XMLTrunc(copy(content,1,separator-1));
      dummy:= XMLTrunc(copy(content,separator+1,length(content)-separator));
      content:= dummy;
      if content = '' then raise EParserException.create('Parser error.');
    end; {if ...}
    if not IsXmlNmtoken(piece) then raise EParserException.create('Parser error.');
    newNode:= RefNode.AppendChild(RefNode.OwnerDocument.CreateNametoken(piece));
    newNode.FIsReadonly:= readonly;
  end; {while ...}
end;

procedure TCustomParser.FindNextAttDef(const Decl: WideString;
                                         var Name,
                                             AttType,
                                             Bracket,
                                             DefaultDecl,
                                             AttValue,
                                             Rest: WideString);
var
  i,j: integer;
  FindBracket, FindDefaultDecl, FindAttValue: boolean;
  QuoteType: WideChar;
begin
  Name:= '';
  AttType:= '';
  Bracket:= '';
  DefaultDecl:= '';
  AttValue:= '';
  Rest:= '';
  FindBracket:= false;
  FindDefaultDecl:= false;
  FindAttValue:= false;

  if Length(Decl) = 0
    then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
  i:= 1;

  {White-space?}
  while IsXmlWhiteSpace(Decl[i]) do begin
    inc(i);
    if i > length(Decl)
      then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
  end;
  j:= i;

  {Name?}
  while not IsXmlWhiteSpace(Decl[i]) do begin
    inc(i);
    if i > length(Decl)
      then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
  end;
  Name:= copy(Decl,j,i-j);

  {White-space?}
  while IsXmlWhiteSpace(Decl[i]) do begin
    inc(i);
    if i > length(Decl) 
      then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
  end;
  j:= i;

  if Decl[j] = '(' then FindBracket:= true;

  {AttType?}
  if not FindBracket then begin
    while not IsXmlWhiteSpace(Decl[i]) do begin
      inc(i);
      if i > length(Decl)
        then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    end;
    AttType:= copy(Decl,j,i-j);
    if AttType = 'NOTATION' then FindBracket:= true;

    {White-space?}
    while IsXmlWhiteSpace(Decl[i]) do begin
      inc(i);
      if i > length(Decl)
        then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    end;
    j:= i;
  end; {if ...}

  {Bracket?}
  if FindBracket then begin
    if Decl[j] <> '('
      then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    while not (Decl[i] = ')') do begin
      inc(i);
      if i >= length(Decl) 
        then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    end;
    Bracket:= copy(Decl,j,i-j+1);

    {White-space?}
    inc(i);
    if not IsXmlWhiteSpace(Decl[i])
      then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    while IsXmlWhiteSpace(Decl[i]) do begin
      inc(i);
      if i > length(Decl) 
        then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    end;
    j:= i;
  end; {if ...}

  if Decl[j] = '#'
    then FindDefaultDecl:= true
    else FindAttValue:= true;

  {DefaultDecl?}
  if FindDefaultDecl then begin
    while not IsXmlWhiteSpace(Decl[i]) do begin
      inc(i);
      if i > length(Decl) then break;
    end; {while ...}
    DefaultDecl:= copy(Decl,j,i-j);
    if DefaultDecl = '#FIXED' then begin
      FindAttValue:= true;
      {White-space?}
      if i > length(Decl)
        then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
      while IsXmlWhiteSpace(Decl[i]) do begin
        inc(i);
        if i > length(Decl)
          then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
      end; {while ...}
      j:= i;
    end; {if ...}
  end; {if ...}

  {AttValue?}
  if FindAttValue then begin
    if i = length(Decl)
      then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    QuoteType:= Decl[i];
    if not ( (QuoteType = '"') or (QuoteType = #$0027))
      then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    inc(i);
    while not (Decl[i] = QuoteType) do begin
      inc(i);
      if i > length(Decl)
        then raise EParserInvalidAttributeDeclaration_Err.create('Invalid attribute declaration error.');
    end; {while ...}
    AttValue:= copy(Decl,j+1,i-j-1);
    inc(i);
  end; {if ...}

  Rest:= copy(Decl,i,length(Decl)-i+1);
end;

procedure TCustomParser.DocToXmlSourceCode(const InputSource :TXmlInputSource;
                                           const Source: TXmlSourceCode);
const
  SingleQuote: WideChar = #39; // code of '
  DoubleQuote: WideChar = #34; // code of "
  MaxCode: array[1..6] of integer = ($7F,$7FF,$FFFF,$1FFFFF,$3FFFFFF,$7FFFFFFF);
var
  str0: Char;
  str1: WideChar;
  subEndMarker,SubStartMarker: WideString;
  SingleQuoteOpen,DoubleQuoteOpen,BracketOpened: boolean;
  StreamSize: longint;
  PieceType: TdomPieceType;
  newSourceCodePiece: TXmlSourceCodePiece;
  content: TdomCustomStr;
  CharSize, ucs4, mask: integer;
  first: char;
begin
  subEndMarker:= '';
  subStartMarker:= '';
  BracketOpened:= false;
  Source.clearAndFree;
  content:= TdomCustomStr.create;
  with inputSource do begin
    try
      StreamSize:= Stream.Size; // buffer storage to increase performance
      while Stream.Position < StreamSize do begin
        SingleQuoteOpen:= false;
        DoubleQuoteOpen:= false;
        content.reset;
        PieceType:= xmlPCData;
        while Stream.Position < StreamSize do begin
          case Encoding of
            etUTF8: begin
              Stream.ReadBuffer(str0,1);
              if ord(str0)>=$80 then	// UTF-8 sequence
              begin
                try
                  CharSize:=1;
                  first:=str0; mask:=$40; ucs4:=ord(str0);
                  if (ord(str0) and $C0<>$C0) then
                    raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                  while (mask and ord(first)<>0) do
                  begin
                    // read next character of stream
                    if Stream.Position=StreamSize then
                      raise EConvertError.CreateFmt('Aborted UTF-8 sequence at position %d',[Stream.Position]);
                    Stream.ReadBuffer(str0,1);
                    if (ord(str0) and $C0<>$80) then
                      raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                    ucs4:=(ucs4 shl 6) or (ord(str0) and $3F); // add bits to result
                    Inc(CharSize);	// increase sequence length
                    mask:=mask shr 1;	// adjust mask
                  end;
                  if (CharSize>6) then	// no 0 bit in sequence header 'first'
                      raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                  ucs4:=ucs4 and MaxCode[CharSize];	// dispose of header bits
                  // check for invalid sequence as suggested by RFC2279
                  if ((CharSize>1) and (ucs4<=MaxCode[CharSize-1])) then
                      raise EConvertError.CreateFmt('Invalid UTF-8 encoding at position %d',[Stream.Position-1]);
                  if (ucs4>=$10000) then
                  begin
                    // add high surrogate to content as if it was processed earlier
                    Content.addWideChar(Utf16HighSurrogate(ucs4));
                    // assign low surrogate to str1
                    str1:=Utf16LowSurrogate(ucs4);
                  end
                  else
                    str1:= WideChar(ord(ucs4));
                except
                  on E: EConvertError do begin
                    content.AddWideChar(WideChar(ord(str0)));
                    PieceType:= xmlCharacterError;
                  end; {on ...}
                end; {try ...}
                if PieceType = xmlCharacterError then break;
              end
              else
                str1:= WideChar(ord(str0));
            end;
            etMBCS : str1:=ReadWideCharFromMBCSStream(Stream);
            etUTF16BE: begin
              Stream.ReadBuffer(str1,2);
            end;
            etUTF16LE: begin
              Stream.ReadBuffer(str1,2);
              str1:= wideChar(Swap(ord(str1)));
            end;
          end; {case ...}

          if not IsXmlChar(str1) then begin
            content.AddWideChar(str1);
            PieceType:= xmlCharacterError;
            break;
          end;

          case PieceType of

            xmlPCData: begin
              if (str1 = '<') or (str1 = '&') then begin
                if content.length = 0 then begin
                  if str1 = '<' then begin
                    PieceType:= xmlStartTag;
                  end else
                  if str1 = '&' then PieceType:= xmlEntityRef;
                  content.AddWideChar(Str1);
                end else begin {if length(content) = 0}
                  case Encoding of
                    etUTF8,etMBCS: Stream.Seek(-1,soFromCurrent);
                    etUTF16BE,etUTF16LE: Stream.Seek(-2,soFromCurrent);
                  end; {case ...}
                  break;
                end; {if length(content) = 0}
              end else  {if (str1 = '<') ...}
                content.AddWideChar(str1);
            end;

            xmlEntityRef: begin
              content.AddWideChar(str1);
              if str1 = ';' then begin
                if content.value[2] = wideChar('#')
                  then PieceType:= xmlCharRef;
                break;
              end;
            end;

            xmlStartTag: begin
              content.AddWideChar(str1);
              case content.length of
                2: if content.value = '<?' then PieceType:= xmlProcessingInstruction;
                4: if content.value = '<!--' then PieceType:= xmlComment;
                9: if content.value = '<![CDATA[' then begin
                     PieceType:= xmlCDATA;
                   end else
                   if content.value = '<!DOCTYPE' then begin
                     PieceType:= xmlDoctype;
                     subEndMarker:= '';
                     subStartMarker:= '';
                     BracketOpened:= false;
                   end;
              end;

              {Count quotation marks:}
              if (str1 = SingleQuote) and (not DoubleQuoteOpen) then begin
                SingleQuoteOpen:= not SingleQuoteOpen;
              end else if (str1 = DoubleQuote) and (not SingleQuoteOpen) then begin
                DoubleQuoteOpen:= not DoubleQuoteOpen;
              end else if str1 = '>' then begin
                if (not DoubleQuoteOpen) and (not SingleQuoteOpen) then begin
                  if (Copy(content.value,1,2) = '</')
                    then PieceType:= xmlEndTag
                  else begin if (Copy(content.value,content.length-1,2) = '/>')
                    then PieceType:= xmlEmptyElementTag;
                  end;
                  break;
                end;
              end;
            end;

            xmlProcessingInstruction: begin
              content.AddWideChar(str1);
              if str1 = '>' then
                if content.value[content.length-1] = '?' then begin
                  if (content.length > 5) then
                    if IsXmlWhiteSpace(content.value[6]) then
                      if (Copy(content.value,1,5) = '<?xml')
                        then PieceType:= xmlXmlDeclaration;
                  break;
                end;
            end;

            xmlComment: begin
              content.AddWideChar(str1);
              if str1 = '>' then
                if content.value[content.length-1] = '-' then
                  if content.value[content.length-2] = '-' then
                    if content.length > 6 then break;
            end;

            xmlCDATA: begin
              content.AddWideChar(str1);
              if str1 = '>' then
                if content.value[content.length-1] = ']' then
                  if content.value[content.length-2] = ']' then break;
            end;

            xmlDoctype: begin
              content.AddWideChar(str1);
              if (SubEndMarker = '') then begin

                if (str1 = SingleQuote) and (not DoubleQuoteOpen) then begin
                  if SingleQuoteOpen
                    then SingleQuoteOpen:= false
                    else SingleQuoteOpen:= true;
                end else if (str1 = DoubleQuote) and (not SingleQuoteOpen) then begin
                  if DoubleQuoteOpen
                    then DoubleQuoteOpen:= false
                    else DoubleQuoteOpen:= true;
                end;

                if BracketOpened then begin
                  if not (SingleQuoteOpen or DoubleQuoteOpen) then begin
                    if str1 = '<' then begin
                      SubStartMarker:= '<';
                    end else if (str1 = '!') and (SubStartMarker = '<') then begin
                      SubStartMarker:= '<!';
                    end else if (str1 = '?') and (SubStartMarker = '<') then begin
                      SubStartMarker:= '';
                      SubEndMarker:= '?>';
                    end else if (str1 = '-') and (SubStartMarker = '<!')then begin
                      SubStartMarker:= '<!-';
                    end else if (str1 = '-') and (SubStartMarker = '<!-')then begin
                      SubStartMarker:= '';
                      SubEndMarker:= '-->';
                    end else if SubStartMarker <> '' then begin
                      SubStartMarker:= '';
                    end;
                    if (str1 = ']')
                      and (not SingleQuoteOpen)
                      and (not DoubleQuoteOpen)
                      then BracketOpened:= false;
                  end; {if not ...}
                end else begin {if BracketOpened ... }
                  if (str1 = '[')
                    and (not SingleQuoteOpen)
                    and (not DoubleQuoteOpen) then BracketOpened:= true;
                end; {if BracketOpened ... else ...}

              end else begin; {if (SubEndMarker = '') ...}
                if (Copy(content.value,content.length-Length(SubEndMarker)+1,Length(SubEndMarker))
                  = SubEndMarker)
                  then SubEndMarker:= '';
              end; {if (SubEndMarker = '') ... else ...}

              if (not DoubleQuoteOpen)
                and (not SingleQuoteOpen)
                and (not BracketOpened)
                and (SubEndMarker = '')
                and (str1 = '>')
                then break;
            end; {xmlDoctype: ...}
          end; {case ...}
        end; {while ...}

        newSourceCodePiece:= TXmlSourceCodePiece.create(PieceType);
        newSourceCodePiece.text:= NormalizeLineBreaks(content.value);
        Source.Add(newSourceCodePiece);

      end; {while ...}
    finally
      content.free;
    end;
  end; {with inputSource ...}
end;


procedure TCustomParser.ExtDtdToXmlSourceCode(const InputSource: TXmlInputSource;
                                              const Source: TXmlSourceCode);
const
  SingleQuote: WideChar = #39; // code of '
  DoubleQuote: WideChar = #34; // code of "
  MaxCode: array[1..6] of integer = ($7F,$7FF,$FFFF,$1FFFFF,$3FFFFFF,$7FFFFFFF);
var
  str0: Char;
  str1: WideChar;
  subEndMarker,SubStartMarker: WideString;
  SingleQuoteOpen,DoubleQuoteOpen,commentActive: boolean;
  StreamSize,condSectCounter: longint;
  PieceType: TdomPieceType;
  newSourceCodePiece: TXmlSourceCodePiece;
  content: TdomCustomStr;
  CharSize, ucs4, mask: integer;
  first: char;
begin
  subEndMarker:= '';
  subStartMarker:= '';
  commentActive:= false;
  condSectCounter:= 0;
  Source.clearAndFree;
  content:= TdomCustomStr.create;
  with InputSource do begin
    try
      StreamSize:= Stream.Size; // buffer storage to increase performance
      while Stream.Position < StreamSize do begin
        SingleQuoteOpen:= false;
        DoubleQuoteOpen:= false;
        Content.reset;
        PieceType:= xmlPCData;
        while Stream.Position < StreamSize do begin
          case Encoding of
            etUTF8: begin
              Stream.ReadBuffer(str0,1);
              if ord(str0)>=$80 then	// UTF-8 sequence
              begin
                try
                  CharSize:=1;
                  first:=str0; mask:=$40; ucs4:=ord(str0);
                  if (ord(str0) and $C0<>$C0) then
                    raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                  while (mask and ord(first)<>0) do
                  begin
                    // read next character of stream
                    if Stream.Position=StreamSize then
                      raise EConvertError.CreateFmt('Aborted UTF-8 sequence at position %d',[Stream.Position]);
                    Stream.ReadBuffer(str0,1);
                    if (ord(str0) and $C0<>$80) then
                      raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                    ucs4:=(ucs4 shl 6) or (ord(str0) and $3F); // add bits to result
                    Inc(CharSize);	// increase sequence length
                    mask:=mask shr 1;	// adjust mask
                  end;
                  if (CharSize>6) then	// no 0 bit in sequence header 'first'
                      raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                  ucs4:=ucs4 and MaxCode[CharSize];	// dispose of header bits
                  // check for invalid sequence as suggested by RFC2279
                  if ((CharSize>1) and (ucs4<=MaxCode[CharSize-1])) then
                      raise EConvertError.CreateFmt('Invalid UTF-8 encoding at position %d',[Stream.Position-1]);
                  if (ucs4>=$10000) then
                  begin
                    // add high surrogate to content as if it was processed earlier
                    Content.addWideChar(Utf16HighSurrogate(ucs4));
                    // assign low surrogate to str1
                    str1:=Utf16LowSurrogate(ucs4);
                  end
                  else
                    str1:= WideChar(ord(ucs4));
                except
                  on E: EConvertError do begin
                    content.AddWideChar(WideChar(ord(str0)));
                    PieceType:= xmlCharacterError;
                  end; {on ...}
                end; {try ...}
                if PieceType = xmlCharacterError then break;
              end
              else
                str1:= WideChar(ord(str0));
            end;
            // add by hyl
            etMBCS : str1:=ReadWideCharFromMBCSStream(Stream);
            // end add
            etUTF16BE: begin
              Stream.ReadBuffer(str1,2);
            end;
            etUTF16LE: begin
              Stream.ReadBuffer(str1,2);
              str1:= wideChar(Swap(ord(str1)));
            end;
          end; {case ...}

          if not IsXmlChar(str1) then begin
            content.addWideChar(str1);
            PieceType:= xmlCharacterError;
            break;
          end;

          if PieceType = xmlPCData then begin
            if str1 = '<' then begin
              PieceType:= xmlStartTag;
            end else
            if str1 = '%' then begin
              PieceType:= xmlParameterEntityRef;
            end else
            if not IsXmlWhiteSpace(str1) then begin;
              content.addWideChar(str1);
              PieceType:= xmlCharacterError;
              break;
            end;
          end; {if ...}

          case PieceType of

            xmlParameterEntityRef: begin
              content.addWideChar(str1);
              if str1 = ';' then break;
            end;

            xmlStartTag: begin
              content.addWideChar(str1);
              case content.length of
                2: if content.value = '<?' then PieceType:= xmlProcessingInstruction;
                3: if content.value = '<![' then begin
                     PieceType:= xmlCondSection;
                     condSectCounter:= 1;
                     commentActive:= false;
                   end;
                4: if content.value = '<!--' then PieceType:= xmlComment;
                8: if content.value = '<!ENTITY' then PieceType:= xmlEntityDecl;
                9: if content.value = '<!ELEMENT' then PieceType:= xmlElementDecl
                   else if content.value = '<!ATTLIST' then PieceType:= xmlAttributeDecl;
               10: if content.value = '<!NOTATION' then PieceType:= xmlNotationDecl;
              end;

            end;

            xmlProcessingInstruction: begin
              content.addWideChar(str1);
              if str1 = '>' then
                if content.value[content.length-1] = '?' then begin
                  if (content.length > 5) then
                    if IsXmlWhiteSpace(content.value[6]) then
                      if (Copy(content.value,1,5) = '<?xml')
                        then PieceType:= xmlTextDeclaration;
                  break;
                end;
            end;

            xmlCondSection: begin
              content.addWideChar(str1);

              if str1 = '[' then begin
                if content.value[content.length-1] = '!' then
                  if content.value[content.length-2] = '<' then
                    if not commentActive then inc(condSectCounter);
              end else if str1 = '>' then begin
                if content.value[content.length-1] = ']' then
                  if content.value[content.length-2] = ']' then
                    if not commentActive then dec(condSectCounter);
              end;

              if commentActive then begin
                if str1 = '>' then
                  if content.value[content.length-1] = '-' then
                    if content.value[content.length-2] = '-' then
                      if not ( (content.value[content.length-3] = '!')
                               and (content.value[content.length-4] = '<') ) then
                        if not ( (content.value[content.length-3] = '-')
                                  and (content.value[content.length-4] = '!')
                                  and (content.value[content.length-5] = '<') )
                          then commentActive:= false;
              end else begin
                if str1 = '-' then
                  if content.value[content.length-1] = '-' then
                    if content.value[content.length-2] = '!' then
                      if content.value[content.length-3] = '<'
                        then commentActive:= true;
              end;

              if condSectCounter = 0 then break;
            end;

            xmlComment: begin
              content.addWideChar(str1);
              if str1 = '>' then
                if content.value[content.length-1] = '-' then
                  if content.value[content.length-2] = '-' then
                    if content.length > 6 then break;
            end;

            xmlEntityDecl,xmlNotationDecl: begin
              content.addWideChar(str1);

              if (str1 = SingleQuote) and (not DoubleQuoteOpen) then begin
                if SingleQuoteOpen
                  then SingleQuoteOpen:= false
                  else SingleQuoteOpen:= true;
              end else if (str1 = DoubleQuote) and (not SingleQuoteOpen) then begin
                if DoubleQuoteOpen
                  then DoubleQuoteOpen:= false
                  else DoubleQuoteOpen:= true;
              end;

              if (not DoubleQuoteOpen)
                and (not SingleQuoteOpen)
                and (str1 = '>')
                then break;
            end;

            xmlElementDecl,xmlAttributeDecl: begin
              content.addWideChar(str1);
              if str1 = '>' then break;
            end;

          end; {case ...}
        end; {while ...}

        newSourceCodePiece:= TXmlSourceCodePiece.create(PieceType);
        newSourceCodePiece.text:= NormalizeLineBreaks(content.value);
        Source.Add(newSourceCodePiece);

      end; {while ...}
    finally
      content.free;
    end;
  end; {with InputSource ...}
end;

procedure TCustomParser.IntDtdToXmlSourceCode(const InputSource: TXmlInputSource;
                                              const Source: TXmlSourceCode);
const
  SingleQuote: WideChar = #39; // code of '
  DoubleQuote: WideChar = #34; // code of "
  MaxCode: array[1..6] of integer = ($7F,$7FF,$FFFF,$1FFFFF,$3FFFFFF,$7FFFFFFF);
var
  str0: Char;
  str1: WideChar;
  subEndMarker,SubStartMarker: WideString;
  SingleQuoteOpen,DoubleQuoteOpen: boolean;
  StreamSize: longint;
  PieceType: TdomPieceType;
  newSourceCodePiece: TXmlSourceCodePiece;
  content: TdomCustomStr;
  CharSize, ucs4, mask: integer;
  first: char;
begin
  subEndMarker:= '';
  subStartMarker:= '';
  Source.clearAndFree;
  content:= TdomCustomStr.create;
  with InputSource do begin
    try
      StreamSize:= Stream.Size; // buffer storage to increase performance
      while Stream.Position < StreamSize do begin
        SingleQuoteOpen:= false;
        DoubleQuoteOpen:= false;
        Content.reset;
        PieceType:= xmlPCData;
        while Stream.Position < StreamSize do begin
          case Encoding of
            etUTF8: begin
              Stream.ReadBuffer(str0,1);
              if ord(str0)>=$80 then	// UTF-8 sequence
              begin
                try
                  CharSize:=1;
                  first:=str0; mask:=$40; ucs4:=ord(str0);
                  if (ord(str0) and $C0<>$C0) then
                    raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                  while (mask and ord(first)<>0) do
                  begin
                    // read next character of stream
                    if Stream.Position=StreamSize then
                      raise EConvertError.CreateFmt('Aborted UTF-8 sequence at position %d',[Stream.Position]);
                    Stream.ReadBuffer(str0,1);
                    if (ord(str0) and $C0<>$80) then
                      raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                    ucs4:=(ucs4 shl 6) or (ord(str0) and $3F); // add bits to result
                    Inc(CharSize);	// increase sequence length
                    mask:=mask shr 1;	// adjust mask
                  end;
                  if (CharSize>6) then	// no 0 bit in sequence header 'first'
                      raise EConvertError.CreateFmt('Invalid UTF-8 sequence at position %d',[Stream.Position-1]);
                  ucs4:=ucs4 and MaxCode[CharSize];	// dispose of header bits
                  // check for invalid sequence as suggested by RFC2279
                  if ((CharSize>1) and (ucs4<=MaxCode[CharSize-1])) then
                      raise EConvertError.CreateFmt('Invalid UTF-8 encoding at position %d',[Stream.Position-1]);
                  if (ucs4>=$10000) then
                  begin
                    // add high surrogate to content as if it was processed earlier
                    Content.addWideChar(Utf16HighSurrogate(ucs4));
                    // assign low surrogate to str1
                    str1:=Utf16LowSurrogate(ucs4);
                  end
                  else
                    str1:= WideChar(ord(ucs4));
                except
                  on E: EConvertError do begin
                    content.AddWideChar(WideChar(ord(str0)));
                    PieceType:= xmlCharacterError;
                  end; {on ...}
                end; {try ...}
                if PieceType = xmlCharacterError then break;
              end
              else
                str1:= WideChar(ord(str0));
            end;
            // begin add
            etMBCS : str1:=ReadWideCharFromMBCSStream(Stream);
            // end add
            etUTF16BE: begin
              Stream.ReadBuffer(str1,2);
            end;
            etUTF16LE: begin
              Stream.ReadBuffer(str1,2);
              str1:= wideChar(Swap(ord(str1)));
            end;
          end; {case ...}

          if not IsXmlChar(str1) then begin
            content.addWideChar(str1);
            PieceType:= xmlCharacterError;
            break;
          end;

          if PieceType = xmlPCData then begin
            if str1 = '<' then begin
              PieceType:= xmlStartTag;
            end else
            if str1 = '%' then begin
              PieceType:= xmlParameterEntityRef;
            end else
            if not IsXmlWhiteSpace(str1) then begin;
              content.addWideChar(str1);
              PieceType:= xmlCharacterError;
              break;
            end;
          end; {if ...}

          case PieceType of

            xmlParameterEntityRef: begin
              content.addWideChar(str1);
              if str1 = ';' then break;
            end;

            xmlStartTag: begin
              content.addWideChar(str1);
              case content.length of
                2: if content.value = '<?' then PieceType:= xmlProcessingInstruction;
                4: if content.value = '<!--' then PieceType:= xmlComment;
                8: if content.value = '<!ENTITY' then PieceType:= xmlEntityDecl;
                9: if content.value = '<!ELEMENT' then PieceType:= xmlElementDecl
                   else if content.value = '<!ATTLIST' then PieceType:= xmlAttributeDecl;
               10: if content.value = '<!NOTATION' then PieceType:= xmlNotationDecl;
              end;

            end;

            xmlProcessingInstruction: begin
              content.addWideChar(str1);
              if str1 = '>' then
                if content.value[content.Length-1] = '?' then break;
            end;

            xmlComment: begin
              content.addWideChar(str1);
              if str1 = '>' then
                if content.value[content.Length-1] = '-' then
                  if content.value[content.Length-2] = '-' then
                    if content.length > 6 then break;
            end;

            xmlEntityDecl,xmlNotationDecl: begin
              content.addWideChar(str1);

              if (str1 = SingleQuote) and (not DoubleQuoteOpen) then begin
                if SingleQuoteOpen
                  then SingleQuoteOpen:= false
                  else SingleQuoteOpen:= true;
              end else if (str1 = DoubleQuote) and (not SingleQuoteOpen) then begin
                if DoubleQuoteOpen
                  then DoubleQuoteOpen:= false
                  else DoubleQuoteOpen:= true;
              end;

              if (not DoubleQuoteOpen)
                and (not SingleQuoteOpen)
                and (str1 = '>')
                then break;
            end;

            xmlElementDecl,xmlAttributeDecl: begin
              content.addWideChar(str1);
              if str1 = '>' then break;
            end;

          end; {case ...}
        end; {while ...}

        newSourceCodePiece:= TXmlSourceCodePiece.create(PieceType);
        newSourceCodePiece.text:= NormalizeLineBreaks(content.value);
        Source.Add(newSourceCodePiece);

      end; {while ...}
    finally
      content.free;
    end;
  end; {with InputSource ...}
end;

procedure TCustomParser.DocSourceCodeToDom(const DocSourceCode: TXmlSourceCode;
                                           const RefNode: TdomNode;
                                           const readonly: boolean);
var
  i: integer;
  FirstLineNumber,LastLineNumber: integer; {xxx später löschen! xxx}
  content: WideString;
  LastNode: TdomNode;
begin
  FirstLineNumber:= 0;
  LastLineNumber:= 0;
  FIntSubset:= '';  // Clear buffer storage for internal subset of the DTD
  ClearErrorList;
  FLineNumber:= 1;
  LastNode:= RefNode;
  try
    for i:= 0 to DocSourceCode.Count -1 do begin
      content:= TXmlSourceCodePiece(DocSourceCode[i]).text;
      case TXmlSourceCodePiece(DocSourceCode[i]).pieceType of
        xmlXmlDeclaration: WriteXmlDeclaration(copy(content,3,length(content)-4),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlProcessingInstruction: WriteProcessingInstruction(copy(content,3,length(content)-4),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlCDATA: WriteCDATA(copy(content,10,length(content)-12),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlPCDATA: WritePCDATA(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlStartTag: LastNode:= WriteStartTag(copy(content,2,length(content)-2),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlEndTag: begin
          if LastNode = RefNode then raise EParserMissingStartTag_Err.create('Missing start tag error.');
          WriteEndTag(copy(content,3,length(content)-3),FirstLineNumber,LastLineNumber,LastNode);
          LastNode:= LastNode.ParentNode;
          end;
        xmlEmptyElementTag: WriteStartTag(copy(content,2,length(content)-3),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlCharRef: WriteCharRef(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlEntityRef: WriteEntityRef(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlComment: WriteComment(copy(content,5,length(content)-7),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlDoctype: WriteDoctype(content,FirstLineNumber,LastLineNumber,LastNode);
        xmlCharacterError: raise EParserInvalidCharacter_Err.create('Invalid character error.');
      end; {case}
    end; {for ...}
  except
    on E: EParserException do
    begin
      FErrorList.Add(TXmlParserError.Create(E.ClassName,LastLineNumber,LastLineNumber,Content,Language));
      raise;
    end;
  end; {try}
end;

procedure TCustomParser.DocStreamToDom(const Stream: TStream;
                                       const RefNode: TdomNode;
                                       const readonly: boolean);
var
  DocSourceCode: TXmlSourceCode;
  sourceCodeCreated: boolean;
  InputSource: TXmlInputSource;
begin
  if FUseSpecifiedDocumentSC and assigned(FDocumentSC) then begin
    DocSourceCode:= FDocumentSC;
    sourceCodeCreated:= false;
  end else begin
    DocSourceCode:= TXmlSourceCode.create;
    sourceCodeCreated:= true;
  end;
  InputSource:= TXmlInputSource.create(Stream,'','',FDefaultEncoding);
  try
    DocToXmlSourceCode(InputSource,DocSourceCode);
    DocSourceCodeToDom(DocSourceCode,RefNode,readonly);
  finally
    InputSource.free;
    if sourceCodeCreated then begin
      DocSourceCode.ClearAndFree;
      DocSourceCode.Free;
    end;
  end; {try}
end;

procedure TCustomParser.DocMemoryToDom(const Ptr: Pointer;
                                       const Size: Longint;
                                       const RefNode: TdomNode;
                                       const readonly: boolean);
var
  MStream: TXmlMemoryStream;
begin
  if not assigned(RefNode) then exit;
  MStream:= TXmlMemoryStream.create;
  try
    MStream.SetPointer(Ptr,Size);
    DocStreamToDom(MStream,RefNode,readonly);
  finally
    MStream.free;
  end; {try}
end;

procedure TCustomParser.DocStringToDom(const Str: string;
                                       const RefNode: TdomNode;
                                       const readonly: boolean);
var
  Ptr: PChar;
  Size: Longint;
begin
  Ptr:= Pointer(Str);
  Size:= length(Str);
  if Size = 0 then exit;
  DocMemoryToDom(Ptr,Size,RefNode,readonly);
end;


procedure TCustomParser.DocWideStringToDom(      Str: WideString;
                                           const RefNode: TdomNode;
                                           const readonly: boolean);
var
  Ptr: Pointer;
  Size: Longint;
begin
  if Str = '' then exit;
  if Str[1] <> #$feff
    then  Str:= concat(wideString(#$feff),Str);
  Ptr:= Pointer(Str);
  Size:= length(Str)*2;
  DocMemoryToDom(Ptr,Size,RefNode,readonly);
end;

procedure TCustomParser.ExtDtdSourceCodeToDom(const ExtDtdSourceCode: TXmlSourceCode;
                                              const RefNode: TdomNode;
                                              const readonly: boolean);
var
  i: integer;
  FirstLineNumber,LastLineNumber: integer; {xxx später löschen! xxx}
  content: WideString;
  LastNode: TdomNode;
begin
  FirstLineNumber:= 0;
  LastLineNumber:= 0;
  FIntSubset:= '';  // Clear buffer storage for internal subset of the DTD
  ClearErrorList;
  FLineNumber:= 1;
  LastNode:= RefNode;
  try
    for i:= 0 to ExtDtdSourceCode.Count -1 do begin
      content:= TXmlSourceCodePiece(ExtDtdSourceCode[i]).text;
      case TXmlSourceCodePiece(ExtDtdSourceCode[i]).pieceType of
        xmlTextDeclaration: WriteTextDeclaration(copy(content,3,length(content)-4),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlProcessingInstruction: WriteProcessingInstruction(copy(content,3,length(content)-4),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlParameterEntityRef: WriteParameterEntityRef(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlComment: WriteComment(copy(content,5,length(content)-7),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlEntityDecl: WriteEntityDeclaration(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlElementDecl: WriteElementDeclaration(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlAttributeDecl: WriteAttributeDeclaration(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlNotationDecl: WriteNotationDeclaration(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlCondSection: WriteConditionalSection(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlCharacterError: raise EParserInvalidCharacter_Err.create('Invalid character error.');
      end; {case}
    end; {for ...}
  except
    on E: EParserException do
    begin
      FErrorList.Add(TXmlParserError.Create(E.ClassName,LastLineNumber,LastLineNumber,Content,Language));
      raise;
    end;
  end; {try}
end;

procedure TCustomParser.ExtDtdStreamToDom(const Stream: TStream;
                                          const RefNode: TdomNode;
                                          const readonly: boolean);
var
  ExtDtdSourceCode: TXmlSourceCode;
  sourceCodeCreated: boolean;
  InputSource: TXmlInputSource;
begin
  if FUseSpecifiedDocumentSC and assigned(FExternalSubsetSC) then begin
    ExtDtdSourceCode:= FExternalSubsetSC;
    sourceCodeCreated:= false;
  end else begin
    ExtDtdSourceCode:= TXmlSourceCode.create;
    sourceCodeCreated:= true;
  end;
  InputSource:= TXmlInputSource.create(Stream,'','',FDefaultEncoding);
  try
    ExtDtdToXmlSourceCode(InputSource,ExtDtdSourceCode);
    ExtDtdSourceCodeToDom(ExtDtdSourceCode,RefNode,readonly);
  finally
    InputSource.free;
    if sourceCodeCreated then begin
      ExtDtdSourceCode.ClearAndFree;
      ExtDtdSourceCode.Free;
    end;
  end; {try}
end;

procedure TCustomParser.ExtDtdMemoryToDom(const Ptr: Pointer;
                                          const Size: Longint;
                                          const RefNode: TdomNode;
                                          const readonly: boolean);
var
  MStream: TXmlMemoryStream;
begin
  if not assigned(RefNode) then exit;
  MStream:= TXmlMemoryStream.create;
  try
    MStream.SetPointer(Ptr,Size);
    ExtDtdStreamToDom(MStream,RefNode,readonly);
  finally
    MStream.free;
  end; {try}
end;

procedure TCustomParser.ExtDtdStringToDom(const Str: string;
                                          const RefNode: TdomNode;
                                          const readonly: boolean);
var
  Ptr: PChar;
  Size: Longint;
begin
  if Str = '' then exit;
  Ptr:= Pointer(Str);
  Size:= length(Str);
  ExtDtdMemoryToDom(Ptr,Size,RefNode,readonly);
end;


procedure TCustomParser.ExtDtdWideStringToDom(      Str: WideString;
                                              const RefNode: TdomNode;
                                              const readonly: boolean);
var
  Ptr: Pointer;
  Size: Longint;
begin
  if Str = '' then exit;
  if Str[1] <> #$feff
    then   Str:= concat(wideString(#$feff),Str);
  Ptr:= Pointer(Str);
  Size:= length(Str)*2;
  ExtDtdMemoryToDom(Ptr,Size,RefNode,readonly);
end;

procedure TCustomParser.IntDtdSourceCodeToDom(const IntDtdSourceCode: TXmlSourceCode;
                                              const RefNode: TdomNode;
                                              const readonly: boolean);
var
  i: integer;
  FirstLineNumber,LastLineNumber: integer; {xxx später löschen! xxx}
  content: WideString;
  LastNode: TdomNode;
begin
  FirstLineNumber:= 0;
  LastLineNumber:= 0;
  FIntSubset:= '';  // Clear buffer storage for internal subset of the DTD
  ClearErrorList;
  FLineNumber:= 1;
  LastNode:= RefNode;
  try
    for i:= 0 to IntDtdSourceCode.Count -1 do begin
      content:= TXmlSourceCodePiece(IntDtdSourceCode[i]).text;
      case TXmlSourceCodePiece(IntDtdSourceCode[i]).pieceType of
        xmlProcessingInstruction: WriteProcessingInstruction(copy(content,3,length(content)-4),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlParameterEntityRef: WriteParameterEntityRef(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlComment: WriteComment(copy(content,5,length(content)-7),FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlEntityDecl: WriteEntityDeclaration(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlElementDecl: WriteElementDeclaration(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlAttributeDecl: WriteAttributeDeclaration(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlNotationDecl: WriteNotationDeclaration(content,FirstLineNumber,LastLineNumber,LastNode,readonly);
        xmlCharacterError: raise EParserInvalidCharacter_Err.create('Invalid character error.');
      end; {case}
    end; {for ...}
  except
    on E: EParserException do
    begin
      FErrorList.Add(TXmlParserError.Create(E.ClassName,LastLineNumber,LastLineNumber,Content,Language));
      raise;
    end;
  end; {try}
end;

procedure TCustomParser.IntDtdStreamToDom(const Stream: TStream;
                                          const RefNode: TdomNode;
                                          const readonly: boolean);
var
  IntDtdSourceCode: TXmlSourceCode;
  sourceCodeCreated: boolean;
  InputSource: TXmlInputSource;
begin
  if FUseSpecifiedDocumentSC and assigned(FInternalSubsetSC) then begin
    IntDtdSourceCode:= FInternalSubsetSC;
    sourceCodeCreated:= false;
  end else begin
    IntDtdSourceCode:= TXmlSourceCode.create;
    sourceCodeCreated:= true;
  end;
  InputSource:= TXmlInputSource.create(Stream,'','',FDefaultEncoding);
  try
    IntDtdToXmlSourceCode(InputSource,IntDtdSourceCode);
    IntDtdSourceCodeToDom(IntDtdSourceCode,RefNode,readonly);
  finally
    InputSource.free;
    if sourceCodeCreated then begin
      IntDtdSourceCode.ClearAndFree;
      IntDtdSourceCode.Free;
    end;
  end; {try}
end;

procedure TCustomParser.IntDtdMemoryToDom(const Ptr: Pointer;
                                          const Size: Longint;
                                          const RefNode: TdomNode;
                                          const readonly: boolean);
var
  MStream: TXmlMemoryStream;
begin
  if not assigned(RefNode) then exit;
  MStream:= TXmlMemoryStream.create;
  try
    MStream.SetPointer(Ptr,Size);
    IntDtdStreamToDom(MStream,RefNode,readonly);
  finally
    MStream.free;
  end; {try}
end;

procedure TCustomParser.IntDtdStringToDom(const Str: string;
                                          const RefNode: TdomNode;
                                          const readonly: boolean);
var
  Ptr: PChar;
  Size: Longint;
begin
  Ptr:= Pointer(Str);
  Size:= length(Str);
  if Size = 0 then exit;
  IntDtdMemoryToDom(Ptr,Size,RefNode,readonly);
end;


procedure TCustomParser.IntDtdWideStringToDom(      Str: WideString;
                                              const RefNode: TdomNode;
                                              const readonly: boolean);
var
  Ptr: Pointer;
  Size: Longint;
begin
  if Str = '' then exit;
  if Str[1] <> #$feff
    then   Str:= concat(wideString(#$feff),Str);
  Ptr:= Pointer(Str);
  Size:= length(Str)*2;
  IntDtdMemoryToDom(Ptr,Size,RefNode,readonly);
end;



// ++++++++++++++++++++++++++++ TXmlToDomParser ++++++++++++++++++++++++
function TXmlToDomParser.FileToDom(const filename: TFileName): TdomDocument;
var
  DocSourceCode: TXmlSourceCode;
  sourceCodeCreated: boolean;
  MStream: TMemoryStream;
  ExtDtd,RootName: WideString;
  InputSource: TXmlInputSource;
begin
  Result:= nil;
  InputSource:= nil;
  if assigned(FDocumentSC) then FDocumentSC.clearAndFree;
  if assigned(FExternalSubsetSC) then FExternalSubsetSC.clearAndFree;
  if assigned(FInternalSubsetSC) then FInternalSubsetSC.clearAndFree;
  if not assigned(FDOMImpl) then raise EAccessViolation.Create('DOMImplementation not specified.');
  if Filename = '' then raise EAccessViolation.Create('Filename not specified.');
  MStream:= TMemoryStream.create;
  try
    MStream.LoadFromFile(Filename);
    InputSource:= TXmlInputSource.create(MStream,'','',FDefaultEncoding);
    if assigned(FDocumentSC) then begin
      DocSourceCode:= FDocumentSC;
      sourceCodeCreated:= false;
    end else begin
      DocSourceCode:= TXmlSourceCode.create;
      sourceCodeCreated:= true;
    end;
    try
      DocToXmlSourceCode(InputSource,DocSourceCode);
      RootName:= DocSourceCode.NameOfFirstTag;
      if not IsXmlName(RootName) then begin
        FErrorList.Add(TXmlParserError.Create('EParserRootNotFound_Err',0,0,'',Language));
        raise EParserRootNotFound_Err.create('Root not found error.');
      end;
      Result:= FDomImpl.createDocument(RootName,nil);
      Result.Clear;  // Delete the dummy node
      Result.Filename:= Filename;
      try
        DocSourceCodeToDom(DocSourceCode,Result,false);
      except
        DOMImpl.FreeDocument(Result);
        raise;
      end;
    finally
      if sourceCodeCreated then begin
        DocSourceCode.ClearAndFree;
        DocSourceCode.Free;
      end;
    end; {try}

    try
      // Parse the DTD:
      if assigned(Result.Doctype) then
        with Result.Doctype do begin
          FEntitiesListing.clear;
          IntDtdWideStringToDom(FIntSubset,InternalSubsetNode,false);
          if (PublicId <> '') or (SystemId <> '') then begin
            if assigned(OnExternalSubset)
              then OnExternalSubset(self,PublicId,SystemId,ExtDtd);
            ExtDtdWideStringToDom(ExtDtd,ExternalSubsetNode,true);
          end; {if ...}
        end; {with ...}
    except
      DOMImpl.FreeDocument(Result);
      raise;
    end;
  finally
    InputSource.free;
    MStream.free;
  end; {try}
end;

end.
