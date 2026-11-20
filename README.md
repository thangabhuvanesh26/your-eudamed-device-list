# EUDAMED device list in Excel

A free how-to package for medical device manufacturers: download your own **Registered and Discarded MDR and legacy MDD device records** from EUDAMED and combine them into one list in **Microsoft 365 desktop Excel on Windows**.

EUDAMED's Bulk Upload screen, normally used for XML uploads, also accepts a download request. In the author's tests, EUDAMED answered with the device records as files, however they were entered: uploaded as XML or entered manually on the website. You save the response files in one folder, and the Excel Power Query script in this package combines them into one list.

No XML or coding skills are needed. You edit your SRN in Notepad, upload a file, save the answer, and click Refresh in Excel.

## Get started

**[Download the package (ZIP)](https://github.com/thangabhuvanesh26/your-eudamed-device-list/releases/latest/download/EUDAMED-device-list.zip)**. In your Downloads folder, right-click the ZIP file, choose **Extract All**, then **Extract**. Work in the extracted folder, not inside the ZIP.

Then pick your route:

- **Try it with sample data** (5 minutes, no EUDAMED needed): see "Try it first with sample data" below.
- **Test on your records:** follow `QUICK_START.pdf` in the extracted folder (7 illustrated pages), or "Step by step" below.

The request files are for **EUDAMED Production schema version 3.0.30**, last accepted in Production on 18 November 2026 (the author's last test). If EUDAMED rejects a request because of the version, see "If something goes wrong".

Supported: MDR and legacy MDD devices, tested by the author. Not tested: IVDR devices and other legacy types; an IVDR record stops the Excel list with an error (see "Limits").

## How it works

1. You upload a request file in EUDAMED.
2. EUDAMED answers with a response file holding your device records. You save it in one folder.
3. You set up the Excel query once and point it at that folder.
4. After every new download, you click **Refresh All**.

## What you need

- An EUDAMED manufacturer account with access to Bulk Upload (in EUDAMED you can see **Data transfer → Bulk Upload**).
- Your Single Registration Number (SRN), the manufacturer number EUDAMED gave you.
- Microsoft 365 **desktop** Excel on Windows, the only version tested. Excel in a web browser does not work for this.

## Try it first with sample data (optional, 5 minutes)

Before you use EUDAMED, you can check that the Excel list works on your computer. Do step 8 below, but set `ResponseFolder` to the `sample-responses` folder of this package. It holds made-up responses. You should see 17 columns and 12 rows: 11 Registered and 1 Discarded.

The sample also shows how pages work. Registered needed 2 pages here, Discarded 1. Open `RESP_full_registered_page_0.xml` in Notepad (as in step 3), press Ctrl+F and search for `numberOfPages`: it says 2, so page 1 is in the folder too.

Before your real download, change the path to your own folder: **Data → Queries & Connections**, right-click the query, **Edit**, then **Home → Advanced Editor**.

## Step by step

**1. Get the package.**
Click **[Download the package (ZIP)](https://github.com/thangabhuvanesh26/your-eudamed-device-list/releases/latest/download/EUDAMED-device-list.zip)**. (Or, on the GitHub page, click the green **Code** button, then **Download ZIP**.) In your Downloads folder, right-click the ZIP file, choose **Extract All**, then **Extract**. Work in the extracted folder, not inside the ZIP.

This page is the README. GitHub shows it formatted below the file list; click any `.md` file to read it the same way.

**2. Make a response folder.**
Create a new, empty folder for the response files. The responses hold your non-public registration data, so restrict access to it. Use separate folders per SRN and per environment (Playground, Production).

**3. Put your SRN into two request files.**
In `requests\full-download\`, you need only `request_registered_page_0.xml` and `request_discarded_page_0.xml` to start. Open each in Notepad: right-click it, choose **Open with**, then **Notepad** (a double-click may open it in a browser instead). Press Ctrl+H. Replace `XX-MF-000000000` with your SRN. It appears three times, so click Replace All, then save. Press Ctrl+F and search for `XX-MF` to check that none is left. Change nothing else.

**4. Upload the Registered request.**
In EUDAMED go to **Data transfer → Bulk Upload → New upload** and choose the service **Download of Legacy/ Regulation Device/SPP**. Choose `request_registered_page_0.xml` and click **Send**.

The request only reads data. It changes nothing in EUDAMED.

**5. Save the response.**
Go to **Upload Management**. Your request is the top row (the newest upload; check the file name). Wait until its status changes from Submitted to a final state, then click the download icon for the response.

Save the file directly in your response folder and give it a name that says what it is, for example `Registered page 0.xml`, `Registered page 1.xml`, `Discarded page 0.xml`. EUDAMED names every file `APP-DTX-….xml`, so this is how you later see which file is which. The query reads the content, not the name.

The name must end in `.xml`. To see the endings, turn them on once in File Explorer: **View → Show → File name extensions**. A file saved as `Registered page 0.xml.txt` stops the refresh with an error until you rename it.

To check what you got, open the file in Notepad. Near the top it says either `PullResponse` (a device response) or `Acknowledgement`. Press Ctrl+F and search for `responseCode`: a device response says `SUCCESS`. Keep that file in the folder. An acknowledgement is, for a download request, usually a rejection: keep it outside the folder and read its reason (see "If something goes wrong").

**6. Check for more pages.**
One response holds up to 300 records. In the response, press Ctrl+F and search for `numberOfPages`. Pages are numbered from 0.

| `numberOfPages` | Further files to send for that state |
|---|---|
| 0 | none (no record in that state) |
| 1 | none |
| 3 | pages 1 and 2 |
| N | pages 1 to N−1 |

The further pages are in `requests\full-download\more-pages\`. Put your SRN into the ones you need (as in step 3), upload them, and save every response in the same folder.

**7. Repeat steps 4 to 6 for Discarded records.**
Upload `request_discarded_page_0.xml` the same way. Check its own `numberOfPages`, which can differ from the Registered one. If you have no Discarded records, the response shows `numberOfPages` 0 and the result SUCCESS. That is normal: save it in the folder too.

Fetch all pages of both states on the same day.

**8. Build the list in Excel (once).**
1. Open a blank workbook and choose **Data → Get Data → From Other Sources → Blank Query**.
2. Open `script\EUDAMED_device_list.pq` in Notepad (as in step 3), press Ctrl+A, then Ctrl+C. In Excel, choose **Home → Advanced Editor**, delete what is there, and press Ctrl+V.
3. In the line that starts `ResponseFolder =`, change the path between the quotation marks to your folder. To get the path, open the folder in File Explorer, click the address bar at the top and press Ctrl+C, then paste it between the quotation marks. Keep exactly one pair of quotation marks and the comma at the end. The line then looks like this, with your own path:
   `ResponseFolder = "C:\EUDAMED\Device responses",`
   Click **Done**.
4. Choose **Home → Close & Load**.
5. Once the list has loaded, save the workbook: **File → Save As**, Excel Workbook (.xlsx). It holds your device data, so keep it where your other controlled records are.

**9. Check it.**
Before you refresh, tick these:

- [ ] A Registered response is in the folder (for example `Registered page 0.xml`).
- [ ] A Discarded response is in the folder (for example `Discarded page 0.xml`), also if it says `numberOfPages` 0.
- [ ] Every page that `numberOfPages` asked for is there.
- [ ] Every file name ends in `.xml`.
- [ ] `ResponseFolder` points to your own folder, not to `sample-responses`.

After you refresh, wait until **Refresh All** has finished, then tick these:

- [ ] No warning next to the query in **Data → Queries & Connections**. An error shows there and as a message.
- [ ] The Response file column lists the files you just saved, not older ones.

If a refresh fails, the table from the previous successful refresh may still be on the sheet, so do not rely on the table alone. If both states had no records, the list is empty: then confirm that both saved responses say `SUCCESS` and `numberOfPages` 0.

Then filter the State column and compare the count with what EUDAMED shows for the same manufacturer and the same state. Equal counts do not prove the records match, so also pick a few records by their UDI-DI / EUDAMED ID, look them up in EUDAMED and compare state, version and last update.

## Update the list later

1. In your response folder, make a subfolder, for example `old`, and move all the old response files into it. The query reads only the files directly in the folder, so it ignores that subfolder, and you keep the old files.
2. Do steps 4 to 7 again. The request files you already filled in can be sent again (tested in the Playground).
3. Click **Data → Refresh All** and check the list as in step 9.

The author plans to repeat the full download once a year. Choose the interval that fits your own procedures.

## If something goes wrong

**EUDAMED rejects a request.**
Read the rejection message first. Only if it says the schema version is wrong and names the version it expects, EUDAMED has moved to a new version. Open each request file you will send in Notepad, change the value inside `version="..."` in the `<m:PullRequest ...>` line to the version the message names, change nothing else, save, and upload it again. If it is still rejected, ask your EUDAMED administrator or the EUDAMED service desk. `advanced\DOWNLOAD_NOTES.md` has the details.

**The refresh stops with an error.**
Read the message. The refresh stops if a file has .xml in its name but does not end in .xml (rename it); if a page of a download is missing, has an impossible page number or is there twice from two different downloads; if pages of one download report different page counts; if a rejection or other acknowledgement is in the folder; if a response does not report SUCCESS or lacks its page count or creation date; or if a response holds a record the query cannot read, such as an IVDR record or a record without a Basic UDI-DI. Fix the folder and click **Refresh All** again.

**The list looks incomplete.**
The checks only see the files in the folder. They cannot know about a response you never saved, so confirm that both states returned a response, even when one of them has no records. A record that no longer comes back from EUDAMED stays in the list until you move the old responses out and do a new full download.

**`numberOfPages` is higher than the pages supplied.**
The package supplies 20 Registered pages (up to 6,000 records) and 5 Discarded pages (up to 1,500). For more, see "More pages than supplied" below.

## Common questions

**Does the request change anything in EUDAMED?**
No. The screen is called Bulk Upload, but this request only reads data.

**Which devices does it return?**
The records of the manufacturer identified by your SRN that match the requested state, once you have retrieved all pages. A request with no state returns Registered records only. In the author's tests it returned MDR and legacy MDD records, including manual entries.

**Can I send the same request files again?**
Yes. In the author's Playground test, EUDAMED accepted request files it had received nine days earlier and answered with SUCCESS. Production was not tested.

**Does it compare the list with my ERP automatically?**
No. Comparing it with your ERP, your internal product system, is your own step. Choose a matching field that suits your records; a reference number is not always unique.

**Does it show failed uploads?**
No. Check the acknowledgement (the result file EUDAMED returns after every upload of device data) of each upload to find rejected records or rejected updates.

**Does it give the original registration date?**
The response files tested contained the version date and the last update, and no separate registration date.

**Does the Excel query send my data to an external service?**
No. The query reads only your local folder and contains no network calls. Whether that folder is synced, for example by OneDrive or to a network share, is outside the query. The response files hold non-public data, so restrict access to that folder.

**Do I have to validate it?**
Before you rely on the output in your quality processes, assess and document its suitability for your intended use under your organisation's procedures. See "For QA and validation" below.

---

# Advanced and optional

You do not need anything below for a first download.

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
| Downloaded on | the creation date and time of the response file the row came from |
| Response file | the name of that response file |

The list shows the newest version EUDAMED returned for each record, with no history. Dates and times appear as written in the response files, without their time zone. Registered and Discarded describe the record in EUDAMED, not what happened to the physical product. Market status is a separate column.

**What happens when the same device appears in several downloads?**
The newest download decides, and each record normally keeps one row. Newest means the creation date and time EUDAMED writes inside each response file, not the file name or file date. Responses created within 12 hours of each other count as the same download. If they return a record in two states, for example because it was discarded between two responses, the record gets a row per state and Other states names the other one. Check such a record in EUDAMED. Fetching all pages on the same day keeps this rare. A UDI-DI with both a legacy and an MDR record keeps two rows.

## More pages than supplied

If `numberOfPages` is higher than the pages supplied (20 for Registered, 5 for Discarded), the supplied files are not enough for that state. Do not add extra pages to them: pages from different sets do not belong together, and the query would report a missing page. Instead, make a whole new set with the helper below, start that state again from the new page 0, and keep only the responses from the new set for that state.

The helper `advanced\tools\make_request_files.py` needs Python 3 only, nothing to install, and writes the same kind of request files as supplied here into a new folder. Run it from the package folder, for example:

```
python advanced\tools\make_request_files.py XX-MF-000000000 --registered-pages 25 --discarded-pages 5 --version 3.0.30 --since 2026-11-20 --out new-requests
```

Give your SRN instead of `XX-MF-000000000`, or keep the placeholder and replace it in Notepad later. All options except the SRN are optional; `--out` sets the output folder (default `request-files`), which must be new or empty. `--since` is the date for the changed-since files (default: today).

Each run makes new message IDs. Use the files of one set together, and never mix pages from different sets or from the supplied files for the same state. You do not need a fresh set just to download again: in the author's Playground test, EUDAMED accepted request files it had received nine days earlier, both unchanged and with only the date changed. The response carried the same conversation and correlation IDs as the request, with a new creation date and time.

## Changed-since updates (optional)

Instead of a full download, you can ask only for records from a given date. This is optional and less tested than a full download.

1. Open `advanced\changed-since\delta_registered.xml` and `delta_discarded.xml` in Notepad. Put in your SRN as in step 3. In the line `<s:UDIDIVersionDate>2026-11-20</s:UDIDIVersionDate>`, set the day your last completed download (full or changed-since) started, written year-month-day: the earliest Downloaded on date of that download. Use the same date in both files. Change nothing else.
2. Upload both files and save the responses in the folder of your full download, next to the earlier ones. Do not move the full download out for this.
3. Click **Data → Refresh All**.

In the author's tests, the filter included records dated on the selected day. That is harmless: the list keeps one row per record.

Move the date forward only after a refresh that completed without an error. The Downloaded on column shows which download each row came from.

In the author's tests, the changed-since request returned newly registered records. It has **not** been tested against real EUDAMED for a new version of an existing record, a state change, a market-status change, or a manual entry. Do not rely on it to capture those yet; do a full download instead.

If a changed-since response reports more than one page, do a full download instead.

## Folder rules

- Keep a full download and any later changed-since responses together in one folder.
- Before each new full download, move the old responses into a subfolder (see "Update the list later").
- Use separate folders per SRN and per environment (Playground, Production).
- The query reads only the `.xml` files directly in that folder, not in subfolders. Exact copies of a file count once.
- Fetch all pages of both states of one download on the same day.

## For QA and validation

Before you rely on the output in your quality processes, assess and document its suitability for your intended use under your organisation's procedures.

The package includes made-up test data in `advanced\test-data\` (17 test cases: full download, full download plus changed-since, missing page, rejection in the folder, empty folder, unknown device type, no page count, no creation date, lock file in the folder, page number out of range, unknown record in the response, no Basic UDI-DI, the same requests sent twice, a state with no records, a misnamed response file, conflicting page counts, and both states empty), the expected results in `advanced\test-data\EXPECTED_RESULTS.md`, and a validation record template in `advanced\validation\TOOL_VALIDATION_RECORD.md`. The template also asks for a first live check against EUDAMED before the list is used as a record.

## What is in this package

| Folder or file | Contents |
|---|---|
| `QUICK_START.pdf` | illustrated 7-page guide to the first download and the Excel list |
| `requests\full-download\` | `request_registered_page_0.xml` and `request_discarded_page_0.xml`, the two files you start with |
| `requests\full-download\more-pages\` | `request_registered_page_1.xml` to `request_registered_page_19.xml` and `request_discarded_page_1.xml` to `request_discarded_page_4.xml` |
| `script\EUDAMED_device_list.pq` | the Excel Power Query script |
| `sample-responses\` | made-up responses to try the Excel list first (12 rows) |
| `advanced\README.md` | a one-page map of the advanced folder |
| `advanced\DOWNLOAD_NOTES.md` | technical notes: schema versions, state filter, pages |
| `advanced\changed-since\` | `delta_registered.xml` and `delta_discarded.xml` (optional) |
| `advanced\test-data\` | made-up response files for 17 test cases, and `EXPECTED_RESULTS.md` |
| `advanced\validation\TOOL_VALIDATION_RECORD.md` | a validation record template |
| `advanced\tools\make_request_files.py` | optional helper, see "More pages than supplied" |
| `LICENSE`, `LICENSE-DOCS.md` | the licence terms, see "Licence" below |

The supplied 20 Registered request files cover up to 6,000 records, the 5 Discarded request files up to 1,500 (300 records per page). The query itself has no such limit.

## Schema versions

The supplied request files carry the Production version 3.0.30, last accepted in Production on 18 November 2026. The Playground (test environment) demanded 3.0.36.1 on 20 November 2026. EUDAMED changes the schema version with its releases; the version at the top of this page is updated when Production changes. `advanced\DOWNLOAD_NOTES.md` explains how to change it in the request files.

## Limits

- Registered and Discarded records only. No drafts and no failed uploads. A Playground request for state Submitted returned no records, and the package has no Submitted request files.
- The list shows what EUDAMED returned in your downloads, nothing newer.
- Tested in the EUDAMED Playground and in Production, with MDR and legacy MDD devices. Not tested: IVDR devices, other legacy types, other Excel versions, and the changed-since cases above (new version of an existing record, state change, market-status change, manual entry).
- Sending the same request files again was tested in the Playground only, not in Production.

## Disclaimer

Shared as-is, without warranty. Not affiliated with the European Commission.

The script was built with Claude Code using made-up test devices. It runs locally, with no AI involved when you click Refresh.

Feedback on any issues is welcome.

## Licence

The Power Query script, the Python helper, the request files, the sample responses and the test data are under the MIT License (`LICENSE`). The README, quick-start guide, download notes, expected results and validation template are under CC BY 4.0 (`LICENSE-DOCS.md`).
