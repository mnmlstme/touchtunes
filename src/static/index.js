// pull in desired CSS files
require( './styles/main.css' );

// inject bundled Elm app into div#main
var app = require( '../elm/Main' );
app.Elm.Main.init({ node: document.getElementById( 'main' ) });
