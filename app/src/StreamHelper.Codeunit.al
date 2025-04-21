namespace SimonOfHH.Kiota.Utilities;

using System.IO;
using System.Text;
using System.Utilities;
codeunit 87100 "StreamHelper SOHH"
{
    Access = Public;

    procedure GetFileAsStream(var FromFile: Text; var FileInStream: InStream): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
    begin
        TempBlob.CreateInStream(FileInStream, TextEncoding::UTF8);
        if not UploadIntoStream('Upload file', '', '', FromFile, FileInStream) then
            exit(false);
        exit(true);
    end;

    procedure GetFileAsText(var FromFile: Text; var FileAsText: Text; Codepage: Integer): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        FileInStream: InStream;
    begin
        TempBlob.CreateInStream(FileInStream, TextEncoding::UTF8);
        if not UploadIntoStream('Upload file', '', '', FromFile, FileInStream) then
            exit(false);
        FileAsText := GetFileContent(FileInStream, Codepage);
        exit(true);
    end;

    procedure GetFileContent(var FileInStream: InStream; TargetCodepage: Integer): Text
    var
        DotnetEncoding: Codeunit DotNet_Encoding;
        DotnetStreamReader: Codeunit DotNet_StreamReader;
        ConvertedText: Text;
    begin
        if TargetCodepage <> 0 then begin
            DotnetEncoding.Encoding(TargetCodepage);
            DotnetStreamReader.StreamReader(FileInStream, DotnetEncoding);
            ConvertedText := DotnetStreamReader.ReadToEnd();
        end else begin
            DotnetEncoding.UTF8();
            DotnetStreamReader.StreamReader(FileInStream, DotnetEncoding);
            ConvertedText := DotnetStreamReader.ReadToEnd();
        end;
        exit(ConvertedText);
    end;
}