#!/usr/bin/env sh

curl "https://raw.githubusercontent.com/Darukutsu/keystrokes/refs/heads/env-access/keystrokes-libinput" --create-dirs -o /usr/local/share/keystrokes/keystrokes-libinput
curl "https://raw.githubusercontent.com/Darukutsu/keystrokes/refs/heads/env-access/keystrokes" --create-dirs -o /usr/local/bin/keystrokes
curl "https://raw.githubusercontent.com/Darukutsu/keystrokes/refs/heads/env-access/com.github.keystrokes.policy" --create-dirs -o /usr/share/polkit-1/actions/com.github.keystrokes.policy
curl "https://raw.githubusercontent.com/Darukutsu/keystrokes/refs/heads/env-access/com.github.keystrokes.rules" --create-dirs -o /usr/share/polkit-1/rules.d/com.github.keystrokes.rules

for file in /usr/local/share/keystrokes/keystrokes-libinput /usr/local/bin/keystrokes; do
  chmod 755 "$file"
  chown root:root "$file"
done

for file in /usr/share/polkit-1/actions/com.github.keystrokes.policy /usr/share/polkit-1/rules.d/com.github.keystrokes.rules; do
  chmod 644 "$file"
  chown root:root "$file"
done
