// EUDAMED device list, version 3.4 (Power Query / M)
//
// What it does: you send the request files to EUDAMED (Bulk Upload, service
// "Download of Legacy/ Regulation Device/SPP") and save each answer EUDAMED sends
// back in one folder. This Excel script reads the answers in that folder and makes
// one list of your devices with their state (this package requests Registered and
// Discarded), market status, version and dates, exactly as EUDAMED sent them.
//
// EUDAMED sends at most 300 devices per answer. If you have more, the first answer
// tells you how many files you need; send them all on the same day and save every
// answer in the folder. If you also keep "changed since" answers in the folder,
// the newest answer decides for each device (see "Same device in several downloads" in
// Part 3 Validate, TECHNICAL_NOTES.md for the 12-hour rule).
// Start an empty folder for each new full download.
//
// It stops with a message, instead of guessing, if: a file has ".xml" in its name
// but does not end in .xml (for example answer.xml.txt); a file is a refusal from
// EUDAMED or not a SUCCESS answer; an answer misses its date or file information,
// or that information is impossible; two different answers exist for the same
// file; an answer holds a record it cannot read (it reads MDR and legacy MDD
// records); the answers of one download disagree on how many files it has; or a
// file of a download is missing. Each message names the file and says what to do.
//
// It cannot know about an answer you never saved: make sure the folder holds an
// answer for each state, also when that answer says there are 0 devices.
//
// Intended use: turning your own saved EUDAMED answers into a device list. It
// shows what EUDAMED sent on the day of the download, nothing newer. Check that
// the list is suitable for your intended use under your own quality procedures
// before you use it as a quality record.
//
// It reads only the folder named below and makes no network calls. Shared as-is,
// without warranty. Not affiliated with the European Commission.
//
// How to use: Excel > Data > Get Data > From Other Sources > Blank Query >
// Advanced Editor > paste this text > change the folder path below > Done >
// Close & Load. After each download, save the answers in the folder and click
// Data > Refresh All.
//
// Technical words used below: an answer is a PullResponse, a refusal is an
// Acknowledgement with an error code, and "file 1, file 2 ..." of a download are
// its pages 0, 1 ... (pageNumber); numberOfPages is how many files it has.

let
    // 1. Change this path to your own answers folder
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

    // Read a date such as 2026-11-09T09:00:00.000+01:00; blank if unreadable
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
    // .xml (for example answer.xml.txt or a download still ending in .crdownload) is
    // most likely an answer saved under a wrong name, so the refresh stops.
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
                        then " does not end in .xml, so Excel cannot read it. If the name ends in .crdownload or .part, the download did not finish: move it out of this folder and download that same answer again from Upload Management (find it by file name and time). Otherwise rename it so that the name ends in .xml. Then refresh."
                        else " do not end in .xml, so Excel cannot read them. If a name ends in .crdownload or .part, that download did not finish: move it out of this folder and download that same answer again from Upload Management (find it by file name and time). Otherwise rename each one so that the name ends in .xml. Then refresh.") &
                       " (To see the full file names in File Explorer: View > Show > " &
                       "File name extensions.)")
            else
                Table.SelectColumns(unique, {"Name", "Content"}),

    // ---------- 2. Read one answer file ----------

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
                    " is a refusal from EUDAMED (acknowledgement), not an answer with devices. EUDAMED did not accept that request. " &
                    "Open the file in Notepad to read why and fix the cause. Then start the download again: move all answers in this folder into a dated subfolder and send the request files of both states again on the same day. Then refresh.")
                else if ack is table then error ("EUDAMED device list: " & file &
                    " is only a receipt from EUDAMED (acknowledgement), not an answer with devices. It is not an answer. " &
                    "It is usually the result of a different upload. Move it out of this folder, find your download in Upload Management by its file name and time, save its PullResponse and refresh. If there is none, start the download again with both states.")
                else if root is table then error ("EUDAMED device list: " & file &
                    " is an answer with the result " & (code ?? "(no result)") & " instead of SUCCESS, so it cannot be used. Start the download again: move all answers in this folder into a dated subfolder and send the request files of both states again on the same day. Then refresh.")
                else error ("EUDAMED device list: " & file &
                    " is not an answer to an EUDAMED device download. Move it out of this folder only when you are sure it is not an answer of this download (for example a request file), then refresh. If it was meant to be an answer, download that same answer again from Upload Management (find it by file name and time), check it (PullResponse and SUCCESS) and refresh. If you are unsure, start the download again: move all answers in this folder into a dated subfolder and send the request files of both states again on the same day. Then refresh."),
            time     = ToTime(Child(root, "creationDateTime")),
            payload  = Child(root, "payload"),
            devices  = Children(payload, "Device"),
            // Elements in the payload that are not device records (an unknown answer shape)
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
            // Records of a type the script cannot read (for example an unrecognised record shape), or without
            // the identifiers, legislation or state that the list needs
            unreadable = others + List.Count(List.Select(List.Positions(devices), (i) =>
                             (Child(devices{i}, "MDRUDIDIData") ?? Child(devices{i}, "MDEUData")) = null or
                             (Child(devices{i}, "MDRBasicUDI") ?? Child(devices{i}, "MDEUDI")) = null or
                             rows{i}[UDI] = null or rows{i}[Basic] = null or
                             rows{i}[Legislation] = null or rows{i}[State] = null)),
            cid      = Txt(Child(root, "conversationID")),
            page     = ToNumber(Child(root, "pageNumber")),
            pages    = ToNumber(Child(root, "numberOfPages")),
            absent   = List.Select({{"the creation date (creationDateTime)", time}, {"the download ID (conversationID)", cid},
                                    {"the file number (pageNumber)", page}, {"how many files the download has (numberOfPages)", pages}}, each _{1} = null),
            badPage  =
                if not Whole(page) or not Whole(pages) then
                    " has a file number or a number of files that is not a whole number of 0 or more (pageNumber, numberOfPages)."
                else if pages = 0 and (page <> 0 or not List.IsEmpty(devices) or others > 0) then
                    " says its download has no devices (numberOfPages 0), but it also says it is file " & Text.From(page + 1) &
                    " or it holds devices."
                else if pages > 0 and page >= pages then
                    " says it is file " & Text.From(page + 1) & ", but the number of files in its download is " & Text.From(pages) &
                    "."
                else null
        in
            if ok then
                if not List.IsEmpty(absent) then
                    error ("EUDAMED device list: " & file & " is missing information that the check for missing files needs: " &
                           Text.Combine(List.Transform(absent, each _{0}), ", ") &
                           ". Download that same answer again from Upload Management (find it by file name and time), check it (PullResponse and SUCCESS), replace the file in this folder and refresh. If you cannot find that upload, start the download again with both states.")
                else if badPage <> null then
                    error ("EUDAMED device list: " & file & badPage &
                           " The check for missing files cannot trust it. Download that same answer again from Upload Management (find it by file name and time), check it (PullResponse and SUCCESS), replace the file in this folder and refresh. If you cannot find that upload, start the download again with both states.")
                else if unreadable > 0 then
                    error ("EUDAMED device list: " & file & " holds " & Text.From(unreadable) &
                           " device record(s) that this Excel script cannot read (it reads MDR and legacy MDD records that have a " &
                           "UDI-DI, Basic UDI-DI, legislation and state). The list would be wrong, so the refresh stops. " &
                           "Keep the file for investigation and do not use the list until the script can read that kind of record.")
                else
                    [File = file, ConversationID = cid, Page = page, Pages = pages, ResponseTime = time, Rows = rows]
            else null,

    Responses = List.Buffer(List.Transform(Table.ToRecords(XmlFiles(ResponseFolder)), each ReadResponse([Name], [Content]))),

    // ---------- 3. Check that no file of a download is missing ----------
    // EUDAMED states in every answer how many files the download has (numberOfPages);
    // inside the answers, file 1, file 2 ... are numbered from 0 (pageNumber 0, 1 ...).
    // The answers of one download carry the same conversationID and arrive within a few days.

    Near = (x, y) => Number.Abs(Duration.TotalDays(DateTimeZone.ToUtc(x) - DateTimeZone.ToUtc(y))) <= 3,

    // Two different answers for the same file of a download with more than one file.
    // This happens when the same request files are sent again within a few days. The
    // check could then use an answer of the older download to fill a gap in the newer
    // one, so the refresh stops. (Exact copies of one file were already removed.)
    Duplicates = List.Distinct(List.Combine(List.Transform(List.Select(Responses, each [Pages] > 1), (r) =>
        List.Transform(List.Select(Responses, each [ConversationID] = r[ConversationID] and [Page] = r[Page]
                           and DateTimeZone.ToUtc([ResponseTime]) <> DateTimeZone.ToUtc(r[ResponseTime])
                           and Near([ResponseTime], r[ResponseTime])),
            (d) => "file " & Text.From(r[Page] + 1) & " in " & Text.Combine(List.Sort({r[File], d[File]}), " and "))))),

    // All answers of one download (same conversationID, within a few days, as for the
    // missing-file check below) must state the same number of files. If they differ, the
    // answers do not come from one complete download and the check cannot be trusted.
    Conflicts = List.Distinct(List.Transform(List.Select(Responses, (r) =>
        List.MatchesAny(Responses, each [ConversationID] = r[ConversationID] and [Pages] <> r[Pages]
                                        and Near([ResponseTime], r[ResponseTime]))), (r) =>
        Text.Combine(List.Transform(List.Sort(List.Select(Responses, each [ConversationID] = r[ConversationID]
                                                and Near([ResponseTime], r[ResponseTime])), each [File]),
            each [File] & " says the number of files is " & Text.From([Pages])), ", "))),

    // Every file of a download must be in the folder, from the same download.
    // Each missing file is reported once, with the alphabetically first file of that download.
    Missing = List.Distinct(List.Combine(List.Transform(Responses, (r) =>
        let
            first  = List.Min(List.Transform(List.Select(Responses, each [ConversationID] = r[ConversationID]
                                  and Near([ResponseTime], r[ResponseTime])), each [File])),
            absent = List.Select(List.Numbers(0, r[Pages]), (p) =>
                         not List.MatchesAny(Responses, each [ConversationID] = r[ConversationID] and [Page] = p
                                                             and Near([ResponseTime], r[ResponseTime])))
        in
            List.Transform(absent, each "File " & Text.From(_ + 1) & " of " & Text.From(r[Pages]) &
                " is missing from the download that includes " & first & "")))),

    AllRows = Table.FromRecords(List.Combine(List.Transform(Responses, each [Rows])),
        {"Reference", "UDI", "Basic", "Legislation", "RiskClass", "TradeName", "State", "Market", "Version",
         "VersionDate", "LastUpdated", "BasicState", "BasicVersion", "BasicUpdated", "File", "ResponseTime"},
        MissingField.UseNull),

    Checked = if not List.IsEmpty(Duplicates) then
                  error ("EUDAMED device list: this folder holds two different answers for the same file of one download: " &
                         Text.Combine(Duplicates, "; ") & ". This happens when the same request files are sent again " &
                         "within a few days, so the folder holds answers from two runs. Start the download again: move all " &
                         "answers in this folder into a dated subfolder and send the request files of both states again on the same day. Then refresh.")
              else if not List.IsEmpty(Conflicts) then
                  error ("EUDAMED device list: the answers of one download do not agree on how many files it has: " &
                         Text.Combine(Conflicts, "; ") & ". They do not form one complete download. Start the download again: " &
                         "move all answers in this folder into a dated subfolder and send the request files of both states " &
                         "again on the same day. Then refresh.")
              else if List.IsEmpty(Missing) then AllRows
              else error ("EUDAMED device list: a file is missing, so the list would be incomplete. " & Text.Combine(Missing, "; ") &
                          ". If you can still send it today, on the same day as the other files of this download: send that file, save the answer in this folder and refresh. Otherwise start the download again: move all answers in this folder into a dated subfolder and send the request files of both states again on the same day. If more than one file is listed, do this for each."),

    // ---------- 4. One current row per device ----------
    // A device is a UDI-DI under a Basic UDI-DI and a legislation. The same UDI-DI
    // can be registered twice, once as a legacy device and once under MDR; these are
    // two rows.
    // For each device the newest download decides: answers created within 12 hours
    // of the newest one that names the device count as that download, older ones are
    // ignored. So a device that was Registered and is downloaded as Discarded more
    // than 12 hours later shows as Discarded only. If answers within 12 hours of
    // each other return the device in two states, it gets a row per state, and
    // "Other states" names the other. Among answers of the same moment, the higher
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
