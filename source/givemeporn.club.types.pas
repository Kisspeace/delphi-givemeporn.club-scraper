unit givemeporn.club.types;

interface

const
  GIVEMEPORNCLUB_URL: string = 'https://givemeporn.club';

type
  TGmpclubItem = record
    Id: int64;
    Title: string;
    ThumbnailUrl: string;
    Url: string;
    function GetUrl: string;
    class function new: TGmpclubItem; static;
    constructor create(AId: int64);
  end;

  TGmpclubItemAr = TArray<TGmpclubItem>;

  TGmpclubFullPage = record
    Id: int64;
    Url: string;
    Title: string;
    ThumbnailUrl: string;
    ContentUrl: string;
    Width: integer;
    Height: integer;
    Duration: integer;
    Category: string;
    Tags: TArray<string>;
    RelatedItems: TGmpclubItemAr;
    function GetThumbnailUrl: string;
    function GetContentUrl: string;
    class function new: TGmpclubFullPage; static;
    constructor Create(AId: int64);
  end;

implementation

constructor TGmpclubItem.create(AId: int64);
begin
  Title := '';
  ThumbnailUrl := '';
  Url := '';
  Id := AId;
end;

function TGmpclubItem.GetUrl: string;
begin
  Result := GIVEMEPORNCLUB_URL + self.Url;
end;

class function TGmpclubItem.new: TGmpclubItem;
begin
  Result := TGmpclubItem.Create(-1);
end;

constructor TGmpclubFullPage.Create(AId: int64);
begin
  Title := '';
  Url := '';
  ThumbnailUrl := '';
  Id := AId;
  ContentUrl := '';
  Width := -1;
  Height := -1;
  Duration := -1;
  Category := '';
  Tags := nil;
  RelatedItems := nil;
end;

function TGmpclubFullPage.GetContentUrl: string;
begin
  Result := GIVEMEPORNCLUB_URL + self.ContentUrl;
end;

function TGmpclubFullPage.GetThumbnailUrl: string;
begin
  Result := GIVEMEPORNCLUB_URL + self.ThumbnailUrl;
end;

class function TGmpclubFullPage.new: TGmpclubFullPage;
begin
  Result := TGmpclubFullPage.Create(-1);
end;

end.
