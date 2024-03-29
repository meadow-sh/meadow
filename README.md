# Meadow

Meadow is a toolkit for losing yourself in thought without losing your thoughts.
The near-term goal is to build a tool that helps you compose structured notes,
blog posts, and essays using audio as the primary input method. The long-term
goal is to build a framework that enables general hands-free education and
knowledge work. I'm imagining a world where a 14-year-old can ride her bike to
school and do her homework at the same time or a mom can cook dinner and study
the fall of Rome at the same time or a backpacker can hike the Appalachian Trail
and write his PhD thesis. 

**Note** The _immediate_ goal is to build the tool that I myself want to use. I
personally have a very strong desire to use Meadow and, for the time being, I'm
going to build a tool with my own needs in mind. Additionally, I'm going to use
this project as a way to learn about a few different technologies that I've been
wanting to learn about (charm.sh, golang, advanced shell scripting, AI-assisted
graphic design, etc).

# v0 Requirements

The very first version of Meadow will be a library of shell scripts that use the
following stack:

- bash
- ffmpeg
- OpenAI

The requirements for the first version of Meadow are:

- [x] Given an audio file, generate transcript.
- [x] Given a transcript, generate a list of topics.
- [x] Given a transcript, transform/inflate into a more readable format.
- [x] Given an inflation, generate a list of topics that were lost.
- [ ] Given a transcript and a list of topics, generate a list of summaries.

# v1 Requirements

- Incorporate some kind of rudimentary data store so that I don't have to use
  local gitignored files
- Build some form of a push-button recorder so I don't have to use the voice memo
  app on my phone and AirDrop the files to my computer.

# v2 Vision

The second version of Meadow will probably incorporate a charm.sh-based UI, but
I'm not sure, it could be the case that the shell scripts are sufficient for my
needs. I'm going to start with the shell scripts and then see how far I can get.

I think a decent target UX right now would be to have a way to copy-paste text
into a specific file and then run certain prompts against it.

# Roadmap (Maybe)

- [ ] Use some super sweet AI tools to generate some branding
  - [ ] Build a static website with a cool animation (I'm imagining some kind of
    looping animation that all those lofi-hiphop youtube channels use).
  - [ ] Design a logo.
- [ ] Write a short essay or blog post that describes the vision for Meadow.
- [ ] Select some text, generate a summary.
- [ ] Given some text, generate a list of related sources
- [ ] Given some text, generate a list of counterpoints
- [ ] Given some text, generate a list of evidence
- [ ] Select a section in a document, record audio, generate transcript, and
  insert into document. 
- [ ] Eventually, I'd like to be able to use audio during the iterative phase of
  composing a document, rather than in only the generative phase.

# Further Reading

- [Language Model Sketchbook](https://maggieappleton.com/lm-sketchbook)

# WIP Notes from 2024-02-03 Revamp

- Went back to the bash-first approach. It actually feels kind of ok.
- Didn't delete the go files yet, maybe I'll still use go for the CLI.
- I got whisper working locally, seems promising.
- I kind of (but also kind of not) expanded the scope. Instead of making this
  project 100% about AI, the specific scope is stream-of-thought note-taking.
  AI can help a lot, but I think there's lots of ways where non-agent AI can
  help. This is a bit of a new train of thought. For example, if I'm sitting at
  my desk reading, I can record an audio snippet, transcribe it, parse it for an
  indication that I'm trying to figure something out or don't understand
  something, and have a simple script that collects context from the web.
- The last thing I did was get live transcription "working". It works in the
  sense that the code runs and transcripts show up, but it looks like not
  everything is getting transcribed and/or things get transcribed in a way that
  makes it not obvious what's happening. __Good idea for next milestone:__ I
  want the live transcription to be just good enough that I know that my audio
  file was saved correctly.