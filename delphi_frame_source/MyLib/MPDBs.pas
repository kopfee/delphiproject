unit MPDBs;

{ 多用途数据库状态管理库
}

interface

uses Windows, Messages, SysUtils, Classes, Graphics,
	Controls, Forms, Dialogs,DB,DBTables;

type
	TDBInteractState = (
  	isInactive, 	// 	非活动状态
  	isBrowse,   	//  浏览
    isUpdate,				//	编辑(修改)
    isInsert,			//	插入(增加)
    isQuery);			//	查询(过滤)
{ 界面元素
		公共 : 切换按键(浏览,编辑,插入,查询)
    浏览 :
    编辑 : 	确认修改 Update
    				取消     CancelUpdate
    插入 : 	确认插入 Insert
    				取消     CancelInsert
    查询 : 	开始查询 Query
    				取消     CancelQuery
}
  TMulitState = class(TComponent)
  private
    FState: TDBInteractState;
    function 	GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetState(const Value: TDBInteractState);
  protected
    // 提交一个插入操作
    function 	InsertItem : boolean; virtual;
    // 提交一个修改操作
    function 	UpdateItem : boolean; virtual;
    // 提交一个查询操作
    function 	QueryItems : boolean; virtual;
    // 当状态发生变化时,被调用
    procedure StateChanged(Old,New : TDBInteractState); virtual;
    // 进入浏览状态时,被调用
    procedure DoEnterBrowse;	virtual;
    // 进入插入状态时,被调用
    procedure DoEnterInsert;	virtual;
    // 进入更新状态时,被调用
    procedure DoEnterUpdate;	virtual;
    // 进入查询状态时,被调用
    procedure DoEnterQuery;	virtual;
    // 退出浏览状态时,被调用
    procedure DoExitBrowse;	virtual;
    // 退出插入状态时,被调用
    procedure DoExitInsert;	virtual;
    // 退出更新状态时,被调用
    procedure DoExitUpdate;	virtual;
    // 退出查询状态时,被调用
    procedure DoExitQuery;	virtual;
  public
    // 进入浏览状态
    procedure EnterBrowse;	virtual;
    // 进入插入状态
    procedure EnterInsert;	virtual;
    // 进入更新状态
    procedure EnterUpdate;	virtual;
    // 进入查询状态
    procedure EnterQuery;	virtual;
    // 退出浏览状态
    procedure ExitBrowse;	virtual;
    // 退出插入状态
    procedure ExitInsert;	virtual;
    // 退出更新状态
    procedure ExitUpdate;	virtual;
    // 退出查询状态
    procedure ExitQuery;	virtual;
  published
  	property 	DataSource : TDataSource
    						read GetDataSource write SetDataSource;
    property 	State : TDBInteractState
    						read FState write SetState;
  end;

implementation

{ TMulitState }

procedure TMulitState.EnterBrowse;
begin
  State := isBrowse;
end;

procedure TMulitState.EnterInsert;
begin
  State := isInsert;
end;

procedure TMulitState.EnterQuery;
begin
  State := isQuery;
end;

procedure TMulitState.EnterUpdate;
begin
  State := isUpdate;
end;

procedure TMulitState.ExitBrowse;
begin
  // nothing
end;

procedure TMulitState.ExitInsert;
begin
  EnterBrowse;
end;

procedure TMulitState.ExitQuery;
begin
  EnterBrowse;
end;

procedure TMulitState.ExitUpdate;
begin
  EnterBrowse;
end;

procedure TMulitState.DoEnterBrowse;
begin

end;

procedure TMulitState.DoEnterInsert;
begin

end;

procedure TMulitState.DoEnterQuery;
begin

end;

procedure TMulitState.DoEnterUpdate;
begin

end;

procedure TMulitState.DoExitBrowse;
begin

end;

procedure TMulitState.DoExitInsert;
begin

end;

procedure TMulitState.DoExitQuery;
begin

end;

procedure TMulitState.DoExitUpdate;
begin

end;



function TMulitState.GetDataSource: TDataSource;
begin

end;

function TMulitState.InsertItem: boolean;
begin

end;

function TMulitState.QueryItems: boolean;
begin

end;

procedure TMulitState.SetDataSource(const Value: TDataSource);
begin

end;

procedure TMulitState.SetState(const Value: TDBInteractState);
begin
  if FState <> Value then
  begin
    StateChanged(FState,Value);
    //FState := Value;
  end;
end;

procedure TMulitState.StateChanged(Old, New: TDBInteractState);
begin
  case Old of
    isBrowse : 	DoExitBrowse;
    isUpdate : 	DoExitUpdate;
    isInsert : 	DoExitInsert;
    isQuery  :  DoExitQuery;
  end;
  FState := New;
  case New of
  	isBrowse : 	DoEnterBrowse;
    isUpdate : 	DoEnterUpdate;
    isInsert : 	DoEnterInsert;
    isQuery  :  DoEnterQuery;
  end;
end;

function TMulitState.UpdateItem: boolean;
begin

end;

end.
