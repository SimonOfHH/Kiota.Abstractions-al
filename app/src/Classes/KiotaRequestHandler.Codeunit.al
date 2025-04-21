namespace SimonOfHH.Kiota.Client;

using SimonOfHH.Kiota.Definitions;
codeunit 87103 "Kiota RequestHandler SoHH"
{
    var
        ClientConfig: Codeunit "Kiota ClientConfig SOHH";
        RequestMsg: HttpRequestMessage;
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

    procedure SetBody(body: Byte)
    begin
        // TODO: Implement this for binary data
        // BodySet := true;
    end;

    procedure SetBody(Objects: List of [Interface "Kiota IModelClass SOHH"])
    var
        Object: Interface "Kiota IModelClass SOHH";
        JsonArray: JsonArray;
    begin
        foreach Object in Objects do
            JsonArray.Add(Object.ToJson());
        BodySet := true;
    end;

    procedure SetBody(Object: Interface "Kiota IModelClass SOHH")
    begin
        BodyAsJson := Object.ToJson();
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
    begin
        if RequestMsgSet then
            exit(RequestMsgToCodeunitObject());
        RequestMsg.Method := Format(Method);
        RequestMsg.SetRequestUri(ClientConfig.BaseUrl());
        if (BodySet) then
            RequestMsg.Content.WriteFrom(BodyAsJson.AsValue().AsText());
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