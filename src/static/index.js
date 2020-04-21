// import SVG sprite symbols

import ttMusicSvg from "../Music/Views/svg";
// import ttMusicCss from "../Music/Views/css";

// inject bundled Elm app into div#main
var app = require("../Main");
app.Elm.Main.init({ node: document.getElementById("main") });
