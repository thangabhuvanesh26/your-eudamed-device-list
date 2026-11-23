# EUDAMED device list in Excel

Get your Registered and Discarded devices from EUDAMED into one Excel list, so you can compare it with your ERP. For medical device manufacturers with MDR and legacy MDD devices. The request files only read data: they change nothing in EUDAMED.

## Three questions, three parts

| Part | The question it answers |
|---|---|
| **[Part 1 Download](Part%201%20Download/README.md)** | Can you confirm which of your devices appear as Registered in EUDAMED? |
| **[Part 2 Excel](Part%202%20Excel/README.md)** | You have the device list from EUDAMED as XML files, but how do you compare it with your ERP? |
| **[Part 3 Validate](Part%203%20Validate/README.md)** | How do you troubleshoot the workflow and validate it for your quality system? |

**Start with Part 1.** It ends with a link to Part 2.

Works with **EUDAMED Production schema version 3.0.30**, last accepted in Production in November 2026 in the author's tests. What was tested: [Part 3, Evidence](Part%203%20Validate/README.md#evidence).

## What you need

- EUDAMED manufacturer access to Bulk Upload (you can see **Data transfer → Bulk Upload**).
- Your SRN (Single Registration Number).
- Microsoft 365 **desktop** Excel on Windows. Excel in a web browser does not work for this.

## Download

**Try it in about 15 minutes (estimate): the starter ZIP.** **[Download the starter (ZIP)](https://github.com/thangabhuvanesh26/your-eudamed-device-list/releases/latest/download/EUDAMED-device-list-starter.zip)**. It holds `START HERE.pdf` (one page with the five steps), the first request file of each state (`Registered file 01.xml`, `Discarded file 01.xml`) and the Excel script. Its limits: at most 300 devices per state (one answer holds at most 300 devices), and the starter list is not validated for QMS use.

**The full package.** **[Download the package (ZIP)](https://github.com/thangabhuvanesh26/your-eudamed-device-list/releases/latest/download/EUDAMED-device-list.zip)**. Use it for more than 300 devices in a state, for troubleshooting, and to validate the list for your quality system. Right-click the ZIP, choose **Extract All**, then **Extract**. Work in the extracted folder, not inside the ZIP. All three parts are in it. The same steps, with pictures, are in `QUICK_START.pdf`; the one-page version is `START HERE.pdf`.

## Limits

- Registered and Discarded records only. No Submitted records, no drafts and no failed uploads (check the result of each upload in EUDAMED for those).
- The list shows what EUDAMED sent in your downloads, nothing newer.
- Tested by the author with MDR and legacy MDD devices. The Excel script was tested on made-up answers (the 17 tests) and on one real Production download of the author's; check your own list once against EUDAMED ([Part 3, TC-10](Part%203%20Validate/README.md#the-live-check-tc-10-separate-from-the-17)). Not tested: IVDR devices, other legacy types, other Excel versions. A record shape the script does not know, such as the one test TC-6 uses, stops the list with a message (IVDR records were not tested).
- One full download per empty folder. Excel cannot always tell two downloads made with the same request files a day or two apart from each other. Before each full download, move all old answers into a new dated subfolder, and send all files of both states on the same day (Part 1, step 1). If an upload must be sent again, or you are unsure which run an answer belongs to, start the download again with both states (Part 1, "Start the download again").
- The supplied request files carry the Production version 3.0.30, last accepted in Production in November 2026 (details: [Part 3, Evidence](Part%203%20Validate/README.md#evidence)).
- Sending the same request files again was tested in the Playground only, not yet in Production.

## Disclaimer and licence

Shared as-is, without warranty. Not affiliated with the European Commission. The Excel script was built with Claude Code using made-up test devices. It runs locally, with no AI involved when you click Refresh. Feedback on any issues is welcome.

The Excel script, the Python helper, the request files, the sample answers and the test data are under the MIT License (`LICENSE`). The texts are under CC BY 4.0 (`LICENSE-DOCS.md`).
