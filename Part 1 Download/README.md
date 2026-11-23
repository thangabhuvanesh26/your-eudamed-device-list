# Part 1: Download your devices from EUDAMED

Can you confirm which of your devices appear as Registered in EUDAMED?

Downloaded the package? If not: [Download](../README.md#download) it first, and extract it.

This part gets the answer from EUDAMED itself. You send small request files in EUDAMED's Bulk Upload and save the answers in one folder. In the author's tests, EUDAMED answered with the devices however they were entered: uploaded as XML or entered manually on the website. The request files only read data: they change nothing in EUDAMED.

You need EUDAMED manufacturer access to Bulk Upload and your SRN. The request files are in the folder `Request files`: you start with `Registered file 01.xml` and `Discarded file 01.xml`; `Request files\More files` holds file 2 onwards.

## Steps

**1. Make an answers folder.**
- Create a new, empty folder, for example `C:\EUDAMED\Device responses`.
- Restrict access to it. The answers hold non-public registration data.
- Use one folder per SRN, and keep only Production answers in it.
- One full download per empty folder. For every later full download, first move all old answers into a new subfolder named with today's date, for example `old 2026-11-21`. Use a new subfolder each time, so older answers are never overwritten. Excel does not read subfolders.
- Send all files of both states of one download on the same day. Excel cannot always tell two downloads made with the same request files a day or two apart from each other, so answers from two runs could be mixed without an error.
- If you have to start again later, see [Start the download again](#start-the-download-again).

**2. Put your SRN in two request files.**
- In `Request files`, right-click `Registered file 01.xml`, choose **Open with**, then **Notepad**.
- Press Ctrl+H. Replace `XX-MF-000000000` with your SRN and click **Replace All**. Save.
- Press Ctrl+F and search for `XX-MF`. None must be left. Change nothing else.
- Then search for your SRN. It must be in three places, each written exactly as your SRN.
- Do the same in `Discarded file 01.xml`.

**3. Send the Registered request file.**
- In EUDAMED, go to **Data transfer → Bulk Upload → New upload**.
- Choose the service **Download of Legacy/ Regulation Device/SPP**.
- Choose `Registered file 01.xml` and click **Send**. Note the time.

**4. Get the answer.**
- Go to **Upload Management**. Find your request by its file name and the time you sent it.
- Wait until its status is final, then click the download icon. EUDAMED names the file `APP-DTX-….xml`.
- Your browser saves it in your Downloads folder. If the name ends in `.crdownload` or `.part`, the download did not finish: keep that file out of the answers folder and download the same answer again from Upload Management (find the upload by its file name and time).
- Move the file from Downloads into your answers folder and rename it `Registered answer 01.xml`, so request file 1 matches answer 1.
- The name must end in `.xml`. Turn on file name extensions once in File Explorer: **View → Show → File name extensions**.
- Open the answer in Notepad. Near the top it must say `PullResponse`. Press Ctrl+F and search for `responseCode`: it must say `SUCCESS`. Both are needed. Do this check for **every** answer you save, also file 2 onwards and the Discarded answers.
- If the file says `Acknowledgement` near the top instead, it is a receipt or a refusal, not an answer. Keep it out of the answers folder. Search for `responseCode`: if it says `SUCCESS`, it is only a receipt. It is not a device answer: it is usually the result of a different upload, such as a registration. In Upload Management, find your download by its file name and time and save its `PullResponse`. If there is none, start the download again with both states ([Start the download again](#start-the-download-again)). Otherwise it is a refusal: read why (see [If something goes wrong](#if-something-goes-wrong)).

**5. How many files do you need?**
EUDAMED sends at most 300 devices per answer. Have more? Send the next file. The first answer tells you how many files you need. In the answer, press Ctrl+F and search for `numberOfPages`. The number after it is how many files you need for this state. If `numberOfPages` is not found, download that answer again.

Check in this order:

- **If it says more than 20 Registered or 5 Discarded**, the supplied files are not enough: go to [If needed](If%20needed/README.md), "More devices than the supplied files". Already using a new set made there? Then this limit does not apply: send only up to the number in the new answer, from the new set.
- **If it says 0:** you have no devices in this state. Keep the answer in the folder: it shows the state was checked. Done with this state.
- **If it says 1:** done with this state.
- **If it says 2 or more**, for example 3: also send file 2 and file 3 from `Request files\More files`. Put your SRN in each first, as in step 2. Save the answers as `Registered answer 02.xml` and `Registered answer 03.xml` (for Discarded: `Discarded answer 02.xml` and so on). Check each one as in step 4. Send all files on the same day.

**6. Do the same for Discarded.**
Also send the Discarded file. Discarding is not part of routine work, but without this file a discarded device simply vanishes from your list, and in the ERP comparison it looks missing instead of discarded.
- Send `Discarded file 01.xml` as in step 3, on the same day as the Registered files.
- Save its answer as `Discarded answer 01.xml`, and check it as in step 4 (`PullResponse` and `SUCCESS`).
- Check its own `numberOfPages` as in step 5. It can differ from the Registered one.

| State | Plain meaning | In this package |
|---|---|---|
| Submitted | for new MDR device entities (a new Basic UDI-DI or UDI-DI) submitted through Data Exchange: waiting, because the new Basic UDI-DI needs a notified body to validate it, or the new UDI-DI is linked to a Basic UDI-DI that is in Submitted state (BR-DTX-UDI-035) | not requested; check these in EUDAMED itself |
| Registered | registered in EUDAMED (BR-DTX-UDI-035) | requested (most of your list) |
| Discarded | a Registered record that the manufacturer discarded. EUDAMED treats it as a logical delete: it no longer shows on the public site and its codes can be reused (BR-UDID-624). The manufacturer can still download its own discarded devices (DEVICE.GET service definition, 'DTX for EOs - services definition'). | requested, so a discarded record shows as Discarded instead of silently disappearing |

Sources: the EUDAMED business rules for UDI devices (BR-DTX-UDI-035, BR-UDID-624) and the DEVICE.GET service definition. BR-DTX-UDI-035 covers new entities submitted through Data Exchange. Market status (on the market or not) is a separate column, not a state.

## Before you go on

Tick every box before you start Part 2. Excel cannot know about an answer you never saved.

- [ ] An answer for **each** state is saved in your answers folder: Registered and Discarded, also when it said 0.
- [ ] Every file the first answers asked for is there. For example, if Registered said 3, you have `Registered answer 01.xml`, `Registered answer 02.xml` and `Registered answer 03.xml`.
- [ ] Every answer says `PullResponse` near the top and `SUCCESS` as its `responseCode`.
- [ ] All answers in the folder come from this download: the folder was empty when you started, and you sent all files of both states on the same day.
- [ ] Every answer in the folder was saved from this run: in Upload Management, the upload you took it from has the time you sent it in this run. For an answer that said 0, also open it and check that its creation date (`creationDateTime`) is from this run.

## If something goes wrong

| What you see | What to do |
|---|---|
| EUDAMED refuses the request, and the refusal names the version it expects | EUDAMED has moved to a new version. See [If needed](If%20needed/README.md), "EUDAMED refuses because of the version". Then start the download again. |
| The first answer asks for more than 20 Registered or 5 Discarded files | The supplied files are not enough. See [If needed](If%20needed/README.md), "More devices than the supplied files". |
| A receipt: the downloaded file says `Acknowledgement` near the top, and its `responseCode` says `SUCCESS` | It is only a receipt. Keep it out of the answers folder. It is not a device answer: it is usually the result of a different upload, such as a registration. In Upload Management, find your download by its file name and time and save its `PullResponse`. If there is none, start the download again with both states ([Start the download again](#start-the-download-again)). |
| A refusal: the downloaded file says `Acknowledgement` near the top, and its `responseCode` is not `SUCCESS` | It is a refusal, not an answer. Keep it out of the answers folder. Open it in Notepad to read why, fix the cause, then [start the download again](#start-the-download-again). |
| An answer says `PullResponse` but its `responseCode` is not `SUCCESS` | The answer cannot be used. [Start the download again](#start-the-download-again). |
| The downloaded file name ends in `.crdownload` or `.part` | The download did not finish. Keep that file out of the answers folder and download the same answer again from Upload Management (find the upload by its file name and time). |
| A file is missing | If you can still send it today, on the same day as the other files of this download, send it and save its answer. Otherwise [start the download again](#start-the-download-again). |
| You are not sure which run an answer belongs to | [Start the download again](#start-the-download-again). |

### Start the download again

1. Make a new subfolder in your answers folder, named with today's date, for example `old 2026-11-21`, and move **all** answers of the folder into it, of both states.
2. Send the request files of **both** states again from file 1, all on the same day (steps 3 to 6).

Do this whenever an upload must be sent again after a refusal or a result other than `SUCCESS`, when a missing file can no longer be sent on the same day as the others, or when you are unsure which run an answer belongs to. Do not repeat a single upload on its own: repeat the whole download.

After any fix, do the [Before you go on](#before-you-go-on) check again, and in Part 2 the checks of step 8.

Anything else: [Part 3, Troubleshoot](../Part%203%20Validate/README.md#troubleshoot).

## Next

**[Next: Part 2 Excel →](../Part%202%20Excel/README.md)**

## Licence

The request files are under the MIT License (`LICENSE`). This text is under CC BY 4.0 (`LICENSE-DOCS.md`).
