// inject bundled Elm app into div#main
var app = require( '../Main' );
app.Elm.Main.init({ node: document.getElementById( 'main' ) });
