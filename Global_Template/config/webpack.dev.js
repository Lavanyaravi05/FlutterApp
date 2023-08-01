const { merge } = require('webpack-merge');
//const ModuleFederationPlugin = require('webpack/lib/container/ModuleFederationPlugin');
const commonConfig = require('./webpack.common');
const packageJson = require('../package.json');
const { ModuleFederationPlugin } = require('webpack').container;
const {EnvironmentPlugin} = require('webpack');

const hostip = Object.values(require("os").networkInterfaces())
        .flat()
        .filter((item) => !item.internal && item.family === "IPv4")
        .find(Boolean).address;

const HOST_IP = process.env.HOST_IP?process.env.HOST_IP:hostip;  

const devConfig = {
    mode: 'development',
    output: {
        publicPath: 'http://' + HOST_IP + ':11211/',
    },
    devServer: {
        port: 11211,
        host: '0.0.0.0',
        historyApiFallback: {
           
        }
    },
    plugins: [
        new ModuleFederationPlugin({
            name: 'deduction',
            filename: 'remoteEntry.js',
            exposes: {
                './DeductionApp': './src/bootstrap'
            },
            shared: packageJson.dependencies,
        }),
        // Environment change starts - vijay d 
        new EnvironmentPlugin({
            NODE_ENV: 'development', // use 'development' unless process.env.NODE_ENV is defined
            DEBUG: false,
        })
    ]
};

module.exports = merge(commonConfig, devConfig);