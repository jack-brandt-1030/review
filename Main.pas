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
    InfoSheet: TTabSheet;
    Tree: TTreeView;
    ReviewSheet: TTabSheet;
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
    CollapseBtn: TButton;
    GenerateSheet: TTabSheet;
    Memo: TMemo;
    InfoPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ExpandBtnClick(Sender: TObject);
    procedure AnswerBtnClick(Sender: TObject);
    procedure CollapseBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FGroups: TArray<TGroup>;
    FNodeToGroup: TDictionary<TTreeNode, TGroup>;
    FChosenGroup: TGroup;
    FQuestionNo: Integer;
    FCorrectId: Integer;
    FRemainingIds: TArray<Integer>;
    FCorrectTag: Integer;
    procedure GoToPage(i: Integer);
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
  GoToPage(0);
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
      Card.Right := Pair[1];
      if NewGroup then
        Group.Cards.Add(Card)
      else
        Subgroup.Cards.Add(Card);
    end else if Copy(Line, 1, 4) = '    ' then begin
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
  GoToPage(1);
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
  GoToPage(2);
  FQuestionNo := 1;
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
    GoToPage(1);
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
    Inc(FQuestionNo);
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
  FQuestionNo := 0;
  FCorrectId := 0;
  FRemainingIds := [];
  FCorrectTag := 0;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Group: TGroup;
begin
  if PageControl.ActivePageIndex = 0 then begin
    if (Key = VK_RETURN) and (ssCtrl in Shift)
    and (Memo.Text <> '') then
      ReadMemo;
  end else if PageControl.ActivePageIndex = 1 then begin
    if (Key = VK_RETURN) and (ssCtrl in Shift)
    and (FNodeToGroup.TryGetValue(Tree.Selected, Group))
    and (Group.Cards.Count > 0) then
      StartReview;
  end else if PageControl.ActivePageIndex = 2 then begin
    if (Key >= Ord('1')) and (Key <= Ord('4')) then
      AnswerBtn(StrToInt(Char(Key)) - 1);
  end;
end;

procedure TMainForm.GoToPage(i: Integer);
begin
  case i of
    0: InfoPanel.Caption := '  Paste formatted notes into the box, then press Control + Enter';
    1: InfoPanel.Caption := '  Pick a group of notes, then press Control + Enter';
    2: InfoPanel.Caption := '  Learn stuff';
  end;
  PageControl.ActivePageIndex := i;
end;

{

*to do

display card notes somewhere
an infinite loop occurs when there's fewer than 4 cards. oof
handle picking the right answer / wrong answer
FGroups - should be ObjectList
make it possible to paste in or use a txt file
make it possible to quit halfway through a quiz
if indented lines have a -, make new card

}

end.
