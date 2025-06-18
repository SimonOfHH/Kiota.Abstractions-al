namespace SimonOfHH.Kiota.Utilities;

using SimonOfHH.Kiota.Definitions;

codeunit 87101 "JSON Helper SOHH"
{
    procedure JsonArrayToStringList(Token: JsonToken) Values: List of [Text]
    var
        JArray: JsonArray;
        SubToken: JsonToken;
    begin
        JArray := Token.AsArray();
        foreach SubToken in JArray do
            Values.Add(SubToken.AsValue().AsText());
    end;

    procedure JsonObjectToStringDictionary(Token: JsonToken) Values: Dictionary of [Text, Text]
    var
        JObject: JsonObject;
        JValue: JsonToken;
        JKeys: List of [Text];
        "key": Text;
    begin
        JObject := Token.AsObject();
        JKeys := JObject.Keys;
        foreach "key" in JKeys do begin
            JObject.Get("key", JValue);
            Values.Add("key", JValue.AsValue().AsText());
        end;
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Guid)
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false)
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Guid; Nullable: Boolean)
    begin
        if (not IsNullGuid(JValue)) or (Nullable) then
            TargetObject.Add(JKey, Format(JValue).ToLower().Replace('{', '').Replace('}', ''));
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Text)
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false)
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Text; Nullable: Boolean)
    begin
        if (JValue <> '') or (Nullable) then
            TargetObject.Add(JKey, JValue);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: List of [Text])
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: List of [Text]; Nullable: Boolean)
    var
        jarray: JsonArray;
        entry: Text;
    begin
        if JValue.Count > 0 then
            if ((JValue.Count = 1) and (JValue.Get(1) = '')) then
                JValue.RemoveAt(1);
        if (JValue.Count = 0) and (not Nullable) then
            exit;
        foreach entry in JValue do
            if entry <> '' then
                jarray.Add(entry);
        TargetObject.Add(JKey, jarray);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Dictionary of [Text, Text]; AsArray: Boolean)
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false, false);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Dictionary of [Text, Text]; AsArray: Boolean; Nullable: Boolean)
    var
        jchildvalue: JsonObject;
        "key": Text;
        value: Text;
    begin
        if (JValue.Count = 0) and (not Nullable) then
            exit;
        if AsArray then begin
            AddToObjectIfNotEmpty(TargetObject, JKey, JValue, Nullable);
            exit;
        end;

        foreach "key" in JValue.Keys do begin
            value := JValue.Get("key");
            jchildvalue.Add("key", value);
        end;
        TargetObject.Add(JKey, jchildvalue);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Dictionary of [Text, Decimal])
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Dictionary of [Text, Decimal]; Nullable: Boolean)
    var
        jarray: JsonArray;
        jchildvalue: JsonObject;
        "key": Text;
        value: Decimal;
    begin
        if (JValue.Count = 0) and (not Nullable) then
            exit;

        foreach "key" in JValue.Keys do begin
            value := JValue.Get("key");
            jchildvalue.Add("key", value);
            jarray.Add(jchildvalue);
        end;
        TargetObject.Add(JKey, jarray);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Interface "Kiota IModelClass SOHH")
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: JsonArray)
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: JsonArray; Nullable: Boolean)
    begin
        if (JValue.Count > 0) or Nullable then
            TargetObject.Add(JKey, JValue);
    end;

    procedure AddToArrayIfNotEmpty(var TargetArray: JsonArray; JValue: Interface "Kiota IModelClass SOHH")
    begin
        AddToArrayIfNotEmpty(TargetArray, JValue, false);
    end;

    procedure AddToArrayIfNotEmpty(var TargetArray: JsonArray; JValue: Interface "Kiota IModelClass SOHH"; Nullable: Boolean)
    begin
        if (not JsonFromCodeunitIsEmpty(JValue)) or Nullable then
            TargetArray.Add(JValue.ToJson());
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Interface "Kiota IModelClass SOHH"; Nullable: Boolean)
    begin
        if (not JsonFromCodeunitIsEmpty(JValue)) then
            if (JKey = 'base') then
                AddToObjectFromBaseObject(TargetObject, JValue)
            else
                TargetObject.Add(JKey, JValue.ToJson());
    end;

    local procedure AddToObjectFromBaseObject(var TargetObject: JsonObject; JValue: Interface "Kiota IModelClass SOHH")
    var
        JObject: JsonObject;
        JBaseValue: JsonToken;
        JTempToken: JsonToken;
        JKeys: List of [Text];
        "key": Text;
    begin
        JObject := JValue.ToJson();
        JKeys := JObject.Keys;
        foreach "key" in JKeys do begin
            JObject.Get("key", JBaseValue);
            if not TargetObject.Get("key", JTempToken) then // might already be added in parent function
                TargetObject.Add("key", JBaseValue);
        end;
    end;

    local procedure JsonFromCodeunitIsEmpty(JValue: Interface "Kiota IModelClass SOHH"): Boolean
    var
        JToken: JsonToken;
        JKeys: List of [Text];
    begin
        JToken := JValue.ToJson().AsToken();
        if not JToken.IsObject then
            exit(true);
        JKeys := JToken.AsObject().Keys;
        exit(JKeys.Count = 0);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Integer)
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Integer; Nullable: Boolean)
    begin
        if (JValue <> 0) or Nullable then
            TargetObject.Add(JKey, JValue);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Decimal)
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Decimal; Nullable: Boolean)
    begin
        if (JValue <> 0) or Nullable then
            TargetObject.Add(JKey, JValue);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: DateTime)
    begin
        AddToObjectIfNotEmpty(TargetObject, JKey, JValue, false);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: DateTime; Nullable: Boolean)
    begin
        if (JValue <> 0DT) or Nullable then
            TargetObject.Add(JKey, JValue);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: Boolean)
    begin
        TargetObject.Add(JKey, JValue);
    end;

    procedure AddToObjectIfNotEmpty(var TargetObject: JsonObject; JKey: Text; JValue: JsonToken)
    begin
        TargetObject.Add(JKey, JValue);
    end;
}