namespace SimonOfHH.Kiota.Client;

using SimonOfHH.Kiota.Definitions;
using SimonOfHH.Kiota.Utilities;
codeunit 87103 "Kiota RequestHandler SoHH"
{
    var
        ClientConfig: Codeunit "Kiota ClientConfig SOHH";
        RequestHelper: Codeunit "RequestHelper SOHH";
        BodySet,
        RequestMsgSet : Boolean;
        Method: Enum System.RestClient."Http Method";
        Content: HttpContent;
        RequestMsg: HttpRequestMessage;
        BodyAsJson: JsonToken;

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
        RestClient := InitializeRestClient();
        RqstMessage := RequestMessage();
        RspMessage := RestClient.Send(RqstMessage);
        ClientConfig.Client().Response(RspMessage);
    end;

    local procedure InitializeRestClient() RestClient: Codeunit System.RestClient."Rest Client";
    begin
        if (ClientConfig.HttpHandlerSet()) then begin
            if (ClientConfig.Authorization().IsInitialized()) then
                RestClient.Create(ClientConfig.HttpHandler(), ClientConfig.Authorization().GetAuthentication())
            else
                RestClient.Create(ClientConfig.HttpHandler())
        end else
            if (ClientConfig.Authorization().IsInitialized()) then
                RestClient.Create(ClientConfig.Authorization().GetAuthentication())
            else
                RestClient.Create();
        exit(RestClient);
    end;


    procedure AddQueryParameter(ParamKey: Text; Value: Text)
    begin
        if ParamKey = '' then
            exit;
        this.ClientConfig.AddQueryParameter(ParamKey, Value);
    end;

    procedure AddQueryParameter(ParamKey: Text; Value: Boolean)
    var
        BooleanText: Text;
    begin
        if ParamKey = '' then
            exit;
        if Value then
            BooleanText := 'true'
        else
            BooleanText := 'false';
        this.ClientConfig.AddQueryParameter(ParamKey, BooleanText);
    end;

    procedure AddQueryParameter(ParamKey: Text; Value: Integer)
    begin
        if ParamKey = '' then
            exit;
        this.ClientConfig.AddQueryParameter(ParamKey, Format(Value));
    end;

    procedure AddQueryParameter(ParamKey: Text; Value: Decimal)
    begin
        if ParamKey = '' then
            exit;
        this.ClientConfig.AddQueryParameter(ParamKey, Format(Value));
    end;

    procedure AddQueryParameter(ParamKey: Text; Value: Date)
    begin
        if ParamKey = '' then
            exit;
        this.ClientConfig.AddQueryParameter(ParamKey, Format(Value, 0, 9));
    end;

    procedure AddQueryParameter(ParamKey: Text; Value: DateTime)
    begin
        if ParamKey = '' then
            exit;
        this.ClientConfig.AddQueryParameter(ParamKey, Format(Value, 0, 9));
    end;

    procedure AddQueryParameter(ParamKey: Text; Value: Time)
    begin
        if ParamKey = '' then
            exit;
        this.ClientConfig.AddQueryParameter(ParamKey, Format(Value, 0, 9));
    end;

    procedure AddQueryParameter(ParamKey: Text; Values: List of [Text])
    var
        IsFirst: Boolean;
        CombinedValue: Text;
        Value: Text;
    begin
        if ParamKey = '' then
            exit;
        IsFirst := true;
        foreach Value in Values do begin
            if not IsFirst then
                CombinedValue += ','
            else
                IsFirst := false;
            CombinedValue += Value;
        end;
        if CombinedValue <> '' then
            this.ClientConfig.AddQueryParameter(ParamKey, CombinedValue);
    end;
}