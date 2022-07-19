unit givemeporn.club.parser;

interface
uses
  givemeporn.club.types, classes, sysutils,
  {*HTMLp*}
  HTMLp.Entities,
  HTMLp.DOMCore,
  HTMLp.HtmlTags,
  HTMLp.HtmlReader,
  HTMLp.HtmlParser,
  HTMLp.Formatter;

  function ParseItems(const ASource: string): TGmpclubItemAr;
  function ParseFullPage(const ASource: string; AParseRelated: boolean = true): TGmpclubFullPage;
  function ParseItemsFromNodes(ANodes: TNodeList): TGmpclubItemAr;
  function ParseItemsFromDefPath(const ADocument: TDocument): TGmpclubItemAr;
  function ParseIdFromUrl(AUrl: string): int64;

implementation

function ParseIdFromUrl(AUrl: string): int64;
var
  Value: string;
  Start: integer;
begin
  Start := AUrl.LastIndexOf('-');
  value := copy(AUrl, Start + 2, AUrl.Length - Start);
  if not TryStrToInt64(value, Result) then
    Result := -1;
end;

function ParseItemsFromNodes(ANodes: TNodeList): TGmpclubItemAr;
var
  I: Integer;
  N: TNode;
  E: TElement;
  Item: TGmpclubItem;
begin
  Result := [];
  for I := 0 to ANodes.Count - 1 do begin
    N := ANodes.Items[I];
    try
      E := (N as TElement);
    except
      Continue;
    end;

    Item := TGmpClubItem.new;
    Item.Url := E.GetAttribute('href');
    Item.Id := ParseIdFromUrl(Item.Url);
    Item.Title := E.GetAttribute('title');

    var Img: TElement := E.GetElementByTagName('img');
    if Assigned(Img) then
      Item.ThumbnailUrl := Img.GetAttribute('src');

    Result := Result + [ Item ];
  end;
end;

function GetContainerWithItems(const ADocument: TDocument): TElement;
begin
  Result := ADocument.DocumentElement.GetElementByXPath('body/div[@class="container"]');
end;

function ParseItemsFromDefPath(const ADocument: TDocument): TGmpclubItemAr;
var
  Container: TElement;
begin
  Result := nil;
  Container := GetContainerWithItems(ADocument);
  if Assigned(Container) then
    Result := ParseItemsFromNodes(Container.ChildNodes);
end;

function ParseItems(const ASource: string): TGmpclubItemAr;
var
  Parser: THTMLParser;
  Doc: TDocument;
  Nodes: TNodeList;
begin
  Doc := nil;
  Nodes := nil;
  Parser := THTMLParser.Create;
  try
    Result := [];
    Doc := Parser.ParseString(ASource);
    Result := ParseItemsFromDefPath(Doc);
  finally
    FreeAndNil(Doc);
    if Assigned(Parser) then Parser.Free;
  end;
end;

function ParseFullPage(const ASource: string; AParseRelated: boolean = true): TGmpclubFullPage;
var
  Parser: THTMLParser;
  Doc: TDocument;
  Nodes: TNodeList;
  I: integer;

  function GetMetaAttr(const ANodes: TNodeList; AProperty: string): string;
  var
    I: integer;
    E: TElement;
  begin
    Result := '';
    for I := 0 to ANodes.Count - 1 do begin
      try
        E := ( ANodes[I] as TElement );
        if ( E.GetAttribute('property').ToUpper = AProperty.ToUpper ) then begin
          Result := E.GetAttribute('content');
        end;
      except
        continue;
      end;
    end;
  end;

begin
  Doc := nil;
  Nodes := nil;
  Parser := THTMLParser.Create;

  try
    Result := TGmpclubFullPage.new;
    Doc := Parser.ParseString(ASource);

    var Meta: TElement := Doc.DocumentElement.GetElementByXPath('head');
    var MetaL := Meta.GetElementsByTagName('meta', 3);
    //var MetaL: TNodeList := Meta.ChildNodes;
    if Assigned(Meta) then begin
      Result.Title := GetMetaAttr(MetaL, 'og:title');
      Result.ThumbnailUrl := GetMetaAttr(MetaL, 'og:image');
      Result.Url := GetMetaAttr(MetaL, 'og:url');
      Result.Id := ParseIdFromUrl(Result.Url);

      try
        Result.Width := StrToInt(GetMetaAttr(MetaL, 'og:video:width'));
        Result.Height := StrToInt(GetMetaAttr(MetaL, 'og:video:height'));
        Result.Duration := StrToInt(GetMetaAttr(MetaL, 'og:duration'));
      except

      end;

    end;

    var Body: TElement := Doc.DocumentElement.GetElementByTagName('body');
    var Video: TElement := Body.GetElementByID('main-video');
    if Assigned(Video) then begin
      var source: TElement := Video.GetElementByTagName('source', 1);
      if assigned(Source) then
        Result.ContentUrl := Source.GetAttribute('src');
    end;

    var VidInfo: TElement := Body.GetElementByClass('video-info', true);
    if Assigned(VidInfo) then begin

      var Category: TElement := VidInfo.GetElementByClass('l');
      if Assigned(Category) then
        Result.Category := Category.GetInnerHtml;

      Nodes := VidInfo.GetElementsByTagName('a');
      for i := 0 to Nodes.Count - 1 do begin

        var Tmp: string := Nodes[I].GetInnerHtml.Trim;
        if ( Tmp.IndexOf('#') = 0 ) then begin
          Tmp := Copy(Tmp, 2, Tmp.Length);
          Result.Tags := Result.Tags + [ Tmp ];
        end;

      end;

    end;

    if AParseRelated then
      Result.RelatedItems := ParseItemsFromDefPath(Doc);

  finally
    FreeAndNil(Doc);
    if Assigned(Parser) then Parser.Free;
  end;
end;

end.
