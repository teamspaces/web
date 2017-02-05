const fs = require('fs');
const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");

const prod = process.argv.indexOf('-p') !== -1;
const css_output_template = prod ? "/stylesheets/[name]-[hash].css" : "/stylesheets/[name].css";
const js_output_template = prod ? "/javascripts/[name]-[hash].js" : "/javascripts/[name].js";
const images_output_template = prod ? "/images/[name]-[hash].[ext]" : "/images/[name].[ext]"

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
    application: ["./javascripts/application.js", "./stylesheets/application.css"]
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
          presets: ['es2017']
        }
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("css-loader!sass-loader")
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
        let output = "ASSET_FINGERPRINT = \"" + stats.hash + "\""
        fs.writeFileSync("config/initializers/asset_fingerprint.rb", output, "utf8");
      });
    }
  ]
};
