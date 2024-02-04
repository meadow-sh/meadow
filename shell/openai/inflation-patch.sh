#!/bin/sh

filename="$1"
parsed="/tmp/parsed.txt"
./shell/transcript-parse.sh "$filename" > "$parsed"
total_lines=$(wc -l < "$parsed")
start_line=1

while (( start_line <= total_lines )); do
  end_line=$((start_line + 19))

  ORIGINAL=$(sed -n "$start_line,$end_line p; $end_line q" "$parsed")

  INFLATION=$(./shell/chat-completion-parse.sh "$filename.$end_line.inflated.json")
  
  read -r -d '' MSG_USER_1 <<EOF
I am going to share a snippet from a transcript of an extemporaneous monologue I
recorded. The snippet is all the text below that comes between the lines
***ORIGINAL*** and ***END ORIGINAL***. I am also going to share a rewritten version
of the snippet. The rewritten version is all the text below that comes between the
lines ***REWRITE*** and ***END REWRITE***. Then I am going to ask you to perform
some analysis on the two snippets. Could you help me with that?

***ORIGINAL***

$ORIGINAL

***END ORIGINAL***

***REWRITE***

$INFLATION

***END REWRITE***

EOF

  read -r -d '' MSG_ASSISTANT_1 <<EOF
That sounds great, how can I help?
EOF

  read -r -d '' MSG_USER_2 <<EOF
Please read the original and the rewrite and then rewrite and decide which
topics from the original are not present in the rewrite. For each topic that
isn't included in the rewrite, write a sentence that describes the topic in the
original. Please format the list of topics as a JSON array of strings. Please do
not include anything but the JSON array (so that I can easily parse the output).
EOF

  read -r -d '' MSG_ASSISTANT_2 <<EOF
Ok, great. So you would like me to read the original and the rewrite and then
list the topics that are not included in the rewrite that were included in the
original. You want me to format the list of topics as a JSON array of strings.
The output is going to be parse as JSON, so it can't include anything but the
JSON array. Is that correct?
EOF

  read -r -d '' MSG_USER_3 <<EOF
Yes, exactly, thank you.
EOF

  OPENAI_PAYLOAD=$(jq -n \
    --arg user_1 "$MSG_USER_1" \
    --arg assistant_1 "$MSG_ASSISTANT_1" \
    --arg user_2 "$MSG_USER_2" \
    --arg assistant_2 "$MSG_ASSISTANT_2" \
    --arg user_3 "$MSG_USER_3" \
    '{model: "gpt-4", messages: [{role: "user", content: $user_1}, {role: "assistant", content: $assistant_1}, {role: "user", content: $user_2}, {role: "assistant", content: $assistant_2}, {role: "user", content: $user_3}]}')

  curl https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPEN_AI_API_KEY" \
    -d "$OPENAI_PAYLOAD" > $1.$end_line.inflation.patch.json

  start_line=$((end_line + 1))
done