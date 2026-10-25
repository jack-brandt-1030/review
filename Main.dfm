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
  OnMouseWheel = FormMouseWheel
  TextHeight = 15
  object PageControl: TPageControl
    Left = 0
    Top = 40
    Width = 796
    Height = 434
    ActivePage = InfoSheet
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 464
    object InfoSheet: TTabSheet
      Caption = 'Info'
      ImageIndex = 3
      object ScrollBox: TScrollBox
        Left = 0
        Top = 0
        Width = 788
        Height = 404
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 434
        object InfoLabel: TLabel
          Left = 10
          Top = 10
          Width = 237
          Height = 510
          Caption = 
            'Formatted notes have the following:'#13#10'Groups marked with *'#13#10'Subgr' +
            'oups marked with ()'#13#10'Info separated by -'#13#10'Unrelated info below *' +
            '**'#13#10'Notes for info indented'#13#10'Notes with - become useable cards'#13#10 +
            'See the following:'#13#10#13#10'*Verbs'#13#10#13#10'essen - eat'#13#10'fressen - devour'#13#10#13 +
            #10'*Nouns'#13#10#13#10'(der)'#13#10#13#10'Baum - Tree'#13#10'    Birnbaum - Pear Tree'#13#10#13#10'(di' +
            'e)'#13#10#13#10'Katze - Cat'#13#10'    Meine Katze ist s'#252#223#13#10#13#10'*Misc'#13#10#13#10'Eher schl' +
            'echt als recht - More bad than good'#13#10#13#10'***'#13#10#13#10'Other info'#13#10'Boris ' +
            'Pistorius (SPD)'
        end
      end
    end
    object GenerateSheet: TTabSheet
      Caption = 'Generate'
      ImageIndex = 2
      object Memo: TMemo
        Left = 0
        Top = 0
        Width = 788
        Height = 404
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitHeight = 434
      end
    end
    object DataSheet: TTabSheet
      Caption = 'Data'
      ImageIndex = 1
      object Tree: TTreeView
        AlignWithMargins = True
        Left = 3
        Top = 43
        Width = 782
        Height = 358
        Align = alClient
        BorderStyle = bsNone
        Indent = 19
        TabOrder = 0
        ExplicitHeight = 388
      end
      object Panel: TPanel
        Left = 0
        Top = 0
        Width = 788
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object ExpandBtn: TButton
          Left = 10
          Top = 5
          Width = 75
          Height = 25
          Caption = 'Expand'
          TabOrder = 0
          OnClick = ExpandBtnClick
        end
        object CollapseBtn: TButton
          Left = 95
          Top = 5
          Width = 75
          Height = 25
          Caption = 'Collapse'
          TabOrder = 1
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
        Height = 210
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitHeight = 240
      end
      object PanelA: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 219
        Width = 782
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 1
        ExplicitTop = 249
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
        Top = 266
        Width = 782
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 2
        ExplicitTop = 296
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
        Top = 313
        Width = 782
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 3
        ExplicitTop = 343
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
        Top = 360
        Width = 782
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 4
        ExplicitTop = 390
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
  object BottomPanel: TPanel
    Left = 0
    Top = 474
    Width = 796
    Height = 30
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 484
  end
end
