# Advanced and optional

You do not need this folder for a first download. Start with `QUICK_START.pdf` or the main [README](../README.md).

## What is here

| File or folder | What it is for |
|---|---|
| `test-data\` | made-up response files for 17 test cases, and `EXPECTED_RESULTS.md` |
| `validation\TOOL_VALIDATION_RECORD.md` | a validation record template |
| `tools\make_request_files.py` | optional Python helper for more pages than supplied |
| `changed-since\` | `delta_registered.xml` and `delta_discarded.xml`, for optional changed-since updates |
| `DOWNLOAD_NOTES.md` | technical notes: schema versions, state filter, pages |

## If you want to…

- **Validate the tool for your quality processes:** see [For QA and validation](../README.md#for-qa-and-validation). Use `test-data\` with `test-data\EXPECTED_RESULTS.md` and fill in `validation\TOOL_VALIDATION_RECORD.md`.
- **Download more pages than supplied** (over 20 Registered or 5 Discarded): see [More pages than supplied](../README.md#more-pages-than-supplied). It uses `tools\make_request_files.py` and needs Python 3.
- **Update with only the records changed since a date:** see [Changed-since updates (optional)](../README.md#changed-since-updates-optional). It uses the files in `changed-since\` and is less tested than a full download.

For schema versions and other technical details, see `DOWNLOAD_NOTES.md` in this folder.
