object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Review'
  ClientHeight = 504
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object PageControl: TPageControl
    Left = 0
    Top = 40
    Width = 796
    Height = 464
    ActivePage = ReviewSheet
    Align = alClient
    TabOrder = 0
    object GenerateSheet: TTabSheet
      Caption = 'Generate'
      ImageIndex = 2
      object Memo: TMemo
        Left = 0
        Top = 0
        Width = 788
        Height = 434
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitTop = 40
      end
    end
    object InfoSheet: TTabSheet
      Caption = 'Info'
      ImageIndex = 1
      object Tree: TTreeView
        AlignWithMargins = True
        Left = 3
        Top = 43
        Width = 782
        Height = 388
        Align = alClient
        BorderStyle = bsNone
        Indent = 19
        TabOrder = 0
        ExplicitTop = 53
        ExplicitHeight = 418
      end
      object Panel: TPanel
        Left = 0
        Top = 0
        Width = 788
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object QuestionsLabel: TLabel
          Left = 190
          Top = 9
          Width = 53
          Height = 15
          Caption = 'Questions'
        end
        object QuestionAmountBox: TNumberBox
          Left = 249
          Top = 6
          Width = 25
          Height = 23
          TabOrder = 0
          Value = 25.000000000000000000
        end
        object ExpandBtn: TButton
          Left = 10
          Top = 5
          Width = 75
          Height = 25
          Caption = 'Expand'
          TabOrder = 1
          OnClick = ExpandBtnClick
        end
        object CollapseBtn: TButton
          Left = 95
          Top = 5
          Width = 75
          Height = 25
          Caption = 'Collapse'
          TabOrder = 2
          OnClick = CollapseBtnClick
        end
      end
    end
    object ReviewSheet: TTabSheet
      Caption = 'Review'
      ImageIndex = 2
      object PromptPanel: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 782
        Height = 240
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
      end
      object PanelA: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 249
        Width = 782
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 1
        object BtnA: TSpeedButton
          Left = 0
          Top = 0
          Width = 782
          Height = 41
          Align = alClient
          Flat = True
          OnClick = AnswerBtnClick
          ExplicitLeft = 80
          ExplicitTop = 8
          ExplicitWidth = 23
          ExplicitHeight = 22
        end
      end
      object PanelB: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 296
        Width = 782
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 2
        object BtnB: TSpeedButton
          Tag = 1
          Left = 0
          Top = 0
          Width = 782
          Height = 41
          Align = alClient
          Flat = True
          OnClick = AnswerBtnClick
          ExplicitLeft = 88
          ExplicitTop = 16
          ExplicitWidth = 23
          ExplicitHeight = 22
        end
      end
      object PanelC: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 343
        Width = 782
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 3
        object BtnC: TSpeedButton
          Tag = 2
          Left = 0
          Top = 0
          Width = 782
          Height = 41
          Align = alClient
          Flat = True
          OnClick = AnswerBtnClick
          ExplicitLeft = 96
          ExplicitTop = 24
          ExplicitWidth = 23
          ExplicitHeight = 22
        end
      end
      object PanelD: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 390
        Width = 782
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 4
        object BtnD: TSpeedButton
          Tag = 3
          Left = 0
          Top = 0
          Width = 782
          Height = 41
          Align = alClient
          Flat = True
          OnClick = AnswerBtnClick
          ExplicitLeft = 104
          ExplicitTop = 32
          ExplicitWidth = 23
          ExplicitHeight = 22
        end
      end
    end
  end
  object InfoPanel: TPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 40
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = 'Words here'
    TabOrder = 1
  end
end
