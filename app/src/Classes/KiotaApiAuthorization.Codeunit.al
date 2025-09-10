namespace SimonOfHH.Kiota.Client;
using System.RestClient;

codeunit 87102 "Kiota API Authorization SOHH"
{
    var
        AuthImplementation: Interface "Http Authentication";
        AuthenticationSet: Boolean;

    procedure IsInitialized(): Boolean
    begin
        exit(AuthenticationSet);
    end;

    procedure SetAuthentication(var Authentication: Interface "Http Authentication")
    begin
        AuthImplementation := Authentication;
        AuthenticationSet := true;
    end;

    procedure GetAuthentication(): Interface "Http Authentication"
    begin
        exit(AuthImplementation);
    end;
}