# Download notes

Technical notes on the EUDAMED device download (DEVICE.GET) behind the request files in this package. They come from the author's own tests in the EUDAMED Playground and in Production, in November 2026. EUDAMED can change; if something here no longer matches what you see, trust the rejection message or the response file.

## Schema version

Every request file states the schema version in its first element, for example:

```xml
<m:PullRequest version="3.0.30" ...>
```

| Environment | Version |
|---|---|
| Production | 3.0.30, last accepted on 18 November 2026. The supplied request files carry this version. |
| Playground (test environment) | 3.0.36.1, last accepted on 20 November 2026. On 11 November it demanded 3.0.36.1 although its help page said 3.0.32. |

The current Production version is also shown at the top of `README.md`.

If a request is rejected because of the schema version, the rejection message names the version it wants. Open each request file you will send in Notepad, change the value inside `version="..."` in the `<m:PullRequest ...>` line to that version, change nothing else, and save. With Python, run from the package folder: `python advanced\tools\make_request_files.py XX-MF-000000000 --version <version> --out <new folder>` writes a fresh set with the new version (replace the parts in angle brackets).

## State filter

- A request without a State filter returns REGISTERED records only.
- The State values used are REGISTERED and DISCARDED. That is why the package has one set of request files per state.
- In one Playground test, a request for SUBMITTED returned no records. This package supplies request files for REGISTERED and DISCARDED only.

## Pages

- `pageSize` is at most 300 records per response. The request files use 300.
- Pages are numbered from 0.
- Each response states `numberOfPages`, near the end of the file. It is 0 when there are no records in that state.
- The response echoes the `conversationID` and `correlationID` of the request. All pages of one state in the supplied files share one `conversationID`; the Excel query uses this to check that no page of a download is missing.

## Changed-since filter

- The changed-since request files add the filter `<s:UDIDIVersionDate>YYYY-MM-DD</s:UDIDIVersionDate>`.
- In the author's tests, the filter was inclusive: records dated on the given day came back too.
- Tested only for newly registered records. If a changed-since response reports more than one page, do a new full download.

## What a response contains

- For each UDI-DI and for its Basic UDI-DI: `state`, `version`, `versionDate` and `lastUpdated`.
- No original registration date.
- The Excel list shows the Basic UDI-DI's state, version and last update, not its versionDate.
