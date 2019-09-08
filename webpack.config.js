var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var ExtractCSSPlugin = require('mini-css-extract-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

const prod = 'production';
const dev = 'development';

// determine build env
const TARGET_ENV = dev; // process.env.npm_lifecycle_event === 'build' ? prod : dev;
const isDev = TARGET_ENV == dev;
const isProd = TARGET_ENV == prod;

// entry and output path/filename variables
const entryPath = path.join(__dirname, 'src/static/index.js');
const outputPath = path.join(__dirname, 'dist');
const outputFilename = isProd ? '[name]-[hash].js' : '[name].js'

console.log('WEBPACK GO! Building for ' + TARGET_ENV);

// common webpack config (valid for dev and prod)
var commonConfig = {
    mode: TARGET_ENV,
    entry: {
        main: entryPath
    },
    output: {
        path: outputPath,
        filename: `static/js/${outputFilename}`,
    },
    resolve: {
        extensions: ['.js', '.elm'],
        modules: ['node_modules']
    },
    module: {
        rules: [{
          test: /\.svg$/,
          loader: 'svg-sprite-loader'
        }]
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: 'src/static/index.html',
            inject: 'body',
            filename: 'index.html'
        })
    ]
}

// additional webpack settings for local env (when invoked by 'npm start')
if (isDev === true) {
    module.exports = merge(commonConfig, {
        devServer: {
            // serve index.html in place of 404 responses
            historyApiFallback: true,
            contentBase: './src',
            hot: true
        },
        module: {
            rules: [{
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: [{
                  loader: "babel-loader",
                  options: {
                    plugins: [
                      "module:elm-css-modules-plugin",
                      [
                        "module:babel-elm-assets-plugin",
                        {},
                        "assets-plugin-generic"
                      ],
                      [
                        "module:babel-elm-assets-plugin",
                        {
                          // "author/project" is the default value if no "name" field is specified in elm.json.
                          package: "author/project",
                          module: "Icon.SvgAsset",
                          function: "svgAsset"
                        },
                        "assets-plugin-svg"
                      ]
                    ]
                  }
                },{
                  loader: 'elm-webpack-loader',
                  options: {
                    optimize: false,
                    verbose: true,
                    debug: true
                  }
                }]
            },{
              test: /\.css$/,
              use: [
                'style-loader',
                {
                  loader: 'css-loader',
                  options: {
                    modules: {
                      localIdentName: '[local]__[hash:base64:5]'
                    }
                  }
                }
              ]
            }]
        }
    });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (isProd === true) {
    module.exports = merge(commonConfig, {
        module: {
            rules: [{
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: 'elm-webpack-loader'
            }, {
                test: /\.css$/,
                use: ExtractCSSPlugin.extract({
                    fallback: 'style-loader',
                    use: ['css-loader'/*, 'postcss-loader'*/]
                })
            }]
        },
        plugins: [
            new ExtractCSSPlugin({
                filename: 'static/css/[name]-[hash].css',
                allChunks: true,
            }),
            new CopyWebpackPlugin([{
                from: 'src/static/img/',
                to: 'static/img/'
            }, {
                from: 'src/favicon.ico'
            }]),
        ]
    });
}
