unit UFrmCadProd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls,
  Data.DB, Data.Win.ADODB, Vcl.Mask, Vcl.Buttons;

type
  TFrmCadProd = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblCad: TLabel;
    EdtCod: TEdit;
    Label8: TLabel;
    EdtDesc: TEdit;
    DBLkCmbCateg: TDBLookupComboBox;
    EdtFabr: TEdit;
    EdtQtde: TEdit;
    EdtUnid: TEdit;
    MEdtDtCad: TMaskEdit;
    ADOQry_Categ: TADOQuery;
    DS_Categ: TDataSource;
    ADOQry_Categcod_categ: TIntegerField;
    ADOQry_Categdesc_categ: TWideStringField;
    ADOQry_Comm: TADOQuery;
    BtnGravar: TBitBtn;
    BtnCancelar: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MEdtDtCadEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LimpaCampos;
  end;

var
  FrmCadProd: TFrmCadProd;

implementation

{$R *.dfm}

uses UFrmProduto;


procedure TFrmCadProd.LimpaCampos;
var i: Integer;
begin
  for i := 0 to Self.ControlCount - 1 do
    if Self.Controls[i] is TEdit then
      (Controls[i] as TEdit).Clear
    else
    if Self.Controls[i] is TMaskEdit then
      (Controls[i] as TMaskEdit).Clear
    else
    if Self.Controls[i] is TDBLookupComboBox then
      (Controls[i] as TDBLookupComboBox).KeyValue := null;
end;

procedure TFrmCadProd.MEdtDtCadEnter(Sender: TObject);
begin
  MEdtDtCad.Text := DateToStr(Now());
end;

procedure TFrmCadProd.BtnCancelarClick(Sender: TObject);
begin
  FrmCadProd.Close;
end;

procedure TFrmCadProd.BtnGravarClick(Sender: TObject);
var comando: String;
begin
  //Validação dos campos
  if Trim(EdtCod.Text) = '' then
  begin
    MessageDlg('Atenção! Campo Código do Produto obrigatório.',TMsgDlgType.mtInformation,[mbOk],0);
    EdtCod.SetFocus;
    Abort;
  end;

  if Trim(EdtDesc.Text) = '' then
  begin
    MessageDlg('Atenção! Campo Descrição do Produto obrigatório.',TMsgDlgType.mtInformation,[mbOk],0);
    EdtDesc.SetFocus;
    Abort;
  end;


  //SQL
  ADOQry_Comm.Close;
  ADOQry_Comm.SQL.Clear;

  if FrmProduto.operacao = 'I' then  //Insert
  begin
    comando := ' INSERT INTO public.cad_produto(codigo, descricao, categoria, '+
               ' fabricante, qtde, unid_med, dt_cad) VALUES ('+
               Trim(EdtCod.Text) + ',' +
               '''' + Trim(EdtDesc.Text) + ''''+ ',' +
               IntToStr(DBLkCmbCateg.KeyValue) + ',' +
               '''' + Trim(EdtFabr.Text) + '''' + ',' +
               Trim(EdtQtde.Text) + ',' +
               '''' + Trim(EdtUnid.Text) + '''' + ',' +
               '''' + Trim(MEdtDtCad.Text) + '''' + ');';
  end else
  if FrmProduto.operacao = 'U' then  //Update
  begin
    comando := ' UPDATE public.cad_produto '+
               ' SET descricao = '+ '''' + Trim(EdtDesc.Text) + ''''+ ',' +
               ' categoria = '+ IntToStr(DBLkCmbCateg.KeyValue) + ',' +
               ' fabricante = '+ '''' + Trim(EdtFabr.Text) + '''' + ',' +
               ' qtde = '+ Trim(EdtQtde.Text) + ',' +
               ' unid_med = '+ '''' + Trim(EdtUnid.Text) + '''' + ',' +
               ' dt_cad = '+ '''' + Trim(MEdtDtCad.Text) + '''' +
               ' WHERE codigo = '+ Trim(EdtCod.Text) + ';';

  end;

  ADOQry_Comm.SQL.Add(Comando);
  ADOQry_Comm.ExecSQL;
  ADOQry_Comm.Close;

  MessageDlg('Produto gravado com sucesso!',TMsgDlgType.mtInformation,[mbOk],0);

  FrmProduto.ADOQryProd.Requery();
  BtnCancelar.OnClick(Self);
end;

procedure TFrmCadProd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ADOQry_Categ.Active := False;
  FrmProduto.operacao := '';
end;

procedure TFrmCadProd.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back)) then
    key := #0;
end;

procedure TFrmCadProd.FormShow(Sender: TObject);
begin
  ADOQry_Categ.Active := True;

  if FrmProduto.operacao = 'I' then   //Insert
  begin
    lblCad.Caption := 'Cadastro de Produtos - Inclusão';

    LimpaCampos();
    EdtCod.Enabled    := True;
    MEdtDtCad.Enabled := True;
    EdtCod.SetFocus;
  end else

  if FrmProduto.operacao = 'U' then   //Update
  begin
    lblCad.Caption := 'Cadastro de Produtos - Alteração';

    LimpaCampos();
    EdtCod.Text    := FrmProduto.ADOQryProdcodigo.AsString;
    EdtDesc.Text   := FrmProduto.ADOQryProddescricao.AsString;
    EdtFabr.Text   := FrmProduto.ADOQryProdfabricante.AsString;
    EdtQtde.Text   := FrmProduto.ADOQryProdqtde.AsString;
    EdtUnid.Text   := FrmProduto.ADOQryProdunid_med.AsString;
    MEdtDtCad.Text := FrmProduto.ADOQryProddt_cad.AsString;
    DBLkCmbCateg.KeyValue := FrmProduto.ADOQryProdcategoria.AsString;

    EdtCod.Enabled    := False;
    MEdtDtCad.Enabled := False;

    EdtDesc.SetFocus;
  end;


end;

end.
