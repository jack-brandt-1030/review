object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Review'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    ActivePage = PracticeSheet
    Align = alClient
    TabOrder = 0
    object InfoSheet: TTabSheet
      Caption = 'Info'
      ImageIndex = 1
      object Tree: TTreeView
        AlignWithMargins = True
        Left = 3
        Top = 63
        Width = 610
        Height = 345
        Align = alClient
        Indent = 19
        TabOrder = 0
        OnChange = TreeChange
        ExplicitLeft = 64
        ExplicitTop = 88
        ExplicitWidth = 393
        ExplicitHeight = 289
      end
      object Panel: TPanel
        Left = 0
        Top = 30
        Width = 616
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitTop = 50
        object QuestionsLabel: TLabel
          Left = 10
          Top = 8
          Width = 53
          Height = 15
          Caption = 'Questions'
        end
        object QuestionAmountBox: TNumberBox
          Left = 75
          Top = 5
          Width = 25
          Height = 23
          TabOrder = 0
          Value = 25.000000000000000000
        end
      end
      object TestPanel: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object ToolBar: TToolBar
          Left = 0
          Top = 0
          Width = 616
          Height = 30
          Align = alClient
          ButtonHeight = 29
          ButtonWidth = 57
          Caption = 'ToolBar'
          ShowCaptions = True
          TabOrder = 0
          object ExpandBtn: TToolButton
            Left = 0
            Top = 0
            Caption = 'Expand'
            ImageIndex = 0
            Style = tbsTextButton
            OnClick = ExpandBtnClick
          end
          object ReviewBtn: TToolButton
            Left = 57
            Top = 0
            Caption = 'Review'
            ImageIndex = 1
            OnClick = ReviewBtnClick
          end
        end
      end
    end
    object PracticeSheet: TTabSheet
      Caption = 'Practice'
      ImageIndex = 2
      object PromptPanel: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 610
        Height = 217
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 616
        ExplicitHeight = 100
      end
      object PanelA: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 226
        Width = 610
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 1
        ExplicitLeft = 88
        ExplicitTop = 168
        ExplicitWidth = 185
        object BtnA: TSpeedButton
          Left = 0
          Top = 0
          Width = 610
          Height = 41
          Align = alClient
          Flat = True
          OnClick = BtnClick
          ExplicitLeft = 80
          ExplicitTop = 8
          ExplicitWidth = 23
          ExplicitHeight = 22
        end
      end
      object PanelB: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 273
        Width = 610
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 2
        ExplicitLeft = 328
        ExplicitTop = 160
        ExplicitWidth = 185
        object BtnB: TSpeedButton
          Left = 0
          Top = 0
          Width = 610
          Height = 41
          Align = alClient
          Flat = True
          ExplicitLeft = 88
          ExplicitTop = 16
          ExplicitWidth = 23
          ExplicitHeight = 22
        end
      end
      object PanelC: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 320
        Width = 610
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 3
        ExplicitLeft = 88
        ExplicitTop = 280
        ExplicitWidth = 185
        object BtnC: TSpeedButton
          Left = 0
          Top = 0
          Width = 610
          Height = 41
          Align = alClient
          Flat = True
          ExplicitLeft = 96
          ExplicitTop = 24
          ExplicitWidth = 23
          ExplicitHeight = 22
        end
      end
      object PanelD: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 367
        Width = 610
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 4
        ExplicitLeft = 368
        ExplicitTop = 288
        ExplicitWidth = 185
        object BtnD: TSpeedButton
          Left = 0
          Top = 0
          Width = 610
          Height = 41
          Align = alClient
          Flat = True
          ExplicitLeft = 104
          ExplicitTop = 32
          ExplicitWidth = 23
          ExplicitHeight = 22
        end
      end
    end
  end
end
