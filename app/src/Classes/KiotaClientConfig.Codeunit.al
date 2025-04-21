namespace SimonOfHH.Kiota.Client;

using SimonOfHH.Kiota.Definitions;

codeunit 87107 "Kiota ClientConfig SOHH"
{
    var
        _Authorization: Codeunit "Kiota API Authorization SOHH";
        _BaseURL: Text;
        _Client: Interface "Kiota IApiClient SOHH";

    procedure BaseURL(URL: Text)
    begin
        _BaseURL := URL;
    end;

    procedure BaseURL(): Text
    begin
        exit(_BaseURL);
    end;

    procedure AppendBaseURL(Append: Text)
    begin
        if _BaseURL = '' then
            _BaseURL := Append
        else
            _BaseURL := _BaseURL + Append;
    end;

    procedure IsInitialized(): Boolean
    begin
        exit(_Authorization.IsInitialized());
    end;

    procedure Authorization(NewAuthorization: Codeunit "Kiota API Authorization SOHH")
    begin
        _Authorization := NewAuthorization;
    end;

    procedure Authorization(): Codeunit "Kiota API Authorization SOHH"
    begin
        exit(_Authorization);
    end;

    procedure Client(): Interface "Kiota IApiClient SOHH"
    begin
        exit(_Client);
    end;

    procedure Client(NewApiClient: Interface "Kiota IApiClient SOHH")
    begin
        _Client := NewApiClient;
    end;
}