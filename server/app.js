const express = require('express')
const app = express()
const port = 3000

app.use(function (err, req, res, next) {
  console.error(err.stack)
  res.status(500).send('Snomething broke!')
})


app.use('/app', express.static('dist'))
app.use(express.json())

app.get('/', function (req, res) {
    res.redirect('/app')
})

const scores = require('./scores')

app.get('/api/scores', scores.list);
app.get('/api/scores/:id', scores.getById);
app.post('/api/scores', scores.create);
app.put('/api/scores/:id', scores.update);

app.listen(port, () =>
    console.log(`Touchtunes server listening at http://localhost:${port}`)
)
