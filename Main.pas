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
    FGroup: TArray<string>;
    FNameToGroup: TDictionary<string, TArray<string>>;
    FQuestionNo: Integer;
    FId: Integer;
    FIds: TArray<Integer>;
    FRandomCorrectIndex: Integer;
    procedure CreateTree;
    procedure AskQuestion;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);

  function ReadLines(Lines: TStringList): TArray<TArray<string>>;
  var
    s: string;
    Name: string;
    Group: TArray<string>;
    Pair: TArray<string>;
  begin
    Result := [];
    Group := [];
    for s in Lines do begin
      if s = '' then
        Continue
      else if s[1] = '*' then begin
        if Length(Group) <> 0 then
          Result := Result + [Group];
        Name := Copy(s, 2, s.Length);
        Group := [Name];
      end else if s.Contains(' - ') then begin
        Pair := s.Split([' - ']);
        Group := Group + [Pair[0]] + [Pair[1]];
      end;
    end;
    Result := Result + [Group];
  end;
var
  Lines: TStringList;
  s: string;
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
    FGroups := ReadLines(Lines);
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
  EvenIdCount: Integer;
begin
  PageControl.ActivePageIndex := PageControl.ActivePageIndex + 1;
  FGroup := FNameToGroup[Tree.Selected.Text];
  FQuestionNo := 1;
  FIds := [];
  EvenIdCount := (Length(FGroup)-1) div 2;
  for i := 1 to EvenIdCount do
    FIds := FIds + [i];
  AskQuestion;
end;

procedure TMainForm.AskQuestion;
var
  i: Integer;
  EvenIdCount: Integer;
  Btn: TSpeedButton;
  Left: string;
  Right: string;
  Btns: TArray<TSpeedButton>;
  WrongIds: TArray<Integer>;
  TakenIds: THashSet<Integer>;
begin
  FId := Random(Length(FIds)) + 1;
  Delete(FIds, FId, 1);
  FRandomCorrectIndex := Random(3);
  Left := FGroup[2*FId-1];
  Right := FGroup[2*FId];
  PromptPanel.Caption := Left;
  Btns := [BtnA, BtnB, BtnC, BtnD];
  Btns[FRandomCorrectIndex].Caption := Right;

  EvenIdCount := (Length(FGroup)-1) div 2;

  TakenIds := THashSet<Integer>.Create;
  try
    TakenIds.Add(FId);
    WrongIds := [0, 0, 0];
    for i := 0 to 2 do begin
      repeat
        WrongIds[i] := Random(EvenIdCount) + 1;
      until not TakenIds.Contains(WrongIds[i]);
      TakenIds.Add(WrongIds[i]);
    end;
  finally
    TakenIds.Free;
  end;

  i := 0;
  for Btn in Btns do begin
    if Btn.Caption = '' then begin
      Btn.Caption := FGroup[2*WrongIds[i]];
      Inc(i);
    end;
  end;
end;

procedure TMainForm.BtnClick(Sender: TObject);
begin
  if (Sender as TSpeedButton).Tag = FRandomCorrectIndex then begin
    ShowMessage('Right');
    Inc(FQuestionNo);
    AskQuestion;
  end;
end;

{

to do

handle picking the right answer / wrong answer
handle indenting within the txt file

}

end.
