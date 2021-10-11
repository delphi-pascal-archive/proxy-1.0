object Form1: TForm1
  Left = 227
  Top = 131
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'VKSSoft - Proxy 1.0'
  ClientHeight = 358
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 339
    Width = 405
    Height = 19
    Panels = <
      item
        Text = #1054#1090#1082#1083#1102#1095#1077#1085
        Width = 160
      end
      item
        Text = #1053#1077#1090' '#1082#1083#1080#1077#1085#1090#1072
        Width = 50
      end>
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 405
    Height = 233
    Align = alTop
    Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1077#1088#1074#1077#1088#1072' '
    TabOrder = 1
    object Label1: TLabel
      Left = 20
      Top = 32
      Width = 15
      Height = 16
      Caption = 'IP:'
    end
    object Label3: TLabel
      Left = 20
      Top = 62
      Width = 27
      Height = 16
      Caption = 'Port:'
    end
    object Label4: TLabel
      Left = 207
      Top = 28
      Width = 145
      Height = 16
      Caption = #1055#1088#1080#1089#1099#1083#1072#1077#1084#1099#1077' '#1087#1072#1082#1077#1090#1099':'
    end
    object Edit1: TEdit
      Left = 59
      Top = 30
      Width = 129
      Height = 21
      TabOrder = 1
      Text = '172.17.1.100'
    end
    object Edit2: TEdit
      Left = 59
      Top = 59
      Width = 129
      Height = 21
      TabOrder = 2
      Text = '6006'
    end
    object Button1: TButton
      Left = 10
      Top = 100
      Width = 177
      Height = 31
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1082' '#1089#1077#1088#1074#1077#1088#1091
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 10
      Top = 143
      Width = 178
      Height = 31
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1086#1090' '#1089#1077#1088#1074#1077#1088#1072
      TabOrder = 3
      OnClick = Button2Click
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 201
      Width = 178
      Height = 21
      Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1086#1089#1099#1083#1082#1091
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object CheckBox2: TCheckBox
      Left = 207
      Top = 49
      Width = 149
      Height = 21
      Caption = 'Log it to "from.log"'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object Memo1: TMemo
      Left = 207
      Top = 79
      Width = 178
      Height = 138
      ScrollBars = ssVertical
      TabOrder = 6
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 233
    Width = 405
    Height = 106
    Align = alClient
    Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1083#1080#1077#1085#1090#1072' '
    TabOrder = 2
    object Label2: TLabel
      Left = 10
      Top = 34
      Width = 27
      Height = 16
      Caption = 'Port:'
    end
    object Edit3: TEdit
      Left = 46
      Top = 30
      Width = 113
      Height = 21
      TabOrder = 0
      Text = '3333'
    end
    object Button4: TButton
      Left = 208
      Top = 22
      Width = 185
      Height = 30
      Caption = #1055#1077#1088#1077#1079#1072#1087#1091#1089#1090#1080#1090#1100
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button3: TButton
      Left = 208
      Top = 64
      Width = 185
      Height = 31
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077
      TabOrder = 2
      OnClick = Button3Click
    end
    object CheckBox3: TCheckBox
      Left = 10
      Top = 71
      Width = 119
      Height = 21
      Caption = 'Log it to "to.log"'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object Client1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = Client1Connect
    OnDisconnect = Client1Disconnect
    OnRead = Client1Read
    OnError = Client1Error
    Left = 216
    Top = 88
  end
  object Server1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = Server1ClientConnect
    OnClientDisconnect = Server1ClientDisconnect
    OnClientRead = Server1ClientRead
    OnClientError = Server1ClientError
    Left = 248
    Top = 88
  end
  object PopupMenu1: TPopupMenu
    Left = 216
    Top = 120
    object N1: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      Default = True
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = N3Click
    end
  end
end
