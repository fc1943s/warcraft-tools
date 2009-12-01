object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 244
  ClientWidth = 235
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object lblTitle: TLabel
    Left = 0
    Top = 6
    Width = 235
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = 'UnknowN Warcraft Tools X.X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
  end
  object lblStew: TLabel
    Left = 0
    Top = 23
    Width = 235
    Height = 16
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    Caption = 'by Stew UnknowN'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = [fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    OnClick = lblUFClick
  end
  object lblUF: TLabel
    Left = 0
    Top = 39
    Width = 235
    Height = 16
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    Caption = 'http://u-forum.org/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = [fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    OnClick = lblUFClick
  end
  object lblStatus: TLabel
    Left = 0
    Top = 205
    Width = 235
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'Status: Aguardando Warcraft 1.21b'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblUpdates: TLabel
    Left = 0
    Top = 222
    Width = 235
    Height = 16
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    Caption = 'Atualiza'#231#245'es em http://u-forum.org/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = [fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    OnClick = lblUFClick
  end
  object lblHotkey: TLabel
    Left = 0
    Top = 187
    Width = 235
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'Tecla de atalho: Delete'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
  end
  object btnActive: TButton
    Left = 70
    Top = 167
    Width = 89
    Height = 20
    Cursor = crHandPoint
    Caption = 'Ativar'
    Enabled = False
    TabOrder = 0
    OnClick = btnActiveClick
  end
  object gbxHacks: TGroupBox
    Left = 10
    Top = 117
    Width = 215
    Height = 44
    Caption = 'Hacks'
    TabOrder = 1
    object chbMapHack: TCheckBox
      Left = 12
      Top = 18
      Width = 97
      Height = 17
      Caption = 'Map Hack'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chbMapHackClick
    end
  end
  object rgpLanguage: TRadioGroup
    Left = 10
    Top = 60
    Width = 109
    Height = 53
    Caption = 'Idioma/Language:'
    ItemIndex = 0
    Items.Strings = (
      'Portugu'#234's'
      'English')
    TabOrder = 2
    OnClick = rgpLanguageClick
  end
  object rgpVersion: TRadioGroup
    Left = 132
    Top = 60
    Width = 93
    Height = 53
    Caption = 'Vers'#227'o:'
    ItemIndex = 1
    Items.Strings = (
      '1.21b'
      '1.22')
    TabOrder = 3
    OnClick = rgpVersionClick
  end
  object tmr1: TTimer
    Interval = 200
    OnTimer = tmr1Timer
    Left = 5
    Top = 1
  end
end
