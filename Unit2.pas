unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  sgcWebSocket_Classes, sgcWebSocket_Classes_Indy, sgcWebSocket_Client,
  sgcWebSocket, sgcBase_Classes, sgcSocket_Classes, sgcTCP_Classes,
  sgcWebSocket_Protocol_Base_Client, sgcWebSocket_Protocol_STOMP_Client,
  sgcWebSocket_Protocols, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo;

type
  TfrmMain = class(TForm)
    btnSubscribe: TButton;
    edtTopic: TEdit;
    Label1: TLabel;
    btnPublish: TButton;
    edtMessage: TEdit;
    Label2: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnSubscribeClick(Sender: TObject);
    procedure btnPublishClick(Sender: TObject);
  private
    FClient: TsgcWebSocketClient;
    FStomp: TsgcWSPClient_STOMP;
    procedure InitSTOMPClient();
    procedure DoOnSTOMPConnected(Connection: TsgcWSConnection;
      Version, Server, Session, HeartBeat, RawHeaders: string);
    procedure DoOnSTOMPMessage(Connection: TsgcWSConnection;
      MessageText, Destination, MessageId, Subscription, ACK, ContentType,
      RawHeaders: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.Macintosh.fmx MACOS}

{ TForm2 }

procedure TfrmMain.btnPublishClick(Sender: TObject);
begin
  FStomp.Send(edtTopic.Text, edtMessage.Text);
end;

procedure TfrmMain.btnSubscribeClick(Sender: TObject);
begin
  FStomp.Subscribe('id0', edtTopic.Text);
end;

procedure TfrmMain.DoOnSTOMPConnected(Connection: TsgcWSConnection; Version,
  Server, Session, HeartBeat, RawHeaders: string);
begin
  Caption := Caption + ' of ' + FClient.Host;
end;

procedure TfrmMain.DoOnSTOMPMessage(Connection: TsgcWSConnection; MessageText,
  Destination, MessageId, Subscription, ACK, ContentType, RawHeaders: string);
begin
  Memo1.Lines.Add('MessageText: '+MessageText)
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitSTOMPClient;
end;

procedure TfrmMain.InitSTOMPClient;
begin
  FClient := TsgcWebSocketClient.Create(nil);
  FClient.Host := 'www.esegece.com';
  FClient.Port := 15674;
  FClient.Options.Parameters := '/ws';

  FStomp := TsgcWSPClient_STOMP.Create(nil);
  FStomp.Client := FClient;
  FStomp.Authentication.Enabled := True;
  FStomp.Authentication.UserName:= 'sgc';
  FStomp.Authentication.Password:= 'sgc';
  FStomp.OnSTOMPConnected := DoOnSTOMPConnected;
  FStomp.OnSTOMPMessage   := DoOnSTOMPMessage;

  FClient.Active := True;
end;

end.
