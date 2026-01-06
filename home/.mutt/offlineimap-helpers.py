import subprocess

def get_pass():
    return subprocess.check_output(
        ["/opt/homebrew/bin/op", "read", "op://42uuu6jy35zg6fldljj4xco6xm/s3mtpagvsspfqyac3cqmr3y6ey/password"],
        text=True
    ).strip()

LOCAL_TO_REMOTE = {
    'inbox':   'INBOX',
    'sent':    '[Gmail]/Sent Mail',
    'drafts':  '[Gmail]/Drafts',
    'trash':   '[Gmail]/Trash',
    'archive': '[Gmail]/All Mail',
}

REMOTE_TO_LOCAL = {v: k for k, v in LOCAL_TO_REMOTE.items()}

REMOTE_FOLDERS = list(LOCAL_TO_REMOTE.values())

def nametrans_local(folder):
    return LOCAL_TO_REMOTE.get(folder, folder)

def nametrans_remote(folder):
    return REMOTE_TO_LOCAL.get(folder, folder)

def folderfilter(folder):
    return folder in REMOTE_FOLDERS
