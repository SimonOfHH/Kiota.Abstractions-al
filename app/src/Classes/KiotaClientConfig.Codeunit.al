namespace SimonOfHH.Kiota.Client;

using SimonOfHH.Kiota.Definitions;
using SimonOfHH.Kiota.Utilities;

codeunit 87107 "Kiota ClientConfig SOHH"
{
    var
        _Authorization: Codeunit "Kiota API Authorization SOHH";
        _BaseURL: Text;
        _Client: Interface "Kiota IApiClient SOHH";
        _CustomHeaders: Dictionary of [Text, Text];
        RequestHelper: Codeunit "RequestHelper SOHH";

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

    procedure AddHeader(HeaderName: Text; HeaderValue: Text)
    begin
        if not _CustomHeaders.ContainsKey(HeaderName) then
            _CustomHeaders.Add(HeaderName, HeaderValue)
        else
            _CustomHeaders.Set(HeaderName, HeaderValue);
    end;

    procedure CustomHeaders(): Dictionary of [Text, Text]
    begin
        exit(_CustomHeaders);
    end;

    procedure RequestHeaders(): Dictionary of [Text, Text]
    var
        NewHeaders: Dictionary of [Text, Text];
        HeaderName, HeaderValue : Text;
    begin
        foreach HeaderName in _CustomHeaders.Keys() do begin
            HeaderValue := _CustomHeaders.Get(HeaderName);
            if not RequestHelper.IsContentHeader(HeaderName) then
                NewHeaders.Add(HeaderName, HeaderValue);
        end;
        exit(NewHeaders);
    end;

    procedure ContentHeaders(): Dictionary of [Text, Text]
    var
        NewHeaders: Dictionary of [Text, Text];
        HeaderName, HeaderValue : Text;
    begin
        foreach HeaderName in _CustomHeaders.Keys() do begin
            HeaderValue := _CustomHeaders.Get(HeaderName);
            if RequestHelper.IsContentHeader(HeaderName) then
                NewHeaders.Add(HeaderName, HeaderValue);
        end;
        exit(NewHeaders);
    end;
}