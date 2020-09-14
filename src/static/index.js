// import SVG sprite symbols

import ttMusicSvg from "../Music/Views/svg";
import ttAppSvg from "../TouchTunes/Views/svg";

// inject bundled Elm app into div#main
var app = require("../Main");
app.Elm.Main.init({ node: document.getElementById("main") });
