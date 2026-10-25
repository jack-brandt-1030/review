unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, Generics.Collections,
  Vcl.NumberBox, Vcl.Buttons;

type
  TCard = class
    Left: string;
    Right: string;
    Notes: TArray<string>;
  end;

  TGroup = class
    Name: string;
    Cards: TObjectList<TCard>;
    Groups: TObjectList<TGroup>;
    constructor Create;
    destructor Destroy; override;
  end;

  TMainForm = class(TForm)
    PageControl: TPageControl;
    DataSheet: TTabSheet;
    Tree: TTreeView;
    ReviewSheet: TTabSheet;
    PromptPanel: TPanel;
    PanelA: TPanel;
    PanelB: TPanel;
    PanelC: TPanel;
    PanelD: TPanel;
    BtnA: TSpeedButton;
    BtnB: TSpeedButton;
    BtnC: TSpeedButton;
    BtnD: TSpeedButton;
    Panel: TPanel;
    ExpandBtn: TButton;
    CollapseBtn: TButton;
    GenerateSheet: TTabSheet;
    Memo: TMemo;
    InfoPanel: TPanel;
    InfoSheet: TTabSheet;
    InfoLabel: TLabel;
    ScrollBox: TScrollBox;
    BottomPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ExpandBtnClick(Sender: TObject);
    procedure AnswerBtnClick(Sender: TObject);
    procedure CollapseBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    FGroups: TArray<TGroup>;
    FNodeToGroup: TDictionary<TTreeNode, TGroup>;
    FChosenGroup: TGroup;
    FCorrectId: Integer;
    FRemainingIds: TArray<Integer>;
    FCorrectTag: Integer;
    procedure GoToSheet(Sheet: TTabSheet);
    procedure ReadMemo;
    procedure StartReview;
    procedure AskQuestion;
    procedure ClearVars;
    procedure AnswerBtn(i: Integer);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

constructor TGroup.Create;
begin
  Cards := TObjectList<TCard>.Create(True);
  Groups := TObjectList<TGroup>.Create(True);
end;

destructor TGroup.Destroy;
begin
  Cards.Free;
  Groups.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Randomize;
  KeyPreview := True;
  for i := 0 to PageControl.PageCount - 1 do
    PageControl.Pages[i].TabVisible := False;
  BottomPanel.Caption := '  Control 0 - info page. Control 1 - paste notes here. Control 2 - data tree page. Control 3 - review page. Control X - hide this';
  GoToSheet(GenerateSheet);
end;

procedure TMainForm.ReadMemo;

  procedure AddToTree(
    Tree: TTreeView;
    ParentNode: TTreeNode;
    Group: TGroup);
  var
    Card: TCard;
    Left: string;
    Right: string;
    Subgroup: TGroup;
    Node: TTreeNode;
  begin
    Node := Tree.Items.AddChild(ParentNode, Group.Name);
    FNodeToGroup.Add(Node, Group);
    for Card in Group.Cards do begin
      Left := Card.Left;
      Right := Card.Right;
      Tree.Items.AddChild(Node, Left + ' - ' + Right);
    end;
    for Subgroup in Group.Groups do
      AddToTree(Tree, Node, Subgroup);
  end;

const
  TabStr = '    ';
var
  Line: string;
  Group: TGroup;
  Card: TCard;
  Pair: TArray<string>;
  Subgroup: TGroup;
  NewGroup: Boolean;
  Root: TTreeNode;
begin
  FGroups := [];
  NewGroup := False;
  for Line in Memo.Lines do begin
    if Line = '' then
      Continue
    else if Line = '***' then
      Break
    else if Line[1] = '*' then begin
      Group := TGroup.Create;
      Group.Name := Copy(Line, 2, Line.Length);
      FGroups := FGroups + [Group];
      NewGroup := True;
    end else if Line.Contains(' - ') then begin
      Card := TCard.Create;
      Pair := Line.Split([' - ']);
      Card.Left := Pair[0];

      if Copy(Card.Left, 1, 4) = TabStr then
        Card.Left := Copy(Card.Left, 5, Line.Length);

      Card.Right := Pair[1];
      if NewGroup
      and Assigned(Group) then
        Group.Cards.Add(Card)
      else if Assigned(Subgroup) then
        Subgroup.Cards.Add(Card);
    end else if (Copy(Line, 1, 4) = TabStr)
    and Assigned(Card) then begin
      Card.Notes := Card.Notes + [Copy(Line, 5, Line.Length)];
    end else if (Line[1] = '(') and (Line[Line.Length] = ')') then begin
      Subgroup := TGroup.Create;
      Subgroup.Name := Copy(Line, 2, Line.Length - 2);
      Group.Groups.Add(Subgroup);
      NewGroup := False;
    end;
  end;
  Memo.Lines.Clear;

  Tree.Items.Clear;
  Root := Tree.Items.Add(nil, 'Info');
  FNodeToGroup := TDictionary<TTreeNode, TGroup>.Create;
  for Group in FGroups do
    AddToTree(Tree, Root, Group);
  Root.Expanded := True;
  GoToSheet(DataSheet);
end;

procedure TMainForm.ExpandBtnClick(Sender: TObject);
begin
  Tree.FullExpand;
end;

procedure TMainForm.CollapseBtnClick(Sender: TObject);
begin
  Tree.FullCollapse;
end;

procedure TMainForm.StartReview;
var
  i: Integer;
begin
  FChosenGroup := FNodeToGroup[Tree.Selected];
  GoToSheet(ReviewSheet);
  FRemainingIds := [];
  SetLength(FRemainingIds, FChosenGroup.Cards.Count);
  for i := 1 to FChosenGroup.Cards.Count - 1 do
    FRemainingIds[i] := i;
  AskQuestion;
end;

procedure TMainForm.AskQuestion;
var
  a: Integer;
  i: Integer;
  IdCount: Integer;
  Btns: TArray<TSpeedButton>;
  TakenIds: THashSet<Integer>;
  WrongId: Integer;
begin
  if Length(FRemainingIds) = 0 then begin
    ClearVars;
    GoToSheet(DataSheet);
    Exit;
  end;

  a := Random(Length(FRemainingIds)-1);
  FCorrectId := FRemainingIds[a];
  Delete(FRemainingIds, a, 1);
  FCorrectTag := Random(3);
  PromptPanel.Caption := FChosenGroup.Cards[FCorrectId].Left;
  Btns := [BtnA, BtnB, BtnC, BtnD];
  Btns[FCorrectTag].Caption := FChosenGroup.Cards[FCorrectId].Right;

  IdCount := (FChosenGroup.Cards.Count)-1;

  TakenIds := THashSet<Integer>.Create;
  try
    TakenIds.Add(FCorrectId);
    for i := 0 to Length(Btns) - 1 do begin
      if i <> FCorrectTag then begin
        repeat
          WrongId := Random(IdCount);
        until not TakenIds.Contains(WrongId);
        TakenIds.Add(WrongId);
        Btns[i].Caption := FChosenGroup.Cards[WrongId].Right;
      end;
    end;
  finally
    TakenIds.Free;
  end;
end;

procedure TMainForm.AnswerBtn(i: Integer);
begin
  if i = FCorrectTag then begin
    ShowMessage('Right!');
    AskQuestion;
  end;
end;

procedure TMainForm.AnswerBtnClick(Sender: TObject);
begin
  AnswerBtn((Sender as TSpeedButton).Tag);
end;

procedure TMainForm.ClearVars;
begin
  FChosenGroup := Default(TGroup);
  FCorrectId := 0;
  FRemainingIds := [];
  FCorrectTag := 0;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Group: TGroup;
  c: Char;
  i: Integer;
begin
  if ssCtrl in Shift then begin
    if Key = Ord('X') then
      BottomPanel.Visible := not BottomPanel.Visible;
    c := IntToStr(PageControl.PageCount - 1)[1];
    if (Key >= Ord('0')) and (Key <= Ord(c)) then begin

      i := StrToInt(Char(Key));

      {clear data as needed}

      GoToSheet(PageControl.Pages[i]);
    end;
  end;

  if PageControl.ActivePage = GenerateSheet then begin
    if (Key = VK_RETURN) and (ssCtrl in Shift)
    and (Memo.Text <> '') then
      ReadMemo;
  end else if PageControl.ActivePage = DataSheet then begin
    if (Key = VK_RETURN) and (ssCtrl in Shift)
    and (FNodeToGroup.TryGetValue(Tree.Selected, Group))
    and (Group.Cards.Count > 3) then
      StartReview;
  end else if PageControl.ActivePage = ReviewSheet then begin
    if (Key >= Ord('1')) and (Key <= Ord('4')) then
      AnswerBtn(StrToInt(Char(Key)) - 1);
  end;
end;

procedure TMainForm.GoToSheet(Sheet: TTabSheet);
begin
  if Sheet = InfoSheet then
    InfoPanel.Caption := '  Info and settings found here'
  else if Sheet = GenerateSheet then
    InfoPanel.Caption := '  Paste formatted notes into the box, then press Control + Enter'
  else if Sheet = DataSheet then
    InfoPanel.Caption := '  Pick a group with at least 4 notes, then press Control + Enter'
  else if Sheet = ReviewSheet then
    InfoPanel.Caption := '  Keys 1, 2, 3, and 4 can be used to answer';

  PageControl.ActivePage := Sheet;
end;

procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if PageControl.ActivePage = InfoSheet then begin
    ScrollBox.VertScrollBar.Position :=
      ScrollBox.VertScrollBar.Position - WheelDelta;
    Handled := True;
  end;
end;

{

*to do

display card notes
handle picking the right answer / wrong answer
FGroups - should be ObjectList
make it possible to paste in OR use a txt file
make it possible to quit halfway through a quiz

}

end.
