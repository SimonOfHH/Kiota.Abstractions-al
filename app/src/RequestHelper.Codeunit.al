namespace SimonOfHH.Kiota.Utilities;

using System.IO;
using System.Text;
using System.Utilities;
codeunit 87104 "RequestHelper SOHH"
{
    procedure IsContentHeader(HeaderName: Text): Boolean
    begin
        exit(HeaderName.ToLower() in ['allow', 'content-disposition', 'content-encoding', 'content-language', 'content-length', 'content-location',
                          'content-md5', 'content-range', 'content-type', 'expires', 'last-modified']);
    end;

    procedure AddHeader(var Headers: HttpHeaders; HeadersDict: Dictionary of [Text, Text])
    var
        Header, Value : Text;
    begin
        foreach Header in HeadersDict.Keys() do begin
            Value := HeadersDict.Get(Header);
            if Headers.Contains(Header) then
                Headers.Remove(Header);
            Headers.Add(Header, Value);
        end;
    end;
}