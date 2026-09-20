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
    ActivePage = InfoSheet
    Align = alClient
    TabOrder = 0
    object InfoSheet: TTabSheet
      Caption = 'Info'
      ImageIndex = 1
      object Tree: TTreeView
        AlignWithMargins = True
        Left = 3
        Top = 53
        Width = 610
        Height = 355
        Align = alClient
        Indent = 19
        TabOrder = 0
        OnChange = TreeChange
        ExplicitTop = 63
        ExplicitHeight = 345
      end
      object Panel: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 50
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitTop = 30
        object QuestionsLabel: TLabel
          Left = 218
          Top = 9
          Width = 53
          Height = 15
          Caption = 'Questions'
        end
        object QuestionAmountBox: TNumberBox
          Left = 277
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
        object ReviewBtn: TButton
          Left = 95
          Top = 5
          Width = 75
          Height = 25
          Caption = 'Review'
          TabOrder = 2
          OnClick = ReviewBtnClick
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
