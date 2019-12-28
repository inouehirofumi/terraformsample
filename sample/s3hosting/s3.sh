#!/usr/bin/bash

aws --endpoint-url=http://192.168.33.33:4572 \
	--profile localstack \
	s3 \
	cp index.html s3://hosting-test

aws --endpoint-url=http://192.168.33.33:4572 \
	--profile localstack \
	s3 \
	cp error.html s3://hosting-test
