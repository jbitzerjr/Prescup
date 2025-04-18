shop-smart:~/shop-smart# cd ..
shop-smart:~# cat init.sh 
#!/bin/sh

ADJECTIVES="fuzzy tartan haunted evil cryptic dumb cursed filthy moldy broken"
NOUNS="squirrel chainsaw gremlin possum priest curse toaster goblin"
FLAG_LOG="/root/current_tokens.txt"
> "$FLAG_LOG"

# Find total number of placeholders
TOTAL=$(grep -r "TOKEN: ########" /root | wc -l)
echo "Found $TOTAL flag slots."

# Replace each one with a unique flag
for i in $(seq 1 $TOTAL); do
  ADJ=$(shuf -n1 -e $ADJECTIVES)
  NOUN=$(shuf -n1 -e $NOUNS)
  HEX=$(head -c4 /dev/urandom | base64 | tr -dc 'a-f0-9' | head -c4)
  FLAG="{flag} ${ADJ}-${NOUN}-${HEX}"

  find /root -type f -name '*.php' -exec sed -i "0,/TOKEN: ########/s//${FLAG}/" {} +
  echo "FLAG $i: $FLAG" >> "$FLAG_LOG"
done

cd /root/shop-smart # change to the shop-smart directory, you need to be in the same directory as the docker-compose.yml file, so alter this line if needed.
docker compose up -d