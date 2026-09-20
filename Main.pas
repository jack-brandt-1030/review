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
    ToolBar: TToolBar;
    ExpandBtn: TToolButton;
    QuestionAmountBox: TNumberBox;
    PanelA: TPanel;
    PanelB: TPanel;
    PanelC: TPanel;
    PanelD: TPanel;
    BtnA: TSpeedButton;
    BtnB: TSpeedButton;
    BtnC: TSpeedButton;
    BtnD: TSpeedButton;
    ReviewBtn: TToolButton;
    Panel: TPanel;
    QuestionsLabel: TLabel;
    TestPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ExpandBtnClick(Sender: TObject);
    procedure ReviewBtnClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure BtnClick(Sender: TObject);
  private
    FGroups: TArray<TArray<string>>;
    FGroup: TArray<string>;
    FNameToGroup: TDictionary<string, TArray<string>>;
    FQuestion: Integer;
    FId: Integer;
    FIds: TArray<Integer>;
    procedure CreateTree;
  public
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
  Tree.FullCollapse;
end;

procedure TMainForm.ExpandBtnClick(Sender: TObject);
begin
  Tree.FullExpand;
end;

procedure TMainForm.ReviewBtnClick(Sender: TObject);
var
  i: Integer;
  RandomCorrectIndex: Integer;
  Btn: TSpeedButton;
  Left: string;
  Right: string;
  Btns: TArray<TSpeedButton>;
  WrongIds: TArray<Integer>;
  EvenIdCount: Integer;
  TakenIds: THashSet<Integer>;
begin
  PageControl.ActivePageIndex := PageControl.ActivePageIndex + 1;
  Btns := [BtnA, BtnB, BtnC, BtnD];
  FGroup := FNameToGroup[Tree.Selected.Text];
  FQuestion := QuestionAmountBox.ValueInt;
  FIds := [];
  EvenIdCount := (Length(FGroup)-1) div 2;
  for i := 1 to EvenIdCount do
    FIds := FIds + [i];
  FId := Random(Length(FIds)) + 1;
  Delete(FIds, FId, 1);
  RandomCorrectIndex := Random(3);
  Left := FGroup[2*FId-1];
  Right := FGroup[2*FId];
  PromptPanel.Caption := Left;
  Btns[RandomCorrectIndex].Caption := Right;

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

procedure TMainForm.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  ReviewBtn.Enabled := Tree.Selected.Level = 0;
end;

procedure TMainForm.BtnClick(Sender: TObject);
begin
//
end;

{

to do - handle indenting within the txt file

}

end.
