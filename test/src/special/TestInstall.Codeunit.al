// For using test: Uncomment all lines in this codeunit and give it an appropriate id
// codeunit 50199 "Install Test"
// {
//     Subtype = Install;
// 
//     trigger OnInstallAppPerCompany()
//     begin
//         InitAppTestSuite();
//     end;
// 
//     procedure InitAppTestSuite()
//     var
//         ALTestSuite: Record "AL Test Suite";
//         TestSuiteMgt: Codeunit "Test Suite Mgt.";
//         ALTestSuiteDescription: Text;
//         TestSuiteTxt: Label 'CCS', Locked = true;
//         ALTestSuiteDescriptionTxt: Label 'App: %1', Comment = '%1 = AppName', Locked = true;
//         ModuleName: Text;
//     begin
//         ModuleName := GetModuleName();
//         ALTestSuiteDescription := StrSubstNo(ALTestSuiteDescriptionTxt, ModuleName);
//         InitTestSuite(ALTestSuite, TestSuiteTxt, ALTestSuiteDescription);
// 
//         Update the range here
//         TestSuiteMgt.SelectTestMethodsByRange(ALTestSuite, '50000..99999');
//     end;
// 
//     local procedure GetModuleName(): Text
//     var
//         ModuleName: Text;
//         AppInfo: ModuleInfo;
//     begin
//         NavApp.GetCurrentModuleInfo(AppInfo);
//         ModuleName := AppInfo.Name;
//         exit(ModuleName);
//     end;
// 
//     local procedure InitTestSuite(var ALTestSuite: Record "AL Test Suite"; ALTestSuiteName: Text; ALTestSuiteDescription: Text)
//     begin
//         if (ALTestSuite.Get(ALTestSuiteName)) then
//             exit;
// 
//         ALTestSuite.Init();
//         ALTestSuite.Name := CopyStr(ALTestSuiteName, 1, MaxStrLen(ALTestSuite.Name));
//         ALTestSuite.Description := CopyStr(ALTestSuiteDescription, 1, MaxStrLen(ALTestSuite.Description));
//         ALTestSuite."Run Type" := ALTestSuite."Run Type"::All;
//         ALTestSuite."Test Runner Id" := Codeunit::"Test Runner - Isol. Codeunit";
//         ALTestSuite.Insert(true);
//     end;
// }
