namespace SimonOfHH.Kiota.Client;

using SimonOfHH.Kiota.Definitions;
using SimonOfHH.Kiota.Utilities;
codeunit 87103 "Kiota RequestHandler SoHH"
{
    var
        ClientConfig: Codeunit "Kiota ClientConfig SOHH";
        RequestHelper: Codeunit "RequestHelper SOHH";
        RequestMsg: HttpRequestMessage;
        Content: HttpContent;
        Method: Enum System.RestClient."Http Method";
        BodyAsJson: JsonToken;
        RequestMsgSet, BodySet : Boolean;

    procedure SetClientConfig(var NewClientConfig: Codeunit "Kiota ClientConfig SOHH")
    begin
        ClientConfig := NewClientConfig;
    end;

    procedure SetMethod(NewMethod: Enum System.RestClient."Http Method")
    begin
        Method := NewMethod;
    end;

    procedure SetBody(NewContent: HttpContent)
    begin
        Content := NewContent;
        BodySet := true;
    end;

    procedure SetBody(Objects: List of [Interface "Kiota IModelClass SOHH"])
    var
        Object: Interface "Kiota IModelClass SOHH";
        JsonArray: JsonArray;
        JsonAsText: Text;
    begin
        foreach Object in Objects do
            JsonArray.Add(Object.ToJson());
        JsonArray.WriteTo(JsonAsText);
        Content.WriteFrom(JsonAsText);
        BodySet := true;
    end;

    procedure SetBody(Object: Interface "Kiota IModelClass SOHH")
    var
        JsonAsText: Text;
    begin
        BodyAsJson := Object.ToJson().AsToken();
        BodyAsJson.WriteTo(JsonAsText);
        Content.WriteFrom(JsonAsText);
        BodySet := true;
    end;

    procedure SetBody(var NewReqMsg: HttpRequestMessage)
    begin
        RequestMsg := NewReqMsg;
        RequestMsgSet := true;
        BodySet := true;
    end;

    local procedure RequestMsgToCodeunitObject() msg: Codeunit System.RestClient."Http Request Message"
    begin
        msg.SetHttpRequestMessage(RequestMsg);
    end;

    procedure RequestMessage(): Codeunit System.RestClient."Http Request Message"
    var
        Headers: HttpHeaders;
    begin
        if RequestMsgSet then
            exit(RequestMsgToCodeunitObject());
        RequestMsg.Method := Format(Method);
        RequestMsg.SetRequestUri(ClientConfig.BaseUrl());
        if (ClientConfig.RequestHeaders().Count > 0) then begin
            RequestMsg.GetHeaders(Headers);
            RequestHelper.AddHeader(Headers, ClientConfig.RequestHeaders()); // Add custom headers
        end;
        if (BodySet) then begin
            RequestMsg.Content := Content;
            RequestMsg.Content.GetHeaders(Headers);
            RequestHelper.AddHeader(Headers, ClientConfig.ContentHeaders()); // Add custom headers
        end;
        exit(RequestMsgToCodeunitObject());
    end;

    procedure HandleRequest()
    var
        RestClient: Codeunit System.RestClient."Rest Client";
        RqstMessage: Codeunit System.RestClient."Http Request Message";
        RspMessage: Codeunit System.RestClient."Http Response Message";
    begin
        RqstMessage := RequestMessage();
        RspMessage := RestClient.Send(RqstMessage);
        ClientConfig.Client().Response(RspMessage);
    end;
}