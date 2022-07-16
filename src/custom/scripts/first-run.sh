#!/bin/sh

echo "First Time => This is script in /webphp/custom/scripts/first-run.sh"
echo "First Time => This script will only run once, the first time your container runs"
echo "First Time =>   You can override this script by mounting your custom script in /webphp/custom/scripts/first-run.sh";
echo "First Time =>   Or if you have more files, you can override the complete folder /webphp/custom/scripts, then you must include a file named first-run.sh";
