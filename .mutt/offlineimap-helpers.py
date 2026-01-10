import subprocess

KEYCHAIN_SERVICE = "gmail-offlineimap"
KEYCHAIN_ACCOUNT = "elliotekj@gmail.com"
OP_SECRET_REF = "op://42uuu6jy35zg6fldljj4xco6xm/s3mtpagvsspfqyac3cqmr3y6ey/password"

def _get_from_keychain():
    try:
        return subprocess.check_output(
            ["/usr/bin/security", "find-generic-password",
             "-s", KEYCHAIN_SERVICE, "-a", KEYCHAIN_ACCOUNT, "-w"],
            text=True, stderr=subprocess.DEVNULL
        ).strip()
    except subprocess.CalledProcessError:
        return None

def _save_to_keychain(password):
    subprocess.run(
        ["/usr/bin/security", "delete-generic-password",
         "-s", KEYCHAIN_SERVICE, "-a", KEYCHAIN_ACCOUNT],
        stderr=subprocess.DEVNULL, check=False
    )
    subprocess.run(
        ["/usr/bin/security", "add-generic-password",
         "-s", KEYCHAIN_SERVICE, "-a", KEYCHAIN_ACCOUNT, "-w", password],
        check=True
    )

def _get_from_op():
    return subprocess.check_output(
        ["/opt/homebrew/bin/op", "read", OP_SECRET_REF],
        text=True
    ).strip()

def get_pass():
    password = _get_from_keychain()
    if password:
        return password
    password = _get_from_op()
    _save_to_keychain(password)
    return password

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
