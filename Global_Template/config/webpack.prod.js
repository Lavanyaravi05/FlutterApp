const { merge } = require('webpack-merge');
//const ModuleFederationPlugin = require('webpack/lib/container/ModuleFederationPlugin');
const { ModuleFederationPlugin } = require('webpack').container;
const {EnvironmentPlugin} = require('webpack');
const commonConfig = require('./webpack.common');

const prodConfig = {
    mode: 'production',
    output: {
        filename: '[name].[contenthash].js',
        publicPath: '/mfp/deduction/',
    },
    plugins: [
        new ModuleFederationPlugin({
            name: 'deduction',
            filename: 'remoteEntry.js',
            exposes: {
                './DeductionApp': './src/bootstrap'
            },
            shared: ['react', 'react-dom']
        }),
        new EnvironmentPlugin({
            NODE_ENV: 'production', // use 'development' unless process.env.NODE_ENV is defined
            DEBUG: false,
        })
    ]

};
module.exports = merge(commonConfig, prodConfig);