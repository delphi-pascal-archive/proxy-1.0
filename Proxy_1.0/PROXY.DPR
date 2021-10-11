program proxy;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}
{$R XPManifest.res}

begin
  Application.Initialize;
  Application.Title := 'VKSSoft - Retranslator 1.0';
  Application.ShowMainForm:=false;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
