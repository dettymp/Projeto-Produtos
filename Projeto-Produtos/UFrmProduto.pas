unit UFrmProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, Data.Win.ADODB, System.UITypes,
  Vcl.Buttons;

type
  TFrmProduto = class(TForm)
    Label1: TLabel;
    DBGProduto: TDBGrid;
    ADOConnection1: TADOConnection;
    ADOQryProd: TADOQuery;
    DS_Produto: TDataSource;
    ADOQryProdcodigo: TIntegerField;
    ADOQryProddescricao: TWideStringField;
    ADOQryProdcategoria: TIntegerField;
    ADOQryProdfabricante: TWideStringField;
    ADOQryProdqtde: TIntegerField;
    ADOQryProdunid_med: TWideStringField;
    ADOQryProddt_cad: TDateField;
    ADOQry_Op: TADOQuery;
    ADOQryProdcod_categ: TIntegerField;
    ADOQryProddesc_categ: TWideStringField;
    BtnInserir: TBitBtn;
    BtnEditar: TBitBtn;
    BtnExcluir: TBitBtn;
    BtnSair: TBitBtn;
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var operacao: String;   //I-Insert | U-Update
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.dfm}

uses UFrmCadProd;

procedure TFrmProduto.BtnEditarClick(Sender: TObject);
begin
  operacao := 'U';

  if FrmCadProd = Nil then
    FrmCadProd := TFrmCadProd.Create(self);
  FrmCadProd.ShowModal;
end;

procedure TFrmProduto.BtnExcluirClick(Sender: TObject);
var comando: String;
begin
  if MessageDlg('Deseja realmente excluir o produto selecionado?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    ADOQry_Op.Close;
    ADOQry_Op.SQL.Clear;
    comando := ' delete from cad_produto '+
               ' where codigo = ' + ADOQryProdcodigo.AsString;
    ADOQry_Op.SQL.Add(comando);
    ADOQry_Op.ExecSQL;
    ADOQry_Op.Close;

    ADOQryProd.Requery();
    ADOQryProd.Refresh;
  end;
end;

procedure TFrmProduto.BtnInserirClick(Sender: TObject);
begin
  operacao := 'I';

  if FrmCadProd = Nil then
    FrmCadProd := TFrmCadProd.Create(self);
  FrmCadProd.ShowModal;
end;

procedure TFrmProduto.BtnSairClick(Sender: TObject);
begin
  FrmProduto.Close;
end;

procedure TFrmProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ADOQryProd.Active := False;
end;

procedure TFrmProduto.FormShow(Sender: TObject);
begin
  ADOQryProd.Active := True;
end;

end.
