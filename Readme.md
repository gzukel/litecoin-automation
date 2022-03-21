#Litecoin Automation Readme

Author: Grant Zukel

Development Time: 2.5 Hours

Date: 3/20/2022

Email: grant.zukel@gmail.com

Technologies:
 - docker
 - kubernetes
 - github actions
 - litecoin
 - bash
 - python
 - aws eks
 - anchore image scanning.

This project was done on a sunday in a few hours. I put this automation to gether to deloy litecoin node into Kubernetes as a Statefulset with persistent storage. This also has re-useable libraries, and a GitHub Action pipeline to build and deploy it.

The pipeline will also do an inline Anchore image scan and fail the pipeline if the built image doesn't pass security checks before pushing it to Kubernetes.

This also maps a vars.json file to environment variables in the github actions pipeline that persist between each step. 

This setup uses a templated statefulset file that gets template replaced when it is run in the pipeline by matching environment variables to the `-=ENV_VARNAME=-` syntax and do a 1 for 1 variable replace.

#### Disclaimer

The Libraries used in this automation we're pre-made libraries written by STUDENTS of Grant Zukel @ iDevOps.io as re-useable pipeline libraries.

## Steps to setup Github Action Pipeline:

### Step 1. SEtup Secrets

Goto settings, secrets, actions and create the following secrets in your git repo for the pipeline to utilize.

#### Github Action Secrets Required For Pipeline Usage:

 - DOCKER_USERNAME: "Docker Username - this is where you are going to push the docker image and what user gets used in the k8s secret."
 - DOCKER_PASSWORD: "Docker Password(pat) - this is a docker PAT token that will be used to login to push the image and it will also be used to create the k8s secret to pull image."
 - AWS_ACCESS_KEY_ID: "AWS Access Key - This is used to pull eks config."
 - AWS_SECRET_ACCESS_KEY: "AWS Secret Key - This is the key used to pull eks config."
 - AWS_DEFAULT_REGION: "region the eks cluster is in."

### Step 2. Edit vars/vars.json

Edit this file and put in your information to configure the docker repo, image name, and values that you want. These all get mapped to environment variables via the pre-built libraries. 

___

## Example Output From K8S:

Here is some output showing the container starting up:

    kubectl get pods -n litecoin -w
    NAME         READY   STATUS              RESTARTS   AGE
    litecoin-0   0/1     ContainerCreating   0          13s
    litecoin-0   1/1     Running             0          17s


Here is the log output of the container you should be looking for when it starts up:

    Log Output:                                                                                                                      brendazukel@Brendas-MacBook-Pro vaas % kubectl logs litecoin-0 -n litecoin
    2022-03-21T03:58:20Z Litecoin Core version v0.18.1 (release build)
    2022-03-21T03:58:20Z Assuming ancestors of block b34a457c601ef8ce3294116e3296078797be7ded1b0d12515395db9ab5e93ab8 have valid signatures.
    2022-03-21T03:58:20Z Setting nMinimumChainWork=0000000000000000000000000000000000000000000002ee655bf00bf13b4cca
    2022-03-21T03:58:20Z Using the 'sse4(1way),sse41(4way),avx2(8way)' SHA256 implementation
    2022-03-21T03:58:20Z Using RdSeed as additional entropy source
    2022-03-21T03:58:20Z Using RdRand as an additional entropy source
    2022-03-21T03:58:20Z Default data directory /home/litecoinUser/.litecoin
    2022-03-21T03:58:20Z Using data directory /home/litecoinUser/lite-data/
    2022-03-21T03:58:20Z Config file: /home/litecoinUser/lite-data/litecoin.conf (not found, skipping)
    2022-03-21T03:58:20Z Using at most 125 automatic connections (1048576 file descriptors available)
    2022-03-21T03:58:20Z Using 16 MiB out of 32/2 requested for signature cache, able to store 524288 elements
    2022-03-21T03:58:20Z Using 16 MiB out of 32/2 requested for script execution cache, able to store 524288 elements
    2022-03-21T03:58:20Z Using 8 threads for script verification
    2022-03-21T03:58:20Z scheduler thread start
    2022-03-21T03:58:20Z libevent: getaddrinfo: address family for nodename not supported
    2022-03-21T03:58:20Z Binding RPC on address ::1 port 9332 failed.
    2022-03-21T03:58:20Z HTTP: creating work queue of depth 16
    2022-03-21T03:58:20Z No rpcpassword set - using random cookie authentication.
    2022-03-21T03:58:20Z Generated RPC authentication cookie /home/litecoinUser/lite-data/.cookie
    2022-03-21T03:58:20Z HTTP: starting 4 worker threads
    2022-03-21T03:58:20Z Using wallet directory /home/litecoinUser/lite-data/
    2022-03-21T03:58:20Z init message: Verifying wallet(s)...
    2022-03-21T03:58:20Z Using BerkeleyDB version Berkeley DB 4.8.30: (April  9, 2010)
    2022-03-21T03:58:20Z Using wallet /home/litecoinUser/lite-data/
    2022-03-21T03:58:20Z BerkeleyEnvironment::Open: LogDir=/home/litecoinUser/lite-data/database ErrorFile=/home/litecoinUser/lite-data/db.log
    2022-03-21T03:58:20Z init message: Loading banlist...
    2022-03-21T03:58:20Z ERROR: DeserializeFileDB: Failed to open file /home/litecoinUser/lite-data/banlist.dat
    2022-03-21T03:58:20Z Invalid or missing banlist.dat; recreating
    2022-03-21T03:58:20Z Cache configuration:
    2022-03-21T03:58:20Z * Using 2.0 MiB for block index database
    2022-03-21T03:58:20Z * Using 8.0 MiB for chain state database
    2022-03-21T03:58:20Z * Using 440.0 MiB for in-memory UTXO set (plus up to 286.1 MiB of unused mempool space)
    2022-03-21T03:58:20Z init message: Loading block index...
    2022-03-21T03:58:20Z Opening LevelDB in /home/litecoinUser/lite-data/blocks/index
    2022-03-21T03:58:20Z Opened LevelDB successfully
    2022-03-21T03:58:20Z Using obfuscation key for /home/litecoinUser/lite-data/blocks/index: 0000000000000000
    2022-03-21T03:58:20Z LoadBlockIndexDB: last block file = 0
    2022-03-21T03:58:20Z LoadBlockIndexDB: last block file info: CBlockFileInfo(blocks=0, size=0, heights=0...0, time=1970-01-01...1970-01-01)
    2022-03-21T03:58:20Z Checking all blk files are present...
    2022-03-21T03:58:20Z Initializing databases...
    2022-03-21T03:58:20Z Pre-allocating up to position 0x1000000 in blk00000.dat
    2022-03-21T03:58:20Z Opening LevelDB in /home/litecoinUser/lite-data/chainstate
    2022-03-21T03:58:20Z Opened LevelDB successfully
    2022-03-21T03:58:20Z Wrote new obfuscate key for /home/litecoinUser/lite-data/chainstate: fbaa2fd1435e76d6
    2022-03-21T03:58:20Z Using obfuscation key for /home/litecoinUser/lite-data/chainstate: fbaa2fd1435e76d6
    2022-03-21T03:58:20Z init message: Rewinding blocks...
    2022-03-21T03:58:20Z  block index              20ms
    2022-03-21T03:58:20Z init message: Loading wallet...
    2022-03-21T03:58:20Z BerkeleyEnvironment::Open: LogDir=/home/litecoinUser/lite-data/database ErrorFile=/home/litecoinUser/lite-data/db.log
    2022-03-21T03:58:20Z [default wallet] nFileVersion = 180100
    2022-03-21T03:58:20Z [default wallet] Keys: 0 plaintext, 0 encrypted, 0 w/ metadata, 0 total. Unknown wallet records: 0
    2022-03-21T03:58:20Z [default wallet] Performing wallet upgrade to 169900
    2022-03-21T03:58:21Z [default wallet] keypool added 2000 keys (1000 internal), size=2000 (1000 internal)
    2022-03-21T03:58:21Z [default wallet] Wallet completed loading in            1065ms
    2022-03-21T03:58:21Z [default wallet] setKeyPool.size() = 2000
    2022-03-21T03:58:21Z [default wallet] mapWallet.size() = 0
    2022-03-21T03:58:21Z [default wallet] mapAddressBook.size() = 0
    2022-03-21T03:58:21Z UpdateTip: new best=12a765e31ffd4059bada1e25190f6e98c99d9714d334efa41a195a7e7e04bfe2 height=0 version=0x00000001 log2_work=20.000022 tx=1 date='2011-10-07T07:31:05Z' progress=0.000000 cache=0.0MiB(0txo)
    2022-03-21T03:58:21Z mapBlockIndex.size() = 1
    2022-03-21T03:58:21Z nBestHeight = 0
    2022-03-21T03:58:21Z Failed to open mempool file from disk. Continuing anyway.
    2022-03-21T03:58:21Z torcontrol thread start
    2022-03-21T03:58:21Z Bound to [::]:9333
    2022-03-21T03:58:21Z Bound to 0.0.0.0:9333
    2022-03-21T03:58:21Z init message: Loading P2P addresses...
    2022-03-21T03:58:21Z ERROR: DeserializeFileDB: Failed to open file /home/litecoinUser/lite-data/peers.dat
    2022-03-21T03:58:21Z Invalid or missing peers.dat; recreating
    2022-03-21T03:58:21Z init message: Starting network threads...
    2022-03-21T03:58:21Z net thread start
    2022-03-21T03:58:21Z dnsseed thread start
    2022-03-21T03:58:21Z addcon thread start
    2022-03-21T03:58:21Z Loading addresses from DNS seeds (could take a while)
    2022-03-21T03:58:21Z opencon thread start
    2022-03-21T03:58:21Z init message: Done loading
    2022-03-21T03:58:21Z msghand thread start
    2022-03-21T03:58:28Z 71 addresses found from DNS seeds
    2022-03-21T03:58:28Z dnsseed thread exit
    2022-03-21T03:58:28Z New outbound peer connected: version: 70015, blocks=2231267, peer=0
    brendazukel@Brendas-MacBook-Pro vaas % kubectl logs litecoin-0 -n litecoin -f
    2022-03-21T03:58:20Z Litecoin Core version v0.18.1 (release build)
    2022-03-21T03:58:20Z Assuming ancestors of block b34a457c601ef8ce3294116e3296078797be7ded1b0d12515395db9ab5e93ab8 have valid signatures.
    2022-03-21T03:58:20Z Setting nMinimumChainWork=0000000000000000000000000000000000000000000002ee655bf00bf13b4cca
    2022-03-21T03:58:20Z Using the 'sse4(1way),sse41(4way),avx2(8way)' SHA256 implementation
    2022-03-21T03:58:20Z Using RdSeed as additional entropy source
    2022-03-21T03:58:20Z Using RdRand as an additional entropy source
    2022-03-21T03:58:20Z Default data directory /home/litecoinUser/.litecoin
    2022-03-21T03:58:20Z Using data directory /home/litecoinUser/lite-data/
    2022-03-21T03:58:20Z Config file: /home/litecoinUser/lite-data/litecoin.conf (not found, skipping)
    2022-03-21T03:58:20Z Using at most 125 automatic connections (1048576 file descriptors available)
    2022-03-21T03:58:20Z Using 16 MiB out of 32/2 requested for signature cache, able to store 524288 elements
    2022-03-21T03:58:20Z Using 16 MiB out of 32/2 requested for script execution cache, able to store 524288 elements
    2022-03-21T03:58:20Z Using 8 threads for script verification
    2022-03-21T03:58:20Z scheduler thread start
    2022-03-21T03:58:20Z libevent: getaddrinfo: address family for nodename not supported
    2022-03-21T03:58:20Z Binding RPC on address ::1 port 9332 failed.
    2022-03-21T03:58:20Z HTTP: creating work queue of depth 16
    2022-03-21T03:58:20Z No rpcpassword set - using random cookie authentication.
    2022-03-21T03:58:20Z Generated RPC authentication cookie /home/litecoinUser/lite-data/.cookie
    2022-03-21T03:58:20Z HTTP: starting 4 worker threads
    2022-03-21T03:58:20Z Using wallet directory /home/litecoinUser/lite-data/
    2022-03-21T03:58:20Z init message: Verifying wallet(s)...
    2022-03-21T03:58:20Z Using BerkeleyDB version Berkeley DB 4.8.30: (April  9, 2010)
    2022-03-21T03:58:20Z Using wallet /home/litecoinUser/lite-data/
    2022-03-21T03:58:20Z BerkeleyEnvironment::Open: LogDir=/home/litecoinUser/lite-data/database ErrorFile=/home/litecoinUser/lite-data/db.log
    2022-03-21T03:58:20Z init message: Loading banlist...
    2022-03-21T03:58:20Z ERROR: DeserializeFileDB: Failed to open file /home/litecoinUser/lite-data/banlist.dat
    2022-03-21T03:58:20Z Invalid or missing banlist.dat; recreating
    2022-03-21T03:58:20Z Cache configuration:
    2022-03-21T03:58:20Z * Using 2.0 MiB for block index database
    2022-03-21T03:58:20Z * Using 8.0 MiB for chain state database
    2022-03-21T03:58:20Z * Using 440.0 MiB for in-memory UTXO set (plus up to 286.1 MiB of unused mempool space)
    2022-03-21T03:58:20Z init message: Loading block index...
    2022-03-21T03:58:20Z Opening LevelDB in /home/litecoinUser/lite-data/blocks/index
    2022-03-21T03:58:20Z Opened LevelDB successfully
    2022-03-21T03:58:20Z Using obfuscation key for /home/litecoinUser/lite-data/blocks/index: 0000000000000000
    2022-03-21T03:58:20Z LoadBlockIndexDB: last block file = 0
    2022-03-21T03:58:20Z LoadBlockIndexDB: last block file info: CBlockFileInfo(blocks=0, size=0, heights=0...0, time=1970-01-01...1970-01-01)
    2022-03-21T03:58:20Z Checking all blk files are present...
    2022-03-21T03:58:20Z Initializing databases...
    2022-03-21T03:58:20Z Pre-allocating up to position 0x1000000 in blk00000.dat
    2022-03-21T03:58:20Z Opening LevelDB in /home/litecoinUser/lite-data/chainstate
    2022-03-21T03:58:20Z Opened LevelDB successfully
    2022-03-21T03:58:20Z Wrote new obfuscate key for /home/litecoinUser/lite-data/chainstate: fbaa2fd1435e76d6
    2022-03-21T03:58:20Z Using obfuscation key for /home/litecoinUser/lite-data/chainstate: fbaa2fd1435e76d6
    2022-03-21T03:58:20Z init message: Rewinding blocks...
    2022-03-21T03:58:20Z  block index              20ms
    2022-03-21T03:58:20Z init message: Loading wallet...
    2022-03-21T03:58:20Z BerkeleyEnvironment::Open: LogDir=/home/litecoinUser/lite-data/database ErrorFile=/home/litecoinUser/lite-data/db.log
    2022-03-21T03:58:20Z [default wallet] nFileVersion = 180100
    2022-03-21T03:58:20Z [default wallet] Keys: 0 plaintext, 0 encrypted, 0 w/ metadata, 0 total. Unknown wallet records: 0
    2022-03-21T03:58:20Z [default wallet] Performing wallet upgrade to 169900
    2022-03-21T03:58:21Z [default wallet] keypool added 2000 keys (1000 internal), size=2000 (1000 internal)
    2022-03-21T03:58:21Z [default wallet] Wallet completed loading in            1065ms
    2022-03-21T03:58:21Z [default wallet] setKeyPool.size() = 2000
    2022-03-21T03:58:21Z [default wallet] mapWallet.size() = 0
    2022-03-21T03:58:21Z [default wallet] mapAddressBook.size() = 0
    2022-03-21T03:58:21Z UpdateTip: new best=12a765e31ffd4059bada1e25190f6e98c99d9714d334efa41a195a7e7e04bfe2 height=0 version=0x00000001 log2_work=20.000022 tx=1 date='2011-10-07T07:31:05Z' progress=0.000000 cache=0.0MiB(0txo)
    2022-03-21T03:58:21Z mapBlockIndex.size() = 1
    2022-03-21T03:58:21Z nBestHeight = 0
    2022-03-21T03:58:21Z Failed to open mempool file from disk. Continuing anyway.
    2022-03-21T03:58:21Z torcontrol thread start
    2022-03-21T03:58:21Z Bound to [::]:9333
    2022-03-21T03:58:21Z Bound to 0.0.0.0:9333
    2022-03-21T03:58:21Z init message: Loading P2P addresses...
    2022-03-21T03:58:21Z ERROR: DeserializeFileDB: Failed to open file /home/litecoinUser/lite-data/peers.dat
    2022-03-21T03:58:21Z Invalid or missing peers.dat; recreating
    2022-03-21T03:58:21Z init message: Starting network threads...
    2022-03-21T03:58:21Z net thread start
    2022-03-21T03:58:21Z dnsseed thread start
    2022-03-21T03:58:21Z addcon thread start
    2022-03-21T03:58:21Z Loading addresses from DNS seeds (could take a while)
    2022-03-21T03:58:21Z opencon thread start
    2022-03-21T03:58:21Z init message: Done loading
    2022-03-21T03:58:21Z msghand thread start
    2022-03-21T03:58:28Z 71 addresses found from DNS seeds
    2022-03-21T03:58:28Z dnsseed thread exit
    2022-03-21T03:58:28Z New outbound peer connected: version: 70015, blocks=2231267, peer=0
    2022-03-21T03:58:35Z New outbound peer connected: version: 70015, blocks=2231267, peer=1
    2022-03-21T03:58:36Z New outbound peer connected: version: 70015, blocks=2231267, peer=2
    2022-03-21T03:58:37Z New outbound peer connected: version: 70015, blocks=2231268, peer=3
    2022-03-21T03:58:38Z New outbound peer connected: version: 70015, blocks=2231268, peer=4
    2022-03-21T03:58:39Z New outbound peer connected: version: 70015, blocks=2231268, peer=5
    2022-03-21T03:58:41Z New outbound peer connected: version: 70015, blocks=2231268, peer=6
    2022-03-21T03:58:42Z New outbound peer connected: version: 70015, blocks=2231268, peer=7