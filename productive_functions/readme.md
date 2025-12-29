# Productive Firebase Function setup

## Cloud Run

## Local Run

`firebase emulators:start --import=./firebase-data --export-on-exit=./firebase-data`

## Common Errors & Troubleshooting

1. when we see the error "Header name must be a valid HTTP token ["* import function triggers from their respective submodules"]", we need to reload the window from command palette
2. To clear the ports run `restFunctions` command that is in Bash Aliases 3.```bash

alias resetEmulators="lsof -ti:4400,4500,8080 | xargs kill -9"

alias startEmulators="firebase emulators:start --import=./firebase-data --export-on-exit=./firebase-data"

```

```

To deploy the functions, we need to run the following command:

```bash
firebase deploy --only functions
```

To call the functions, using HTTP we need to call the following rest api

```bash
curl http://localhost:5002/todo-app-4200/us-central1/createTodo
```

and the firebase function urls are

```bash
https://us-central1-productive-78c0e.cloudfunctions.net/createUser
```

# Install Google Cloud SDK (on macOS)

brew install --cask google-cloud-sdk

# Then authenticate and clean up

```bash
gcloud auth login gcloud container images list-tags gcr.io/productive-78c0e/us/gcf --format="get(digest)" | while read digest; do gcloud container images delete "gcr.io/productive-78c0e/us/gcf@$digest" --quiet; done
```
