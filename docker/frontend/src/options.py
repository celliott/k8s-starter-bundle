#!/usr/bin/python

import os

def get():
  return {
    'app_host': os.getenv('APP_NAME', '0.0.0.0'),
    'app_port': os.getenv('APP_PORT', 5000),
    'api_host': os.getenv('API_HOST', '127.0.0.1'),
    'api_port': os.getenv('API_PORT', 3000),
    'api_user': os.getenv('API_USER', 'admin'),
    'api_pass': os.getenv('API_PASS', 'mypassword'),
    'secret': os.getenv('SECRET'),
  }
