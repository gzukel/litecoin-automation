FROM ubuntu:20.04

#Create User to Run Application as, and install tools. #This will install some essential ubuntu ulitities for troubleshooting and doing the sha comparison.
RUN apt-get update -y && \
    apt-get install -y wget curl bash jq coreutils && \
    useradd -ms /bin/bash litecoinUser

USER litecoinUser
WORKDIR /home/litecoinUser

#This is the expected sha from the litecoin binary download page.
ENV APPLICATION_EXPECT_SHA="ca50936299e2c5a66b954c266dcaaeef9e91b2f5307069b9894048acf3eb5751"

#This is the version of litecoin you are downloading, This also represents the folder that will be untared with the tar command used in the CMD to start the container.
ENV LITECOIN_VERSION=litecoin-0.18.1

#This is the file name to make the automation not need hard coded values.
ENV LITECOIN_FILENAME=litecoin-0.18.1-x86_64-linux-gnu.tar.gz

#This will ensure the file being downloaded matches the expected sha above and fail pipeline if it doesn't, and untar and proceed if it does.
RUN wget https://download.litecoin.org/litecoin-0.18.1/linux/${LITECOIN_FILENAME} && \
    mkdir -p /home/litecoinUser/lite-data/ && \
    chmod -R 700 /home/litecoinUser/lite-data/ && \
    DOWNLOADED_FILE_SHA=$(sha256sum ${LITECOIN_FILENAME} | cut -d ' ' -f 1) && \
    if [ "${APPLICATION_EXPECT_SHA}" = "${DOWNLOADED_FILE_SHA}" ]; then tar xvf ${LITECOIN_FILENAME} ; else echo "Failed to validate sha" && exit 1 ; fi && \
    chown -R litecoinUser:litecoinUser ./

#Run the binary
CMD ${LITECOIN_VERSION}/bin/litecoind -datadir=/home/litecoinUser/lite-data/