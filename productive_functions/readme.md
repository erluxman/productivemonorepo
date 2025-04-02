# Productive Firebase Function setup

## Cloud Run

## Local Run

`firebase emulators:start --import=./firebase-data --export-on-exit=./firebase-data`

## Common Errors & Troubleshooting

1. when we see the error "Header name must be a valid HTTP token ["* import function triggers from their respective submodules"]", we need to reload the window from command palette
2. To clear the ports run `restFunctions` command that is in Bash Aliases 3.```bash

alias restFunctions="lsof -ti:4400,4500,8080 | xargs kill -9"

```

```
