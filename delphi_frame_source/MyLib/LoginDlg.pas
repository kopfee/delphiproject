unit LoginDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Login;

type
  TLoginEvent = procedure (Sender : TLoginDlg; UserID,Password:string; 
                     var Connected : boolean) of object;

// you must set OnLogin  
  TCustomUserManager = class(TComponent)
  private
    { Private declarations }
    FDlgLogin : TdlgLogin;
    FUserID : string;
    FPassword : string;
    FConnected : boolean;
    FOnLogin : TLoginEvent;
    FOnLogOut : TNotifyEvent;
    FLoginCount : integer; 
    FMaxLoginNumber : integer;
    OnBadLogin : TNotifyEvent;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    // if successfully login , return true, and connected is true.
    function login(): boolean;
    procedure logout;
    property UserID : string read FUserID;
    property Password : string read FPassword;
    property Connected : boolean read FConnected; 
    property LoginCount : integer read FLoginCount;
  protected
    property OnLogin : TLoginEvent read FOnLogin write FOnLogin;
    property OnLogout : TNotifyEvent read FOnLogout write FOnLogout;
    property OnBadLogin : TNotifyEvent read FOnBadLogin write FOnBadLogin ;
    function DoLogin :boolean; virtual;
    procedure DoLogout; virtual;
    procedure DoBadLogin; virtual;
  published
    { Published declarations }
    // max error login number 
    property MaxLoginNumber : integer 
      read FMaxLoginNumber write MaxLoginNumber default 3;
  end;

  TUserManager = class(TCustomUserManager)
  published 
    property OnLogin;
    property OnLogout;
    property OnBadLogin;
  end;

  
  TDBUserManager = class(TCustomUserManager)
  private
    FDatabase : TDatabase;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function DoLogin :boolean; virtual;
    procedure DoLogout; virtual;
    procedure DoBadLogin; virtual;  
  published 
    property Database : TDatabase read FDatabase write FDatabase;
  end;
  
var
  LoginDialogClass : TLoginDialogClass
    =  TdlgLogin; 
    
implementation

constructor TCustomUserManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDlgLogin := LoginDialogClass.create(self);
  FConnected := false;
  FMaxLoginNumber := 3;
end;

destructor  TCustomUserManager.Destroy;
begin
  FDlgLogin.free;
  inherited destroy;
end;

function TCustomUserManager.login: boolean;
var
  canExit : boolean;
begin
  canExit := false;
  FConnected := false;
  FLoginCount := 0;
  repeat
    result := FDlgLogin.ShowModal = mrOK;
    if result
      then begin
        FUserID := FDlgLogin.edUserID.text;
        FPassword := FDlgLogin.edPassword.text;
        Dologin;
        Inc(FLoginCount);
        if not FConnected
          then begin 
            if FLoginCount=FMaxLoginNumber
               then begin
                 result := false;
                 canExit := true;
                 doBadLogin;
               end;
          end
          else canExit := true; 
      end
      else begin 
        canExit := true;
      end;  
  until canExit;   
end;

procedure TCustomUserManager.logout;
begin
  connected := false;
  DoLogout;
end;

function TCustomUserManager.DoLogin :boolean;
begin
  if assigned(FONlogin) 
    then FOnLogin(self,FUserID,FPassword,FConnected);
end;  
 
procedure TCustomUserManager.DoLogout; 
begin
  if Assigned(FOnLogout) then FOnLogout(self);
end;  

procedure TCustomUserManager.DoBadLogin; 
begin
  if Assigned(FOnBadLogin) then FOnBadLogin(self);
end;

end.
