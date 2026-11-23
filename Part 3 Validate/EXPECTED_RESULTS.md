# Expected results for the test cases

The 17 folders TC-1 to TC-9 and TC-11 to TC-18 in `Part 3 Validate\Test cases` hold made-up EUDAMED answers. (TC-10 is the first live check against EUDAMED; it is in the validation record, not here.) All devices, numbers and names in them are invented. Use them to check that the Excel script works on your computer before you use it with your own answers.

**File names in the test cases.** The answer files keep their original technical names, for example `RESP_full_registered_page_0.xml`. In these names the file number is counted from 0: "page 0" is file 1, "page 1" is file 2. The descriptions below count from 1, as the messages in Excel do.

**How to run a test.** Open a new, empty workbook and set up Excel as in the Part 2 README, with the Excel script `Part 2 Excel\EUDAMED device list.pq`, but set `ResponseFolder` to the test case folder. Click **Done**, then **Home → Close & Load**. Close the workbook without saving. Use a new workbook for each test, so that an older table cannot be mistaken for the result.

**When a test passes.**

- *Where a list is expected:* the table has the 17 column headers below and exactly the expected number of rows; for every row, State, Version, Last updated and Response file are exactly as expected (set the date columns to the format `dd.mm.yyyy hh:mm:ss`); the column Other states is empty in every row; UDI-DIs keep their leading zero.
- *Where an error is expected:* the refresh stops, the message contains the expected text, and no new table is loaded. (In a workbook that already holds a table, the old table can stay on the sheet after a failed refresh.)

The 17 column headers, in this order:

Reference number · UDI-DI / EUDAMED ID · Basic UDI-DI / EUDAMED DI · Legislation · Risk class · Trade name · State · Other states · Market status · Version · Version date · Last updated · Basic state · Basic version · Basic last updated · Downloaded on · Response file

## TC-1 Full download (`Part 3 Validate\Test cases\TC-1 Full download`)

Two Registered answers (file 1 and file 2 of one download) and one Discarded answer. Tests reading MDR and legacy devices, both states, and a download with more than one file.

Expected: 17 headers, 12 rows.

| # | Reference number | UDI-DI / EUDAMED ID | Legislation | State | Version | Last updated | Response file |
|---|---|---|---|---|---|---|---|
| 1 | TST-LEG-01 | 09521053390012 | MDD | REGISTERED | 1 | 12.11.2026 09:10:00 | RESP_full_registered_page_1.xml |
| 2 | TST-LEG-02 | 09521053390029 | MDD | REGISTERED | 1 | 12.11.2026 09:11:00 | RESP_full_registered_page_1.xml |
| 3 | PGT-TSA-01-A1 | 09521053366123 | MDR | REGISTERED | 1 | 09.11.2026 09:02:00 | RESP_full_registered_page_0.xml |
| 4 | PGT-TSA-01-B1 | 09521053366024 | MDR | REGISTERED | 1 | 09.11.2026 09:06:00 | RESP_full_registered_page_0.xml |
| 5 | PGT-TSB-02-A1 | 09521053367472 | MDR | REGISTERED | 1 | 09.11.2026 09:28:00 | RESP_full_registered_page_1.xml |
| 6 | PGT-TSB-02-B1 | 09521053366345 | MDR | REGISTERED | 1 | 09.11.2026 09:11:00 | RESP_full_registered_page_1.xml |
| 7 | PGT-TSB-02-C1 | 09521053369681 | MDR | REGISTERED | 1 | 09.11.2026 09:16:00 | RESP_full_registered_page_1.xml |
| 8 | PGT-TSB-03-B1 | 09521053365508 | MDR | REGISTERED | 1 | 09.11.2026 09:20:00 | RESP_full_registered_page_0.xml |
| 9 | PGT-TSB-03-C1 | 09521053361173 | MDR | REGISTERED | 1 | 09.11.2026 09:24:00 | RESP_full_registered_page_0.xml |
| 10 | PGT-TSB-06-B2 | 09521053364297 | MDR | REGISTERED | 1 | 09.11.2026 09:31:00 | RESP_full_registered_page_0.xml |
| 11 | PGT-TSB-07-B3 | 09521053363108 | MDR | REGISTERED | 1 | 09.11.2026 09:34:00 | RESP_full_registered_page_0.xml |
| 12 | TST-MDR-D1 | 09521053390036 | MDR | DISCARDED | 1 | 13.11.2026 14:00:00 | RESP_full_discarded_page_0.xml |

## TC-2 Full download plus delta (`Part 3 Validate\Test cases\TC-2 Full download plus delta`)

The files of TC-1 plus a later "changed since" download with one new device, one new version and one device now discarded. Tests that the newest download decides.

Expected: 17 headers, 13 rows. All rows of TC-1 are unchanged **except** rows 2 and 10, and there is one new row 13:

| # | Reference number | UDI-DI / EUDAMED ID | Legislation | State | Version | Last updated | Response file |
|---|---|---|---|---|---|---|---|
| 2 | TST-LEG-02 | 09521053390029 | MDD | **DISCARDED** | 1 | **26.11.2026 11:10:00** | **RESP_delta_discarded_page_0.xml** |
| 10 | PGT-TSB-06-B2 | 09521053364297 | MDR | REGISTERED | **2** | **26.11.2026 11:05:00** | **RESP_delta_registered_page_0.xml** |
| 13 | TST-MDR-N1 | 09521053390043 | MDR | REGISTERED | 1 | 26.11.2026 11:00:00 | RESP_delta_registered_page_0.xml |
| others | rows 1, 3–9, 11, 12 as in TC-1 | | | | | | |

## TC-3 Missing page (`Part 3 Validate\Test cases\TC-3 Missing page`)

Only file 1 of a two-file Registered download is in the folder.

Expected: the refresh stops. The message contains "a file is missing, so the list would be incomplete" and "File 2 of 2 is missing from the download that includes RESP_full_registered_page_0.xml". No new table is loaded.

## TC-4 Rejection in folder (`Part 3 Validate\Test cases\TC-4 Rejection in folder`)

A complete download plus one refusal from EUDAMED (an acknowledgement with an error code).

Expected: the refresh stops. The message contains "ACK_rejected_request.xml is a refusal from EUDAMED". No new table is loaded.

## TC-5 Empty folder (`Part 3 Validate\Test cases\TC-5 Empty folder`)

No answers (the folder holds only a README.txt, which the Excel script ignores).

Expected: a table with the 17 column headers, no rows, no error.

## TC-6 Unknown device type (`Part 3 Validate\Test cases\TC-6 Unknown device type`)

The files of TC-1, but one device in Registered file 1 uses element names the script does not know (as an IVDR record might). Tests that an unreadable record stops the refresh instead of becoming a blank row.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml holds 1 device record(s) that this Excel script cannot read". No new table is loaded.

## TC-7 No page count (`Part 3 Validate\Test cases\TC-7 No page count`)

Registered file 1 without the number of files in the download (`numberOfPages`), and file 2 not saved. Tests that a missing file count stops the refresh instead of hiding the missing file.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml is missing information that the check for missing files needs: how many files the download has (numberOfPages)". No new table is loaded.

## TC-8 No creation date (`Part 3 Validate\Test cases\TC-8 No creation date`)

The files of TC-1, but Registered file 1 has an empty creation date (`creationDateTime`). Tests that an answer without a date stops the refresh.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml is missing information that the check for missing files needs: the creation date (creationDateTime)". No new table is loaded.

## TC-9 Lock file in folder (`Part 3 Validate\Test cases\TC-9 Lock file in folder`)

The files of TC-1 plus a lock file (`~$RESP_full_registered_page_0.xml`) such as Excel leaves while a file is open. Tests that lock files are skipped.

Expected: the same 12 rows as TC-1, no error.

## TC-11 Page number out of range (`Part 3 Validate\Test cases\TC-11 Page number out of range`)

The files of TC-1, but Registered file 2 says it is file 3 of a download with 2 files. Tests that an impossible file number stops the refresh.

Expected: the refresh stops. The message contains "RESP_full_registered_page_1.xml says it is file 3, but the number of files in its download is 2". No new table is loaded.

## TC-12 Unknown record in payload (`Part 3 Validate\Test cases\TC-12 Unknown record in payload`)

The files of TC-1, but Registered file 1 also holds an element that is not a device record. Tests that an unknown answer shape stops the refresh instead of being skipped.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml holds 1 device record(s) that this Excel script cannot read". No new table is loaded.

## TC-13 No Basic UDI-DI (`Part 3 Validate\Test cases\TC-13 No Basic UDI-DI`)

The files of TC-1, but one device in Registered file 1 has an empty Basic UDI-DI. Tests that a record without the identifiers the list needs stops the refresh.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml holds 1 device record(s) that this Excel script cannot read". No new table is loaded.

## TC-14 Same requests sent twice (`Part 3 Validate\Test cases\TC-14 Same requests sent twice`)

The files of TC-1, plus file 1 of a second download made one day later with the same request files. File 2 of the second download was not saved. Tests that Excel detects two copies of file 1 from two runs. It does not show that other mixes of two runs are caught (see "What the tests show, and what they do not" in [README.md](README.md#what-the-tests-show-and-what-they-do-not)).

Expected: the refresh stops. The message contains "two different answers for the same file of one download: file 1 in RESP_again_registered_page_0.xml and RESP_full_registered_page_0.xml". No new table is loaded.

## TC-15 No Discarded records (`Part 3 Validate\Test cases\TC-15 No Discarded records`)

The Registered files of TC-1, plus a Discarded answer that reports 0 files (`numberOfPages` 0), no records and the result SUCCESS. Tests that a state with no records is accepted.

Expected: 17 headers, 11 rows: rows 1 to 11 of TC-1, without TST-MDR-D1. No error.

## TC-16 Misnamed response file (`Part 3 Validate\Test cases\TC-16 Misnamed response file`)

The files of TC-1, but Registered file 2 is saved as `RESP_full_registered_page_1.xml.txt` (as happens when Windows hides file name extensions). Tests that an answer with a wrong file name stops the refresh instead of being skipped.

Expected: the refresh stops. The message contains "RESP_full_registered_page_1.xml.txt does not end in .xml, so Excel cannot read it". No new table is loaded.

## TC-17 Conflicting page counts (`Part 3 Validate\Test cases\TC-17 Conflicting page counts`)

The files of TC-1, but Registered file 1 says the download has 1 file (`numberOfPages` 1), while file 2 says it has 2. Tests that answers of one download that disagree on the number of files stop the refresh.

Expected: the refresh stops. The message contains "RESP_full_registered_page_0.xml says the number of files is 1" and "RESP_full_registered_page_1.xml says the number of files is 2". No new table is loaded.

## TC-18 Both states empty (`Part 3 Validate\Test cases\TC-18 Both states empty`)

A Registered and a Discarded answer, each reporting 0 files (`numberOfPages` 0), file 1 (`pageNumber` 0), no records and the result SUCCESS. Tests that a download without any devices is accepted.

Expected: a table with the 17 column headers, no rows, no error.

## Author's extra tests (not in the package)

The author also runs extra tests that are not in the `Test cases` folder. Two of them cover "Only what changed since a date" ([Part 1, If needed](../Part%201%20Download/If%20needed/Changed%20since/HOW_TO.md)). Both are built from the made-up files of TC-1, TC-2 and TC-18. Two more, X10 and X11, cover the starter ZIP, which holds only file 1 of each state. They are built from the made-up answers of TC-1 and TC-2, saved under the names the starter uses (`Registered answer 01.xml`, `Discarded answer 01.xml`).

**X8 Reused changed-since IDs.** The files of TC-1, plus two changed-since Registered answers with the same download ID, created one day apart: as if the same changed-since request files were sent twice within three days. The earlier answer says 0 devices (`numberOfPages` 0); the later one says 1 file and holds devices. Tests that the two runs are not silently combined.

The result to see: the refresh stops. The message contains "the answers of one download do not agree on how many files it has: RESP_delta_registered_earlier_page_0.xml says the number of files is 0, RESP_delta_registered_page_0.xml says the number of files is 1". No new table is loaded.

**X9 Changed since within 12 hours.** The files of TC-1, plus the changed-since answers of TC-2, but with the start date on the day of the full download, and created 6 hours after the full download. The records in the changed-since answers are dated on that start date. Tests the inclusive start date together with the 12-hour rule.

The result to see: 17 headers, 14 rows, no error. TST-LEG-02 has two rows: REGISTERED from `RESP_full_registered_page_1.xml`, with DISCARDED in Other states, and DISCARDED from `RESP_delta_discarded_page_0.xml`, with REGISTERED in Other states. PGT-TSB-06-B2 shows version 2 from `RESP_delta_registered_page_0.xml`, and TST-MDR-N1 comes from that answer too. All other rows are as in TC-1, with Other states empty.

**X10 Only file 1 of each state.** Only file 1 of the Registered answers of TC-1 and its Discarded answer. The Registered answer says 2 files (`numberOfPages` 2), so file 2 is missing: as for a starter user with more than 300 devices in a state.

The result to see: the refresh stops. The message contains "a file is missing, so the list would be incomplete" and "File 2 of 2 is missing from the download that includes Registered answer 01.xml". No new table is loaded.

**X11 Small set, file 1 only.** Only the two changed-since answers of TC-2, on their own. Each says 1 file (`numberOfPages` 1), so file 1 is the whole download: as for a starter user with at most 300 devices in each state.

The result to see: 17 headers, 3 rows, no error: one row per device in the two answers. TST-MDR-N1 and PGT-TSB-06-B2 are REGISTERED from `Registered answer 01.xml`; TST-LEG-02 is DISCARDED from `Discarded answer 01.xml`. Other states is empty.
