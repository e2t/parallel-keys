unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, StdCtrls, ButtonPanel, LCLType,
  FileInfo, Calculate, DryConversion, INIFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonPanel: TButtonPanel;
    ComboBoxKey: TComboBox;
    EditTorque: TEdit;
    EditShaftDiam: TEdit;
    EditForce: TEdit;
    EditBearingStress: TEdit;
    EditShearStress: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MemoResult: TMemo;
    PageControl: TPageControl;
    TabSheetShaft: TTabSheet;
    TabSheetPlane: TTabSheet;
    procedure EditBearingStressChange(Sender: TObject);
    procedure EditShearStressChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure Message(const Info: string);
    procedure MessageAndFocus(const Info: string; const Edit: TEdit);
  private

  public

  end;

const
  IniFileName = 'ParallelKeys.ini';
  IniKeyBearingStress = 'BearingStress';
  IniKeyShearStress = 'ShearStress';
  IniSection = 'MainWindow';

var
  Form1: TForm1;
  IniFile: TINIFile;

implementation

type
  TFuncConvertUnitsFloat = function(const Value: Extended): Extended;

function GetFloatFromEdit(const Edit: TEdit; out Number: Extended;
  ConvertUnits: TFuncConvertUnitsFloat = nil): Boolean;
begin
  Result := ConvertStrToFloat(Edit.Text, Number) = CorrectLine;
  if Result and (ConvertUnits <> nil) then
    Number := ConvertUnits(Number);
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Message(const Info: string);
begin
  MemoResult.Text := Info;
end;

procedure TForm1.MessageAndFocus(const Info: string; const Edit: TEdit);
begin
  Message(Info);
  Edit.SetFocus;
end;

procedure TForm1.HelpButtonClick(Sender: TObject);
const
  InfoText = 'Расчет на смятие:  Lp = (2 * M) / (d * K * [G])' + sLineBreak +
    sLineBreak +
    'Расчет на срез:  Lp = (2 * M) / (b * (d + K) * [T])' + sLineBreak +
    sLineBreak +
    'Lp — рабочая длина шпонки (минимальная)' + sLineBreak +
    'М — крутящий момент на валу' + sLineBreak +
    'd — диаметр вала' + sLineBreak +
    'b — ширина шпонки' + sLineBreak +
    'K — выступ шпонки над валом' + sLineBreak +
    '[G] — допускаемое напряжение на смятие' + sLineBreak +
    '[T] — допускаемое напряжение на срез';
begin
  Application.MessageBox(InfoText, 'Справка', MB_ICONINFORMATION);
end;

procedure TForm1.OKButtonClick(Sender: TObject);
const
  ErrorPositiveNumberExpected = 'Ожидается число больше нуля.';
  MinDiam = 0.006;  { включительно }
var
  MaxDiam: Extended;
  ErrorShaftDiamRangeExpected: string;
  IsTabShaftSelected: Boolean;
  Torque, ShaftDiam, BearingStress, ShearStress, Force: Extended;
  Key: TParallelKey;
  CanContinue: Boolean = False;
begin
  MaxDiam := ParallelKeysTable[ParallelKeysTableCount - 1].MaxDiameter;
  ErrorShaftDiamRangeExpected := 'Ожидается число от ' +
    FormatFloat('0.#', ToMm(MinDiam)) + ' до ' +
    FormatFloat('0.#', ToMm(MaxDiam)) + ' мм.';
  IsTabShaftSelected := PageControl.TabIndex = TabSheetShaft.PageIndex;

  if IsTabShaftSelected then
  begin
    if not GetFloatFromEdit(EditTorque, Torque) or (Torque <= 0) then
      MessageAndFocus('Крутящий момент: ' + ErrorPositiveNumberExpected, EditTorque)
    else if not GetFloatFromEdit(EditShaftDiam, ShaftDiam, @FromMm) or (ShaftDiam < MinDiam) or (ShaftDiam > MaxDiam) then
      MessageAndFocus('Диаметр вала: ' + ErrorShaftDiamRangeExpected, EditShaftDiam)
    else
      CanContinue := True;
  end
  else
  begin
    if not GetFloatFromEdit(EditForce, Force) or (Force <= 0) then
      MessageAndFocus('Сдвигающая сила: ' + ErrorPositiveNumberExpected, EditForce)
    else
    begin
      Key := ParallelKeysTable[ComboBoxKey.ItemIndex];
      CanContinue := True;
    end;
  end;

  if CanContinue then
  begin
    if not GetFloatFromEdit(EditBearingStress, BearingStress, @FromMPa) or (BearingStress <= 0) then
      MessageAndFocus('Напряжение смятия: ' + ErrorPositiveNumberExpected, EditBearingStress)
    else if not GetFloatFromEdit(EditShearStress, ShearStress, @FromMPa) or (ShearStress <= 0) then
      MessageAndFocus('Напряжение среза: ' + ErrorPositiveNumberExpected, EditShearStress)
    else if IsTabShaftSelected then
      Message(CreateOutputFromTorque(Torque, ShaftDiam, BearingStress, ShearStress))
    else
      Message(CreateOutputFromForce(Force, Force, Key, BearingStress, ShearStress))
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FileVerInfo: TFileVersionInfo;
  Key: TParallelKey;
begin
  FileVerInfo := TFileVersionInfo.Create(nil);
  try
    FileVerInfo.ReadFileInfo;
    Form1.Caption := FileVerInfo.VersionStrings.Values['FileDescription'] +
      ' (v' + FileVerInfo.VersionStrings.Values['ProductVersion'] + ')';
  finally
    FileVerInfo.Free;
  end;

  for Key in ParallelKeysTable do
    ComboBoxKey.Items.Add(FormatFloat('0.#', ToMm(Key.Width)) + 'x' +
      FormatFloat('0.#', ToMm(Key.Height)));
  ComboBoxKey.ItemIndex := 0;

  IniFile := TIniFile.Create(IniFileName);
  EditBearingStress.Text := IniFile.ReadString(IniSection, IniKeyBearingStress,
    '210');
  EditShearStress.Text := IniFile.ReadString(IniSection, IniKeyShearStress,
    '85');
end;

procedure TForm1.EditBearingStressChange(Sender: TObject);
begin
  try
    IniFile.WriteString(IniSection, IniKeyBearingStress, EditBearingStress.Text);
  except
    on E: EFCreateError do
      { To do nothing. };
  end;
end;

procedure TForm1.EditShearStressChange(Sender: TObject);
begin
  try
    IniFile.WriteString(IniSection, IniKeyShearStress, EditShearStress.Text);
  except
    on E: EFCreateError do
      { To do nothing. };
  end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then
    Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  EditTorque.SetFocus;
end;

end.
