const fs = require('fs');
const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

const production = process.argv.indexOf('-p') !== -1;
const css_output_template = production ? "/stylesheets/[name]-[hash].css" : "/stylesheets/[name].css";
const js_output_template = production ? "/javascripts/[name]-[hash].js" : "/javascripts/[name].js";
const images_output_template = production ? "/images/[name]-[hash].[ext]" : "/images/[name].[ext]";
const fonts_output_template = production ? "/fonts/[name]-[hash].[ext]" : "/fonts/[name].[ext]";

// TODO: Move this into it's own package.
// My docker containers don't respond to  ctrl+c and this fixes it.
process.on('SIGINT', function() {
  setTimeout(function() {
    process.exit(1);
  }, 200);
});

module.exports = {
  context: __dirname + "/app/assets",
  entry: {
    application: [
        "./javascripts/application.js",
        "../../vendor/assets/javascripts/jquery.mjs.nestedSortable.js",  // The NPM package has issues loading the correct modules
        "./stylesheets/application.scss",
    ]
  },

  output: {
    path: __dirname + "/public",
    filename: js_output_template,
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        query: {
          plugins: ['transform-runtime'],
          presets: ['es2015']
        }
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract("css-loader!sass-loader")
      },
      {
        test: /\.woff2?$/,
        loader: 'file-loader?name=' + fonts_output_template
      },
      {
        test: /.*\.(gif|png|jpe?g|svg)$/i,
        loaders: [
          'file-loader?name=' + images_output_template,
          {
            loader: 'image-webpack-loader',
            query: {
                mozjpeg: {
                  progressive: true,
                  quality: 65
                },
                pngquant: {
                  quality: "65-90",
                  speed: 4
                },
                gifsicle: {
                  interlaced: false
                },
                svgo: {
                  plugins: [
                    {
                      removeViewBox: false
                    },
                    {
                      removeEmptyAttrs: false
                    }
                  ]
                }
            }
          }
        ]
      }
    ]
  },

  plugins: [
    new ExtractTextPlugin(css_output_template),

    new CopyWebpackPlugin([
        { from: "images/static", to: "images/static" }
    ]),

    new webpack.DefinePlugin({
      SENTRY_PUBLIC_DSN: JSON.stringify(process.env.SENTRY_PUBLIC_DSN)
    }),

    function() {
      // delete previous outputs
      this.plugin("compile", function() {
        let basepath = __dirname + "/public";
        let paths = ["/javascripts", "/stylesheets"];

        for (let x = 0; x < paths.length; x++) {
          const asset_path = basepath + paths[x];

          fs.readdir(asset_path, function(err, files) {
            if (files === undefined) {
              return;
            }

            for (let i = 0; i < files.length; i++) {
              fs.unlinkSync(asset_path + "/" + files[i]);
            }
          });
        }
      });

      // output the fingerprint
      this.plugin("done", function(stats) {
        if(production) {
          let output = "# Automatically generated by webpack\nASSET_FINGERPRINT = \"" + stats.hash + "\""
          fs.writeFileSync("config/initializers/asset_fingerprint.rb", output, "utf8");
        }
      });
    }
  ]
};
