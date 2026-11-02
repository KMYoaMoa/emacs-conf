# AGENTS.md

Guidance for AI agents / assistants working in this repository.

## Source of truth: this repository

**This repo is the first and primary source of fact.**

- Answer questions, diagnose issues, and make changes based on the files in this
  repo (first and foremost `init.el`).
- When repo content and any installed/runtime copy disagree, **treat the repo as
  correct** and say so explicitly. Divergence is itself a finding worth reporting.
- Do not infer the user's intent from what happens to be installed on the machine.

## Hard rule: do not read `~/.emacs.d/` unless explicitly asked

- **Never** inspect, grep, read, diff against, or otherwise open paths under
  `~/.emacs.d/` in order to answer a question or verify behavior.
- `~/.emacs.d/` is a **deployment target**, not a source. It is written to only by
  `make install` (see `Makefile`), and its contents (`init.el`, `init.el.bak.*`,
  `elpa/`, `eln-cache/`, `auto-save-list/`, ...) are generated, stale, or local
  runtime state — not the contract.
- This includes package sources installed under `~/.emacs.d/elpa/` (e.g. `evil-*`).
  If upstream package behavior must be checked, use the repository, official
  documentation, or `webfetch`/`websearch` — or **ask the user first**.
- The only exception: the user **explicitly** asks you to look at `~/.emacs.d/`
  (e.g. "check my installed config", "why is my installed init different").
  If the request is ambiguous, ask before reading.

## Consequences / working style

- To reproduce or validate behavior, load files from this repo, e.g.:
  `emacs -Q --batch -l init.el --eval '...'`
  Do not fall back to `~/.emacs.d/init.el`.
- If a diagnosis seems to require the installed copy, state the assumption you
  are making from the repo and ask the user for permission instead of peeking.
- Prefer explaining over editing when the user says "explain, don't edit".
- Residual files in the repo such as `#init.el#`, `.#init.el`, `init.el~` are
  editor artifacts; never treat them as configuration. `init.el` is the file that
  matters, and `make install` deploys it to `$(HOME)/.emacs.d`.
