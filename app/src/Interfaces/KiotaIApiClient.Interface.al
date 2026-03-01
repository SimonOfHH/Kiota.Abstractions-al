namespace SimonOfHH.Kiota.Definitions;
interface "Kiota IApiClient"
{
    Access = Public;
    procedure Response(var ApiResponse: Codeunit System.RestClient."Http Response Message");
    procedure Response(): Codeunit System.RestClient."Http Response Message";
}