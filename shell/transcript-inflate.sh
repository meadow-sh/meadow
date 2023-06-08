#!/bin/sh

filename="$1"
parsed="/tmp/parsed.txt"
./shell/transcript-parse.sh "$filename" > "$parsed"
total_lines=$(wc -l < "$parsed")
start_line=1

while (( start_line <= total_lines )); do
  end_line=$((start_line + 19))

  TRANSCRIPT=$(sed -n "1,$start_line p; $end_line q" "$parsed")
  CONTINUATION=$(sed -n "$start_line,$end_line p; $end_line q" "$parsed")

  echo "-------------BEGIN TRANSCRIPT-------------"; echo
  echo $TRANSCRIPT
  echo; echo "------------END TRANSCRIPT----------------"; echo;

  echo "-------------BEGIN CONTINUATION-------------"; echo
  echo $CONTINUATION
  echo; echo "------------END CONTINUATION----------------"; echo

  read -r -d '' MSG_USER_1 <<EOF
I am going to share two snippets from a transcript of an extemporaneous
monologue I recorded. The first snippet is all the text below that comes between
the lines ***TRANSCRIPT*** and ***END TRANSCRIPT***. This snippet is the
beginning of the monologue. The second snippet is all the text below that comes
between the lines ***CONTINUATION*** and ***END CONTINUATION***. This second
snippet is the end of the monolouge. 

***TRANSCRIPT***

$TRANSCRIPT

***END TRANSCRIPT***

***CONTINUATION***

$CONTINUATION

***END CONTINUATION***

EOF

  read -r -d '' MSG_ASSISTANT_1 <<EOF
That sounds great, how can I help?
EOF

  read -r -d '' MSG_USER_2 <<EOF
Please read the transcript and the continuation and then rewrite the continuation according
to some criteria that I will now share. The first criterion is that the rewritten continuation
should remove all the filler words and phrases and artifacts of extemporaneous speech. The second criterion
is that the rewritten continuation should written as a standalone text. In other words, the rewritten
continuation should not be a continuation of the transcript, but rather a standalone text that does not require
the transcript to be understood.
EOF

  read -r -d '' MSG_ASSISTANT_2 <<EOF
Ok, great. So you would like me to rewrite the continuation as a standalone text
that does not require reading the transcript to be understood and also you would like the rewritten
continuation to be written more formally rather than as a spoken monologue?
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
    -d "$OPENAI_PAYLOAD" > $1.$end_line.inflated.json

  start_line=$((end_line + 1))
done