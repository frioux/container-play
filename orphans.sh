#!/bin/dash

echo "Parent: $$"
dash -c 'while true; do sleep 1; done' &
echo "Child 1: $!"
dash -c 'while true; do sleep 1; done' &
echo "Child 2: $!"
dash -c 'while true; do sleep 1; done' &
echo "Child 3: $!"
dash -c 'while true; do sleep 1; done' &
echo "Child 4: $!"
while true; do sleep 1; done
