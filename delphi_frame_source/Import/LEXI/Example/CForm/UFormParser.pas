unit UFormParser;

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CommParser, Scanner,contnrs,stdctrls,ExtCtrls,Buttons,KSCtrls, ExtDialogs;

type
  TUIObjectParam = (pNone,pLeft,pTop,pRight,pBottom,pColor,pBKColor,pCaption);

const
  maxParams = ord(pCaption)-ord(pNone)+1;

type
  TUIItemClass = class of TUIItem;

  TUIObjectParams = Array[0..maxParams-1] of TUIObjectParam;
  TClassMethodParams = record
    className : string;
    methodName : string;
    params : TUIObjectParams;
    itemClass : TUIItemClass;
  end;

  TUIObject = class
  public
    objname, className : string;
    left,top,right,bottom : integer;
    caption : string;
    color, bkcolor : TColor;
    isForm : boolean;
    formIndex : integer;
    constructor Create;
  end;

  TUIItem = class(TUIObject)
  public

  end;

  //TUIItemClass = class of TUIItem;

  TUIItemsObject = class(TUIObject)
  private
    FItems : TObjectList;
    function GetItems(index: integer): TUIItem;
  public
    property Items[index : integer] : TUIItem read GetItems;
    constructor Create;
    Destructor Destroy;override;
    function  addItem : TUIItem;
    procedure add(item : TUIItem);
    function  count : integer;
  end;

  TUIObjects = class(TObjectList)
  private
    function GetItems(index: integer): TUIObject;
  public
    function  add:TUIObject;
    function  addItems: TUIItemsObject;
    property  Items[index:integer] : TUIObject read GetItems; default;
    function  findObj(const aname:string): TUIObject;
    function  getForm : TUIObject;
  end;

  TdmFormParser = class(TCommonParser)
    SaveDialog: TOpenDialogEx;
    procedure ScannerTokenRead(Sender: TObject; Token: TToken;
      var AddToList, Stop: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    UIObjects : TUIObjects;
    UIFormClasses : TStringList;
    CureentFormClass : integer;
  protected
    procedure analyseToken; override;
    procedure beforeExecute; override;
    procedure processMethod(obj : TUIObject; const Params: Array of TUIObjectParam);
    procedure reportInfo; override;
    procedure setObjBounds(ctrl : TControl; UIObj : TUIObject; delY:integer=0);
    function  getFormClassIndex(const className:string): integer;
    function  generateOneForm(formIndex : integer):TForm;
  public
    { Public declarations }
    // generate a delphi form from UIObjects
    procedure generateForm(const pasFile:string; autoFileName:boolean=false; isShowForm:boolean=true);
  end;

var
  dmFormParser: TdmFormParser;

type
  TUIConv = record
    className : string;
    Class1,Class2 : TControlClass;
  end;

const
  // symbol tags
  stMember = 1; // ->
  stDefine = 2; // ::

  AllUIConvCount = 12;
  AllUIConvs : array[0..AllUIConvCount-1] of TUIConv
    = (
       (className : 'CButton'; class1:TKSButton; class2:nil),
       (className : 'CEdit'; class1:TKSLabel; class2:TKSEdit),
       (className : 'CF2Edit'; class1:TKSLabel; class2:TKSSwitchEdit),
       (className : 'CListEdit'; class1:TKSLabel; class2:TKSListEdit),
       (className : 'CDateEdit'; class1:TKSLabel; class2:TKSDateEdit),
       (className : 'CCheckBox'; class1:TKSCheckBox; class2:nil),
       (className : 'CDBGrid'; class1:TKSDBGrid; class2:nil),
       (className : 'CText'; class1:TKSMemo; class2:nil),
       (className : 'CDBText'; class1:TKSDBMemo; class2:nil),
       (className : 'CList'; class1:TKSPanel; class2:nil),
       (className : 'CComboBox'; class1:TKSLabel; class2:TKSComboBox),
       (className : 'CPanel'; class1:TKSPanel; class2:nil)
      );
  AllItemsClasseCount = 4;
  AllItemsClasses : array[0..AllItemsClasseCount-1] of string
    = ('CPanel','CDBGrid','CF2Edit','CList');

  AllClassMethodCount = 17;
  AllClassMethodParams : Array[0..AllClassMethodCount-1] of TClassMethodParams
    =(
      (className:'CButton';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pCaption,pNone,pNone);itemClass:nil),
      (className:'CEdit';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pCaption,pNone,pNone);itemClass:nil),
      (className:'CF2Edit';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pCaption,pNone,pNone);itemClass:nil),
      (className:'CF2Edit';methodName:'AddItem';params:(pCaption,pNone,pNone,pNone,pNone,pNone,pNone,pNone);itemClass:TUIItem),
      (className:'CListEdit';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pCaption,pNone,pNone);itemClass:nil),
      (className:'CDateEdit';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pCaption,pNone,pNone);itemClass:nil),
      (className:'CCheckBox';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pNone,pNone,pNone);itemClass:nil),
      (className:'CListCheckBox';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pNone,pNone,pNone);itemClass:nil),
      (className:'CDBGrid';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pNone,pNone,pNone);itemClass:nil),
      (className:'CDBGrid';methodName:'AddField';params:(pCaption,pNone,pNone,pNone,pNone,pNone,pNone,pNone);itemClass:TUIItem),
      (className:'CText';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pNone,pNone,pNone);itemClass:nil),
      (className:'CDBText';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pNone,pNone,pNone);itemClass:nil),
      (className:'CList';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pNone,pNone,pNone);itemClass:nil),
      (className:'CList';methodName:'AddField';params:(pLeft,pTop,pCaption,pNone,pNone,pNone,pNone,pNone);itemClass:TUIItem),
      (className:'CComboBox';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pCaption,pNone,pNone);itemClass:nil),
      (className:'CPanel';methodName:'Create';params:(pNone,pLeft,pTop,pRight,pBottom,pNone,pNone,pNone);itemClass:nil),
      (className:'CPanel';methodName:'ViewCaption';params:(pCaption,pLeft,pTop,pNone,pNone,pNone,pNone,pNone);itemClass:TUIItem)
     );

  TitleHeight = 24;

implementation

uses ProgDlg2,FrmFileGen,DBGrids,ExtUtils;

{$R *.DFM}

function  isItemsClass(const className:string):boolean;
var
  i : integer;
begin
  result := true;
  for i:=0 to AllItemsClasseCount-1 do
    if AllItemsClasses[i]=className then exit;
  result := false;
end;

// filter the Prefix of objName
function filterPrefix(const objName:string):string;
var
  i,j,k : integer;
begin
  k:=0;
  j:=length(objName);
  for i:=1 to j do
  begin
    if (objName[i]>='A') and (objName[i]<='Z') then
    begin
      k:=i;
      break;
    end;
  end;
  if (k>=1) and (k<j) then
    result := copy(objName,k,j) else
    result := objName;
end;

{ TUIObject }

constructor TUIObject.Create;
begin
  formIndex := -1;
  isForm:=false;
end;


{ TUIObjects }

function TUIObjects.add: TUIObject;
begin
  result := TUIObject.create;
  inherited add(result);
end;

function TUIObjects.addItems: TUIItemsObject;
begin
  result := TUIItemsObject.create;
  inherited add(result);
end;

function TUIObjects.findObj(const aname: string): TUIObject;
var
  i : integer;
begin
  for i:=count-1 downto 0 do
  begin
    result :=items[i];
    if result.objname=aname then
      exit;
  end;
  result := nil;
end;

function TUIObjects.getForm: TUIObject;
var
  i : integer;
begin
  for i:=count-1 downto 0 do
  begin
    result :=items[i];
    if result.isForm then
      exit;
  end;
  result := nil;
end;

function TUIObjects.GetItems(index: integer): TUIObject;
begin
  result := TUIObject(inherited items[index]);
end;

{ TUIItemsObject }

procedure TUIItemsObject.add(item: TUIItem);
begin
  FItems.add(item);
end;

function TUIItemsObject.addItem: TUIItem;
begin
  result := TUIItem.create;
  FItems.add(result);
end;

function TUIItemsObject.count: integer;
begin
  result := FItems.count;
end;

constructor TUIItemsObject.Create;
begin
  inherited;
  FItems := TObjectList.create;
end;

destructor TUIItemsObject.Destroy;
begin
  FItems.free;
  inherited;
end;

function TUIItemsObject.GetItems(index: integer): TUIItem;
begin
  result := TUIItem(FItems[index]);
end;

{ TdmFormParser }

procedure TdmFormParser.analyseToken;
var
  i : integer;
  t1,t2 : TToken;
  objname,methodname,classname,parentClass : string;
  UIObj : TUIObject;
  Item : TUIItem;
begin
  if isKeyword(token,'class') then
  begin
    t1 := nextToken;
    className := getIdentifier(t1);
    if className<>'' then
    begin
      nextToken; // skip :
      nextToken; // skip public
      t2 := nextToken; // parent class
      parentClass := getIdentifier(t2);
      if parentClass='CForm' then
        UIFormClasses.add(className);
    end;
  end
  else if (token.Token=ttSpecialChar) and (token.tag=stDefine) and (FTokenSeq>=2) then
  begin
    t1 := Scanner.Token[FTokenSeq-2];
    className := getIdentifier(t1);
    CureentFormClass := getFormClassIndex(className);
  end
  else if isKeyword(token,'new') then
  begin
    if FTokenSeq>=3 then
    begin
      // process: obj = new(className)
      t1 := Scanner.Token[FTokenSeq-3]; // iden
      t2 := Scanner.Token[FTokenSeq-2]; // =
      objname:= getIdentifier(t1);
      if (objname<>'') and (isSymbol(t2,'=')) then
      begin
        t2:=nextToken;
        if isSymbol(t2,'(') then
          t2:=nextToken;
        classname:=getIdentifier(t2);
        if classname<>'' then
        begin
          // find : obj = new(className)
          //Freporter.addInfo(objname+'=new '+className);
          if isItemsClass(classname) then
            UIObj := UIObjects.addItems else
            UIObj := UIObjects.add;
          UIObj.className := classname;
          UIObj.objname := objName;
          UIObj.formIndex := CureentFormClass;
          t2:=nextToken;
          if isSymbol(t2,')') then
            t2:=nextToken;
          if isSymbol(t2,'(') then
          begin
            UIObj.formIndex := getFormClassIndex(UIObj.className);
            UIObj.isForm:=UIObj.formIndex>=0;
            if UIObj.isForm then processMethod(UIObj,[pLeft,pTop,pRight,pBottom,pCaption]);
          end;
          dlgProgress.checkCanceled;
        end;
      end;
    end;
  end
  else if (token.Token=ttSpecialChar) and (token.tag=stMember) and (FTokenSeq>=2) then
  begin
    // process: obj->method
    t1 := Scanner.Token[FTokenSeq-2];
    objname := getIdentifier(t1);
    t2 := nextToken;
    methodname:=getIdentifier(t2);
    t2 := nextToken;
    if (objname<>'') and (methodname<>'') and isSymbol(t2,'(') then
    begin
      //Freporter.addInfo(objname+'->'+methodName);
      dlgProgress.checkCanceled;
      UIObj := UIObjects.findObj(objname);
      if UIObj<>nil then
      begin
        className := UIObj.className;
        for i:=0 to AllClassMethodCount-1 do
          if (AllClassMethodParams[i].className=className)
            and (AllClassMethodParams[i].methodName=methodName) then
          begin
            if (UIObj is TUIItemsObject) and (AllClassMethodParams[i].itemClass<>nil) then
            begin
              Item  := AllClassMethodParams[i].itemClass.create;
              TUIItemsObject(UIObj).add(item);
              processMethod(item,AllClassMethodParams[i].params);
            end
            else
              processMethod(UIObj,AllClassMethodParams[i].params);
          end;
      end;
    end;
  end;
end;

procedure TdmFormParser.ScannerTokenRead(Sender: TObject; Token: TToken;
  var AddToList, Stop: Boolean);
var
  i : integer;
  t1 : TToken;

  procedure check;
  begin
    dlgProgress.setInfo('Read Lines:'+IntToStr(Token.Row));
    dlgProgress.checkCanceled;
  end;

begin
  inherited;
  i:=Scanner.Count;
  AddToList:=true;
  stop:=false;
  if i>0 then
  begin
    t1 := Scanner.Token[i-1];
    if isSymbol(token,'>') and isSymbol(t1,'-') then
    begin
      t1.Text:='->';
      t1.tag := stMember;
      AddToList:=false;
      check;
    end
    else if isSymbol(token,':') and isSymbol(t1,':') then
    begin
      t1.Text:='::';
      t1.tag := stDefine;
      AddToList:=false;
      check;
    end
  end;
end;

procedure TdmFormParser.DataModuleCreate(Sender: TObject);
begin
  inherited;
  UIObjects := TUIObjects.create;
  UIFormClasses := TStringList.create;
end;

procedure TdmFormParser.DataModuleDestroy(Sender: TObject);
begin
  UIFormClasses.free;
  UIObjects.free;
  inherited;
end;

procedure TdmFormParser.beforeExecute;
begin
  inherited;
  UIObjects.Clear;
  UIFormClasses.Clear;
  CureentFormClass := -1;
end;

procedure TdmFormParser.processMethod(obj: TUIObject;
  const Params: array of TUIObjectParam);
var
  i : integer;
  t : TToken;
begin
  for i:=low(Params) to high(Params) do
  begin
    repeat
      t:=nextToken;
      if isSymbol(t,')') then exit;
    until not isSymbol(t,',');
    case Params[i] of
      pNone:  ;
      pLeft:  if t.token=ttInteger then obj.left:=StrToInt(t.text);
      pTop:   if t.token=ttInteger then obj.top:=StrToInt(t.text);
      pRight: if t.token=ttInteger then obj.right:=StrToInt(t.text);
      pBottom: if t.token=ttInteger then obj.bottom:=StrToInt(t.text);
      pColor:  ;
      pBKColor: ;
      pCaption: if t.token=ttString then obj.caption:=t.text;
    end;
  end;
end;

procedure TdmFormParser.reportInfo;
var
  i,j : integer;
  obj : TUIObject;
  item : TUIItem;
  formClass : string;
begin
  inherited;
  if FReporter=nil then exit;
  FReporter.addInfo('');
  FReporter.addInfo('======= Report =======');
  FReporter.addInfo('');
  FReporter.addInfo('Form Classes:'+IntToSTR(UIFormClasses.count));
  for i:=0 to UIFormClasses.count-1 do
    FReporter.addInfo('  '+UIFormClasses[i]);
  FReporter.addInfo('');
  for i:=0 to UIObjects.count-1 do
  begin
    obj := UIObjects[i];
    if not obj.isForm and (obj.formIndex>=0) then
      formClass:=UIFormClasses[obj.formIndex] else
      formClass:='';
    with obj do
      FReporter.addInfo(
        format('class=%s.%s; name=%s; left=%d; top=%d; right=%d; bottom=%d,caption=%s',
        [formClass,className,objName,left,top,right,bottom,caption])
        );
    if obj is TUIItemsObject then
    begin
      for j:=0 to TUIItemsObject(obj).count-1 do
      begin
        item := TUIItemsObject(obj).Items[j];
        with item do
          FReporter.addInfo(
            format('child-> class=%s; name=%s; left=%d; top=%d; right=%d; bottom=%d,caption=%s',
            [className,objName,left,top,right,bottom,caption])
            );
      end;
    end;
  end;
  FReporter.addInfo('');
  FReporter.addInfo('======= Report 2 =======');
  FReporter.addInfo('');
  for i:=0 to UIFormClasses.count-1 do
  begin
    FReporter.addInfo(' * '+UIFormClasses[i]);
    for j:=0 to UIObjects.count-1 do
    begin
      obj := UIObjects[j];
      if obj.formIndex=i then
      with obj do
      begin
        FReporter.addInfo(
          format('class=%s; name=%s; left=%d; top=%d; right=%d; bottom=%d,caption=%s',
          [className,objName,left,top,right,bottom,caption])
          );
      end;
    end;
  end;
end;

type
  TControlAccess = class(TControl);

procedure TdmFormParser.generateForm(const pasFile:string; autoFileName:boolean=false;
  isShowForm:boolean=true);
var
  i : integer;
  form : TForm;
  fileName : string;
  saveThis : boolean;
  namePart,extPart : string;
begin
  SaveDialog.FileName:=pasFile;
  ParseFileName(pasFile,namePart,ExtPart);
  //ExtPart:='.pas';
  for i:=0 to UIFormClasses.count-1 do
  begin
    try
      form:=generateOneForm(i);
      if form<>nil then
      begin
        if isShowForm then form.ShowModal;
        saveThis := false;
        if autoFileName then
        begin
          saveThis:=true;
          if i>0 then
            FileName:=NamePart+'_'+IntToStr(i)+ExtPart else
            FileName:=NamePart+ExtPart;
        end else
        begin
          SaveDialog.Title:='Save form : '+form.caption;
          if SaveDialog.Execute then
          begin
            saveThis:=true;
            fileName := SaveDialog.fileName;
          end;
        end;
        if saveThis then
            ModuleFileGen(fileName,form,'T'+form.name,'TKSForm');
      end;
    finally
      FreeAndNil(form);
    end;
  end;
end;

procedure TdmFormParser.setObjBounds(ctrl: TControl; UIObj: TUIObject; delY:integer=0);
begin
  ctrl.SetBounds(UIobj.left,UIobj.top+delY,UIObj.right-UIObj.left,UIObj.bottom-UIObj.top);
end;


function TdmFormParser.getFormClassIndex(const className: string): integer;
begin
  result := UIFormClasses.IndexOf(className);
end;

function TdmFormParser.generateOneForm(formIndex: integer): TForm;
var
  i,j,k : integer;
  form : TForm;
  UIobj : TUIObject;
  formClass : string;
  ctrl,ctrl2,child : TControl;
  labelWidth : integer;
  column : TColumn;
  labelCaption : string;
  parentName : string;
begin
  Form := nil;
  // found form instance
  if (formIndex<0) or (formIndex>=UIFormClasses.count) then
  begin
    result := nil;
    exit;
  end;
  UIobj:= nil;
  for i:=0 to UIObjects.Count-1 do
  begin
    if (UIObjects.items[i].isForm) and (UIObjects.items[i].formIndex=formIndex) then
    begin
      UIobj := UIObjects.items[i];
      break;
    end;
  end;
  if UIobj=nil then
  begin
    result := nil;
    exit;
  end;
  try
    // create this form
    form := TForm.create(Application);
    form.caption := UIobj.caption;
    form.name := UIobj.className;
    formClass := 'T'+UIobj.className;
    form.font.Name := 'ËÎÌו';
    form.font.Height:= -14;
    form.Scaled:=false;
    form.Position := poScreenCenter;
    setObjBounds(form,UIobj);
    // generate children
    for i:=0 to UIObjects.count-1 do
    begin
      UIobj:=UIObjects[i];
      if not UIobj.isForm and (UIobj.formIndex=formIndex) then
      begin
        ctrl := nil;
        ctrl2 := nil;
        for k:=0 to AllUIConvCount-1 do
          if AllUIConvs[k].className=UIObj.className then
          begin
            ctrl := AllUIConvs[k].class1.Create(Form);
            if AllUIConvs[k].class2<>nil then
              ctrl2:=AllUIConvs[k].class2.Create(Form);
            labelCaption := UIObj.caption;
            if ctrl2<>nil then
            begin
              if UIobj.className='CF2Edit' then
              begin
                if TUIItemsObject(UIobj).count>0 then
                begin
                  labelCaption := TUIItemsObject(UIobj).items[0].caption;
                end;
              end;
              labelWidth := length(labelCaption)*8;
              ctrl.name := 'lb'+UIObj.objname;
              ctrl2.name := UIObj.objname;
              ctrl.SetBounds(UIobj.left,UIobj.top-TitleHeight,labelWidth,UIObj.bottom-UIObj.top);
              ctrl2.SetBounds(UIobj.left+labelWidth,UIobj.top-TitleHeight,UIObj.right-UIObj.left-labelWidth,UIObj.bottom-UIObj.top);
              TControlAccess(ctrl2).Text:='';
            end else
            begin
              ctrl.name := UIobj.objname;
              ctrl.setBounds(UIobj.left,UIobj.top-TitleHeight,UIObj.right-UIObj.left,UIObj.bottom-UIObj.top);
            end;
            TControlAccess(ctrl).Caption:=labelCaption;
            break;
          end; // if, for k
        if ctrl=nil then continue;
        Form.InsertControl(ctrl);
        if ctrl2<>nil then Form.InsertControl(ctrl2);
        // handle specail children generate
        if (UIObj.className='CPanel') or (UIObj.className='CList') then
        begin
          parentName := filterPrefix(UIObj.objname);
          if (UIObj.className='CList') then
          begin
            TKSPanel(ctrl).BevelInner := bvRaised;
            TKSPanel(ctrl).BevelOuter := bvLowered;
          end else
          begin
            TKSPanel(ctrl).BevelInner := bvNone;
            TKSPanel(ctrl).BevelOuter := bvNone;
          end;

          for j:=0 to TUIItemsObject(UIObj).count-1 do
          begin
            child := TKSLabel.create(Form);
            child.name := 'lb'+parentName+'_'+IntToStr(j);
            with TUIItemsObject(UIObj).Items[j] do
            begin
              child.Left := left;
              child.top :=  top;
              TKSLabel(child).caption := caption;
            end;
            labelWidth := length(TKSLabel(child).caption)*8+10;
            TKSPanel(ctrl).InsertControl(child);
            if (UIObj.className='CList') then
            begin
              child := TKSDBLabel.create(Form);
              child.name := 'dlb'+parentName+'_'+IntToStr(j);
              with TUIItemsObject(UIObj).Items[j] do
              begin
                child.Left := left+labelWidth;
                child.top :=  top;
                //TKSLabel(child).caption := '';
              end;
              TKSPanel(ctrl).InsertControl(child);
            end;
          end;
        end
        else if UIObj.className='CF2Edit' then
        begin
          for j:=0 to TUIItemsObject(UIObj).count-1 do
          begin
            TKSSwitchEdit(Ctrl2).items.add(TUIItemsObject(UIObj).items[j].caption);
          end;
        end
        else if UIObj.className='CDBGrid' then
        begin
          for j:=0 to TUIItemsObject(UIObj).count-1 do
          begin
            column := TKSDBGrid(ctrl).Columns.Add;
            column.Title.Caption:=TUIItemsObject(UIObj).Items[j].caption;
            column.Width:=length(column.Title.Caption)*8;
          end;
        end;
      end; // if is child
    end;  // for i
    result := form;
  except
    result := nil;
    Form.free;
  end;
end;

end.
