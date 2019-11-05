#!/usr/bin/env node

const express = require('express');
const basicAuth = require('basic-auth');
const logger = require('morgan');
const data = require('./data');

const api_port = process.env['API_PORT'] || 3000;
const api_host = process.env['API_HOST'] || '0.0.0.0';
const api_user = process.env['API_USER'] || 'admin';
const api_pass = process.env['API_PASS'] || 'mypassword';

require('newrelic');

const app = express();
app.use(logger('dev'));

var auth = function (req, res, next) {
  function unauthorized(res) {
    res.set('WWW-Authenticate', 'Basic realm=Authorization Required');
    return res.status(401).send({ msg: 'Not Authorized' })
  }
  var user = basicAuth(req)
  if (!user || !user.name || !user.pass) {
    return unauthorized(res);
  }
  if (user.pass === api_pass) {
    return next();
  } else {
    return unauthorized(res);
  }
}

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

app.get('/healthz', function(req, res, next) {
  res.status(200).send({status: "ok"});
})

app.get('/', auth, function(req, res, next) {
  setTimeout(function(){
    res.status(200).send(data);
  }, getRandomInt(300));
})

app.get('/v2', auth, function(req, res, next) {
  setTimeout(function(){
    res.status(200).send("<!> /v2 coming Soon... </!>");
  }, getRandomInt(1000));
})

app.get('/:path', function(req, res) {
  var path = req.params.path
  if (parseInt(path)) {
    res.status(path).send();
  } else {
    res.status(200).send(path);
  }
});

app.listen(api_port, api_host, function(){
  console.log(`Running on http://${api_host}:${api_port}`);
})
