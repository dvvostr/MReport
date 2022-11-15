object frmAnalystReferenceReport: TfrmAnalystReferenceReport
  Left = 0
  Top = 0
  Caption = 'Reference Report'
  ClientHeight = 734
  ClientWidth = 778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object LayoutControlLeft: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 778
    Height = 734
    Align = alClient
    TabOrder = 0
    object btnReportExecute: TButton
      Left = 624
      Top = 686
      Width = 146
      Height = 40
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1086#1090#1095#1077#1090
      TabOrder = 23
    end
    object edReportDateType: TcxComboBox
      Left = 126
      Top = 25
      Properties.DropDownListStyle = lsFixedList
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 0
      Width = 218
    end
    object edReportDateStart: TcxDateEdit
      Left = 87
      Top = 76
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 1
      Width = 243
    end
    object edReportDateEnd: TcxDateEdit
      Left = 87
      Top = 106
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 2
      Width = 243
    end
    object edReportBrandType: TcxPopupEdit
      Left = 126
      Top = 163
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 3
      Text = 'edReportBrandType'
      Width = 218
    end
    object edReportGoodsType: TcxPopupEdit
      Left = 126
      Top = 193
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 4
      Text = 'edReportGoodsType'
      Width = 218
    end
    object edReportProductionType: TcxPopupEdit
      Left = 126
      Top = 223
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 5
      Text = 'edReportProductionType'
      Width = 218
    end
    object edReportCollection: TcxPopupEdit
      Left = 126
      Top = 253
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 6
      Text = 'edReportCollection'
      Width = 218
    end
    object edReportPriceGroup: TcxPopupEdit
      Left = 126
      Top = 283
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 7
      Text = 'edReportPriceGroup'
      Width = 218
    end
    object edReportGoldColor: TcxPopupEdit
      Left = 126
      Top = 313
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 8
      Text = 'edReportGoldColor'
      Width = 218
    end
    object edReportColumns: TcxPopupEdit
      Left = 126
      Top = 373
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 10
      Text = 'edReportColumns'
      Width = 218
    end
    object edReportTopCount: TcxMaskEdit
      Left = 126
      Top = 343
      Properties.MaskKind = emkRegExprEx
      Properties.EditMask = '[0-9]+'
      Properties.MaxLength = 0
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 9
      Width = 218
    end
    object edReportLiquidType: TcxPopupEdit
      Left = 126
      Top = 403
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 11
      Text = 'edReportLiquidType'
      Width = 218
    end
    object edReportUseDistribution: TcxCheckBox
      Left = 22
      Top = 446
      Caption = #1057' '#1091#1095#1077#1090#1086#1084' '#1076#1080#1089#1090#1088#1080#1073#1091#1094#1080#1080':'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 12
    end
    object edReportUseConsignation: TcxCheckBox
      Left = 22
      Top = 472
      Caption = #1057' '#1091#1095#1077#1090#1086#1084' '#1082#1086#1085#1089#1080#1075#1085#1072#1094#1080#1080
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 13
    end
    object edReportSortByModels: TcxCheckBox
      Left = 22
      Top = 498
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1084#1086#1076#1077#1083#1103#1084
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 14
    end
    object edReportShowRefWithSalesOnly: TcxCheckBox
      Left = 22
      Top = 524
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1072#1088#1090#1080#1082#1091#1083#1099' '#1090#1086#1083#1100#1082#1086' '#1089' '#1087#1088#1086#1076#1072#1078#1072#1084#1080
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 15
    end
    object edReportShowWatchDiameter: TcxCheckBox
      Left = 22
      Top = 550
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' "'#1044#1080#1072#1084#1077#1090#1088' '#1095#1072#1089#1086#1074'"'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 16
    end
    object edReportShowSize: TcxCheckBox
      Left = 22
      Top = 576
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' "'#1056#1072#1079#1084#1077#1088'"'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 17
    end
    object edReportAllSizePhoto: TcxCheckBox
      Left = 22
      Top = 602
      Caption = #1060#1086#1090#1086' '#1087#1086' '#1074#1089#1077#1084' '#1088#1072#1079#1084#1077#1088#1072#1084
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 18
    end
    object edReportCreatePivot: TcxCheckBox
      Left = 22
      Top = 641
      Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1089#1074#1086#1076#1085#1086#1081' '#1090#1072#1073#1083#1080#1094#1099
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 19
    end
    object edReportLocationDetail: TcxCheckBox
      Left = 22
      Top = 667
      Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1086' '#1087#1083#1086#1097#1072#1076#1082#1080
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 20
    end
    object edReportShowPhotoForEachSize: TcxCheckBox
      Left = 22
      Top = 693
      Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1092#1086#1090#1086' '#1076#1083#1103' '#1082#1072#1078#1076#1086#1075#1086' '#1088#1072#1079#1084#1077#1088#1072
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 21
    end
    object edReportBrandGroup: TcxDBTreeList
      Left = 392
      Top = 25
      Width = 364
      Height = 640
      Bands = <
        item
        end>
      Navigator.Buttons.CustomButtons = <>
      RootValue = -1
      ScrollbarAnnotations.CustomAnnotations = <>
      TabOrder = 22
      object edReportBrandGroupcxDBTreeListColumn1: TcxDBTreeListColumn
        DataBinding.FieldName = 'NAME'
        Width = 335
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
    end
    object LayoutControlLeftGroup_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      CaptionOptions.Text = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1086#1090#1095#1077#1090#1072
      Hidden = True
      LayoutDirection = ldHorizontal
      Padding.Bottom = -4
      Padding.Left = -4
      Padding.Right = -4
      Padding.Top = -8
      Padding.AssignedValues = [lpavBottom, lpavLeft, lpavRight, lpavTop]
      ShowBorder = False
      Index = -1
    end
    object liReportDateType: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1058#1080#1087' '#1076#1072#1090#1099':'
      Control = edReportDateType
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liReportSettings: TdxLayoutGroup
      Parent = LayoutControlLeftGroup_Root
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1086#1090#1095#1077#1090#1072
      SizeOptions.Width = 350
      Padding.AssignedValues = [lpavTop]
      Index = 0
    end
    object liReportDatePeriod: TdxLayoutGroup
      Parent = liReportSettings
      CaptionOptions.Text = #1055#1088#1086#1080#1079#1074#1086#1083#1100#1085#1099#1081' '#1087#1077#1088#1080#1086#1076
      Index = 1
    end
    object liReportDateStart: TdxLayoutItem
      Parent = liReportDatePeriod
      CaptionOptions.Text = #1053#1072#1095#1072#1083#1086':'
      Control = edReportDateStart
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liReportDateEnd: TdxLayoutItem
      Parent = liReportDatePeriod
      CaptionOptions.Text = #1050#1086#1085#1077#1094':'
      Control = edReportDateEnd
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liReportSeparator1: TdxLayoutSeparatorItem
      Parent = liReportSettings
      CaptionOptions.Text = 'Separator'
      Index = 2
    end
    object liReportBrandType: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1058#1080#1087' '#1073#1088#1077#1085#1076#1072':'
      Control = edReportBrandType
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liReportGoodsType: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1058#1080#1087' '#1090#1086#1074#1072#1088#1072':'
      Control = edReportGoodsType
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liReportProductionType: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1058#1080#1087' '#1080#1079#1076#1077#1083#1080#1103':'
      Control = edReportProductionType
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liReportCollection: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1050#1086#1083#1083#1077#1082#1094#1080#1103':'
      Control = edReportCollection
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object liReportPriceGroup: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1043#1088#1091#1087#1087#1072' '#1094#1077#1085':'
      Control = edReportPriceGroup
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object liReportGoldColor: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1062#1074#1077#1090' '#1079#1086#1083#1086#1090#1072':'
      Control = edReportGoldColor
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 8
    end
    object liReportTopCount: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1058#1086#1087' '#1072#1088#1090#1080#1082#1091#1083#1086#1074':'
      Control = edReportTopCount
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 9
    end
    object liReportColumns: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1050#1086#1083#1086#1085#1082#1080':'
      Control = edReportColumns
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 10
    end
    object liReportLiquidType: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1058#1080#1087' '#1083#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080':'
      Control = edReportLiquidType
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 11
    end
    object liReportSeparator2: TdxLayoutSeparatorItem
      Parent = liReportSettings
      CaptionOptions.Text = 'Separator'
      Index = 12
    end
    object liReportUseDistribution: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1057' '#1091#1095#1077#1090#1086#1084' '#1076#1080#1089#1090#1088#1080#1073#1091#1094#1080#1080
      CaptionOptions.Visible = False
      Control = edReportUseDistribution
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 147
      ControlOptions.ShowBorder = False
      Index = 13
    end
    object liReportSortByModels: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1084#1086#1076#1077#1083#1103#1084':'
      CaptionOptions.Visible = False
      Control = edReportSortByModels
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 15
    end
    object liReportShowRefWithSalesOnly: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1072#1088#1090#1080#1082#1091#1083#1099' '#1090#1086#1083#1100#1082#1086' '#1089' '#1087#1088#1086#1076#1072#1078#1072#1084#1080
      CaptionOptions.Visible = False
      Control = edReportShowRefWithSalesOnly
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 16
    end
    object liReportShowWatchDiameter: TdxLayoutItem
      Parent = liReportSettings
      AlignHorz = ahLeft
      CaptionOptions.Text = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' "'#1044#1080#1072#1084#1077#1090#1088' '#1095#1072#1089#1086#1074'"'
      CaptionOptions.Visible = False
      Control = edReportShowWatchDiameter
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 179
      ControlOptions.ShowBorder = False
      Index = 17
    end
    object liReportShowSize: TdxLayoutItem
      Parent = liReportSettings
      AlignHorz = ahLeft
      CaptionOptions.Text = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' "'#1056#1072#1079#1084#1077#1088'"'
      CaptionOptions.Visible = False
      Control = edReportShowSize
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 136
      ControlOptions.ShowBorder = False
      Index = 18
    end
    object liReportUseConsignation: TdxLayoutItem
      Parent = liReportSettings
      CaptionOptions.Text = #1057' '#1091#1095#1077#1090#1086#1084' '#1082#1086#1085#1089#1080#1075#1085#1072#1094#1080#1080':'
      CaptionOptions.Visible = False
      Control = edReportUseConsignation
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 14
    end
    object liReportAllSizePhoto: TdxLayoutItem
      Parent = liReportSettings
      AlignHorz = ahLeft
      CaptionOptions.Text = #1060#1086#1090#1086' '#1087#1086' '#1074#1089#1077#1084' '#1088#1072#1079#1084#1077#1088#1072#1084
      CaptionOptions.Visible = False
      Control = edReportAllSizePhoto
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 151
      ControlOptions.ShowBorder = False
      Index = 19
    end
    object liReportSeparator3: TdxLayoutSeparatorItem
      Parent = liReportSettings
      CaptionOptions.Text = 'Separator'
      Index = 20
    end
    object liReportCreatePivot: TdxLayoutItem
      Parent = liReportSettings
      AlignHorz = ahLeft
      CaptionOptions.Text = #1057#1086#1079#1076#1072#1085#1080#1077' '#1089#1074#1086#1076#1085#1086#1081' '#1090#1072#1073#1083#1080#1094#1099
      CaptionOptions.Visible = False
      Control = edReportCreatePivot
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 21
    end
    object liReportLocationDetail: TdxLayoutItem
      Parent = liReportSettings
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1086' '#1087#1083#1086#1097#1072#1076#1082#1080
      CaptionOptions.Visible = False
      Control = edReportLocationDetail
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 164
      ControlOptions.ShowBorder = False
      Index = 22
    end
    object liReportShowPhotoForEachSize: TdxLayoutItem
      Parent = liReportSettings
      AlignHorz = ahLeft
      CaptionOptions.Text = #1042#1099#1074#1086#1076#1080#1090#1100' '#1092#1086#1090#1086' '#1076#1083#1103' '#1082#1072#1078#1076#1086#1075#1086' '#1088#1072#1079#1084#1077#1088#1072
      CaptionOptions.Visible = False
      Control = edReportShowPhotoForEachSize
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 222
      ControlOptions.ShowBorder = False
      Index = 23
    end
    object liReportSeparator4: TdxLayoutSeparatorItem
      Parent = LayoutControlLeftGroup_Root
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object liReportBrandGroupGroup: TdxLayoutGroup
      Parent = liReportRight
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = #1041#1088#1077#1085#1076'-'#1075#1088#1091#1087#1087#1072
      Index = 0
    end
    object liReportBrandGroup: TdxLayoutItem
      Parent = liReportBrandGroupGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxDBTreeList1'
      CaptionOptions.Visible = False
      Control = edReportBrandGroup
      ControlOptions.OriginalHeight = 150
      ControlOptions.OriginalWidth = 250
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liReportExecute: TdxLayoutItem
      Parent = liReportRight
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnReportExecute
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 146
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liReportRight: TdxLayoutAutoCreatedGroup
      Parent = LayoutControlLeftGroup_Root
      AlignHorz = ahClient
      Index = 2
    end
  end
end
