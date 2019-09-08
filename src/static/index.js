// pull in desired CSS files
require( './styles/main.css' );

// inject bundled Elm app into div#main
var bundle = require( '../elm/Main' );
bundle.Elm.Main.init({ node: document.getElementById( 'main' ) });
