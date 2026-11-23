# More devices than the supplied files

Most users never need this page. It is an expert option for an unusual case: more devices than the supplied request files can download. It needs Python 3 and typing a command.

Part 1 supplies 20 Registered request files (up to 6,000 devices) and 5 Discarded request files (up to 1,500 devices), in `Part 1 Download\Request files`. If the first answer says it needs more files than that, the supplied files are not enough for that state.

Do not add extra files to the supplied ones. Files from different sets do not belong together, and Excel would report a missing file. Instead, make a whole new set with the helper `make_request_files.py`, and start the download again with the new set: both states, from file 1, on the same day, into an empty folder.

## What you need

- Python 3. Nothing else to install.
- The number of files the first answer asked for (`numberOfPages`), per state.

## Make the new set

1. Open this folder (`More files than supplied`) in File Explorer.
2. Click the address bar, type `powershell` and press Enter. A window opens in this folder.
3. Type the command below and press Enter. Put your SRN instead of `XX-MF-000000000`, or keep the placeholder and replace it in Notepad later. Put the numbers your first answers asked for instead of 25 and 5. Each number must be at least 1: for a state whose answer said 0, put 1. The option `--out` names a new, empty folder for the new set. Keep its path short, such as `C:\EUDAMED\new`, so the file paths stay short for Windows.

```
python make_request_files.py XX-MF-000000000 --registered-pages 25 --discarded-pages 5 --out C:\EUDAMED\new
```

4. The helper writes the folder you named (here `C:\EUDAMED\new`), with two folders inside:
   - `Request files`: `Registered file 01.xml` … `Registered file 25.xml` and `Discarded file 01.xml` … `Discarded file 05.xml`.
   - `Changed since`: `delta_registered.xml` and `delta_discarded.xml` (optional, see [Changed since/HOW_TO.md](../Changed%20since/HOW_TO.md)).

File numbers have two digits (01, 02 …), or three if you ask for 100 files or more, so the files sort in the right order everywhere.

## Options

All options except the SRN are optional.

| Option | What it does | Default |
|---|---|---|
| `--registered-pages` | how many Registered files to make, one per 300 devices | 20 |
| `--discarded-pages` | how many Discarded files to make, one per 300 devices | 5 |
| `--version` | the EUDAMED version written into the files | 3.0.30 |
| `--since` | the date for the changed-since files, written year-month-day | today |
| `--out` | the output folder; it must be new or empty | `request-files`, inside this folder |

Example with all options:

```
python make_request_files.py XX-MF-000000000 --registered-pages 25 --discarded-pages 5 --version 3.0.30 --since 2026-11-20 --out C:\EUDAMED\new
```

## Use the new set

Use the new set for a new full download of both states, into an empty folder, as in [Part 1](../../README.md):

1. Move all old answers out of your answers folder, into a new subfolder named with today's date, for example `old 2026-11-21`.
2. Put your SRN in the new files, if you kept the placeholder. Check that your SRN is in three places in each file.
3. Send file 1 of each state from the new set, as in steps 3 and 4 of Part 1. Save the answers as `Registered answer 01.xml` and `Discarded answer 01.xml`, and check each: `PullResponse` and `SUCCESS`.
4. Read the new `numberOfPages` in each of these answers. Send files 2 up to that number from the new set, all on the same day as file 1. Save them as `Registered answer 02.xml` … and `Discarded answer 02.xml` …, and check each. The limit of 20 Registered or 5 Discarded in step 5 of Part 1 is for the supplied files only: with the new set, do not go back to it. If the new answer asks for more files than the new set has, make a new set with that number and start again from step 1 here.
5. Do the "Before you go on" check of Part 1.
6. Click **Data → Refresh All** and do the checks of step 8 in [Part 2](../../../Part%202%20Excel/README.md).

Each run of the helper makes new IDs. Use the files of one set together. Never mix files from different sets, or from the supplied files, for the same state.

You do not need a new set just to download again: the request files you already filled in can be sent again. This was tested in the Playground, not yet in Production.

## Licence

The helper is under the MIT License (`LICENSE`). This text is under CC BY 4.0 (`LICENSE-DOCS.md`).
