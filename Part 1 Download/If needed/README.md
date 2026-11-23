# If needed

You do not need this for a first download. Start with the steps of [Part 1](../README.md). Come here only if one of these happens.

## If this happens, read this

| If this happens | Read this | Use these files |
|---|---|---|
| **More devices than the supplied files**: the first answer says more than 20 Registered files (more than 6,000 devices) or more than 5 Discarded files (more than 1,500 devices) | [More files than supplied/HOW_TO.md](More%20files%20than%20supplied/HOW_TO.md) | `More files than supplied\make_request_files.py` (needs Python 3) |
| **EUDAMED refuses because of the version**: the refusal says the version is wrong and names the version it expects | [TECHNICAL_NOTES.md](../../Part%203%20Validate/TECHNICAL_NOTES.md#version-of-the-request-files), "Version of the request files" | the request files you send, from `Part 1 Download\Request files` |
| **You want only what changed since a date** (optional, less tested than a full download) | [Changed since/HOW_TO.md](Changed%20since/HOW_TO.md) | `Changed since\delta_registered.xml` and `Changed since\delta_discarded.xml` |

For any other problem, see [Part 3, Troubleshoot](../../Part%203%20Validate/README.md#troubleshoot). The technical background (columns, states, file counts, versions, folder rules) is in [TECHNICAL_NOTES.md](../../Part%203%20Validate/TECHNICAL_NOTES.md).

## Licence

The Python helper and the request files are under the MIT License (`LICENSE`). The texts are under CC BY 4.0 (`LICENSE-DOCS.md`).
