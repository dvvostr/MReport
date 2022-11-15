object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'JWReports'
  ClientHeight = 424
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Button1: TButton
    Left = 496
    Top = 24
    Width = 114
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 496
    Top = 72
    Width = 114
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 496
    Top = 120
    Width = 114
    Height = 25
    Caption = 'Button3'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 496
    Top = 168
    Width = 114
    Height = 25
    Caption = 'Reference Report'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 496
    Top = 224
    Width = 114
    Height = 25
    Caption = 'XSLT '
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Left = 336
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    Left = 392
    Top = 16
  end
end
