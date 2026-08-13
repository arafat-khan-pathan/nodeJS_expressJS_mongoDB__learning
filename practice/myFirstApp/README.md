# MyFirstApp — quick notes

This project uses MySQL via `mysql2`. Added helper examples:

- `dbPool.js` — connection pool example (recommended)
- `dbAsync.js` — promise-based connection example (mentioned in `sql.md`)

Quick commands

```bash
# install dependencies
npm install

# start the app (if server.js is entry)
node server.js

# during development (if you have nodemon)
npx nodemon server.js
```

Notes

- If you use async/await examples, install `mysql2` (it includes promise API):

```bash
npm install mysql2
```

- Update DB credentials in `dbPool.js` or `dbAsync.js` as needed.
