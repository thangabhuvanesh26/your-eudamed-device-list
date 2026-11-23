# Part 2: Turn the EUDAMED answers into an Excel list

You have the device list from EUDAMED as XML files, but how do you compare it with your ERP?

Just want to try first? → [Try Excel with sample answers](#try-excel-with-sample-answers-optional)

This part makes one Excel list from the answers, one row per device record. You set it up once. After that, one click on **Refresh All** reads the newest answers.

**You need:** the answers folder from [Part 1](../Part%201%20Download/README.md), with the checks of "Before you go on" ticked. You also need Microsoft 365 **desktop** Excel on Windows. Excel in a web browser does not work for this.

## Which folder Excel must point at

Excel reads the answers from one folder: the folder you put in the line `ResponseFolder =` in step 7.

| You want to | Put this folder in `ResponseFolder` |
|---|---|
| make your real list | your answers folder from Part 1, for example `C:\EUDAMED\Device responses` |
| try Excel with the sample answers | the folder `Part 2 Excel\Try it first` of this package |
| run one validation test | one single test folder, for example `Part 3 Validate\Test cases\TC-3 Missing page` |

Never put in the extracted package folder itself, or the folder `Part 3 Validate\Test cases`. Excel reads only the files directly in the folder you name, not the files in folders inside it. So it would show an empty list, without an error.

## Steps

**7. Set up Excel once.**
1. Open a blank workbook. Choose **Data → Get Data → From Other Sources → Blank Query**.
2. In this folder (`Part 2 Excel`), right-click `EUDAMED device list.pq`, choose **Open with**, then **Notepad**. Press Ctrl+A, then Ctrl+C.
3. In the window that opens (the query editor), choose **Home → Advanced Editor**. Delete what is there and press Ctrl+V.
4. Find the line that starts `ResponseFolder =`. Put the path of your answers folder between the quotation marks. To copy the path, click the address bar of the folder in File Explorer and press Ctrl+C. Keep one pair of quotation marks and the comma at the end:
   `ResponseFolder = "C:\EUDAMED\Device responses",`
5. Click **Done**, then **Home → Close & Load**.
6. Save the workbook: **File → Save As**, Excel Workbook (.xlsx). It holds your device data, so keep it with your other controlled records.

**8. Check it before you trust it.** Do not start the ERP comparison until every box is ticked.

- [ ] One answer for **each** state is in the folder, also when it said 0. Excel cannot know about an answer you never saved: without the Discarded answer you get a list with no error.
- [ ] Every file the first answers asked for is there.
- [ ] **Data → Refresh All** finished with no error. After a failed refresh the old table can stay on the sheet, so the table alone proves nothing. The refresh has finished when the status bar at the bottom no longer shows it running, and **Data → Queries & Connections** shows the rows loaded, with no error.
- [ ] The Response file and Downloaded on columns show today's answers, not older ones. All answers of a full download are from the same day. Every answer in the folder was saved from this run: in Upload Management, the upload you took it from has the time you sent it in this run (as in [Before you go on](../Part%201%20Download/README.md#before-you-go-on) of Part 1). An answer with 0 devices has no rows, so open it and check that its creation date (`creationDateTime`) is from this run.
- [ ] The count per state matches what EUDAMED shows for the same SRN and state, under **Tasks → UDI-DIs/Device → Manage your device details** with only the State filter set. To count the rows per state, click the filter arrow of the State column and choose one state; the count shows at the bottom left. A few devices, looked up by UDI-DI in EUDAMED, match in state and version. How to do this check step by step: the live check [TC-10](../Part%203%20Validate/TOOL_VALIDATION_RECORD.md#tc-10-first-live-check-recommended-before-the-list-is-used-as-a-record) in Part 3.
- [ ] An empty list is right only if both answers say `SUCCESS` and 0.

Before you rely on the list in your quality processes, check its suitability under your own procedures (see [Part 3, Validate for your QMS](../Part%203%20Validate/README.md#validate-for-your-qms)).

## Try Excel with sample answers (optional)

To check Excel on your computer before you use EUDAMED:
1. Do step 7, but put the path of the folder `Part 2 Excel\Try it first` in `ResponseFolder`. It holds made-up answers.
2. You should see 17 columns and 12 rows: 11 Registered, 1 Discarded.
3. Then switch to your real folder: **Data → Queries & Connections**, right-click the query, **Edit**, then **Home → Advanced Editor**. Change the `ResponseFolder` path, click **Done**, then **Close & Load**.
4. Do the checks of step 8 with your real answers.

## Routine use

Your routine is: upload submissions, keep the EUDAMED list current, compare it with your ERP. After each upload batch, or on your own interval:

1. Empty the answers folder: make a new subfolder named with today's date, for example `old 2026-11-21`, and move all old answers into it. Use a new subfolder each time. Excel reads only the files directly in the folder, so you keep the old answers without mixing them in.
2. Download again: do steps 3 to 6 of [Part 1](../Part%201%20Download/README.md), all files of both states on the same day, and its "Before you go on" check. The request files you already filled in can be sent again. This was tested in the Playground, not yet in Production.
3. Click **Data → Refresh All** and do the checks of step 8.
4. Compare the list with your ERP. Choose a matching field that suits your records; a reference number is not always unique.

## If something goes wrong

| What you see | What to do |
|---|---|
| Folder not found: "We couldn't find the folder …" (Excel's own message, marked DataSource.NotFound) | The path in `ResponseFolder` is wrong. Copy it again from the File Explorer address bar (step 7), then click **Done** and **Close & Load**. |
| "… does not end in .xml, so Excel cannot read it" | If the name ends in `.crdownload` or `.part`, the download did not finish: move it out of the answers folder and download the same answer again from Upload Management (find the upload by its file name and time). Otherwise (often `.xml.txt`) rename it so the name ends in `.xml`. Then refresh. |
| "a file is missing, so the list would be incomplete" | If you can still send it today, on the same day as the other files of this download, send that file in EUDAMED (see [Part 1](../Part%201%20Download/README.md)), save its answer in the folder and refresh. Otherwise [start the download again](../Part%201%20Download/README.md#start-the-download-again): move all answers of the folder into a new dated subfolder and send the request files of both states again, on the same day. |
| The list looks short or empty, but there is no error | Excel checks only the files in the folder. Make sure an answer for each state is there, also when it said 0, and every file it asked for (step 8). Check that `ResponseFolder` names the right folder (see [Which folder Excel must point at](#which-folder-excel-must-point-at)). |

After you fix any of these, do the "Before you go on" check of Part 1 and the checks of step 8 again before you rely on the list. A file you move out must be replaced by a correct answer (`PullResponse` and `SUCCESS`), or the list is incomplete. Get an original answer again from Upload Management, by its upload's file name and time. If an upload must be sent again, or you are unsure which run an answer belongs to, [start the download again](../Part%201%20Download/README.md#start-the-download-again).

Excel shows the script's messages with `[Expression.Error]` in front; that tag is normal. Every other message from the Excel script starts with "EUDAMED device list:" and says what is wrong and the one thing to do. All of them are explained in [Part 3, Troubleshoot](../Part%203%20Validate/README.md#troubleshoot).

## Next

**[Next: Part 3 Validate →](../Part%203%20Validate/README.md)**

## Licence

The Excel script and the sample answers are under the MIT License (`LICENSE`). This text is under CC BY 4.0 (`LICENSE-DOCS.md`).
