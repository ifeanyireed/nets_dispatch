#!/bin/bash
echo "=== Running git remote -v ===" > push_log.txt
git remote -v >> push_log.txt 2>&1
echo "=== Running git status ===" >> push_log.txt
git status >> push_log.txt 2>&1
echo "=== Running git push ===" >> push_log.txt
git push -f -u origin main >> push_log.txt 2>&1
echo "=== Done ===" >> push_log.txt
