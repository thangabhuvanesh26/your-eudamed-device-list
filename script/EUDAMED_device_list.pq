// EUDAMED device list, version 3.3 (Power Query / M)
//
// What it does: reads the response XML files EUDAMED returns for a device
// download request (DEVICE.GET sent through Bulk Upload) and lists the device
// records in them with their state (the package requests Registered and
// Discarded), market status, version and dates as EUDAMED returned them. Keep the
// responses of one full download and of every later "changed since" download in
// the folder together: for each record the newest download decides (see part 4
// for the 12-hour rule). Fetch all pages of both states on the same day. Start an
// empty folder for each new full download.
//
// It stops with an error, instead of guessing, if a file has ".xml" in its name
// but does not end in .xml (for example response.xml.txt), if a file is an
// acknowledgement (for example a rejection), not a SUCCESS response, misses or has
// impossible page or date information, holds two different responses for the same
// page, or holds a record of a type it cannot read (it reads MDR and legacy MDD
// records), or if the pages of one download state different page counts.
// It cannot know about a response you never saved: check that both states
// returned a response, even when one of them has no records.
//
// Intended use: turning your own saved download responses into a device list.
// It shows what EUDAMED returned on the day of the download, nothing newer.
// Assess the output for your intended use under your quality procedures before
// you use it as a quality record.
//
// The query reads only the local folder named below and makes no network
// calls. Shared as-is, without warranty. Not affiliated with the European
// Commission.
//
// How to use: Excel > Data > Get Data > From Other Sources > Blank Query >
// Advanced Editor > paste this text > change the folder path > Done >
// Close & Load. After each download, save the response files in the folder and
// click Data > Refresh All.

let
    // 1. Change this path to your own folder
    ResponseFolder = "C:\EUDAMED\Device responses",

    // ---------- Small helpers ----------

    // First child element with this name (or null if there is none)
    Child = (parent, name as text) =>
        if parent is table then
            let found = Table.SelectRows(parent, each [Name] = name)
            in if Table.IsEmpty(found) then null else found{0}[Value]
        else null,

    // All child elements with this name, as a list
    Children = (parent, name as text) as list =>
        if parent is table then Table.SelectRows(parent, each [Name] = name)[Value] else {},

    // Read a date such as 2026-11-10T15:14:13.226+01:00; blank if unreadable
    ToTime = (t) => try DateTimeZone.FromText(t, [Culture = "en-US"]) otherwise null,

    // Show a date as the clock time written in the file, in whole seconds (cut, not rounded)
    Show = (t) => if t = null then null else
        let d = DateTimeZone.RemoveZone(t)
        in #datetime(Date.Year(d), Date.Month(d), Date.Day(d), Time.Hour(d), Time.Minute(d), Number.RoundDown(Time.Second(d))),

    ToNumber = (t) => try Number.FromText(t, "en-US") otherwise null,

    // Text with content, or null (an empty element is not text)
    Txt = (v) => if v is text and Text.Trim(v) <> "" then v else null,

    // A whole number of 0 or more
    Whole = (n) => n is number and n >= 0 and Number.RoundDown(n) = n,

    // All language versions of a name, e.g. trade names, joined into one cell
    Names = (parent) =>
        let texts = List.RemoveNulls(List.Transform(Children(parent, "name"), each Child(_, "textValue")))
        in if List.IsEmpty(texts) then null else Text.Combine(List.Distinct(texts), " | "),

    // The .xml files directly in the folder (not in subfolders); exact copies count once.
    // Lock files (~$...) that Excel or Word leave while a file is open are skipped.
    // Other files are ignored, but a file with ".xml" in its name that does not end in
    // .xml (for example response.xml.txt or a download still ending in .crdownload) is
    // most likely a response saved under a wrong name, so the refresh stops.
    XmlFiles = (folder as text) as table =>
        let
            all      = Table.SelectRows(Folder.Contents(folder), each [Content] is binary
                                                and not Text.StartsWith([Name], "~$")),
            xml      = Table.SelectRows(all, each Text.Lower([Extension]) = ".xml"),
            misnamed = List.Sort(Table.SelectRows(all, each Text.Lower([Extension]) <> ".xml"
                                                and Text.Contains(Text.Lower([Name]), ".xml"))[Name]),
            sorted   = Table.Buffer(Table.Sort(xml, {"Name"})),
            text     = Table.AddColumn(sorted, "Text", each Text.FromBinary([Content])),
            unique   = Table.Distinct(text, {"Text"})
        in
            if not List.IsEmpty(misnamed) then
                error ("EUDAMED device list: " & Text.Combine(misnamed, ", ") &
                       (if List.Count(misnamed) = 1
                        then " has .xml in its name but does not end in .xml, so it would not be read. Rename the file"
                        else " have .xml in their names but do not end in .xml, so they would not be read. Rename each file") &
                       " so that its name ends in .xml and refresh again. To see the full file names, turn on " &
                       "View > Show > File name extensions in File Explorer.")
            else
                Table.SelectColumns(unique, {"Name", "Content"}),

    // ---------- 2. Read one response file ----------

    ReadResponse = (file as text, content as binary) as record =>
        let
            doc      = try Xml.Document(content) otherwise null,
            root     = Child(doc, "PullResponse"),
            ack      = Child(doc, "Acknowledgement"),
            code     = Txt(Child(root, "responseCode")),
            ackCodes = List.Transform(Children(Child(ack, "responseEntities"), "responseEntity"),
                                      each Txt(Child(_, "responseCode"))),
            ackOk    = not List.IsEmpty(ackCodes) and List.AllTrue(List.Transform(ackCodes, each _ = "SUCCESS")),
            ok       =
                if root is table and code = "SUCCESS" then true
                else if ack is table and not ackOk then error ("EUDAMED device list: " & file &
                    " is a rejection (acknowledgement), not a device list. EUDAMED refused that request. " &
                    "Read the reason in the file, then remove it from the folder and refresh again.")
                else if ack is table then error ("EUDAMED device list: " & file &
                    " is an acknowledgement, not a device download response. Save the device response for that " &
                    "request instead, remove this file from the folder and refresh again.")
                else if root is table then error ("EUDAMED device list: " & file &
                    " has the result " & (code ?? "(none)") & " instead of SUCCESS. Remove it and refresh again.")
                else error ("EUDAMED device list: " & file &
                    " is not an EUDAMED device download response. Remove it and refresh again."),
            time     = ToTime(Child(root, "creationDateTime")),
            payload  = Child(root, "payload"),
            devices  = Children(payload, "Device"),
            // Elements in the payload that are not device records (an unknown response shape)
            others   = if payload is table then Table.RowCount(Table.SelectRows(payload, each [Name] <> "Device")) else 0,
            rows     = List.Transform(devices, (v) =>
                let
                    isMdr = Child(v, "MDRUDIDIData") <> null,
                    data  = Child(v, "MDRUDIDIData") ?? Child(v, "MDEUData"),      // UDI-DI level
                    basic = Child(v, "MDRBasicUDI") ?? Child(v, "MDEUDI"),        // Basic UDI-DI level
                    row   =
                    [Reference    = Child(data, "referenceNumber"),
                     UDI          = Txt(Child(Child(data, "identifier"), "DICode")),
                     Basic        = Txt(Child(Child(data, "basicUDIIdentifier"), "DICode")),
                     Legislation  = if isMdr then "MDR" else Txt(Child(basic, "applicableLegislation")),
                     RiskClass    = Child(basic, "riskClass"),
                     TradeName    = Names(Child(data, "tradeNames")),
                     State        = Txt(Child(data, "state")),
                     Market       = Child(Child(data, "status"), "code"),
                     Version      = ToNumber(Child(data, "version")),
                     VersionDate  = ToTime(Child(data, "versionDate")),
                     LastUpdated  = ToTime(Child(data, "lastUpdated")),
                     BasicState   = Child(basic, "state"),
                     BasicVersion = ToNumber(Child(basic, "version")),
                     BasicUpdated = ToTime(Child(basic, "lastUpdated")),
                     File         = file,
                     ResponseTime = time]
                in
                    row),
            // Records of a type the script cannot read (for example IVDR), or without
            // the identifiers, legislation or state that the list needs
            unreadable = others + List.Count(List.Select(List.Positions(devices), (i) =>
                             (Child(devices{i}, "MDRUDIDIData") ?? Child(devices{i}, "MDEUData")) = null or
                             (Child(devices{i}, "MDRBasicUDI") ?? Child(devices{i}, "MDEUDI")) = null or
                             rows{i}[UDI] = null or rows{i}[Basic] = null or
                             rows{i}[Legislation] = null or rows{i}[State] = null)),
            cid      = Txt(Child(root, "conversationID")),
            page     = ToNumber(Child(root, "pageNumber")),
            pages    = ToNumber(Child(root, "numberOfPages")),
            absent   = List.Select({{"creationDateTime", time}, {"conversationID", cid},
                                    {"pageNumber", page}, {"numberOfPages", pages}}, each _{1} = null),
            badPage  =
                if not Whole(page) or not Whole(pages) then
                    " has a pageNumber or numberOfPages that is not a whole number of 0 or more."
                else if pages = 0 and (page <> 0 or not List.IsEmpty(devices) or others > 0) then
                    " says the download has no records (numberOfPages 0) but is page " & Text.From(page) &
                    " or holds records."
                else if pages > 0 and page >= pages then
                    " is page " & Text.From(page) & ", but the download has only " & Text.From(pages) &
                    " page(s), numbered from 0."
                else null
        in
            if ok then
                if not List.IsEmpty(absent) then
                    error ("EUDAMED device list: " & file & " has no readable " &
                           Text.Combine(List.Transform(absent, each _{0}), ", ") &
                           ". Without it the page check cannot work. Download that page again, replace the file and refresh.")
                else if badPage <> null then
                    error ("EUDAMED device list: " & file & badPage &
                           " The page check cannot trust it. Download that page again, replace the file and refresh.")
                else if unreadable > 0 then
                    error ("EUDAMED device list: " & file & " holds " & Text.From(unreadable) &
                           " device record(s) this script cannot read (it reads MDR and legacy MDD records with " &
                           "UDI-DI, Basic UDI-DI, legislation and state). The list would be wrong, so the refresh stops. " &
                           "Keep the file for investigation and do not use the list until the script supports that record type.")
                else
                    [File = file, ConversationID = cid, Page = page, Pages = pages, ResponseTime = time, Rows = rows]
            else null,

    Responses = List.Buffer(List.Transform(Table.ToRecords(XmlFiles(ResponseFolder)), each ReadResponse([Name], [Content]))),

    // ---------- 3. Check that no page of a download is missing ----------
    // EUDAMED states the number of pages in every response; pages are numbered from 0.
    // The pages of one download carry the same conversationID and arrive within a few days.

    Near = (x, y) => Number.Abs(Duration.TotalDays(DateTimeZone.ToUtc(x) - DateTimeZone.ToUtc(y))) <= 3,

    // Two different responses for the same page of a download with more than one page.
    // This happens when the same request files are sent again within a few days. The
    // page check could then use a page of the older download to fill a gap in the newer
    // one, so the refresh stops. (Exact copies of one file were already removed.)
    Duplicates = List.Distinct(List.Combine(List.Transform(List.Select(Responses, each [Pages] > 1), (r) =>
        List.Transform(List.Select(Responses, each [ConversationID] = r[ConversationID] and [Page] = r[Page]
                           and DateTimeZone.ToUtc([ResponseTime]) <> DateTimeZone.ToUtc(r[ResponseTime])
                           and Near([ResponseTime], r[ResponseTime])),
            (d) => "page " & Text.From(r[Page]) & " in " & Text.Combine(List.Sort({r[File], d[File]}), " and "))))),

    // All pages of one download (same conversationID, within a few days, as for the
    // missing-page check below) must state the same numberOfPages. If they differ, the
    // files do not come from one complete download and the page check cannot be trusted.
    Conflicts = List.Distinct(List.Transform(List.Select(Responses, (r) =>
        List.MatchesAny(Responses, each [ConversationID] = r[ConversationID] and [Pages] <> r[Pages]
                                        and Near([ResponseTime], r[ResponseTime]))), (r) =>
        Text.Combine(List.Transform(List.Sort(List.Select(Responses, each [ConversationID] = r[ConversationID]
                                                and Near([ResponseTime], r[ResponseTime])), each [File]),
            each [File] & " says numberOfPages " & Text.From([Pages])), ", "))),

    // Every page from 0 to numberOfPages - 1 must be in the folder, from the same download.
    // Each missing page is reported once, with the first file of that download.
    Missing = List.Distinct(List.Combine(List.Transform(Responses, (r) =>
        let
            first  = List.Min(List.Transform(List.Select(Responses, each [ConversationID] = r[ConversationID]
                                  and Near([ResponseTime], r[ResponseTime])), each [File])),
            absent = List.Select(List.Numbers(0, r[Pages]), (p) =>
                         not List.MatchesAny(Responses, each [ConversationID] = r[ConversationID] and [Page] = p
                                                             and Near([ResponseTime], r[ResponseTime])))
        in
            List.Transform(absent, each "page " & Text.From(_) & " of the " & Text.From(r[Pages]) &
                " pages of the download that includes " & first & " (pages are numbered from 0)")))),

    AllRows = Table.FromRecords(List.Combine(List.Transform(Responses, each [Rows])),
        {"Reference", "UDI", "Basic", "Legislation", "RiskClass", "TradeName", "State", "Market", "Version",
         "VersionDate", "LastUpdated", "BasicState", "BasicVersion", "BasicUpdated", "File", "ResponseTime"},
        MissingField.UseNull),

    Checked = if not List.IsEmpty(Duplicates) then
                  error ("EUDAMED device list: two different responses for the same page of one download: " &
                         Text.Combine(Duplicates, "; ") & ". This happens when the same request files are sent again " &
                         "within a few days. Keep one complete download in this folder: move the files of the other " &
                         "one to another folder and refresh again.")
              else if not List.IsEmpty(Conflicts) then
                  error ("EUDAMED device list: the pages of one download state different page counts: " &
                         Text.Combine(Conflicts, "; ") & ". The files do not form one complete download. " &
                         "Download that state again as a full set (all pages, the same day) into an empty folder " &
                         "and refresh again.")
              else if List.IsEmpty(Missing) then AllRows
              else error ("EUDAMED device list: the list would be incomplete. Missing: " & Text.Combine(Missing, "; ") &
                          ". Download the missing page(s), save them in the folder and refresh again."),

    // ---------- 4. One current row per device ----------
    // A device is a UDI-DI under a Basic UDI-DI and a legislation. The same UDI-DI
    // can be registered twice, once as a legacy device and once under MDR; these are
    // two rows.
    // For each device the newest download decides: responses created within 12 hours
    // of the newest one that names the device count as that download, older ones are
    // ignored. So a device that was Registered and is downloaded as Discarded more
    // than 12 hours later shows as Discarded only. If responses within 12 hours of
    // each other return the device in two states, it gets a row per state, and
    // "Other states" names the other. Among responses of the same moment, the higher
    // version, then the later "last updated", then the file name decides.

    WithUtc   = Table.AddColumn(Checked, "Utc", each if [ResponseTime] = null then null else DateTimeZone.ToUtc([ResponseTime])),
    PerDevice = Table.Group(WithUtc, {"UDI", "Basic", "Legislation"}, {{"Rows", each _, type table}}),

    Current = (t as table) as list =>
        let
            newest = List.Max(List.RemoveNulls(t[Utc])),
            recent = Table.SelectRows(t, each newest = null or [Utc] = null or newest - [Utc] <= #duration(0, 12, 0, 0)),
            states = List.Sort(List.Distinct(recent[State])),
            pick   = (state) => Table.Buffer(Table.Sort(Table.SelectRows(recent, each [State] = state),
                                    {{"Utc", Order.Descending}, {"Version", Order.Descending},
                                     {"LastUpdated", Order.Descending}, {"File", Order.Descending}})){0}
        in
            List.Transform(states, (state) => pick(state) & [States = states]),

    Final = Table.FromRecords(List.Transform(List.Combine(List.Transform(PerDevice[Rows], Current)), (r) =>
            [#"Reference number"          = r[Reference],
             #"UDI-DI / EUDAMED ID"       = r[UDI],
             #"Basic UDI-DI / EUDAMED DI" = r[Basic],
             Legislation                  = r[Legislation],
             #"Risk class"                = r[RiskClass],
             #"Trade name"                = r[TradeName],
             State                        = r[State],
             #"Other states"              = let o = List.Select(r[States], each _ <> r[State])
                                            in if List.IsEmpty(o) then null else Text.Combine(o, ", "),
             #"Market status"             = r[Market],
             Version                      = r[Version],
             #"Version date"              = Show(r[VersionDate]),
             #"Last updated"              = Show(r[LastUpdated]),
             #"Basic state"               = r[BasicState],
             #"Basic version"             = r[BasicVersion],
             #"Basic last updated"        = Show(r[BasicUpdated]),
             #"Downloaded on"             = Show(r[ResponseTime]),
             #"Response file"             = r[File]]),
        type table [#"Reference number" = text, #"UDI-DI / EUDAMED ID" = text, #"Basic UDI-DI / EUDAMED DI" = text,
                    Legislation = text, #"Risk class" = text, #"Trade name" = text, State = text, #"Other states" = text,
                    #"Market status" = text, Version = nullable number, #"Version date" = nullable datetime,
                    #"Last updated" = nullable datetime, #"Basic state" = text, #"Basic version" = nullable number,
                    #"Basic last updated" = nullable datetime, #"Downloaded on" = nullable datetime,
                    #"Response file" = text]),

    Sorted = Table.Sort(Final, {{"Legislation", Order.Ascending}, {"Reference number", Order.Ascending},
                                {"UDI-DI / EUDAMED ID", Order.Ascending}, {"State", Order.Ascending}})
in
    Sorted
