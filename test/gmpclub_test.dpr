program gmpclub_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  givemeporn.club.types in '..\source\givemeporn.club.types.pas',
  givemeporn.club.parser in '..\source\givemeporn.club.parser.pas',
  givemeporn.club.scraper in '..\source\givemeporn.club.scraper.pas';


var
  GmpClub: TGmpclubScraper;
  Items: TGmpclubItemAr;
  Full: TGmpclubFullPage;

procedure WriteLnI(const AItem: TGmpclubItem); overload;
begin
  writeln('Id: ' + AItem.Id.ToString);
  writeln('Title: ' + AItem.Title);
  writeln('ThumbnailUrl: ' + AItem.ThumbnailUrl);
  writeln('Url: ' + AItem.GetUrl);
end;

procedure WritelnI(const AItems: TGmpclubItemAr); overload;
var
  I: integer;
begin
  writeln(Length(AItems).ToString + ' items:');
  for I := low(AItems) to High(AItems) do begin
    Writeln('[ ' + I.ToString  + ' ] {');
    WritelnI(AItems[I]);
    Writeln('};');
  end;
end;

procedure WritelnI(const AStrs: TArray<string>); overload;
var
  I: integer;
begin
  for i := Low(AStrs) to High(AStrs) do begin
    Write(' "' + AStrs[i] + '"');
    if ( I <> high(AStrs) ) then
      Write(',');
  end;
  Writeln('');
end;

procedure WritelnI(const AItem: TGmpclubFullPage); overload;
begin
  writeln('Id: ' + AItem.Id.ToString);
  writeln('Title: ' + AItem.Title);
  writeln('ThumbnailUrl: ' + AItem.ThumbnailUrl);
  writeln('Url: ' + AItem.Url);
  writeln('ContentUrl: ' + Aitem.ContentUrl);
  writeln('Width: ' + AItem.Width.ToString);
  writeln('Height: ' + AItem.Height.ToString);
  writeln('Duration: ' + AItem.Duration.ToString);
  writeln('Category: ' + Aitem.Category);
  write('Tags: ');
  writelni(AItem.Tags);
  writelnI(AItem.RelatedItems);
end;

var FullLog: boolean;

procedure WriteResult;
begin
  if ( Length(items) > 0 ) then begin
    Writeln(' OK, ' + Length(Items).ToString);
    if FullLog then
      WritelnI(Items);
  end else begin
    Writeln(' ERROR!!!');
  end;
end;

var I: integer;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    GmpClub := TGmpClubScraper.Create;
    GmpClub.WebClient.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0';

    Items := GmpClub.GetItems(1);
    write('GetItems: ');
    WriteResult;

    items := GmpClub.GetItemsByTag('big cock', 1);
    write('GetItemsByTag: ');
    WriteResult;

    items := GmpClub.GetItems(1);
    write('GetItemsByCategory: ');
    WriteResult;

    if (Length(items) > 0 ) then begin

      Full := GmpClub.GetPage(Items[0].GetUrl, true);

      if Full.Id <> -1 then
        Writeln('GetPage: OK. Url: ' + Full.Url)
      else
        Writeln('GetPage: ERROR!!!');

      writeln('ContentUrl: ' + Full.ContentUrl + ' Thumb: ' + Full.ThumbnailUrl);

      var TagsStr: string := '';
      for I := low(Full.Tags) to High(Full.Tags) do
        TagsStr := TagsStr + ' | ' + Full.Tags[I];

      writeln('Tags count: ' + Length(Full.Tags).ToString + ' ' + TagsStr + ' |');

      items := Full.RelatedItems;
      Write('GetPage RelatedItems: ');
      WriteResult;

      if FullLog then
        WritelnI(Full);
    end;

    readln;
  except
    on E: Exception do begin
      Writeln(E.ClassName, ': ', E.Message);
      readln;
    end;
  end;
end.
