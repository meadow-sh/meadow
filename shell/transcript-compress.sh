#!/bin/sh

if [ -z $1 ]; then
  echo "Usage: $0 <transcript file>"
  exit 1
fi

TRANSCRIPT=$(cat "$1" | jq .text -r)

read -r -d '' USER_1 <<EOF
Everything between the lines ***BEGIN TRANSCRIPT*** and ***END TRANSCRIPT*** is a transcript
of a voice recording I made of myself while I was walking in my backyard.  I'm going to ask you
to perform some analysis of the transcript, can you help me with that?

***BEGIN TRANSCRIPT***

$TRANSCRIPT

***END TRANSCRIPT***
EOF

read -r -d '' ASSISTANT_1 <<EOF
That sounds great, how can I help?
EOF

read -r -d '' USER_2 <<EOF
The transcript is literally me walking around and talking to myself, so there's a lot of filler
words and phrases. By "filler" I mean that I repeated myself, I backtracked and changed my idea,
I wandered, I said "kind of" "sort of" etc a lot. Could you please read the transcript and output
a version that has all of the same information, but without the filler? Thanks!
EOF

PAYLOAD=$(jq -n \
  --arg user_1 "$USER_1" \
  --arg assistant_1 "$ASSISTANT_1" \
  --arg user_2 "$USER_2" \
  '{model: "gpt-4", messages: [{role: "user", content: $user_1}, {role: "assistant", content: $assistant_1}, {role: "user", content: $user_2}]}')

curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPEN_AI_API_KEY" \
  -d "$PAYLOAD" > $1.compressed.json