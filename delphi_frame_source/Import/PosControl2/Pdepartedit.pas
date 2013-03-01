unit Pdepartedit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TPdepartedit = class(TEdit)
  public
    constructor Create(AOwner: TComponent); override;
    function checkstate: integer;//手工合法性检查函数：
                       // 0-成功；1-ERN标识不合法；2-ERN不存在于库中
    procedure validcheck;//全权处理式的合法检查
  end;

procedure Register;

implementation

constructor TPdepartedit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     self.Font.Size := 9;
     self.Font.Name := '宋体';
     self.ParentFont := False;
end;
//=================================================================
function TPdepartedit.checkstate: integer;//手工合法性检查函数：
                    // 0-成功；1-ERN标识不合法；2-ERN不存在于库中
begin
result:=0;
end;
//=================================================================
procedure TPdepartedit.validcheck;//全权处理式的合法检查
begin
showmessage('TPdepartedit.validcheck is actived.');
end;
//=================================================================
procedure Register;
begin
  RegisterComponents('PosControl', [TPdepartedit]);
end;

end.
