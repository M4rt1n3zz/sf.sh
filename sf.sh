#!/bin/bash

YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

usage() {
    echo -e "${YELLOW}[${RED}!${YELLOW}] Usage: ${RED}$0 <domain> [-o <output_file>] [-a <for all include 'www'>${NC}"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

DOMAIN=$1
OUTPUT_FILE=""
INCLUDE_ALL=false

shift
while getopts "o:a" opt; do
    case $opt in
        o)
            OUTPUT_FILE=$OPTARG
            ;;
        a)
            INCLUDE_ALL=true
            ;;
        *)
            usage
            ;;
    esac
done

if ! command -v jq &> /dev/null; then
    echo "${RED}[-] jq is required but it's not installed. Please install jq and try again.${NC}"
    exit 1
fi

echo -e "${YELLOW}[${RED}!${YELLOW}] Fetching subdomains for [${RED}$DOMAIN${YELLOW}] from ${GREEN}crt.sh...${NC}"

if $INCLUDE_ALL; then
    SUBDOMAINS=$(curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | \
        jq -r '.[].name_value' | \
        sed 's/\*\.//g' | \
        sort -u)
else
    SUBDOMAINS=$(curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | \
        jq -r '.[].name_value' | \
        sed 's/\*\.//g' | \
        grep -v "^www\." | \
        sort -u)
fi

echo "$SUBDOMAINS"

if [ -n "$OUTPUT_FILE" ]; then
    echo "$SUBDOMAINS" > "$OUTPUT_FILE"
    echo -e "${YELLOW}[${GREEN}+${YELLOW}] Subdomains saved to ${RED}$OUTPUT_FILE${NC}"
fi

COUNT=$(echo "$SUBDOMAINS" | wc -l)

if $INCLUDE_ALL; then
    echo -e "${YELLOW}[${GREEN}+${YELLOW}] Total subdomains ${RED}(including 'www'):${NC} $COUNT"
else
    echo -e "${YELLOW}[${GREEN}+${YELLOW}] Total subdomains ${RED}(excluding 'www'):${NC} $COUNT"
fi