# Tool validation record: EUDAMED device list

Template. Fill in the fields marked [ ] on your own computer. Adapt the headings to your QMS procedure for software or tool validation; your procedure takes precedence over this template.

## 1. Tool description

| | |
|---|---|
| Tool | Excel workbook with the Power Query script `EUDAMED_device_list.pq` (version 3.3) |
| What it does | Reads the response XML files EUDAMED returns for device download requests (DEVICE.GET sent through Bulk Upload) from one local folder and lists each device record, with its state (Registered or Discarded), market status, version and dates. Combines one full download with later "changed since" downloads; for each record the newest download decides (see "What happens when the same device appears in several downloads?" in the README). |
| Intended use | [e.g. Keeping a current list of the manufacturer's devices registered in EUDAMED, and comparing it once a year with the ERP.] |
| Not intended for | Showing failed uploads (use the acknowledgement of each upload); draft devices; the original registration date; any data newer than the last download. |
| Owner | [name / role] |
| Users | [roles] |

## 2. Risk classification

| | |
|---|---|
| What could go wrong | A device is missing from the list or shows an outdated state, so a registration gap or a discarded device goes unnoticed. |
| How it is limited | Every row comes from EUDAMED's own download responses, which are kept. The refresh stops with a message when a page of a download is missing, impossible or present twice, when the pages of one download state different page counts, when a response file has .xml in its name but does not end in .xml, when a rejection or other acknowledgement is in the folder, or when a record cannot be read. A new full download at a fixed interval (set it here: [ ]) replaces the accumulated changed-since downloads. The user checks that both states returned a response. |
| Risk class | [per your procedure, e.g. low / medium] |
| Rationale | [one or two sentences] |

## 3. Configuration under test

| | |
|---|---|
| Script file and version | `EUDAMED_device_list.pq`, version 3.3 [attach a copy of the query text exactly as pasted] |
| Excel version | [File → Account → About Excel] |
| Excel language | [ ] |
| Windows date format | [ ] |
| Test files | `advanced\test-data` folder of this package (synthetic; all devices are made up) |
| EUDAMED schema version in use | [e.g. 3.0.30, from your last successful response] |

## 4. Test cases

**How to run each test.** Open a new, empty workbook and set up the query as in step 8 of the README, but set `ResponseFolder` to the test folder. Click **Done**, then **Home → Close & Load**. Record the result, then close the workbook without saving. Use a new workbook for each test, so that an older table cannot be mistaken for the result.

**Acceptance criterion.** Any mismatch is a failed test.

- *Where a list is expected:* the table has the 17 column headers listed in the README and exactly the expected number of rows; for every row, State, Version, Last updated and Response file are exactly as expected (set the date columns to the format `dd.mm.yyyy hh:mm:ss`); the column Other states is empty in every row; UDI-DIs keep their leading zero.
- *Where an error is expected:* the refresh stops, the message contains the expected text, and no new table is loaded.

### TC-1 Full download (`advanced\test-data\TC-1 Full download`)

Two pages of Registered devices and one Discarded response. Tests reading MDR and legacy devices, both states, and paging.

Headers: 17 [ ]  Rows: expected 12, actual [ ]

| # | Reference number | UDI-DI / EUDAMED ID | Legislation | State | Version | Last updated | Response file | Pass? |
|---|---|---|---|---|---|---|---|---|
| 1 | TST-LEG-01 | 09521053390012 | MDD | REGISTERED | 1 | 12.11.2026 09:10:00 | RESP_full_registered_page_1.xml | [ ] |
| 2 | TST-LEG-02 | 09521053390029 | MDD | REGISTERED | 1 | 12.11.2026 09:11:00 | RESP_full_registered_page_1.xml | [ ] |
| 3 | PGT-TSA-01-A1 | 09521053366123 | MDR | REGISTERED | 1 | 10.11.2026 15:14:12 | RESP_full_registered_page_0.xml | [ ] |
| 4 | PGT-TSA-01-B1 | 09521053366024 | MDR | REGISTERED | 1 | 10.11.2026 15:14:13 | RESP_full_registered_page_0.xml | [ ] |
| 5 | PGT-TSB-02-A1 | 09521053367472 | MDR | REGISTERED | 1 | 10.11.2026 15:27:04 | RESP_full_registered_page_1.xml | [ ] |
| 6 | PGT-TSB-02-B1 | 09521053366345 | MDR | REGISTERED | 1 | 10.11.2026 15:23:23 | RESP_full_registered_page_1.xml | [ ] |
| 7 | PGT-TSB-02-C1 | 09521053369681 | MDR | REGISTERED | 1 | 10.11.2026 15:23:24 | RESP_full_registered_page_1.xml | [ ] |
| 8 | PGT-TSB-03-B1 | 09521053365508 | MDR | REGISTERED | 1 | 10.11.2026 15:25:04 | RESP_full_registered_page_0.xml | [ ] |
| 9 | PGT-TSB-03-C1 | 09521053361173 | MDR | REGISTERED | 1 | 10.11.2026 15:25:04 | RESP_full_registered_page_0.xml | [ ] |
| 10 | PGT-TSB-06-B2 | 09521053364297 | MDR | REGISTERED | 1 | 10.11.2026 15:33:27 | RESP_full_registered_page_0.xml | [ ] |
| 11 | PGT-TSB-07-B3 | 09521053363108 | MDR | REGISTERED | 1 | 10.11.2026 15:34:28 | RESP_full_registered_page_0.xml | [ ] |
| 12 | TST-MDR-D1 | 09521053390036 | MDR | DISCARDED | 1 | 13.11.2026 14:00:00 | RESP_full_discarded_page_0.xml | [ ] |

### TC-2 Full download plus delta (`advanced\test-data\TC-2 Full download plus delta`)

The files of TC-1 plus a later "changed since" download with one new device, one new version and one device now discarded. Tests that the newest download decides.

Headers: 17 [ ]  Rows: expected 13, actual [ ]

All rows of TC-1 are unchanged **except** rows 2 and 10, and there is one new row:

| # | Reference number | UDI-DI / EUDAMED ID | Legislation | State | Version | Last updated | Response file | Pass? |
|---|---|---|---|---|---|---|---|---|
| 2 | TST-LEG-02 | 09521053390029 | MDD | **DISCARDED** | 1 | **26.11.2026 11:10:00** | **RESP_delta_discarded_page_0.xml** | [ ] |
| 10 | PGT-TSB-06-B2 | 09521053364297 | MDR | REGISTERED | **2** | **26.11.2026 11:05:00** | **RESP_delta_registered_page_0.xml** | [ ] |
| 13 | TST-MDR-N1 | 09521053390043 | MDR | REGISTERED | 1 | 26.11.2026 11:00:00 | RESP_delta_registered_page_0.xml | [ ] |
| others | rows 1, 3–9, 11, 12 as in TC-1 | | | | | | | [ ] |

### TC-3 Missing page (`advanced\test-data\TC-3 Missing page`)

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "Missing: page 1 of the 2 pages" and "RESP_full_registered_page_0.xml". No new table is loaded. | [ ] | [ ] |

### TC-4 Rejection in folder (`advanced\test-data\TC-4 Rejection in folder`)

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "ACK_rejected_request.xml is a rejection". No new table is loaded. | [ ] | [ ] |

### TC-5 Empty folder (`advanced\test-data\TC-5 Empty folder`)

| Expected | Actual | Pass? |
|---|---|---|
| Table with the 17 column headers, no rows, no error. | [ ] | [ ] |

### TC-6 Unknown device type (`advanced\test-data\TC-6 Unknown device type`)

The files of TC-1, but one device on Registered page 0 uses element names the script does not know (as an IVDR record might). Tests that an unreadable record stops the refresh instead of becoming a blank row.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml holds 1 device record(s) this script cannot read". No new table is loaded. | [ ] | [ ] |

### TC-7 No page count (`advanced\test-data\TC-7 No page count`)

Registered page 0 without `numberOfPages`, and page 1 not saved. Tests that a missing page count stops the refresh instead of hiding the missing page.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml has no readable numberOfPages". No new table is loaded. | [ ] | [ ] |

### TC-8 No creation date (`advanced\test-data\TC-8 No creation date`)

The files of TC-1, but Registered page 0 has an empty `creationDateTime`. Tests that a response without a date stops the refresh.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml has no readable creationDateTime". No new table is loaded. | [ ] | [ ] |

### TC-9 Lock file in folder (`advanced\test-data\TC-9 Lock file in folder`)

The files of TC-1 plus a lock file (`~$RESP_full_registered_page_0.xml`) such as Excel leaves while a file is open. Tests that lock files are skipped.

| Expected | Actual | Pass? |
|---|---|---|
| The same 12 rows as TC-1, no error. | [ ] | [ ] |

### TC-11 Page number out of range (`advanced\test-data\TC-11 Page number out of range`)

The files of TC-1, but the second Registered page says it is page 2 of 2 (pages are numbered 0 and 1).

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_1.xml is page 2, but the download has only 2 page(s)". No new table is loaded. | [ ] | [ ] |

### TC-12 Unknown record in payload (`advanced\test-data\TC-12 Unknown record in payload`)

The files of TC-1, but Registered page 0 also holds an element that is not a device record.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml holds 1 device record(s) this script cannot read". No new table is loaded. | [ ] | [ ] |

### TC-13 No Basic UDI-DI (`advanced\test-data\TC-13 No Basic UDI-DI`)

The files of TC-1, but one device on Registered page 0 has an empty Basic UDI-DI.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml holds 1 device record(s) this script cannot read". No new table is loaded. | [ ] | [ ] |

### TC-14 Same requests sent twice (`advanced\test-data\TC-14 Same requests sent twice`)

The files of TC-1, plus page 0 of a second download made a day later with the same request files; its page 1 is missing.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "two different responses for the same page of one download: page 0 in RESP_again_registered_page_0.xml and RESP_full_registered_page_0.xml". No new table is loaded. | [ ] | [ ] |

### TC-15 No Discarded records (`advanced\test-data\TC-15 No Discarded records`)

The Registered files of TC-1, plus a Discarded response with `numberOfPages` 0, no records and the result SUCCESS.

| Expected | Actual | Pass? |
|---|---|---|
| 11 rows: rows 1 to 11 of TC-1 (TST-MDR-D1 is not in the list), no error. | [ ] | [ ] |

### TC-16 Misnamed response file (`advanced\test-data\TC-16 Misnamed response file`)

The files of TC-1, but Registered page 1 is saved as `RESP_full_registered_page_1.xml.txt`.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_1.xml.txt has .xml in its name but does not end in .xml". No new table is loaded. | [ ] | [ ] |

### TC-17 Conflicting page counts (`advanced\test-data\TC-17 Conflicting page counts`)

The files of TC-1, but Registered page 0 says `numberOfPages` 1 while page 1 says 2.

| Expected | Actual | Pass? |
|---|---|---|
| Refresh stops. Message contains "RESP_full_registered_page_0.xml says numberOfPages 1" and "RESP_full_registered_page_1.xml says numberOfPages 2". No new table is loaded. | [ ] | [ ] |

### TC-18 Both states empty (`advanced\test-data\TC-18 Both states empty`)

A Registered and a Discarded response, each with `numberOfPages` 0, `pageNumber` 0, no records and the result SUCCESS.

| Expected | Actual | Pass? |
|---|---|---|
| Table with the 17 column headers, no rows, no error. | [ ] | [ ] |

### TC-10 First live check (required before the list is used as a record)

After your first real full download:

1. Note the number of rows per State in the list. In EUDAMED, open your own device list, filter it by state, and note the number of Registered and of Discarded devices.
2. If the list has fewer than 10 rows, check all of them. Otherwise take at least 10 rows, including every Discarded row (or at least 5 of them, if there are many) and at least 2 MDR and 2 legacy devices where you have them. Search each UDI-DI in EUDAMED and compare state, version and last update date.

If TC-10 cannot be done yet, mark it "open" in section 5 and do not release the tool. Also note how long Refresh All takes with your real folder: [ ]

| | List | EUDAMED | Agrees? |
|---|---|---|---|
| Registered devices | [ ] | [ ] | [ ] |
| Discarded devices | [ ] | [ ] | [ ] |

| UDI-DI | State in list | Version in list | State, version and last update in EUDAMED | Agrees? |
|---|---|---|---|---|
| [ ] | [ ] | [ ] | [ ] | [ ] |

## 5. Result

| | |
|---|---|
| Date of test | [ ] |
| Tested by | [ ] |
| TC-1 to TC-9 and TC-11 to TC-18 (test data) | [pass / fail] |
| TC-10 (first live check) | [pass / fail / open] |
| Deviations and how they were resolved | [none / describe] |
| Conclusion | [released for the intended use / not released] |

## 6. Change control

Repeat TC-1 to TC-9 and TC-11 to TC-18 and update this record when:

- the script changes (any change other than the folder path),
- Excel is moved to a new computer or receives a major update,
- EUDAMED changes its schema version, or a download response looks different from before,
- the intended use changes.

| Version | Date | Change | Re-tested by |
|---|---|---|---|
| 3.3 | [ ] | First release | [ ] |

## 7. Sign-off

| Role | Name | Date | Signature |
|---|---|---|---|
| Tested by | [ ] | [ ] | [ ] |
| Reviewed by | [ ] | [ ] | [ ] |
| Approved by | [ ] | [ ] | [ ] |
