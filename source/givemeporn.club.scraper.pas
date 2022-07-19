unit givemeporn.club.scraper;

interface
uses
  givemeporn.club.types, givemeporn.club.parser, classes, sysutils,
  system.Net.HttpClient, system.Net.HttpClientComponent;

type

  TGmpclubScraper =   Class(TObject)
    public
      WebClient: TNetHttpClient;
      function GetPage(AUrl: string; AParseRelated: boolean = true): TGmpclubFullPage; overload;
      function GetPage(const AItem: TGmpClubItem; AParseRelated: boolean = true): TGmpclubFullPage; overload;
      function GetItems(AUrl: string): TGmpclubItemAr; overload;
      function GetItems(APage: integer = 1): TGmpclubItemAr; overload;
      function GetItemsByCategory(ACategory: string; APage: integer = 1): TGmpclubItemAr;
      function GetItemsByTag(ATag: string; APage: integer = 1): TGmpclubItemAr;
      function GetRandomItems: TGmpclubItemAr;
      constructor Create;
      destructor Destroy; override;
  End;

implementation

{ TGmpclubScraper }

constructor TGmpclubScraper.Create;
begin
  WebClient := TNetHttpClient.Create(nil);
end;

destructor TGmpclubScraper.Destroy;
begin
  WebClient.Free;
  inherited;
end;

function TGmpclubScraper.GetItems(AUrl: string): TGmpclubItemAr;
var
  Content: string;
begin
  Content := WebClient.Get(AUrl).ContentAsString;
  Result := ParseItems(Content);
end;

function TGmpclubScraper.GetItems(APage: integer = 1): TGmpclubItemAr;
begin
  Result := Self.GetItems(GIVEMEPORNCLUB_URL + '?p=' + APage.ToString);
end;

function TGmpclubScraper.GetItemsByCategory(ACategory: string; APage: integer = 1): TGmpclubItemAr;
begin
  Result := Self.GetItems(GIVEMEPORNCLUB_URL + '/theme/' + ACategory + '?p=' + APage.ToString);
end;

function TGmpclubScraper.GetItemsByTag(ATag: string; APage: integer = 1): TGmpclubItemAr;
begin
  Result := Self.GetItems(GIVEMEPORNCLUB_URL + '/tag/' + ATag + '?p=' + APage.ToString);
end;

function TGmpclubScraper.GetPage(const AItem: TGmpClubItem;
  AParseRelated: boolean): TGmpclubFullPage;
begin
  Result := Self.GetPage(Aitem.GetUrl, AParseRelated);
end;

function TGmpclubScraper.GetPage(AUrl: string; AParseRelated: boolean = true): TGmpclubFullPage;
var
  Content: string;
begin
  Content := WebClient.Get(AUrl).ContentAsString;
  Result := ParseFullPage(Content, AParseRelated);
end;

function TGmpclubScraper.GetRandomItems: TGmpclubItemAr;
begin
  Result := Self.GetItems(GIVEMEPORNCLUB_URL + '/random/');
end;

end.
