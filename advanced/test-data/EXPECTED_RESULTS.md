# Expected results for the test data

The 17 folders TC-1 to TC-9 and TC-11 to TC-18 hold made-up EUDAMED response files. (TC-10 is the first live check against EUDAMED; it is in the validation record, not here.) All devices, numbers and names in them are invented. Use them to check that the Excel query works on your computer before you use it with your own downloads.

**How to run a test.** Open a new, empty workbook and set up the query as in step 8 of the README, but set `ResponseFolder` to the test folder. Click **Done**, then **Home → Close & Load**. Close the workbook without saving. Use a new workbook for each test, so that an older table cannot be mistaken for the result.

**When a test passes.**

- *Where a list is expected:* the table has the 17 column headers below and exactly the expected number of rows; for every row, State, Version, Last updated and Response file are exactly as expected (set the date columns to the format `dd.mm.yyyy hh:mm:ss`); the column Other states is empty in every row; UDI-DIs keep their leading zero.
- *Where an error is expected:* the refresh stops, the message contains the expected text, and no new table is loaded. (In a workbook that already holds a table, the old table can stay on the sheet after a failed refresh.)

The 17 column headers, in this order:

Reference number · UDI-DI / EUDAMED ID · Basic UDI-DI / EUDAMED DI · Legislation · Risk class · Trade name · State · Other states · Market status · Version · Version date · Last updated · Basic state · Basic version · Basic last updated · Downloaded on · Response file

## TC-1 Full download (`advanced\test-data\TC-1 Full download`)

Two pages of Registered devices and one Discarded response. Tests reading MDR and legacy devices, both states, and paging.

Expected: 17 headers, 12 rows.

| # | Reference number | UDI-DI / EUDAMED ID | Legislation | State | Version | Last updated | Response file |
|---|---|---|---|---|---|---|---|
| 1 | TST-LEG-01 | 09521053390012 | MDD | REGISTERED | 1 | 12.11.2026 09:10:00 | RESP_full_registered_page_1.xml |
| 2 | TST-LEG-02 | 09521053390029 | MDD | REGISTERED | 1 | 12.11.2026 09:11:00 | RESP_full_registered_page_1.xml |
| 3 | PGT-TSA-01-A1 | 09521053366123 | MDR | REGISTERED | 1 | 10.11.2026 15:14:12 | RESP_full_registered_page_0.xml |
| 4 | PGT-TSA-01-B1 | 09521053366024 | MDR | REGISTERED | 1 | 10.11.2026 15:14:13 | RESP_full_registered_page_0.xml |
| 5 | PGT-TSB-02-A1 | 09521053367472 | MDR | REGISTERED | 1 | 10.11.2026 15:27:04 | RESP_full_registered_page_1.xml |
| 6 | PGT-TSB-02-B1 | 09521053366345 | MDR | REGISTERED | 1 | 10.11.2026 15:23:23 | RESP_full_registered_page_1.xml |
| 7 | PGT-TSB-02-C1 | 09521053369681 | MDR | REGISTERED | 1 | 10.11.2026 15:23:24 | RESP_full_registered_page_1.xml |
| 8 | PGT-TSB-03-B1 | 09521053365508 | MDR | REGISTERED | 1 | 10.11.2026 15:25:04 | RESP_full_registered_page_0.xml |
| 9 | PGT-TSB-03-C1 | 09521053361173 | MDR | REGISTERED | 1 | 10.11.2026 15:25:04 | RESP_full_registered_page_0.xml |
| 10 | PGT-TSB-06-B2 | 09521053364297 | MDR | REGISTERED | 1 | 10.11.2026 15:33:27 | RESP_full_registered_page_0.xml |
| 11 | PGT-TSB-07-B3 | 09521053363108 | MDR | REGISTERED | 1 | 10.11.2026 15:34:28 | RESP_full_registered_page_0.xml |
| 12 | TST-MDR-D1 | 09521053390036 | MDR | DISCARDED | 1 | 13.11.2026 14:00:00 | RESP_full_discarded_page_0.xml |

## TC-2 Full download plus delta (`advanced\test-data\TC-2 Full download plus delta`)

The files of TC-1 plus a later "changed since" download with one new device, one new version and one device now discarded. Tests that the newest download decides.

Expected: 17 headers, 13 rows. All rows of TC-1 are unchanged **except** rows 2 and 10, and there is one new row 13:

| # | Reference number | UDI-DI / EUDAMED ID | Legislation | State | Version | Last updated | Response file |
|---|---|---|---|---|---|---|---|
| 2 | TST-LEG-02 | 09521053390029 | MDD | **DISCARDED** | 1 | **26.11.2026 11:10:00** | **RESP_delta_discarded_page_0.xml** |
| 10 | PGT-TSB-06-B2 | 09521053364297 | MDR | REGISTERED | **2** | **26.11.2026 11:05:00** | **RESP_delta_registered_page_0.xml** |
| 13 | TST-MDR-N1 | 09521053390043 | MDR | REGISTERED | 1 | 26.11.2026 11:00:00 | RESP_delta_registered_page_0.xml |
| others | rows 1, 3–9, 11, 12 as in TC-1 | | | | | | |

## TC-3 Missing page (`advanced\test-data\TC-3 Missing page`)

Only page 0 of a two-page Registered download is in the folder.

Expected: the refresh stops. The message contains "Missing: page 1 of the 2 pages" and "RESP_full_registered_page_0.xml". No new table is loaded.

## TC-4 Rejection in folder (`advanced\test-data\TC-4 Rejection in folder`)

A complete download plus one rejection (acknowledgement) file.

Expected: the refresh stops. The message contains "ACK_rejected_request.xml is a rejection". No new table is loaded.

## TC-5 Empty folder (`advanced\test-data\TC-5 Empty folder`)

No response files (the folder holds only a README.txt, which the query ignores).

Expected: a table with the 17 column headers, no rows, no error.

## TC-6 Unknown device type (`advanced\test-data\TC-6 Unknown device type`)

The files of TC-1, but one device on Registered page 0 uses element names the script does not know (as an IVDR record might). Tests that an unreadable record stops the refresh instead of becoming a blank row.

Expected: Refresh stops. Message contains "RESP_full_registered_page_0.xml holds 1 device record(s) this script cannot read". No new table is loaded.

## TC-7 No page count (`advanced\test-data\TC-7 No page count`)

Registered page 0 without `numberOfPages`, and page 1 not saved. Tests that a missing page count stops the refresh instead of hiding the missing page.

Expected: Refresh stops. Message contains "RESP_full_registered_page_0.xml has no readable numberOfPages". No new table is loaded.

## TC-8 No creation date (`advanced\test-data\TC-8 No creation date`)

The files of TC-1, but Registered page 0 has an empty `creationDateTime`. Tests that a response without a date stops the refresh.

Expected: Refresh stops. Message contains "RESP_full_registered_page_0.xml has no readable creationDateTime". No new table is loaded.

## TC-9 Lock file in folder (`advanced\test-data\TC-9 Lock file in folder`)

The files of TC-1 plus a lock file (`~$RESP_full_registered_page_0.xml`) such as Excel leaves while a file is open. Tests that lock files are skipped.

Expected: The same 12 rows as TC-1, no error.

## TC-11 Page number out of range (`advanced\test-data\TC-11 Page number out of range`)

The files of TC-1, but the second Registered page says it is page 2 of a download with 2 pages (pages are numbered 0 and 1). Tests that an impossible page number stops the refresh.

Expected: the refresh stops. The message contains "RESP_full_registered_page_1.xml is page 2, but the download has only 2 page(s)". No new table is loaded.

## TC-12 Unknown record in payload (`advanced\test-data\TC-12 Unknown record in payload`)

The files of TC-1, but Registered page 0 also holds an element that is not a device record. Tests that an unknown response shape stops the refresh instead of being skipped.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml holds 1 device record(s) this script cannot read". No new table is loaded.

## TC-13 No Basic UDI-DI (`advanced\test-data\TC-13 No Basic UDI-DI`)

The files of TC-1, but one device on Registered page 0 has an empty Basic UDI-DI. Tests that a record without the identifiers the list needs stops the refresh.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml holds 1 device record(s) this script cannot read". No new table is loaded.

## TC-14 Same requests sent twice (`advanced\test-data\TC-14 Same requests sent twice`)

The files of TC-1, plus page 0 of a second download made one day later with the same request files. Page 1 of the second download was not saved. Tests that a page of the older download cannot hide the missing page of the newer one.

Expected: the refresh stops. The message contains "two different responses for the same page of one download: page 0 in RESP_again_registered_page_0.xml and RESP_full_registered_page_0.xml". No new table is loaded.

## TC-15 No Discarded records (`advanced\test-data\TC-15 No Discarded records`)

The Registered files of TC-1, plus a Discarded response that reports `numberOfPages` 0, no records and the result SUCCESS. Tests that a state with no records is accepted.

Expected: 17 headers, 11 rows: rows 1 to 11 of TC-1, without TST-MDR-D1. No error.

## TC-16 Misnamed response file (`advanced\test-data\TC-16 Misnamed response file`)

The files of TC-1, but Registered page 1 is saved as `RESP_full_registered_page_1.xml.txt` (as happens when Windows hides file name extensions). Tests that a response with a wrong file name stops the refresh instead of being skipped.

Expected: the refresh stops. The message contains "RESP_full_registered_page_1.xml.txt has .xml in its name but does not end in .xml". No new table is loaded.

## TC-17 Conflicting page counts (`advanced\test-data\TC-17 Conflicting page counts`)

The files of TC-1, but Registered page 0 says the download has 1 page (`numberOfPages` 1), while page 1 says it has 2. Tests that pages of one download that disagree on the page count stop the refresh.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml says numberOfPages 1" and "RESP_full_registered_page_1.xml says numberOfPages 2". No new table is loaded.

## TC-18 Both states empty (`advanced\test-data\TC-18 Both states empty`)

A Registered and a Discarded response, each with `numberOfPages` 0, `pageNumber` 0, no records and the result SUCCESS. Tests that a download without any devices is accepted.

Expected: a table with the 17 column headers, no rows, no error.
