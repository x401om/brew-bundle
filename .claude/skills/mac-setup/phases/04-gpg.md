# Phase 4 — GPG signing key import

Import the GPG private key from the migration bundle so `git commit -S` (signed commits) works.

## Idempotency check

```bash
gpg --list-secret-keys CE5189648157F28F >/dev/null 2>&1
```

If passes → key already imported, skip.

## Steps

### 4.1 Locate the migration bundle

Ask the user: "Положил ли ты `gpg-private.asc` и `gpg-trust.txt` (со старого мака) в `~/Downloads/migration/`? (y/n)"

If no → tell them how to do it (re-read Phase A in the README) and pause.

### 4.2 Import the key

```bash
cd ~/Downloads/migration

gpg --import gpg-private.asc
gpg --import-ownertrust gpg-trust.txt
```

### 4.3 Set ultimate trust on the key

```bash
gpg --list-secret-keys --keyid-format=long
```

Should show `CE5189648157F28F`. Now set trust=5 (ultimate) so git can use it without warnings:

```bash
expect -c '
spawn gpg --edit-key CE5189648157F28F
expect "gpg>"
send "trust\r"
expect "Your decision?"
send "5\r"
expect "really want to set this key to ultimate trust?"
send "y\r"
expect "gpg>"
send "quit\r"
expect eof
' 2>/dev/null || {
    echo "expect not available — do it manually:"
    echo "  gpg --edit-key CE5189648157F28F"
    echo "  > trust"
    echo "  > 5"
    echo "  > y"
    echo "  > quit"
}
```

### 4.4 Test git signing

```bash
echo "test" | gpg --clearsign --default-key CE5189648157F28F
```

Should produce a signed message. If it asks for passphrase — enter it; pinentry-mac will offer to save it in Keychain.

### 4.5 Securely delete the bundle

```bash
rm -rf ~/Downloads/migration
```

## Completion

Mark phase 4 completed. Tell the user "GPG ключ импортирован, можно делать signed commits".
