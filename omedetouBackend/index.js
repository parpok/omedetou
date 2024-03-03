// I forgot I was trying to make a backend in PHP
// Whatever maybe express JS will be easier for a basic side project

// RN Ill leave hello world

const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})

