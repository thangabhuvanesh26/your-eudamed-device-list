# Tool validation record: EUDAMED device list

For EUDAMED device list v2.0.

Template. Fill in the fields marked [ ] on your own computer. Adapt the headings to your QMS procedure for software or tool validation; your procedure takes precedence over this template. What the tests mean and which to run first: [README.md](README.md).

## 1. Tool description

| | |
|---|---|
| Tool | Excel workbook with the Excel script (Power Query) `EUDAMED device list.pq`, version 3.4 |
| What it does | Reads the answers EUDAMED sends back for device download requests (DEVICE.GET sent through Bulk Upload) from one local folder and lists each device record, with its state (Registered or Discarded), market status, version and dates. Combines one full download with later "changed since" downloads; for each record the newest download decides (see "Same device in several downloads" in [TECHNICAL_NOTES.md](TECHNICAL_NOTES.md#same-device-in-several-downloads)). |
| Intended use | [e.g. Keeping a current list of the manufacturer's devices registered in EUDAMED, and comparing it with the ERP.] |
| Not intended for | Showing failed uploads (use the result of each upload in EUDAMED); draft devices; Submitted devices; the original registration date; any data newer than the last download. |
| Owner | [name / role] |
| Users | [roles] |

## 2. Risk classification

| | |
|---|---|
| What could go wrong | A device is missing from the list or shows an outdated state, so a registration gap or a discarded device goes unnoticed. |
| How it is limited | Every row comes from EUDAMED's own answers, which are kept. The refresh stops with a message when a file of a download is missing, impossible or present twice, when the answers of one download disagree on how many files it has, when an answer has .xml in its name but does not end in .xml, when a refusal or other acknowledgement is in the folder, or when a record cannot be read. A new full download at a fixed interval (set it here: [ ]) replaces the accumulated changed-since downloads. The user checks that each state returned an answer (the "Before you go on" check of `Part 1 Download\README.md` and step 8 of `Part 2 Excel\README.md`). Answers from two runs made with the same request files a day or two apart can be mixed without an error; the user prevents this with one full download per empty folder, all files of both states sent on the same day. |
| Risk class | [per your procedure, e.g. low / medium] |
| Rationale | [one or two sentences] |

## 3. Configuration under test

| | |
|---|---|
| Script file and version | `Part 2 Excel\EUDAMED device list.pq`, version 3.4 [attach a copy of the script text exactly as pasted] |
| Script SHA-256 | expected `b8fba6733e3f197d11bbcee36735ab2308df84a30f6e2707365351e880f10f11`; checked with `Get-FileHash`: [ ] (see README.md, "Check that you test the right script") |
| Excel version | [File → Account → About Excel] |
| Excel language | [ ] |
| Windows date format | [ ] |
| Test files | `Part 3 Validate\Test cases` folder (made up; all devices are made up) |
| EUDAMED schema version in use | [e.g. 3.0.30, from your last successful answer] |
| Test group run | [core / core + empty pair / core + TC-2 / all / custom (list and reason)] (groups: see README.md, "Which tests to run first") |

## 4. Test cases

**How to run each test.** Open a new, empty workbook and set up the Excel script as in step 7 of `Part 2 Excel\README.md`, but set `ResponseFolder` to one single test folder, such as `Part 3 Validate\Test cases\TC-3 Missing page`. Never the folder `Test cases` itself: Excel reads only the files directly in the folder, so it would show an empty list without an error. Click **Done**, then **Home → Close & Load**. Record the result, then close the workbook without saving. Use a new workbook for each test, so that an older table cannot be mistaken for the result.

**Acceptance criterion.** Any mismatch is a failed test.

- *Where a list is expected:* the table has the 17 column headers listed in [TECHNICAL_NOTES.md](TECHNICAL_NOTES.md#what-you-get-the-columns) and exactly the expected number of rows; for every row, State, Version, Last updated and Response file are exactly as expected (set the date columns to the format `dd.mm.yyyy hh:mm:ss`); the column Other states is empty in every row; UDI-DIs keep their leading zero.
- *Where an error is expected:* the refresh stops, the message contains the expected text, and no new table is loaded.

The test folders keep their technical file names: `RESP_full_registered_page_0.xml` is Registered answer file 1, `RESP_full_registered_page_1.xml` is file 2. Full expected results: [EXPECTED_RESULTS.md](EXPECTED_RESULTS.md). Run only the tests of the group you recorded in section 3; mark the others "not run".

**What these results do not show.** The 17 tests are made-up answers run in Excel. Keep them apart from live evidence: message branches 8 and 9 are not reached by any test; script v3.4 ran on one real Production download of the author's, not on yours; sending the same request files again was tested in the Playground only. A whole state that was never saved still refreshes without an error; the checks in Part 1 and Part 2 catch that, not these tests. Answers from two runs a day or two apart can be mixed without an error (the author's extra test X7 shows this limit); one full download per empty folder prevents it. Live evidence so far: request files with version 3.0.30 were accepted in Production in November 2026 for a full download (under their v1 file names), for a changed-since request, and under their v2.0 file names. Your own live evidence is TC-10.

### TC-1 Full download (`Part 3 Validate\Test cases\TC-1 Full download`)

Two Registered answers and one Discarded answer. Tests reading MDR and legacy devices, both states, and more than one file per download.

Headers: 17 [ ]  Rows: expected 12, actual [ ]

| # | Reference number | UDI-DI / EUDAMED ID | Legislation | State | Version | Last updated | Response file | Pass? |
|---|---|---|---|---|---|---|---|---|
| 1 | TST-LEG-01 | 09521053390012 | MDD | REGISTERED | 1 | 12.11.2026 09:10:00 | RESP_full_registered_page_1.xml | [ ] |
| 2 | TST-LEG-02 | 09521053390029 | MDD | REGISTERED | 1 | 12.11.2026 09:11:00 | RESP_full_registered_page_1.xml | [ ] |
| 3 | PGT-TSA-01-A1 | 09521053366123 | MDR | REGISTERED | 1 | 09.11.2026 09:02:00 | RESP_full_registered_page_0.xml | [ ] |
| 4 | PGT-TSA-01-B1 | 09521053366024 | MDR | REGISTERED | 1 | 09.11.2026 09:06:00 | RESP_full_registered_page_0.xml | [ ] |
| 5 | PGT-TSB-02-A1 | 09521053367472 | MDR | REGISTERED | 1 | 09.11.2026 09:28:00 | RESP_full_registered_page_1.xml | [ ] |
| 6 | PGT-TSB-02-B1 | 09521053366345 | MDR | REGISTERED | 1 | 09.11.2026 09:11:00 | RESP_full_registered_page_1.xml | [ ] |
| 7 | PGT-TSB-02-C1 | 09521053369681 | MDR | REGISTERED | 1 | 09.11.2026 09:16:00 | RESP_full_registered_page_1.xml | [ ] |
| 8 | PGT-TSB-03-B1 | 09521053365508 | MDR | REGISTERED | 1 | 09.11.2026 09:20:00 | RESP_full_registered_page_0.xml | [ ] |
| 9 | PGT-TSB-03-C1 | 09521053361173 | MDR | REGISTERED | 1 | 09.11.2026 09:24:00 | RESP_full_registered_page_0.xml | [ ] |
| 10 | PGT-TSB-06-B2 | 09521053364297 | MDR | REGISTERED | 1 | 09.11.2026 09:31:00 | RESP_full_registered_page_0.xml | [ ] |
| 11 | PGT-TSB-07-B3 | 09521053363108 | MDR | REGISTERED | 1 | 09.11.2026 09:34:00 | RESP_full_registered_page_0.xml | [ ] |
| 12 | TST-MDR-D1 | 09521053390036 | MDR | DISCARDED | 1 | 13.11.2026 14:00:00 | RESP_full_discarded_page_0.xml | [ ] |

### TC-2 Full download plus delta (`Part 3 Validate\Test cases\TC-2 Full download plus delta`)

The files of TC-1 plus a later "changed since" download with one new device, one new version and one device now discarded. Tests that the newest download decides.

Headers: 17 [ ]  Rows: expected 13, actual [ ]

All rows of TC-1 are unchanged **except** rows 2 and 10, and there is one new row:

| # | Reference number | UDI-DI / EUDAMED ID | Legislation | State | Version | Last updated | Response file | Pass? |
|---|---|---|---|---|---|---|---|---|
| 2 | TST-LEG-02 | 09521053390029 | MDD | **DISCARDED** | 1 | **26.11.2026 11:10:00** | **RESP_delta_discarded_page_0.xml** | [ ] |
| 10 | PGT-TSB-06-B2 | 09521053364297 | MDR | REGISTERED | **2** | **26.11.2026 11:05:00** | **RESP_delta_registered_page_0.xml** | [ ] |
| 13 | TST-MDR-N1 | 09521053390043 | MDR | REGISTERED | 1 | 26.11.2026 11:00:00 | RESP_delta_registered_page_0.xml | [ ] |
| others | rows 1, 3–9, 11, 12 as in TC-1 | | | | | | | [ ] |

### TC-3 Missing page (`Part 3 Validate\Test cases\TC-3 Missing page`)

Registered file 2 of 2 was not saved.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "a file is missing, so the list would be incomplete" and "File 2 of 2 is missing from the download that includes RESP_full_registered_page_0.xml". No new table is loaded. | [ ] | [ ] |

### TC-4 Rejection in folder (`Part 3 Validate\Test cases\TC-4 Rejection in folder`)

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "ACK_rejected_request.xml is a refusal from EUDAMED". No new table is loaded. | [ ] | [ ] |

### TC-5 Empty folder (`Part 3 Validate\Test cases\TC-5 Empty folder`)

| Expected | Actual | Pass? |
|---|---|---|
| Table with the 17 column headers, no rows, no error. | [ ] | [ ] |

### TC-6 Unknown device type (`Part 3 Validate\Test cases\TC-6 Unknown device type`)

The files of TC-1, but one device in Registered answer file 1 uses element names the script does not know (IVDR records were not tested). Tests that an unreadable record stops the refresh instead of becoming a blank row.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml holds 1 device record(s) that this Excel script cannot read". No new table is loaded. | [ ] | [ ] |

### TC-7 No page count (`Part 3 Validate\Test cases\TC-7 No page count`)

Registered answer file 1 without `numberOfPages`, and file 2 not saved. Tests that a missing file count stops the refresh instead of hiding the missing file.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml is missing information that the check for missing files needs: how many files the download has (numberOfPages)". No new table is loaded. | [ ] | [ ] |

### TC-8 No creation date (`Part 3 Validate\Test cases\TC-8 No creation date`)

The files of TC-1, but Registered answer file 1 has an empty `creationDateTime`. Tests that an answer without a date stops the refresh.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml is missing information that the check for missing files needs: the creation date (creationDateTime)". No new table is loaded. | [ ] | [ ] |

### TC-9 Lock file in folder (`Part 3 Validate\Test cases\TC-9 Lock file in folder`)

The files of TC-1 plus a lock file (`~$RESP_full_registered_page_0.xml`) such as Excel leaves while a file is open. Tests that lock files are skipped.

| Expected | Actual | Pass? |
|---|---|---|
| The same 12 rows as TC-1, no error. | [ ] | [ ] |

### TC-11 Page number out of range (`Part 3 Validate\Test cases\TC-11 Page number out of range`)

The files of TC-1, but Registered answer file 2 says it is file 3 of 2.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_1.xml says it is file 3, but the number of files in its download is 2". No new table is loaded. | [ ] | [ ] |

### TC-12 Unknown record in payload (`Part 3 Validate\Test cases\TC-12 Unknown record in payload`)

The files of TC-1, but Registered answer file 1 also holds an element that is not a device record.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml holds 1 device record(s) that this Excel script cannot read". No new table is loaded. | [ ] | [ ] |

### TC-13 No Basic UDI-DI (`Part 3 Validate\Test cases\TC-13 No Basic UDI-DI`)

The files of TC-1, but one device in Registered answer file 1 has an empty Basic UDI-DI.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml holds 1 device record(s) that this Excel script cannot read". No new table is loaded. | [ ] | [ ] |

### TC-14 Same requests sent twice (`Part 3 Validate\Test cases\TC-14 Same requests sent twice`)

The files of TC-1, plus file 1 of a second download made a day later with the same request files; its file 2 is missing.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "two different answers for the same file of one download: file 1 in RESP_again_registered_page_0.xml and RESP_full_registered_page_0.xml". No new table is loaded. | [ ] | [ ] |

### TC-15 No Discarded records (`Part 3 Validate\Test cases\TC-15 No Discarded records`)

The Registered files of TC-1, plus a Discarded answer with `numberOfPages` 0, no records and the result SUCCESS.

| Expected | Actual | Pass? |
|---|---|---|
| 11 rows: rows 1 to 11 of TC-1 (TST-MDR-D1 is not in the list), no error. | [ ] | [ ] |

### TC-16 Misnamed response file (`Part 3 Validate\Test cases\TC-16 Misnamed response file`)

The files of TC-1, but Registered answer file 2 is saved as `RESP_full_registered_page_1.xml.txt`.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_1.xml.txt does not end in .xml, so Excel cannot read it". No new table is loaded. | [ ] | [ ] |

### TC-17 Conflicting page counts (`Part 3 Validate\Test cases\TC-17 Conflicting page counts`)

The files of TC-1, but Registered answer file 1 says `numberOfPages` 1 while file 2 says 2.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml says the number of files is 1" and "RESP_full_registered_page_1.xml says the number of files is 2". No new table is loaded. | [ ] | [ ] |

### TC-18 Both states empty (`Part 3 Validate\Test cases\TC-18 Both states empty`)

A Registered and a Discarded answer, each with `numberOfPages` 0, `pageNumber` 0, no records and the result SUCCESS.

| Expected | Actual | Pass? |
|---|---|---|
| Table with the 17 column headers, no rows, no error. | [ ] | [ ] |

### TC-10 First live check (recommended before the list is used as a record)

Separate from the 17 tests and from their time estimate. After your first real full download:

1. Note the number of rows per State in the list. Then, in EUDAMED:
   - Log in and choose the actor profile of your SRN.
   - Open **Tasks → UDI-DIs/Device → Manage your device details**.
   - Click **Filter**, set **State** to **Registered**, and leave every other filter empty. Note N from "Showing 1 to 20 of **N** entries".
   - Repeat with **State** set to **Discarded**.

   The results are grouped under headers: a **Basic UDI-DI** header, or an **EUDAMED DI** header for a legacy device. Each line under a header is one device identifier (a UDI-DI, or an EUDAMED ID for a legacy device), like one row in the list. If the numbers differ, first check that no filter other than State is active (the Active filters line). Then look for a record that has a row in each state; see "12-hour rule" in [TECHNICAL_NOTES.md](TECHNICAL_NOTES.md).
2. If the list has fewer than 10 rows, check all of them. Otherwise take at least 10 rows, including every Discarded row (or at least 5 of them, if there are many) and at least 2 MDR and 2 legacy devices where you have them. Search each UDI-DI in EUDAMED and compare state, version and last update date.

If you plan TC-10 but cannot do it yet, mark it "open" in section 5 and do not release the list for use in your QMS until it is done. If you decide not to do it, mark it "not selected" and give the reason. A mismatch you cannot explain by a later change in EUDAMED (the 12-hour rule, or devices registered after your download) means TC-10 fails; while TC-10 is open, the list is not released for QMS use. Also note how long Refresh All takes with your real folder: [ ]

| | List | EUDAMED | Agrees? |
|---|---|---|---|
| Registered devices | [ ] | [ ] | [ ] |
| Discarded devices | [ ] | [ ] | [ ] |

| UDI-DI | State in list | Version in list | Last updated in list | State, version and last update in EUDAMED | Agrees? |
|---|---|---|---|---|---|
| [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |

## 5. Result

| | |
|---|---|
| Date of test | [ ] |
| Tested by | [ ] |
| Test group run | [core / core + empty pair / core + TC-2 / all / custom (list and reason)] |
| Tests run from the 17 (test data) | [list, e.g. TC-1, TC-3, TC-4, TC-7, TC-14, TC-15, TC-16, TC-17] [pass / fail] |
| Tests not run, and why | [none / list and reason] |
| TC-10 (first live check) | [pass / fail / open / not selected, reason: ...] |
| Deviations and how they were resolved | [none / describe] |
| Conclusion | [released for the intended use / not released] |

## 6. Change control

Repeat the tests of the recorded group (at least the core group) and update this record when:

- the script changes (any change other than the folder path),
- Excel is moved to a new computer or receives a major update,
- EUDAMED changes its schema version, or an answer looks different from before,
- the intended use changes.

| Version | Date | Change | Test group run | Re-tested by |
|---|---|---|---|---|
| 3.4 | [ ] | First release | [ ] | [ ] |

## 7. Sign-off

| Role | Name | Date | Signature |
|---|---|---|---|
| Tested by | [ ] | [ ] | [ ] |
| Reviewed by | [ ] | [ ] | [ ] |
| Approved by | [ ] | [ ] | [ ] |
