// import SVG sprite symbols

import ttMusic from "../Music/Views/svg";

// inject bundled Elm app into div#main
var app = require("../Main");
app.Elm.Main.init({ node: document.getElementById("main") });
