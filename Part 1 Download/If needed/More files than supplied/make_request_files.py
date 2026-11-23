"""Make a fresh set of EUDAMED request files (for a device download, DEVICE.GET).

Optional helper. Use it only if you need more files than the package supplies (more than
20 Registered or 5 Discarded files, so more than 6,000 Registered or 1,500 Discarded
devices), or a fresh set with new IDs.

Each run makes NEW IDs. Files from one run do not join files from another run or the
supplied files. If you need more files for a state, make a whole new set and send that
state again from its file 1. Do not mix its files with older ones.

Writes two folders into the output folder:
  Request files    Registered file 01.xml ... and Discarded file 01.xml ...
                   (one file per 300 devices; all files of one state belong together,
                   technically: they share one conversationID, and each file has its own
                   correlationID and messageID; file 1 asks for page 0, file 2 for page 1 ...)
  Changed since    delta_registered.xml and delta_discarded.xml (devices changed on or
                   after the --since date)

File numbers have two digits (01, 02 ...), or three if you ask for 100 files or more, so
the files sort in the right order everywhere.

Needs Python 3 only (nothing to install). The files only read data from EUDAMED; they
change nothing there.

Run, for example:
  python make_request_files.py XX-MF-000000000
  python make_request_files.py XX-MF-000000000 --registered-pages 25 --discarded-pages 5
  python make_request_files.py XX-MF-000000000 --version 3.0.30 --since 2026-11-20 --out my-requests

Give your own SRN instead of XX-MF-000000000 to write it straight into the files, or keep the
placeholder and replace it later in Notepad.
"""
import argparse
import datetime
import os
import re
import sys
import uuid

PAGE_SIZE = 300

FULL_TEMPLATE = """<?xml version="1.0" encoding="utf-8"?>
<!-- Device download request: {state} devices, page {page} (devices {first} to {last}). Reads data only. -->
<m:PullRequest version="{version}" xmlns:m="https://ec.europa.eu/tools/eudamed/dtx/servicemodel/Message/v1" xmlns:s="https://ec.europa.eu/tools/eudamed/dtx/servicemodel/Service/v1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<m:conversationID>{conv}</m:conversationID>
	<m:correlationID>{corr}</m:correlationID>
	<m:creationDateTime>{now}</m:creationDateTime>
	<m:messageID>{msg}</m:messageID>
	<m:recipient>
		<m:node>
			<s:nodeActorCode>EUDAMED</s:nodeActorCode>
			<s:nodeID>eDelivery:EUDAMED</s:nodeID>
		</m:node>
		<m:service>
			<s:serviceID>DEVICE</s:serviceID>
			<s:serviceOperation>GET</s:serviceOperation>
		</m:service>
	</m:recipient>
	<m:payload/>
	<m:sender>
		<m:node>
			<s:nodeActorCode>{srn}</s:nodeActorCode>
			<s:nodeID>eDelivery:{srn}</s:nodeID>
		</m:node>
		<m:service>
			<s:serviceID>REPLY_SERVICE</s:serviceID>
			<s:serviceOperation>GET</s:serviceOperation>
		</m:service>
	</m:sender>
	<m:pageNumber>{page}</m:pageNumber>
	<m:pageSize>{page_size}</m:pageSize>
	<m:criteriaPayload>
		<m:diDownloadCriteria>
			<s:MFActorCode>{srn}</s:MFActorCode>
			<s:State>{STATE}</s:State>
		</m:diDownloadCriteria>
	</m:criteriaPayload>
</m:PullRequest>
"""

DELTA_TEMPLATE = """<?xml version="1.0" encoding="utf-8"?>
<!-- "Changed since" request: {state} devices changed on or after the date below. Reads data only. -->
<m:PullRequest version="{version}" xmlns:m="https://ec.europa.eu/tools/eudamed/dtx/servicemodel/Message/v1" xmlns:s="https://ec.europa.eu/tools/eudamed/dtx/servicemodel/Service/v1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<m:conversationID>{conv}</m:conversationID>
	<m:correlationID>{corr}</m:correlationID>
	<m:creationDateTime>{now}</m:creationDateTime>
	<m:messageID>{msg}</m:messageID>
	<m:recipient>
		<m:node>
			<s:nodeActorCode>EUDAMED</s:nodeActorCode>
			<s:nodeID>eDelivery:EUDAMED</s:nodeID>
		</m:node>
		<m:service>
			<s:serviceID>DEVICE</s:serviceID>
			<s:serviceOperation>GET</s:serviceOperation>
		</m:service>
	</m:recipient>
	<m:payload/>
	<m:sender>
		<m:node>
			<s:nodeActorCode>{srn}</s:nodeActorCode>
			<s:nodeID>eDelivery:{srn}</s:nodeID>
		</m:node>
		<m:service>
			<s:serviceID>REPLY_SERVICE</s:serviceID>
			<s:serviceOperation>GET</s:serviceOperation>
		</m:service>
	</m:sender>
	<m:pageNumber>0</m:pageNumber>
	<m:pageSize>{page_size}</m:pageSize>
	<m:criteriaPayload>
		<m:diDownloadCriteria>
			<s:MFActorCode>{srn}</s:MFActorCode>
			<!-- CHANGE THIS DATE to the day of your last download (year-month-day). Change nothing else. -->
			<s:UDIDIVersionDate>{date}</s:UDIDIVersionDate>
			<s:State>{STATE}</s:State>
		</m:diDownloadCriteria>
	</m:criteriaPayload>
</m:PullRequest>
"""


def write(path, text):
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def main():
    p = argparse.ArgumentParser(description="Make fresh EUDAMED request files for a device download.")
    p.add_argument("srn", help="your SRN, e.g. XX-MF-000000000 (the placeholder) or your own")
    p.add_argument("--registered-pages", type=int, default=20, help="how many Registered files to make, one per 300 devices (default 20)")
    p.add_argument("--discarded-pages", type=int, default=5, help="how many Discarded files to make, one per 300 devices (default 5)")
    p.add_argument("--version", default="3.0.30", help="EUDAMED version written into the files (default 3.0.30)")
    p.add_argument("--since", default=datetime.date.today().isoformat(),
                   help="date for the changed-since files, YYYY-MM-DD (default: today)")
    p.add_argument("--out", default="request-files", help="new output folder (default: request-files)")
    a = p.parse_args()

    # These checks catch typing errors only. They cannot tell whether EUDAMED knows the SRN or version.
    if not re.fullmatch(r"[A-Z]{2}-MF-[0-9]{9}", a.srn):
        sys.exit(f"'{a.srn}' does not look like a manufacturer SRN (for example XX-MF-000000000).")
    if not re.fullmatch(r"[0-9]+(\.[0-9]+)+", a.version):
        sys.exit(f"'{a.version}' does not look like a schema version (for example 3.0.30).")
    try:
        if not re.fullmatch(r"[0-9]{4}-[0-9]{2}-[0-9]{2}", a.since):
            raise ValueError
        datetime.date.fromisoformat(a.since)
    except ValueError:
        sys.exit(f"'{a.since}' is not a date written YYYY-MM-DD (for example 2026-11-20).")
    if a.registered_pages < 1 or a.discarded_pages < 1:
        sys.exit("The number of files must be at least 1.")

    # Never mix a new set with older files: they would carry different IDs.
    if os.path.exists(a.out) and (not os.path.isdir(a.out) or os.listdir(a.out)):
        sys.exit(f"The output folder '{a.out}' already exists and is not empty. "
                 "Choose a new folder with --out, for example --out new-requests.")

    full_dir = os.path.join(a.out, "Request files")
    delta_dir = os.path.join(a.out, "Changed since")
    os.makedirs(full_dir, exist_ok=True)
    os.makedirs(delta_dir, exist_ok=True)
    now = datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()

    count = 0
    for state, pages in (("registered", a.registered_pages), ("discarded", a.discarded_pages)):
        conv = uuid.uuid4()  # one conversation per state: all its files belong together
        width = max(2, len(str(pages)))  # 01, 02 ... (001 ... from 100 files)
        for page in range(pages):
            xml = FULL_TEMPLATE.format(version=a.version, conv=conv, corr=uuid.uuid4(), msg=uuid.uuid4(),
                                       now=now, srn=a.srn, page=page, page_size=PAGE_SIZE,
                                       first=page * PAGE_SIZE + 1, last=(page + 1) * PAGE_SIZE,
                                       state=state, STATE=state.upper())
            write(os.path.join(full_dir, f"{state.capitalize()} file {page + 1:0{width}d}.xml"), xml)
            count += 1
        xml = DELTA_TEMPLATE.format(version=a.version, conv=uuid.uuid4(), corr=uuid.uuid4(), msg=uuid.uuid4(),
                                    now=now, srn=a.srn, page_size=PAGE_SIZE, date=a.since,
                                    state=state, STATE=state.upper())
        write(os.path.join(delta_dir, f"delta_{state}.xml"), xml)
        count += 1

    print(f"Wrote {count} request files to {os.path.abspath(a.out)}")
    print(f"  Request files: {a.registered_pages} Registered files (up to {a.registered_pages * PAGE_SIZE} devices), "
          f"{a.discarded_pages} Discarded files (up to {a.discarded_pages * PAGE_SIZE} devices)")
    print(f"  Changed since: date {a.since}")
    print(f"  EUDAMED version {a.version}, SRN {a.srn}")


if __name__ == "__main__":
    main()
