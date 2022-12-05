#! /bin/bash

# Update README and CHANGELOG for the unidata/ramadda-docker repository
# Script called from within github actions workflow

function print_help() {
cat << HELP
Usage:
$(basename $0) -m|--major-version <major-version> -f|--full-version <full-version>
    -i|--image [ -r|--readme </path/to/readme> ] [ -c|--changelog </path/to/changelog> ]
    [ -h|--help ]
    -- ARGS --
    -m|--major-version: The major version to be inserted into the changelog (ie XX)
    -f|--full-version: The full version to be inserted into the changelog (ie XX.YY.ZZ)
    -i|--image: The name of the image on dockerhub (ie unidata/ramadda-docker)
    -r|--readme: The path to the readme file to update. Defaults to "./README.md"
    -c|--changelog: The path to the changelog file to update. Defaults to "./CHANGELOG.md"
    -h|--help: Print this message and exit
HELP
}

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
        -h|--help)
            print_help
            exit 0
            ;;
        -m|--major-version)
            MAJOR_VERSION=$2
            shift
            ;;
        -f|--full-version)
            FULL_VERSION=$2
            shift
            ;;
        -i|--image)
            # Replace "/" with "\/"
            IMAGE=$(echo $2 | sed -e 's|/|\\/|g')
            shift
            ;;
        -r|--readme)
            README=$2
            shift
            ;;
        -c|--changelog)
            CHANGELOG=$2
            shift
            ;;
    esac
done


if [ -z "$MAJOR_VERSION" ]
then
    echo "Must supply a major version"
    print_help
    exit 1
fi

if [ -z "$FULL_VERSION" ]
then
    echo "Must supply a full version"
    print_help
    exit 1
fi

if [ -z "$IMAGE" ]
then
    echo "Must supply an image name"
    print_help
    exit 1
fi

# Default values
README=${README:-./README.md}
CHANGELOG=${CHANGELOG:-./CHANGELOG.md}

# Temp file for operating on the changelog
TMPCHANGELOG=/tmp/CHANGELOG.md

##########################
# BEGIN THE ACTUAL SCRIPT
##########################

# Add major version entry if it doesn't already exist
# Entry is added as "- ${IMAGE}:${MAJOR_VERSION}" immediately below the line in
# the ${README} file that has "<-- MAJOR VERSIONS -->" as a comment
grep -e "- \`${IMAGE}:${MAJOR_VERSION}\`" ${README} \
|| sed -e "/<-- MAJOR VERSIONS -->/s|.*|&\n- \`${IMAGE}:${MAJOR_VERSION}\`|" -i ${README}

# Add full version entry (ie x.y.z) if it doesn't already exist
# Similarly as above, but added below the corresponding MAJOR_VERSION entry
grep -e "unidata/ramadda-docker:${FULL_VERSION}" ${README} \
|| sed -e "/- \`${IMAGE}:${MAJOR_VERSION}\`/s|.*|&\n- \`${IMAGE}:${FULL_VERSION}\`|" -i ${README}

# Update changelog based on [Keep a Changelog](http://keepachangelog.com/)
# CHANGELOG is appended starting at the line that has the comment
# <-- BEGIN CHANGELOG --> on it
LINE=$(grep -n -e "<-- BEGIN CHANGELOG -->" ${CHANGELOG} | awk -F ":" '{print $1}')

# Output first ${LINE} lines to a tmp file
head -n ${LINE} ${CHANGELOG} > $TMPCHANGELOG

# Add changes to tmp file
cat >> $TMPCHANGELOG << EOF
## [${FULL_VERSION}] - $(date +%Y-%m-%d)

### Changed

- Updated Dockerfile to build RAMADDA ${FULL_VERSION}
- Update produced by GitHub Actions workflow
- See the [main RAMADDA repo](https://github.com/geodesystems/ramadda) for more info

EOF

# Add older changes to tmp file
tail -n +$((LINE+1)) ${CHANGELOG} >> $TMPCHANGELOG

# Apply changes to CHANGELOG
cp $TMPCHANGELOG $CHANGELOG
