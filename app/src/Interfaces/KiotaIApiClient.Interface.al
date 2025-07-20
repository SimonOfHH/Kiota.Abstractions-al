namespace SimonOfHH.Kiota.Definitions;
interface "Kiota IApiClient SOHH"
{
    Access = Public;
    procedure Response(var ApiResponse: Codeunit System.RestClient."Http Response Message");
    procedure Response(): Codeunit System.RestClient."Http Response Message";
}