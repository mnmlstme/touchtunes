In-browser musical notation editor with touch interface.

## Build

```sh
npm run build
```

### Start Server

```
export AIRTABLE_BASE_ID=<getIdfromAirtable>
export AIRTABLE_API_KEY=<getAPIKeyfromAirtable>
npm run start
```
The app will be available at `localhost:3000`


### Dev Server

``` sh
npm run dev
```

Starts the `webpack` server with HMR.
The app will be available at `localhost:8080`

### Tests

```
npm run test
```

Runs the tests using `elm-test`.
