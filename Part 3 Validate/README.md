For EUDAMED device list v2.0.

# Part 3: Troubleshoot and validate

How do you troubleshoot the workflow and validate it for your quality system?

This part has two entries:

- **[Troubleshoot](#troubleshoot)**: Excel stopped with a message, EUDAMED refused a request, or the list looks wrong.
- **[Validate for your QMS](#validate-for-your-qms)**: test the Excel script on your own computer and document the result.

## Troubleshoot

### Excel cannot find the folder

Excel's own message: "We couldn't find the folder …" (marked DataSource.NotFound). The path in `ResponseFolder` is wrong. Copy it again from the File Explorer address bar, put it between the quotation marks (step 7 of [Part 2](../Part%202%20Excel/README.md)), then click **Done** and **Close & Load**.

### The messages of the Excel script

Excel shows these messages with `[Expression.Error]` in front; that tag is normal. Each message starts with "EUDAMED device list:" and names the file. Here "…" stands for the file name. After you have done what the message says, click **Data → Refresh All**. Then do the "Before you go on" check of [Part 1](../Part%201%20Download/README.md#before-you-go-on) and the checks of step 8 in [Part 2](../Part%202%20Excel/README.md) again before you rely on the list.

A file you move out must be replaced by a correct answer: one that says `PullResponse` near the top and `SUCCESS` as its result. Otherwise the list is short, and the refresh may still finish without an error, for example when the file you moved out was the only answer of a state.

One recovery rule for all messages: get an original answer again from Upload Management, by its upload's file name and time. Move unfinished files (`.crdownload`, `.part`) out of the answers folder. If an upload must be sent again, or you are unsure which run an answer belongs to, [start the download again](../Part%201%20Download/README.md#start-the-download-again): move all answers of the folder into a new dated subfolder, and send the request files of both states again, on the same day. A receipt (an acknowledgement that says `SUCCESS`) is not a refusal: it only needs the answer for that upload.

| # | The message starts with | What it means | What to do |
|---|---|---|---|
| 1 | "… does not end in .xml, so Excel cannot read it" | An answer was saved with another ending, often `.xml.txt`. | If the name ends in `.crdownload` or `.part`, the download did not finish: move it out of the answers folder and download the same answer again from Upload Management (find the upload by its file name and time). Otherwise rename it so that the name ends in `.xml`. To see the full names: File Explorer, **View → Show → File name extensions**. |
| 2 | "… do not end in .xml, so Excel cannot read them" | The same, for several files. | As for message 1, for each file. |
| 3 | "… is a refusal from EUDAMED (acknowledgement), not an answer with devices" | EUDAMED did not accept that request. A refusal is in the answers folder. | Open the file in Notepad to read why, and move it out of the answers folder. Fix the cause, then [start the download again](../Part%201%20Download/README.md#start-the-download-again). If the refusal names a version, see [EUDAMED refused a request](#eudamed-refused-a-request). |
| 4 | "… is only a receipt from EUDAMED (acknowledgement), not an answer with devices" | The file holds no devices. It is not a device answer: it is usually the result of a different upload, such as a registration. | Move the receipt out of the answers folder. In Upload Management, find your download by its file name and time and save its `PullResponse`. Check it (`PullResponse` and `SUCCESS`). If there is none, start the download again with both states ([Start the download again](../Part%201%20Download/README.md#start-the-download-again)). |
| 5 | "… is an answer with the result … instead of SUCCESS" | EUDAMED answered, but not with SUCCESS. The answer cannot be used. | Move it out of the answers folder, then [start the download again](../Part%201%20Download/README.md#start-the-download-again). |
| 6 | "… is not an answer to an EUDAMED device download" | The file is something else, for example a request file or another XML file. | Move it out of the answers folder only when you are sure it is not an answer of this download, for example a request file. Keep only answers there. If it was meant to be an answer, download the same answer again from Upload Management (find the upload by its file name and time) and check it (`PullResponse` and `SUCCESS`). If you are unsure, [start the download again](../Part%201%20Download/README.md#start-the-download-again). |
| 7 | "… is missing information that the check for missing files needs" | The answer lacks its date, its download ID, its file number or how many files the download has. Excel cannot check that the download is complete. | Download that answer again from Upload Management (find the upload by its file name and time), check it (`PullResponse` and `SUCCESS`) and replace the file in the answers folder. If you cannot find that upload, [start the download again](../Part%201%20Download/README.md#start-the-download-again). |
| 8 | "… has a file number or a number of files that is not a whole number of 0 or more" | The file number or the number of files in the answer is impossible. | As for message 7: download that answer again from Upload Management (find the upload by its file name and time), check it and replace the file. If you cannot find that upload, start the download again. |
| 9 | "… says its download has no devices (numberOfPages 0), but it also says it is file …" | The answer says 0 devices, but also says it is a later file or it holds devices. | As for message 7: download that answer again from Upload Management (find the upload by its file name and time), check it and replace the file. If you cannot find that upload, start the download again. |
| 10 | "… says it is file …, but the number of files in its download is …" | The file number is higher than the number of files in the download. | As for message 7: download that answer again from Upload Management (find the upload by its file name and time), check it and replace the file. If you cannot find that upload, start the download again. |
| 11 | "… holds … device record(s) that this Excel script cannot read" | A record is not an MDR or legacy MDD record with a UDI-DI, Basic UDI-DI, legislation and state: for example a record shape the script does not know, such as the one TC-6 tests (IVDR records were not tested). The list would be wrong, so the refresh stops. | Keep the file for investigation. Do not use the list until the script can read that kind of record. |
| 12 | "this folder holds two different answers for the same file of one download" | The same request files were sent again within a few days, and the answers of both downloads are in the folder. | The folder holds answers from two runs. [Start the download again](../Part%201%20Download/README.md#start-the-download-again): move all answers of the folder into a new dated subfolder, and send the request files of both states again, on the same day. |
| 13 | "the answers of one download do not agree on how many files it has" | The answers do not form one complete download. | [Start the download again](../Part%201%20Download/README.md#start-the-download-again). |
| 14 | "a file is missing, so the list would be incomplete" | The message names the file and how many files the download has, for example "File 2 of 2". | If you can still send it today, on the same day as the other files of this download, send that file in EUDAMED ([Part 1](../Part%201%20Download/README.md), step 5) and save its answer in the answers folder. Otherwise [start the download again](../Part%201%20Download/README.md#start-the-download-again). If more than one file is listed, do this for each. |

### EUDAMED refused a request

A refusal says `Acknowledgement` near the top, not `PullResponse`, and its `responseCode` is not `SUCCESS` (an acknowledgement that says `SUCCESS` is only a receipt, usually from a different upload: find your download in Upload Management by its file name and time and save its `PullResponse`). Keep a refusal out of the answers folder. Open it in Notepad and read why. Once the cause is fixed, [start the download again](../Part%201%20Download/README.md#start-the-download-again); then do the "Before you go on" check of Part 1 and the checks of step 8 in Part 2 again.

- **The refusal says the version is wrong and names the version it expects:** EUDAMED has moved to a new version. See [Part 1, If needed](../Part%201%20Download/If%20needed/README.md), "EUDAMED refuses because of the version".
- **Another reason:** if the refusal does not tell you what to change, ask your EUDAMED administrator or the EUDAMED service desk.

### The same device shows twice, or Other states is filled

Check that record in EUDAMED. Why it happens: [TECHNICAL_NOTES.md](TECHNICAL_NOTES.md#same-device-in-several-downloads), "Same device in several downloads".

### The list looks short, but there is no error

Excel checks only the files in the folder. It cannot know about an answer you never saved. Do the "Before you go on" check of [Part 1](../Part%201%20Download/README.md#before-you-go-on) and the six checks of step 8 in [Part 2](../Part%202%20Excel/README.md). Also check that `ResponseFolder` names the right folder ([Which folder Excel must point at](../Part%202%20Excel/README.md#which-folder-excel-must-point-at)).

## Validate for your QMS

### Why validate

Before you rely on the list in your quality processes, assess and document its suitability for your intended use under your organisation's procedures. Your procedures decide how much testing is needed.

The tests here are made-up answers. All devices in them are made up. Each test folder holds the answers for one situation. You point the Excel script at the folder and check that it does the right thing on your own computer: either the expected list, or a stop with the expected message. The core group takes about 30 minutes (estimate).

### What the 17 tests mean

| Test | Situation | What Excel must do |
|---|---|---|
| TC-1 Full download | 2 Registered answers and 1 Discarded answer, MDR and legacy devices | show the full list: 12 rows |
| TC-2 Full download plus delta | TC-1 plus a later changed-since download: one new device, one new version, one device now discarded | let the newest answer decide: 13 rows |
| TC-3 Missing page | Registered file 2 of 2 was not saved | stop, not show a short list |
| TC-4 Rejection in folder | a refusal from EUDAMED is in the folder | stop and name the refusal |
| TC-5 Empty folder | no answers at all | show an empty list, no error |
| TC-6 Unknown device type | one device uses element names the script does not know (IVDR records were not tested) | stop, not make a blank row |
| TC-7 No page count | the first answer does not say how many files are needed, and file 2 was not saved | stop, not hide the missing file |
| TC-8 No creation date | an answer has no creation date | stop |
| TC-9 Lock file in folder | a lock file that Excel leaves while a file is open (`~$…`) | skip it: the same 12 rows as TC-1 |
| TC-11 Page number out of range | an answer says it is file 3 of a download of 2 files | stop |
| TC-12 Unknown record in payload | an answer holds something that is not a device record | stop |
| TC-13 No Basic UDI-DI | one device has an empty Basic UDI-DI | stop |
| TC-14 Same requests sent twice | two copies of file 1 from two runs made a day apart with the same request files | stop: it detects two copies of file 1 from two runs |
| TC-15 No Discarded records | the Discarded answer says 0 devices | show the 11 Registered rows, no error |
| TC-16 Misnamed response file | an answer was saved as `.xml.txt` | stop and name the file |
| TC-17 Conflicting page counts | file 1 says the download has 1 file, file 2 says 2 | stop |
| TC-18 Both states empty | both answers say 0 devices | show an empty list, no error |

The test folders keep their technical file names. For example, `RESP_full_registered_page_0.xml` is Registered answer file 1, and `RESP_full_registered_page_1.xml` is Registered answer file 2.

### What the tests show, and what they do not

The tests show that the Excel script stops when a file of a saved download is missing or impossible, when the answers of one download disagree on how many files it has, or when two answers for the same file sit side by side (TC-3, TC-7, TC-11, TC-14, TC-17). TC-14 detects two copies of file 1 from two runs, nothing more. It does not show that other mixes of two runs are caught (see below).

The tests do not cover everything:

- **Answers from two runs, mixed.** Excel groups the files of one download by an ID that repeats when you reuse request files. So answers from two runs a day or two apart can be mixed without an error, for example file 1 from one run and file 2 from the other. The author's extra test X7 shows this limit. The rule "one full download per empty folder" of [Part 1](../Part%201%20Download/README.md), step 1, prevents it: before each full download, move all old answers into a new dated subfolder, and send all files of both states on the same day. The "Before you go on" check of Part 1 then confirms that every answer was saved from this run, also an answer with 0 devices (its creation date, `creationDateTime`).
- **A whole state that was never saved.** If the Registered or the Discarded answer is not in the folder, Excel still refreshes without an error, and the list is short. Excel cannot know about an answer you never saved. The "Before you go on" check of [Part 1](../Part%201%20Download/README.md#before-you-go-on) and the first tick of step 8 in [Part 2](../Part%202%20Excel/README.md) catch this.
- **Messages 8 and 9** of the [Troubleshoot table](#the-messages-of-the-excel-script) are not reached by any of the 17 tests.
- **Real Production answers.** The 17 tests use made-up answers. The author also ran script v3.4 on one real Production download (November 2026). Your own list is checked by the live check TC-10.
- **Sending the same request files again** was tested in the Playground only, not yet in Production.

### Evidence

Keep these apart in your validation record:

- **Request files, Production, full download:** request files with version 3.0.30 were accepted in Production for a full download (Registered and Discarded, several files), under their v1 file names (November 2026).
- **Request files, Production, changed since:** a changed-since request with version 3.0.30 was accepted in Production (November 2026).
- **Request files, Production, v2.0 file names:** request files under their v2.0 file names were accepted in Production (November 2026); each answer said SUCCESS for the expected file.
- **Sending the same request files again:** tested in the Playground only (November 2026).
- **Excel script v3.4:** tested in Excel on made-up answers (the 17 tests) and on one real Production download of the author's (November 2026): the list loaded without a message, with one row per device record in the answers.
- **Your own live evidence:** the live check TC-10, below.

### Which tests to run first

These tests are a starting point. Choose and adapt them to fit your QMS, and record what you ran and why.

Triage rule: rank by the chance that someone trusts a wrong or incomplete list.

| Group | Tests | Why |
|---|---|---|
| **Run first (core, about 30 minutes, estimate)** | TC-1 full download, TC-3 missing file, TC-4 refusal in the folder, TC-7 no file count, TC-14 same requests sent twice, TC-15 no Discarded devices, TC-16 answer saved as `.xml.txt`, TC-17 conflicting file counts | the list is right; a download with a missing file, a missing file count or conflicting file counts stops instead of giving a short list (TC-3, 7, 17); two copies of file 1 from two runs stop the refresh (TC-14); the mistakes beginners actually make are caught (TC-4, 16); the normal "no Discarded" case works (TC-15) |
| **Pair: empty results** | TC-5 empty folder, TC-18 both states empty | both give an empty list without an error; run them together so you see why the guide's check (both answers saved, both say 0) is what tells them apart |
| **Run if you use that feature** | TC-2 (changed-since) | only if you use "Only what changed since a date" from [Part 1, If needed](../Part%201%20Download/If%20needed/README.md) |
| **Later / robustness** | TC-6 unknown device type, TC-8 no creation date, TC-9 Excel lock file, TC-11 impossible file number, TC-12 unknown record, TC-13 no Basic UDI-DI | protect against damaged or unexpected answers: the script stops rather than guessing, except TC-9, where it skips the lock file and shows the list |

Write down in the validation record which group you ran: core, core + empty pair, core + TC-2, all, or custom (list the tests and the reason). A partial validation is then documented, not hidden.

### How to run a test

1. Open a new, empty workbook. Use a new one for each test, so an older table cannot be mistaken for the result.
2. Set up the Excel script as in step 7 of [Part 2](../Part%202%20Excel/README.md). In `ResponseFolder`, put the path of **one single test folder**, for example `Part 3 Validate\Test cases\TC-3 Missing page`. Never the folder `Test cases` itself: Excel reads only the files directly in the folder, so it would show an empty list without an error.
3. Click **Done**, then **Home → Close & Load**.
4. Compare what you see with [EXPECTED_RESULTS.md](EXPECTED_RESULTS.md): the expected rows, or the expected words in the message.
5. Record the result in [TOOL_VALIDATION_RECORD.md](TOOL_VALIDATION_RECORD.md). Close the workbook without saving.

Any mismatch is a failed test.

### The live check (TC-10), separate from the 17

TC-10 checks your own real list against EUDAMED after your first real download. It is not one of the 17 tests and is not in the time estimate. We recommend doing it before you use the list as a record; decide for your QMS whether you need it. If you skip it, mark it "not selected" in the record, with the reason. You compare the count per state with what EUDAMED shows for your SRN under **Tasks → UDI-DIs/Device → Manage your device details**, with only the State filter set, and check a sample of devices by UDI-DI. The steps, including how many devices to check, are in [TOOL_VALIDATION_RECORD.md, TC-10](TOOL_VALIDATION_RECORD.md#tc-10-first-live-check-recommended-before-the-list-is-used-as-a-record).

### Check that you test the right script

The tests are valid for this exact script file. Its SHA-256 is:

`b8fba6733e3f197d11bbcee36735ab2308df84a30f6e2707365351e880f10f11`

To check it:
1. Open the extracted package folder in File Explorer: the folder that holds `README.md` and the three Part folders.
2. Click the address bar, type `powershell` and press Enter.
3. Type `Get-FileHash "Part 2 Excel\EUDAMED device list.pq"` and press Enter.
4. Compare the Hash shown with the value above. PowerShell shows it in capital letters; that does not matter. Every character must match.

If it does not match, the script was changed. Do not use these test results for it.

## Licence

The test data are under the MIT License (`LICENSE`). The texts are under CC BY 4.0 (`LICENSE-DOCS.md`).
