unit Unit1;

//-------------------------------------------------------
//
//  VKSSoft - Proxy 1.0
//  Copyrigth (c) 2005
//
//-------------------------------------------------------

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ScktComp, ShellApi, Menus, AppEvnts;

function SwitchToThisWindow(hWnd: THandle; Restore: BOOL):DWORD; stdcall;
         external 'user32.dll';

const
  APP_NAME = 'VKSSoft - Proxy 1.0';
  WM_TRAYMSG     = WM_USER + 1;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button4: TButton;
    Client1: TClientSocket;
    Server1: TServerSocket;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    CheckBox2: TCheckBox;
    Memo1: TMemo;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Client1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Client1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Client1Disconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button2Click(Sender: TObject);
    procedure Client1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Server1ClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Server1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Server1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Server1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button3Click(Sender: TObject);
    procedure WMTrayMsg(var msg: TMsg); message WM_TRAYMSG;
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure Minimize(var msg: TMessage); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

const
  LOG_TO   = 'to.log';
  LOG_FROM = 'from.log';

var
  Form1: TForm1;
  bol: BOOL;
  IconData: NotifyIconData;
  MousePos: TPoint;
  vbuf: String;
  logto,logfrom: THandle;

implementation

{$R *.DFM}
{$R tray.res}

function GetFileSizeByName(FileName: String): Integer;
var 
  FindData: TWin32FindData; 
  hFind: THandle; 
begin 
  Result := -1; 
  hFind := FindFirstFile(PChar(FileName), FindData); 
  if hFind <> INVALID_HANDLE_VALUE then 
  begin 
    Windows.FindClose(hFind); 
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then 
       Result := FindData.nFileSizeLow; 
  end;
end;

procedure SetEnd(h: THandle);
var
  sz: DWORD;
begin
  sz:=GetFileSize(h,nil);
  if sz <> $FFFFFFFF then
     FileSeek(h,sz,0);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not Client1.Socket.Connected then begin
  StatusBar1.Panels.Items[0].Text:='Ждём';
  with Client1 do
  begin
    Port:=StrToInt(Edit2.Text);
    Host:=Edit1.Text;
    Open;
  end;
  end;
end;

procedure TForm1.Client1Error(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  StatusBar1.Panels.Items[0].Text:='Ошибка подключения';
  ErrorCode:=0;
end;

procedure TForm1.Client1Connect(Sender: TObject; Socket: TCustomWinSocket);
begin
  StatusBar1.Panels.Items[0].Text:='Подключен';
end;

procedure TForm1.Client1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusBar1.Panels.Items[0].Text:='Отключен';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Client1.Close;
end;

procedure FormatPacket(var s: String);
begin
  s:='Пакет прислан - '+TimeToStr(time)+' '+
      DateToStr(date)+#13#10+s+#13#10;
  s:=s+'--- конец пакета '+#13#10+#13#10;
end;

procedure WriteLogTo(s: String);
var
  re: DWORD;
begin
  if logto <> 0 then
  begin
    FormatPacket(s);
    if not WriteFile(logto,s[1],Length(s),re,nil)  then
       ShowMessage('error log occured');
  end;
end;

procedure WriteLogFrom(s: String);
var
  re: DWORD;
begin
  if logfrom <> 0 then
  begin
    FormatPacket(s);
    if not WriteFile(logfrom,s[1],Length(s),re,nil) then
       ShowMessage('error log occured');
  end;
end;

procedure TForm1.Client1Read(Sender: TObject; Socket: TCustomWinSocket);
var
   tmp, st: string;
begin
  Memo1.Clear;
  tmp:=Socket.ReceiveText;
  st:=tmp;
  //убираем нули
  while Pos(#0, tmp) > 0 do
    tmp[Pos(#0, tmp)] := '0';
  Memo1.Text:=tmp;
  try
   if bol then
   begin
    if CheckBox2.Checked then WriteLogFrom(st) ;
    Server1.Socket.Connections[0].SendText(st);
   end;
  except
    Server1.Close;
    Server1.Open;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
  with IconData do begin
    cbSize:=Sizeof(IconData);
    Wnd:=Form1.Handle;
    hIcon:=LoadIcon(hInstance,'TRAYP');
    uFlags:=NIF_ICON or NIF_TIP or NIF_MESSAGE;
    szTip:=APP_NAME;
    uCallbackMessage:=WM_TRAYMSG;
  end;
  Shell_NotifyIcon(NIM_ADD,@IconData);
  Server1.Port:=StrToInt(Edit3.Text);
  Server1.Open;

  logfrom:=CreateFile(PChar(LOG_FROM),GENERIC_WRITE,
                      FILE_SHARE_WRITE,nil,OPEN_ALWAYS,0,0);
  SetEnd(logfrom);

  logto:=CreateFile(PChar(LOG_TO),GENERIC_WRITE,
                    FILE_SHARE_WRITE,nil,OPEN_ALWAYS,0,0);
  SetEnd(logto);

  bol:=false;
  except
    Shell_NotifyIcon(NIM_DELETE,@IconData);
    PostQuitMessage(0);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  StatusBar1.Panels.Items[1].Text:='Подключение возобновлено';
  Server1.Close;
  Server1.Open;
  bol:=true;
end;

procedure TForm1.Server1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  StatusBar1.Panels.Items[1].Text:='Ошибка сети';
  ErrorCode:=0;
end;

procedure TForm1.Server1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusBar1.Panels.Items[1].Text:='Клиент подключился';
  bol:=true;
end;

procedure TForm1.Server1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusBar1.Panels.Items[1].Text:='Нет клиента';
  bol:=false;
end;

procedure TForm1.Server1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   str: string;
begin
  str:=Socket.ReceiveText;
  vbuf:=str;

  if CheckBox3.Checked then
     WriteLogTo(str);
  if CheckBox1.Checked then
     Client1.Socket.SendText(str);
end;      

procedure TForm1.Button3Click(Sender: TObject);
begin
  Server1.Close;
  bol:=false;
  StatusBar1.Panels.Items[1].Text:='Подключение остановлено';
end;

procedure TForm1.WMTrayMsg(var msg: TMsg);
begin
  case msg.wParam of
   WM_RBUTTONDOWN: begin
       GetCursorPos(MousePos);
       PopupMenu1.Popup(MousePos.X, MousePos.Y - (GetSystemMetrics(SM_CYMENUSIZE) * (PopupMenu1.Items.Count)));
     end;
   WM_LBUTTONDBLCLK: N1Click(nil);
  end;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  Form1.Show;
  SwitchToThisWindow(Application.Handle,true);
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE,@IconData);
  PostQuitMessage(0);
end;

procedure TForm1.Minimize(var msg: TMessage);
begin
  inherited;
  //SendMessage(Application.Handle,msg.Msg,msg.wParam,msg.lParam);
  case msg.WParam of
    SC_MINIMIZE: Form1.Hide;
    SC_CLOSE: begin
              Shell_NotifyIcon(NIM_DELETE,@IconData);
              PostQuitMessage(0);
              end;
  end;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Shell_NotifyIcon(NIM_DELETE,@IconData);
  CloseHandle(logto);
  CloseHandle(logfrom);
end;

end.
