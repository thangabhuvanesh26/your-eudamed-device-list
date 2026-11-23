# Only what changed since a date (optional)

Instead of a full download, you can ask only for the devices changed since a given date. This is optional and less tested than a full download. You need a full download first ([Part 1](../../README.md)).

## What it was tested for

In the author's tests, the changed-since request returned newly registered records. It has **not** been tested against real EUDAMED for a new version of an existing record, a state change, a market-status change, or a manual entry. Do not rely on it to capture those yet; do a full download instead.

## Your run log

Write down each run here (or in your own record). The date you put in the files comes from this log, not from the list.

| Run | Start date of the run | Answers saved as | All checks passed? |
|---|---|---|---|
| Full download | [ ] | `Registered answer 01.xml` … | [ ] |
| Changed since, run 1 | [ ] | `Registered changed 2026-11-21 run 1.xml`, `Discarded changed 2026-11-21 run 1.xml` | [ ] |

## Steps

1. Open `delta_registered.xml` in Notepad (right-click, **Open with**, **Notepad**). Did you send these same changed-since files less than three days ago? Then do not send them again: see "Fresh files for each run" below.
2. Put in your SRN as in step 2 of [Part 1](../../README.md): Ctrl+H, replace `XX-MF-000000000`, **Replace All**, save. Check with Ctrl+F that no `XX-MF` is left, and that your SRN is in three places.
3. Find the line `<s:UDIDIVersionDate>2026-11-20</s:UDIDIVersionDate>`. Put in the start date of your last run whose checks all passed, from your run log, written year-month-day.
4. Change nothing else. Save.
5. Do the same in `delta_discarded.xml`. Use the same date in both files.
6. Write today's date in your run log as the start date of this run.
7. Send both files in EUDAMED on the same day, as in step 3 of Part 1. Check each answer as in step 4 of Part 1 (`PullResponse` and `SUCCESS`).
8. Save both answers in the answers folder of your full download, next to the earlier answers. Do not move the full download out for this. Give each run its own names, with the run date and a number, for example `Registered changed 2026-11-21 run 1.xml` and `Discarded changed 2026-11-21 run 1.xml`. A second run on the same day is `run 2`.
9. Click **Data → Refresh All**, then do the check below.

If a changed-since answer says it needs more than one file (`numberOfPages` more than 1), do a full download instead.

## Check after the refresh

This check replaces the step 8 checks of [Part 2](../../../Part%202%20Excel/README.md) for a changed-since refresh. Do not start the ERP comparison until every box is ticked.

- [ ] **Data → Refresh All** finished with no error.
- [ ] Both changed-since answers of this run, Registered and Discarded, are in the folder, next to all answers of the full download.
- [ ] Both changed-since answers were saved from this run: in Upload Management, the upload you took each one from has the time you sent it in this run. For an answer that said 0, also open it and check that its creation date (`creationDateTime`) is from this run.
- [ ] Rows for the records that this run's answers returned show that answer in Response file, and its date in Downloaded on. Check this against the records in the answers, not against what you think changed: the filter includes the start date, so a record dated on that day comes back too, even if it did not change after your last run.
- [ ] All other rows keep their older Downloaded on date and Response file. That is normal: those records were not in this run's answers.
- [ ] A record shows twice, or Other states is filled: check that record in EUDAMED (see the 12-hour rule below).
- [ ] The count per state matches what EUDAMED shows for the same SRN and state.

Only then tick "All checks passed" in your run log. The next run uses this run's start date.

## Good to know

- Move the date forward only after a refresh with all checks passed. A run with no changed devices still counts: take its date from the run log, because the list has no new rows to show it.
- Answers created within 12 hours of each other count as one download, so a device that changed in between can show twice. See "Same device in several downloads" in [TECHNICAL_NOTES.md](../../../Part%203%20Validate/TECHNICAL_NOTES.md#same-device-in-several-downloads).
- In the author's tests, the filter included records dated on the selected day. Such a record comes back again. It normally keeps one row, now with the new answer as its Response file. It gets a row per state when answers created within 12 hours of each other return it in two states (the 12-hour rule above).
- The newest answer decides for each device.
- To make fresh changed-since files with another date, the helper in `More files than supplied` writes them too (option `--since`).
- When you are unsure which date to use, or a check fails: do a fresh full download into an empty folder (Part 1, step 1).

## Fresh files for each run

When you change only the date, the changed-since files keep their download ID (`conversationID`). Excel treats answers with the same download ID, created within 3 days of each other, as one download. So if you send the same changed-since files again within three days, the answers of the two runs are treated as one download. If their file counts differ, for example 0 and 1, the refresh stops. If they agree, answers from two runs can be mixed without an error.

So for a changed-since run within three days of the last one, use a fresh pair of changed-since files:

- Make a new set with the helper in `More files than supplied` (option `--since` with your start date), and use only the two files in its `Changed since` folder. Each run of the helper makes new IDs.
- Or do a full download into an empty folder instead (Part 1, step 1).

## Licence

The request files are under the MIT License (`LICENSE`). This text is under CC BY 4.0 (`LICENSE-DOCS.md`).
