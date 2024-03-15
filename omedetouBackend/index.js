// I forgot I was trying to make a backend in PHP
// Whatever maybe express JS will be easier for a basic side project

const express = require("express");
const crypto = require("crypto");
const app = express();
const port = 3000;
class Item {
  constructor(content, id = crypto.randomUUID()) {
    this.id = id;
    this.content = content;
  } 
}
// Change here so the frontend app sees this

let affirmations = [
  "おめでとう",
  "おめでたいな",
  "Congratulations",
  "Congrats",
  "Gratulacje",
  "Gratulacje",
];

let items = affirmations.map(
  (affirmation) => new Item(affirmation)
);

app.get("/", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.send(JSON.stringify(items));
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
