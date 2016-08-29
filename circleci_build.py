#!/usr/bin/env python
import logging
import httplib
import json
import time
import argparse

logger = logging.getLogger('debug')
ch = logging.StreamHandler();
ch.setLevel(logging.DEBUG)
logger.addHandler(ch)
logger.setLevel(logging.DEBUG)

HOST='circleci.com'

def post_build(args, body_dictionary):
    json_body = json.dumps(body_dictionary)
    logger.debug('request body: {0}'.format(json_body))

    conn = httplib.HTTPSConnection(HOST)
    path = '/api/v1/project/KiiPlatform/photocolle-iOSSDK/tree/{0}?circle-token={1}'.format(args.branch, args.token)

    headers = {'content-type': 'application/json'}
    conn.request('POST', path, json_body, headers)
    response = conn.getresponse()

    responseMessage = 'Response for parameterized build:\n status:{0}\n {1}'.format(
        response.status, response.read())
    logger.debug('respose: {0}'.format(responseMessage))

def release_sdk(args):
    logger.debug('started release_sdk')
    parameters = {}
    if (args.sdk_upload_dest != None):
        parameters.update({'UPLOAD_SDK': 'true',
            'SDK_DEST': args.sdk_upload_dest})

    if (args.doc_upload):
        parameters.update({'UPLOAD_DOC': 'true'})
    if (args.pod_push):
        parameters.update({'POD_PUSH' : 'true'})
    if (args.skip_test):
        parameters.update({'SKIP_TEST': 'true'})

    body_dictionary = {}
    if parameters:
        body_dictionary = {'build_parameters':parameters}
    post_build(args, body_dictionary)

parent_parser = argparse.ArgumentParser(add_help=False)
parent_parser.add_argument('-b', '--branch', dest='branch', help='branch to build',
        required=True)
parent_parser.add_argument('-t', '--token', dest='token', help='Circle CI API token',
        required=True)

# make subcommands. release
parser = argparse.ArgumentParser(add_help=False)
sub_parser = parser.add_subparsers(help='Sub command help')

# release command
parser_release = sub_parser.add_parser('release', parents=[parent_parser], help='Release SDK')

parser_release.add_argument('-d', '--doc-upload', action='store_true',
        dest='doc_upload',
        help='upload generated java docs to gh-pages')
parser_release.add_argument('-s', '--sdk-upload', dest='sdk_upload_dest',
        choices=['test', 'release'],
        help='destination to upload generated sdk')
parser_release.add_argument('-c', '--pod-push', action='store_true',
        dest='pod_push',
        help='upload to cocoapods')
parser_release.add_argument('-st', '--skip-test', action='store_true',
        dest='skip_test',
        help='skip test execution')

parser_release.set_defaults(func=release_sdk)

args = parser.parse_args()
args.func(args)
