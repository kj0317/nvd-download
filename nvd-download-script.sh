# Downloads the National Vulnerability Database files from https://nvd.nist.gov
# If no parameter is specified the files will be downloaded to the current directory. Alternativly a target directory can be specified as an argument to the script.
 
#export http_proxy=http://proxy.interhack.net:3128
 
START_YEAR=2002
END_YEAR=$(date +'%Y')
DOWNLOAD_DIR=.
 
CVE_20_MODIFIED_URL='https://static.nvd.nist.gov/feeds/xml/cve/2.0/nvdcve-2.0-modified.xml.gz'
CVE_20_RECENT_URL='https://static.nvd.nist.gov/feeds/xml/cve/2.0/nvdcve-2.0-recent.xml.gz'
CVE_20_BASE_URL='https://static.nvd.nist.gov/feeds/xml/cve/2.0/nvdcve-2.0-%d.xml.gz'

 
if [[ $# -eq 1 ]] ; then
    DOWNLOAD_DIR=$1
fi
 
START_TIME=$(date +%s)
 
download () {
    echo
    echo "Starting download of $1"
    OUTPUT_FILE=${1##*/}
    wget --no-check-certificate $1 -P $DOWNLOAD_DIR -O $OUTPUT_FILE
    if [ "$?" != 0 ]; then
        echo "ERROR: Downloading of $1 failed."
        exit 1
    fi
    
    echo "Extracting $OUTPUT_FILE" 
    gzip -df $OUTPUT_FILE
    
    if [ "$?" != 0 ]; then
        echo "ERROR: Extracting of $OUTPUT_FILE failed."
        exit 1
    fi
    
    echo "Download of $1 sucessfully completed."
    echo
}
 
echo "Starting download of Modified NVD files ..."
download "$CVE_20_MODIFIED_URL"
echo "Starting download of Recent NVD files ..."
download "$CVE_20_RECENT_URL"
   

for ((i=$START_YEAR;i<=$END_YEAR;i++));
do
    download "${CVE_20_BASE_URL//%d/$i}"
done
 
END_TIME=$(date +%s)
DURATION=$((END_TIME-START_TIME))
echo "Download of NVD files successfully completed in $DURATION seconds."
