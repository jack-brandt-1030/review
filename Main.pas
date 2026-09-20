unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, Generics.Collections,
  Vcl.NumberBox, Vcl.Buttons;

type
  TMainForm = class(TForm)
    PageControl: TPageControl;
    InfoSheet: TTabSheet;
    Tree: TTreeView;
    PracticeSheet: TTabSheet;
    PromptPanel: TPanel;
    QuestionAmountBox: TNumberBox;
    PanelA: TPanel;
    PanelB: TPanel;
    PanelC: TPanel;
    PanelD: TPanel;
    BtnA: TSpeedButton;
    BtnB: TSpeedButton;
    BtnC: TSpeedButton;
    BtnD: TSpeedButton;
    Panel: TPanel;
    QuestionsLabel: TLabel;
    ExpandBtn: TButton;
    ReviewBtn: TButton;
    CollapseBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ExpandBtnClick(Sender: TObject);
    procedure ReviewBtnClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure BtnClick(Sender: TObject);
    procedure CollapseBtnClick(Sender: TObject);
  private
    FGroups: TArray<TArray<string>>;
    FNameToGroup: TDictionary<string, TArray<string>>;

    FChosenGroup: TArray<string>;
    FQuestionNo: Integer;
    FCorrectId: Integer;
    FRemainingEvenIds: TArray<Integer>;
    FCorrectTag: Integer;

    procedure CreateTree;
    procedure AskQuestion;
    procedure ClearVars;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  s: string;
  Name: string;
  Group: TArray<string>;
  Pair: TArray<string>;
  Lines: TStringList;
begin
  Randomize;
  PageControl.ActivePageIndex := 0;
  Lines := TStringList.Create;
  try
    if GetEnvironmentVariable('USERNAME') = 'liftj' then
      s := '..\..\cards.txt'
    else
      s := 'cards.txt';
    Lines.LoadFromFile(s, TEncoding.UTF8);

    FGroups := [];
    Group := [];
    for s in Lines do begin
      if s = '' then
        Continue
      else if s[1] = '*' then begin
        if Length(Group) <> 0 then
          FGroups := FGroups + [Group];
        Name := Copy(s, 2, s.Length);
        Group := [Name];
      end else if s.Contains(' - ') then begin
        Pair := s.Split([' - ']);
        Group := Group + [Pair[0]] + [Pair[1]];
      end;
    end;
    FGroups := FGroups + [Group];

    CreateTree;
  finally
    Lines.Free;
  end;
end;

procedure TMainForm.CreateTree;
var
  Root: TTreeNode;
  Group: TArray<string>;
  i: Integer;
  Left: string;
  Right: string;
  Node: TTreeNode;
begin
  FNameToGroup := TDictionary<string, TArray<string>>.Create;
  Tree.Items.Clear;
  Root := Tree.Items.Add(nil, 'Info');
  for Group in FGroups do begin
    FNameToGroup.Add(Group[0], Group);
    Node := Tree.Items.Add(Root, Group[0]);
    for i := 1 to (Length(Group)-1) div 2 do begin
      Left := Group[2*i-1];
      Right := Group[2*i];
      Tree.Items.AddChild(Node, Left + ' - ' + Right);
    end;
  end;
  Tree.FullExpand;
  ReviewBtn.Enabled := False;
end;

procedure TMainForm.ExpandBtnClick(Sender: TObject);
begin
  Tree.FullExpand;
end;

procedure TMainForm.CollapseBtnClick(Sender: TObject);
begin
  Tree.FullCollapse;
end;

procedure TMainForm.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  ReviewBtn.Enabled := (Tree.Selected.Level = 0) and (Tree.Selected.Count > 0);
end;

procedure TMainForm.ReviewBtnClick(Sender: TObject);
var
  i: Integer;
begin
  FChosenGroup := FNameToGroup[Tree.Selected.Text];
  PageControl.ActivePage := PracticeSheet;
  FQuestionNo := 1;
  FRemainingEvenIds := [];
  for i := 1 to Length(FChosenGroup) - 1 do
    if i mod 2 = 0 then
      FRemainingEvenIds := FRemainingEvenIds + [i];
  AskQuestion;
end;

procedure TMainForm.AskQuestion;
var
  a: Integer;
  i: Integer;
  EvenIdCount: Integer;
  Left: string;
  Right: string;
  Btns: TArray<TSpeedButton>;
  TakenIds: THashSet<Integer>;
  WrongId: Integer;
begin

  if Length(FRemainingEvenIds) = 0 then begin
    ClearVars;
    PageControl.ActivePage := InfoSheet;
  end;

  a := Random(Length(FRemainingEvenIds)-1) + 1;
  FCorrectId := FRemainingEvenIds[a];
  Delete(FRemainingEvenIds, a, 1);
  FCorrectTag := Random(3);
  Left := FChosenGroup[FCorrectId-1];
  Right := FChosenGroup[FCorrectId];
  PromptPanel.Caption := Left;
  Btns := [BtnA, BtnB, BtnC, BtnD];
  Btns[FCorrectTag].Caption := Right;

  EvenIdCount := (Length(FChosenGroup)-1) div 2;

  TakenIds := THashSet<Integer>.Create;
  try
    TakenIds.Add(FCorrectId);
    for i := 0 to Length(Btns) - 1 do begin
      if i <> FCorrectTag then begin
        repeat
          WrongId := 2*(Random(EvenIdCount) + 1);
        until not TakenIds.Contains(WrongId);
        TakenIds.Add(WrongId);
        Btns[i].Caption := FChosenGroup[WrongId];
      end;
    end;
  finally
    TakenIds.Free;
  end;
end;

procedure TMainForm.BtnClick(Sender: TObject);
begin
  if (Sender as TSpeedButton).Tag = FCorrectTag then begin
    ShowMessage('Right!');
    Inc(FQuestionNo);
    AskQuestion;
  end;
end;

procedure TMainForm.ClearVars;
begin
  FChosenGroup := [];
  FQuestionNo := 0;
  FCorrectId := 0;
  FRemainingEvenIds := [];
  FCorrectTag := 0;
end;

{

*notes

group format:

[name, foreign language, english, foreign language, english, etc]
 0     1                 2        3                 4

*to do

handle picking the right answer / wrong answer
handle indenting within the txt file

}

end.
