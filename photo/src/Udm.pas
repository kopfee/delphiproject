unit Udm;

interface

uses
    SysUtils, Classes, DB, ADODB, Dialogs, DBAccess, Ora, IniFiles, MemDS;

type
    Tfrmdm = class(TDataModule)
        conn: TOraSession;
        qryImport: TOraQuery;
        qryQuery: TOraQuery;
        qrySpec: TOraQuery;
        qryArea: TOraQuery;
        qryDept: TOraQuery;
        qryType: TOraQuery;
        qryAdd: TOraQuery;
        qryFeeType: TOraQuery;
        procedure DataModuleCreate(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frmdm: Tfrmdm;

implementation

uses uCommon, TLoggerUnit, uGetPhotoSet;

{$R *.dfm}

procedure Tfrmdm.DataModuleCreate(Sender: TObject);
begin
    conn.Server := dburl;
    conn.Username := dbUid;
    conn.Password := dbPwd;

    if conn.Connected then
        conn.Disconnect;
    try
        conn.Connect;
    except
        on e: Exception do begin
            TLogger.GetInstance.Error('连接数据库失败--[' + conn.Server + ']Err--' + e.Message);
            ShowMessage('数据库连接失败--' + e.Message + '，请重新设置数据库或检查网络、服务器是否正常！');
            frmGetPhotoSet := TfrmGetPhotoSet.Create(nil);
            frmGetPhotoSet.ShowModal;
            frmGetPhotoSet.Free;

        end;
    end;
end;

end.

