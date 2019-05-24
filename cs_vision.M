(URL) =>
let

    JsonRecords = URL,
    JsonRequest = "{""url"": """ & JsonRecords & """}",
    JsonContent = Text.ToBinary(JsonRequest, TextEncoding.Ascii),
    Response =
        Web.Contents("https://<REGION>.api.cognitive.microsoft.com/vision/v1.0/analyze?",
                [Headers=[#"Ocp-Apim-Subscription-Key"="<KEY>", #"Content-Type"="application/json"],
                Content=JsonContent
            ]),

    JsonResponse = Json.Document(Response,1252),
    categories = JsonResponse[categories], // chose visul features : https://westus.dev.cognitive.microsoft.com/docs/services/56f91f2d778daf23d8ec6739/operations/56f91f2e778daf14a499e1fa 
    ConvertToTable = Table.FromList(categories, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    ExtractColumn = Table.ExpandRecordColumn(ConvertToTable, "Column1", {"name", "score"}, {"name", "score"}),
    TypesModified = Table.TransformColumnTypes(ExtractColumn,{{"name", type text}, {"score", type number}})
in
    TypesModified