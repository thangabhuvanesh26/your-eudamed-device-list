# Technical notes

For EUDAMED device list v2.0.

Technical notes on the EUDAMED device download (DEVICE.GET) behind the request files in this package. They come from the author's own tests in the EUDAMED Playground and in Production, in November 2026. EUDAMED can change; if something here no longer matches what you see, trust the refusal message or the answer file.

## Words used

The READMEs of the three parts use plain words. Here is what they mean technically.

| Plain word | Means | Technical term |
|---|---|---|
| request file | the file you send to EUDAMED | PullRequest XML |
| answer | the file EUDAMED sends back with your devices | PullResponse |
| refusal | the file EUDAMED sends back when it refuses a request | Acknowledgement with an error code |
| file 1, file 2 … | the files of one download, counted from 1 | page 0, page 1 … |
| "how many files you need" | the count written in the first answer | numberOfPages |
| answers folder | the one folder where you save the answers | ResponseFolder |
| the Excel script | what you paste into Excel once | Power Query M script |

## Version of the request files

Every request file states the schema version in its first element, for example:

```xml
<m:PullRequest version="3.0.30" ...>
```

| Environment | Version |
|---|---|
| Production | 3.0.30, last accepted in November 2026. Accepted in the author's tests: a full download (Registered and Discarded, several files) under the v1 file names, a changed-since request, and the v2.0 file names. The supplied request files carry this version. |
| Playground (test environment) | 3.0.36.1, last accepted in November 2026. In an earlier test it demanded 3.0.36.1 although its help page said 3.0.32. |

The supplied request files carry the Production version 3.0.30, last accepted in Production in November 2026.

Evidence (the author's tests, November 2026): request files with version 3.0.30 were accepted in Production for a full download (Registered and Discarded, several files) under their v1 file names, for a changed-since request, and under their v2.0 file names, each answered with SUCCESS. Sending the same request files again was tested in the Playground only. Excel script v3.4 was tested in Excel on made-up answers (the 17 tests) and on one real Production download of the author's.

EUDAMED changes the schema version with its releases; the version at the top of the package's `README.md` is updated when Production changes.

**If EUDAMED refuses a request because of the version.** Read the refusal first. Only if it says the schema version is wrong and names the version it expects, EUDAMED has moved to a new version. Then:

1. Open each request file you will send in Notepad.
2. In the `<m:PullRequest ...>` line, change the value inside `version="..."` to the version the refusal names. Change nothing else.
3. Save, and send it again.

If it is still refused, ask your EUDAMED administrator or the EUDAMED service desk.

With Python, the helper writes a fresh set with the new version instead: `python make_request_files.py XX-MF-000000000 --version <version> --out <new folder>`, run from the folder `Part 1 Download\If needed\More files than supplied` (replace the parts in angle brackets; keep the new folder path short, for example `C:\EUDAMED\new`). See [HOW_TO.md](../Part%201%20Download/If%20needed/More%20files%20than%20supplied/HOW_TO.md).

## State filter

- A request without a State filter returns REGISTERED records only.
- The State values used are REGISTERED and DISCARDED. That is why the package has one set of request files per state.
- The service also accepts SUBMITTED. In one Playground test, a request for SUBMITTED returned no records. This package requests Registered and Discarded only; check Submitted devices in EUDAMED itself.
- Submitted: for new MDR device entities (a new Basic UDI-DI or UDI-DI) submitted through Data Exchange: waiting, because the new Basic UDI-DI needs a notified body to validate it, or the new UDI-DI is linked to a Basic UDI-DI that is in Submitted state (BR-DTX-UDI-035). That rule covers new entities submitted through Data Exchange.
- Registered: registered in EUDAMED (BR-DTX-UDI-035).
- Discarded: a Registered record that the manufacturer discarded. EUDAMED treats it as a logical delete: it no longer shows on the public site and its codes can be reused (BR-UDID-624). The manufacturer can still download its own discarded devices (DEVICE.GET service definition, 'DTX for EOs - services definition').
- Market status (on the market or not) is a separate column, not a state.

## File counts (pages)

- `pageSize` is at most 300 records per answer. The request files use 300.
- Pages are numbered from 0: file 1 asks for page 0, file 2 for page 1, and so on.
- Each answer states `numberOfPages`, near the end of the file. It is 0 when there are no records in that state.
- The answer echoes the `conversationID` (the download ID) and `correlationID` of the request. All files of one state in the supplied set share one `conversationID`; the Excel script uses this to check that no file of a download is missing.
- The Excel script treats answers with the same download ID, created within 3 days of each other, as one download. Request files you send again keep their download ID. So answers from two runs a day or two apart can be mixed without an error, for example file 1 from one run and file 2 from the other. That is why each full download goes into an empty folder, with all files of both states sent on the same day (see "Folder rules").
- The supplied 20 Registered request files cover up to 6,000 records, the 5 Discarded request files up to 1,500. The Excel script itself has no such limit.

## What you get: the columns

One row represents one device record in EUDAMED. Separate legacy and MDR records remain separate, even where they share a UDI-DI. MDR is the Medical Device Regulation; legacy devices fall under the Medical Devices Directive (MDD).

| Column | What it shows |
|---|---|
| Reference number | |
| UDI-DI / EUDAMED ID | the device identifier (for a legacy device: the EUDAMED ID) |
| Basic UDI-DI / EUDAMED DI | (for a legacy device: the EUDAMED DI) |
| Legislation | MDR or MDD |
| Risk class | |
| Trade name | the different trade-name texts, joined into one cell, without language labels |
| State | REGISTERED or DISCARDED, as EUDAMED writes it |
| Other states | filled only if one download returns the device in two states; check that record in EUDAMED |
| Market status | |
| Version | |
| Version date | |
| Last updated | |
| Basic state | state of the Basic UDI-DI |
| Basic version | version of the Basic UDI-DI |
| Basic last updated | last update of the Basic UDI-DI |
| Downloaded on | the creation date and time of the answer the row came from |
| Response file | the name of that answer file |

The list shows the newest version EUDAMED returned for each record, with no history. Dates and times appear as written in the answers, without their time zone. Registered and Discarded describe the record in EUDAMED, not what happened to the physical product.

## What an answer contains

- For each UDI-DI and for its Basic UDI-DI: `state`, `version`, `versionDate` and `lastUpdated`.
- No original registration date. The answers tested contained the version date and the last update, and no separate registration date.
- The Excel list shows the Basic UDI-DI's state, version and last update, not its versionDate.

## Same device in several downloads

The newest download decides, and each record normally keeps one row. Newest means the creation date and time EUDAMED writes inside each answer, not the file name or file date.

**12-hour rule.** Answers created within 12 hours of each other count as the same download. If they return a record in two states, for example because it was discarded between two answers, the record gets a row per state and Other states names the other one. Check such a record in EUDAMED. Sending all files of both states on the same day keeps this rare.

A UDI-DI with both a legacy and an MDR record keeps two rows.

## Sending the same request files again

In the author's Playground test (November 2026), EUDAMED accepted request files it had received nine days earlier, both unchanged and with only the date changed, and answered with SUCCESS. The answer carried the same conversation and correlation IDs as the request, with a new creation date and time. This was tested in the Playground only, not yet in Production.

## Changed-since filter

- The changed-since request files add the filter `<s:UDIDIVersionDate>YYYY-MM-DD</s:UDIDIVersionDate>`.
- In the author's tests, the filter was inclusive: records dated on the given day came back too. Such a record takes the new answer as its Response file, even if it did not change after the last run. It gets a row per state if answers created within 12 hours of each other return it in two states (12-hour rule).
- Tested only for newly registered records. If a changed-since answer reports more than one file, do a new full download.
- Which rows come from a changed-since answer depends on the records that answer actually returned, not on whether a device changed. Check the rows against the records in the answers.
- Changing only the date keeps the download ID (`conversationID`) of the changed-since files. Answers of two changed-since runs sent within 3 days of each other with the same files are then treated as one download: if their file counts differ (for example 0 and 1), the refresh stops; if they agree, answers from two runs can be mixed without an error. For a run within three days of the last one, use a fresh pair from the helper (option `--since`), or do a full download into an empty folder.
- Give each changed-since run its own answer names (run date and number), note its start date in a run log, and move the date forward only after a refresh with all checks passed. Check that each changed-since answer was saved from this run (its upload time in Upload Management; for an answer that said 0, also its creation date). When unsure, do a fresh full download into an empty folder. How to use it: [HOW_TO.md](../Part%201%20Download/If%20needed/Changed%20since/HOW_TO.md) in `Part 1 Download\If needed\Changed since`.

## Folder rules

- One full download per empty folder. Before each new full download, move all old answers into a new subfolder named with the date, for example `old 2026-11-21`. Use a new subfolder each time, so older answers are never overwritten.
- Keep a full download and any later changed-since answers together in one folder.
- Use separate folders per SRN and per environment (Playground, Production).
- The Excel script reads only the `.xml` files directly in that folder, not in subfolders. Exact copies of a file count once.
- So a folder that holds only other folders, such as the extracted package folder or `Part 3 Validate\Test cases`, gives an empty list without an error. Point Excel at your answers folder, at `Part 2 Excel\Try it first`, or at one single test folder.
- Send all files of both states of one download on the same day.
- Recovery: get an original answer again from Upload Management, by its upload's file name and time. Move unfinished files (`.crdownload`, `.part`) out of the folder. A receipt (an Acknowledgement that says SUCCESS) is not a device answer and is usually the result of a different upload: find your download by its file name and time and save its PullResponse, or start the download again if there is none; a refusal (an Acknowledgement with an error code) needs its cause fixed. If an upload must be sent again after an interruption (a refusal, a result other than SUCCESS, a missing file that can no longer be sent on the same day), or you are unsure which run an answer belongs to, start the download again: move all answers into a new dated subfolder and send the request files of both states again, on the same day, into the empty folder. After any fix, repeat the "Before you go on" check of Part 1 and the checks of step 8 in Part 2. See [Start the download again](../Part%201%20Download/README.md#start-the-download-again).

## Licence

This text is under CC BY 4.0 (`LICENSE-DOCS.md`).
