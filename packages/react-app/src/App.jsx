import {
  Box,
  Button,
  Center,
  Container,
  Flex,
  Grid,
  GridItem,
  Heading,
  HStack,
  Image,
  Input,
  List,
  ListItem,
  Stack,
  Text,
} from "@chakra-ui/react";
import {
  useBalance,
  useContractLoader,
  useContractReader,
  useGasPrice,
  usePoller,
  useUserProviderAndSigner,
} from "eth-hooks";
import { useExchangeEthPrice } from "eth-hooks/dapps/dex";
import { useEventListener } from "eth-hooks/events";
import React, { useCallback, useEffect, useState } from "react";
import { Link, Route, Switch, useLocation } from "react-router-dom";
import "./App.css";
import {
  Account,
  Address,
  AddressInput,
  //Contract,
  //Faucet,
  GasGauge,
  Header,
  Ramp,
  ThemeSwitch,
  NetworkDisplay,
  FaucetHint,
  //NetworkSwitch,
} from "./components";
import { NETWORKS, ALCHEMY_KEY } from "./constants";
import externalContracts from "./contracts/external_contracts";
// contracts
import deployedContracts from "./contracts/hardhat_contracts.json";
import { Transactor, Web3ModalSetup } from "./helpers";
import { useStaticJsonRPC } from "./hooks";

const { ethers } = require("ethers");
/*
    Welcome to 🏗 scaffold-eth !

    Code:
    https://github.com/scaffold-eth/scaffold-eth

    Support:
    https://t.me/joinchat/KByvmRe5wkR-8F_zz6AjpA
    or DM @austingriffith on twitter or telegram

    You should get your own Alchemy.com & Infura.io ID and put it in `constants.js`
    (this is your connection to the main Ethereum network for ENS etc.)


    🌏 EXTERNAL CONTRACTS:
    You can also bring in contract artifacts in `constants.js`
    (and then use the `useExternalContractLoader()` hook!)
*/

/// 📡 What chain are your contracts deployed to?
const initialNetwork = NETWORKS.localhost; // <------- select your target frontend network (localhost, rinkeby, xdai, mainnet)

// 😬 Sorry for all the console logging
const DEBUG = true;
const NETWORKCHECK = true;
const USE_BURNER_WALLET = true; // toggle burner wallet feature
const USE_NETWORK_SELECTOR = false;

const web3Modal = Web3ModalSetup();

// 🛰 providers
const providers = [
  "https://eth-mainnet.gateway.pokt.network/v1/lb/611156b4a585a20035148406",
  `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_KEY}`,
  "https://rpc.scaffoldeth.io:48544",
];

function App(props) {
  // specify all the chains your app is available on. Eg: ['localhost', 'mainnet', ...otherNetworks ]
  // reference './constants.js' for other networks
  const networkOptions = [initialNetwork.name, "mainnet", "rinkeby"];

  const [injectedProvider, setInjectedProvider] = useState();
  const [address, setAddress] = useState();
  const [selectedNetwork, setSelectedNetwork] = useState(networkOptions[0]);
  const location = useLocation();

  /// 📡 What chain are your contracts deployed to?
  const targetNetwork = NETWORKS[selectedNetwork]; // <------- select your target frontend network (localhost, rinkeby, xdai, mainnet)

  // 🔭 block explorer URL
  const blockExplorer = targetNetwork.blockExplorer;

  // load all your providers
  const localProvider = useStaticJsonRPC([
    process.env.REACT_APP_PROVIDER ? process.env.REACT_APP_PROVIDER : targetNetwork.rpcUrl,
  ]);
  const mainnetProvider = useStaticJsonRPC(providers);

  if (DEBUG) console.log(`Using ${selectedNetwork} network`);

  // 🛰 providers
  if (DEBUG) console.log("📡 Connecting to Mainnet Ethereum");

  const logoutOfWeb3Modal = async () => {
    await web3Modal.clearCachedProvider();
    if (injectedProvider && injectedProvider.provider && typeof injectedProvider.provider.disconnect == "function") {
      await injectedProvider.provider.disconnect();
    }
    setTimeout(() => {
      window.location.reload();
    }, 1);
  };

  /* 💵 This hook will get the price of ETH from 🦄 Uniswap: */
  const price = useExchangeEthPrice(targetNetwork, mainnetProvider);

  /* 🔥 This hook will get the price of Gas from ⛽️ EtherGasStation */
  const gasPrice = useGasPrice(targetNetwork, "fast");
  // Use your injected provider from 🦊 Metamask or if you don't have it then instantly generate a 🔥 burner wallet.
  const userProviderAndSigner = useUserProviderAndSigner(injectedProvider, localProvider, USE_BURNER_WALLET);
  const userSigner = userProviderAndSigner.signer;

  useEffect(() => {
    async function getAddress() {
      if (userSigner) {
        const newAddress = await userSigner.getAddress();
        setAddress(newAddress);
      }
    }
    getAddress();
  }, [userSigner]);

  // You can warn the user if you would like them to be on a specific network
  const localChainId = localProvider && localProvider._network && localProvider._network.chainId;
  const selectedChainId =
    userSigner && userSigner.provider && userSigner.provider._network && userSigner.provider._network.chainId;

  // For more hooks, check out 🔗eth-hooks at: https://www.npmjs.com/package/eth-hooks

  // The transactor wraps transactions and provides notificiations
  const tx = Transactor(userSigner, gasPrice);

  // 🏗 scaffold-eth is full of handy hooks like this one to get your balance:
  const yourLocalBalance = useBalance(localProvider, address);

  // Just plug in different 🛰 providers to get your balance on different chains:
  const yourMainnetBalance = useBalance(mainnetProvider, address);

  // const contractConfig = useContractConfig();

  const contractConfig = { deployedContracts: deployedContracts || {}, externalContracts: externalContracts || {} };

  // Load in your local 📝 contract and read a value from it:
  const readContracts = useContractLoader(localProvider, contractConfig);

  // If you want to make 🔐 write transactions to your contracts, use the userSigner:
  const writeContracts = useContractLoader(userSigner, contractConfig, localChainId);

  // EXTERNAL CONTRACT EXAMPLE:
  //
  // If you want to bring in the mainnet DAI contract it would look like:
  const mainnetContracts = useContractLoader(mainnetProvider, contractConfig);

  // call every 1500 seconds.
  // usePoller(() => {
  //   updateGuidler();
  // }, 1500000);

  // Then read your DAI balance like:
  const myMainnetDAIBalance = useContractReader(mainnetContracts, "DAI", "balanceOf", [
    "0x34aA3F359A9D614239015126635CE7732c18fDF3",
  ]);

  // keep track of a variable from the contract in the local React state:
  const capeBalance = useContractReader(readContracts, "Cape", "balanceOf", [address]);
  console.log("🤗 Cape balance:", capeBalance);
  const armsBalance = useContractReader(readContracts, "Arms", "balanceOf", [address]);
  console.log("🤗 Arms balance:", armsBalance);
  const chestBalance = useContractReader(readContracts, "Chest", "balanceOf", [address]);
  console.log("🤗 Chest balance:", chestBalance);
  const capeFrontBalance = useContractReader(readContracts, "CapeFront", "balanceOf", [address]);
  console.log("🤗 CapeFront balance:", capeFrontBalance);
  const bootsBalance = useContractReader(readContracts, "Boots", "balanceOf", [address]);
  console.log("🤗 Boots balance:", bootsBalance);
  const waistBalance = useContractReader(readContracts, "Waist", "balanceOf", [address]);
  console.log("🤗 Waist balance:", waistBalance);
  const headmailBalance = useContractReader(readContracts, "HeadMail", "balanceOf", [address]);
  console.log("🤗 Headmail balance:", headmailBalance);
  const helmetBalance = useContractReader(readContracts, "Helmet", "balanceOf", [address]);
  console.log("🤗 Helmet balance:", helmetBalance);
  const ethlogoBalance = useContractReader(readContracts, "ETHLogo", "balanceOf", [address]);
  console.log("🤗 ETHLogo balance:", ethlogoBalance);
  const swordBalance = useContractReader(readContracts, "Sword", "balanceOf", [address]);
  console.log("🤗 Sword balance:", swordBalance);

  const guidlerBalance = useContractReader(readContracts, "Noob", "balanceOf", [address]);
  // console.log("🤗 Guidler balance:", guidlerBalance);

  // 📟 Listen for broadcast events
  const capeTransferEvents = useEventListener(readContracts, "Cape", "Transfer", localProvider, 1);
  // console.log("📟 Cape Transfer events:", capeTransferEvents);
  const waistTransferEvents = useEventListener(readContracts, "Waist", "Transfer", localProvider, 1);
  console.log("📟 Waist Transfer events:", waistTransferEvents);

  const guidlerTransferEvents = useEventListener(readContracts, "Noob", "Transfer", localProvider, 1);
  // console.log("📟 Guidler Transfer events:", guidlerTransferEvents);

  //
  // 🧠 This effect will update yourCollectibles by polling when your balance changes
  //
  const yourCapeBalance = capeBalance && capeBalance.toNumber && capeBalance.toNumber();
  const yourArmsBalance = armsBalance && armsBalance.toNumber && armsBalance.toNumber();
  const yourChestBalance = chestBalance && chestBalance.toNumber && chestBalance.toNumber();
  const yourCapeFrontBalance = capeFrontBalance && capeFrontBalance.toNumber && capeFrontBalance.toNumber();
  const yourBootsBalance = bootsBalance && bootsBalance.toNumber && bootsBalance.toNumber();
  const yourWaistBalance = waistBalance && waistBalance.toNumber && waistBalance.toNumber();
  const yourHeadmailBalance = headmailBalance && headmailBalance.toNumber && headmailBalance.toNumber();
  const yourHelmetBalance = helmetBalance && helmetBalance.toNumber && helmetBalance.toNumber();
  const yourETHLogoBalance = ethlogoBalance && ethlogoBalance.toNumber && ethlogoBalance.toNumber();
  const yourSwordBalance = swordBalance && swordBalance.toNumber && swordBalance.toNumber();

  const yourGuidlerBalance = guidlerBalance && guidlerBalance.toNumber && guidlerBalance.toNumber();


  const [yourGuidler, setYourGuidler] = useState();
  const [yourCollectable, setYourCollectable] = useState();

  async function updateGuidler() {
    const guidlerUpdate = [];

    for (let tokenIndex = 0; tokenIndex < yourGuidlerBalance; tokenIndex++) {
      try {
        console.log("Getting token index", tokenIndex);
        const tokenId = await readContracts.Noob.tokenOfOwnerByIndex(address, tokenIndex);
        console.log("tokenId", tokenId);
        console.log(readContracts.Noob.tokenURI(tokenId));
        const tokenURI = await readContracts.Noob.tokenURI(tokenId);
        console.log("tokenURI", tokenURI);
        const jsonManifestString = Buffer.from(tokenURI.substring(29), 'Base64');
        console.log("jsonManifestString", jsonManifestString);

        try {
          const jsonManifest = JSON.parse(jsonManifestString);
          console.log("jsonManifest", jsonManifest);
          guidlerUpdate.push({ id: tokenId, uri: tokenURI, owner: address, ...jsonManifest });
        } catch (e) {
          console.log(e);
        }
      } catch (e) {
        console.log(e);
      }
    }
    setYourGuidler(guidlerUpdate.reverse());
  }

  const updateYourCollectables = async () => {
    const collectableUpdate = [];
    const contracts = ['Cape', 'Arms', 'Chest', 'CapeFront', 'Boots', 'Waist', 'Headmail'];
    const balances = [yourCapeBalance, yourArmsBalance, yourChestBalance, yourCapeFrontBalance, yourBootsBalance, yourWaistBalance, yourHeadmailBalance];
    let tokenIndex = 0;
  
    for(let i = 0; i < contracts.length; i++) {
      if(balances[i] > 0) {
        try {
          const tokenId = await readContracts[contracts[i]].tokenOfOwnerByIndex(address, tokenIndex);
          const tokenURI = await readContracts[contracts[i]].tokenURI(tokenId);
          const jsonManifestString = Buffer.from(tokenURI.substring(29), 'Base64');
          const jsonManifest = JSON.parse(jsonManifestString);
          collectableUpdate.push({ key: tokenId, id: tokenId, uri: tokenURI, owner: address, contract: contracts[i], ...jsonManifest });
        } catch (e) {
          console.log(e);
        }
      }
    }
    setYourCollectable(collectableUpdate);
  }
  useEffect(() => {
    updateYourCollectables();
  }, [address, yourCapeBalance, yourArmsBalance, yourChestBalance, yourCapeFrontBalance, yourBootsBalance, yourWaistBalance, yourHeadmailBalance])

    const [allGuidlers, setAllGuidlers] = useState({});
    let allGuidlerUpdate = [];
      
    
async function getTokenInfo() {
  try {
    const totalSupply = readContracts.Noob && await readContracts.Noob.totalSupply();
    const totalNum = totalSupply && totalSupply.toNumber();

    for (let i = 1; i <= totalNum; i++) {
      const tokenId = i;
      const owner = await readContracts.Noob.ownerOf(tokenId);
      const tokenURI = await readContracts.Noob.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), 'Base64');

      try {
        const jsonManifest = JSON.parse(jsonManifestString);
        allGuidlerUpdate.push({ id: tokenId, uri: tokenURI, owner: address, ...jsonManifest });
      } catch (e) {
        console.log(e);
      }
    }
  } catch (err) {
    console.error(err);
  }
  setAllGuidlers(allGuidlerUpdate.reverse());
}

getTokenInfo();

   

  /*
  const addressFromENS = useResolveName(mainnetProvider, "austingriffith.eth");
  console.log("🏷 Resolved austingriffith.eth as:",addressFromENS)
  */

  //
  // 🧫 DEBUG 👨🏻‍🔬
  //
  useEffect(() => {
    if (
      DEBUG &&
      mainnetProvider &&
      address &&
      selectedChainId &&
      yourLocalBalance &&
      yourMainnetBalance &&
      readContracts &&
      writeContracts &&
      mainnetContracts
    ) {
      console.log("_____________________________________ 🏗 scaffold-eth _____________________________________");
      console.log("🌎 mainnetProvider", mainnetProvider);
      console.log("🏠 localChainId", localChainId);
      console.log("👩‍💼 selected address:", address);
      console.log("🕵🏻‍♂️ selectedChainId:", selectedChainId);
      console.log("💵 yourLocalBalance", yourLocalBalance ? ethers.utils.formatEther(yourLocalBalance) : "...");
      console.log("💵 yourMainnetBalance", yourMainnetBalance ? ethers.utils.formatEther(yourMainnetBalance) : "...");
      console.log("📝 readContracts", readContracts);
      console.log("🌍 DAI contract on mainnet:", mainnetContracts);
      console.log("💵 yourMainnetDAIBalance", myMainnetDAIBalance);
      console.log("🔐 writeContracts", writeContracts);
    }
  }, [
    mainnetProvider,
    address,
    selectedChainId,
    yourLocalBalance,
    yourMainnetBalance,
    readContracts,
    writeContracts,
    mainnetContracts,
  ]);

  const loadWeb3Modal = useCallback(async () => {
    const provider = await web3Modal.connect();
    setInjectedProvider(new ethers.providers.Web3Provider(provider));

    provider.on("chainChanged", chainId => {
      console.log(`chain changed to ${chainId}! updating providers`);
      setInjectedProvider(new ethers.providers.Web3Provider(provider));
    });

    provider.on("accountsChanged", () => {
      console.log(`account changed!`);
      setInjectedProvider(new ethers.providers.Web3Provider(provider));
    });

    // Subscribe to session disconnection
    provider.on("disconnect", (code, reason) => {
      console.log(code, reason);
      logoutOfWeb3Modal();
    });
  }, [setInjectedProvider]);

  useEffect(() => {
    if (web3Modal.cachedProvider) {
      loadWeb3Modal();
    }
  }, [loadWeb3Modal]);

  const faucetAvailable = localProvider && localProvider.connection && targetNetwork.name.indexOf("local") !== -1;
  const [transferToAddresses, setTransferToAddresses] = useState({});
  const [transferToGuidlerId, setTransferToGuidlerId] = useState({});
  const [pending, setPending] = useState(false);

  return (
    <div className="App">
      {/* ✏️ Edit the header and change the title to your project name */}
      <Header>
        {/* 👨‍💼 Your account is in the top right with a wallet at connect options */}
        <div style={{ position: "relative", display: "flex", flexDirection: "column" }}>
          <div style={{ display: "flex", flex: 1 }}>
            {USE_NETWORK_SELECTOR && (
              <div style={{ marginRight: 20 }}>
                {/* <NetworkSwitch
                  networkOptions={networkOptions}
                  selectedNetwork={selectedNetwork}
                  setSelectedNetwork={setSelectedNetwork}
                /> */}
              </div>
            )}
            <Account
              useBurner={USE_BURNER_WALLET}
              address={address}
              localProvider={localProvider}
              userSigner={userSigner}
              mainnetProvider={mainnetProvider}
              price={price}
              web3Modal={web3Modal}
              loadWeb3Modal={loadWeb3Modal}
              logoutOfWeb3Modal={logoutOfWeb3Modal}
              blockExplorer={blockExplorer}
            />
          </div>
        </div>
      </Header>
      {yourLocalBalance.lte(ethers.BigNumber.from("0")) && (
        <FaucetHint localProvider={localProvider} targetNetwork={targetNetwork} address={address} />
      )}
      <NetworkDisplay
        NETWORKCHECK={NETWORKCHECK}
        localChainId={localChainId}
        selectedChainId={selectedChainId}
        targetNetwork={targetNetwork}
        logoutOfWeb3Modal={logoutOfWeb3Modal}
        USE_NETWORK_SELECTOR={USE_NETWORK_SELECTOR}
      />

      <Stack direction={"row"} align={"center"} justify={"center"} spacing={77}>
        <Link to={"/"}>Guilder</Link>
        <Link to={"/collectable"}>Collectables</Link>
        <Link to={"/guidlers"}>Guidlers</Link>
      </Stack>

      <Switch>
        {/* <Route exact path="/">
          
                🎛 this scaffolding is full of commonly used components
                this <Contract/> component will automatically parse your ABI
                and give you a form to interact with it locally
           

          <Contract
            name="Cape"
            customContract={writeContracts && writeContracts.Cape}
            signer={userSigner}
            provider={localProvider}
            address={address}
            blockExplorer={blockExplorer}
            contractConfig={contractConfig}
          />
        </Route>
        <Route exact path="/guidler">
          <Contract
            name="Guidler"
            signer={userSigner}
            provider={localProvider}
            address={address}
            blockExplorer={blockExplorer}
            contractConfig={contractConfig}
          />
        </Route> */}
        <Route exact path="/">          
          <Flex w={"full"} direction={"row-reverse"}>
            <Button
              mr={5}
              onClick={async () => {
                setPending(true);
                await tx(writeContracts.Noob.mintItem());
                setPending(false);
              }}
              isLoading={pending}
              loadingText="Minting"
            >
              MINT
            </Button>
            <Button mr={5} onClick={() => updateGuidler()}>
              Refresh
            </Button>
          </Flex>
          {/* */}

          <Container boxShadow="dark-lg" rounded="3xl" p={4} w={"fit-content"}>
            <List>
              {yourGuidler &&
                yourGuidler.map(item => {
                  const id = item.id.toNumber();


                  return (
                    <ListItem key={id + "_" + item.uri + "_" + item.owner}>
                      <Flex direction={"column"}>
                        <Heading fontFamily={"monospace"}>{item.name}</Heading>
                        <Image borderRadius={"2xl"} src={item.image} />
                        <Text>{item.description}</Text>
                      </Flex>

                      <Flex my={2} alignItems={"center"} justify={"center"} direction={"column"}>
                        <Flex direction={"row"} justify={"center"} align={"center"}>
                          <Text pr={2}>Owner</Text>
                          <Address
                            address={item.owner}
                            ensProvider={mainnetProvider}
                            blockExplorer={blockExplorer}
                            fontSize={16}
                          />
                        </Flex>
                        <Flex direction={"column"} alignItems={"center"} w={"fit-content"}>
                          <AddressInput
                            ensProvider={mainnetProvider}
                            placeholder="Transfer to address"
                            value={transferToAddresses[id]}
                            onChange={newValue => {
                              const update = {};
                              update[id] = newValue;
                              setTransferToAddresses({ ...transferToAddresses, ...update });
                            }}
                          />
                        </Flex>
                        <HStack my={3}>
                          <Button
                            onClick={() => {
                              console.log("writeContracts", writeContracts);
                              tx(writeContracts.Noob.transferFrom(address, transferToAddresses[id], id));
                            }}
                          >
                            Transfer
                          </Button>
                          <br />
                        </HStack>
                      </Flex>
                    </ListItem>
                  );
                })}
            </List>
          </Container>
        </Route>


        <Route exact path="/collectable">
        <div style={{ maxWidth: 820, margin: "auto", marginTop: 32, paddingBottom: 32 }}>
            <Button
              onClick={async () => {
                setPending(true);
                await tx(writeContracts.Cape.mintItem());
                await tx(writeContracts.Arms.mintItem());
                await tx(writeContracts.Chest.mintItem());
                await tx(writeContracts.CapeFront.mintItem());
                await tx(writeContracts.Boots.mintItem());
                await tx(writeContracts.Waist.mintItem());
                await tx(writeContracts.HeadMail.mintItem());
                await tx(writeContracts.Helmet.mintItem());
                await tx(writeContracts.ETHLogo.mintItem());
                await tx(writeContracts.Sword.mintItem());
                setPending(false);
              }}
              isLoading={pending}
            >
              MINT
            </Button>
          </div>
          {/* */}
            <Grid templateColumns='repeat(3, 1fr)' gap={6}>
              {yourCollectable &&
                yourCollectable.map((item, index) => {
                  const id = item.id.toNumber();
                  const contract = item.contract;
                  console.log(contract);

                  return (
                    <Container boxShadow="dark-lg" rounded="2xl" p={4} my={5} w={"fit-content"}>
                      <GridItem key={id + "_" + item.uri + "_" + item.owner + "_" + index}>
                        <Flex direction={"column"} align={"center"}> 
                          <Heading>
                            <div>
                              <span style={{ fontSize: 18, marginRight: 8 }}>{item.name}</span>
                            </div>
                          </Heading>
                          <Image h={"244"} src={item.image} />
                          <div>{item.description}</div>
                        </Flex>
                        <Flex my={2} alignItems={"center"} justify={"center"} direction={"column"}>
                          <Flex direction={"row"} justify={"center"} align={"center"}>
                            <Text pr={2}>Owner</Text>
                            <Address
                              address={item.owner}
                              ensProvider={mainnetProvider}
                              blockExplorer={blockExplorer}
                              fontSize={16}
                            />
                          </Flex>
                          <Flex direction={"column"} alignItems={"center"} w={"fit-content"}>
                            <br />
                            <Flex direction={"row"} justify={"center"} align={"center"}>
                              <Text pr={2}>Transfer to Guidler:</Text>
                              <Address
                                address={readContracts.Noob.address}
                                blockExplorer={blockExplorer}
                                fontSize={16}
                              />
                            </Flex>

                            <Input
                              placeholder="GUIDLER ID"
                              onChange={newValue => {
                                console.log("newValue", newValue.target.value);
                                const update = {};
                                update[id] = newValue.target.value;
                                console.log(update);
                                console.log(transferToGuidlerId);
                                setTransferToGuidlerId({ ...transferToGuidlerId, ...update });
                              }}
                            />

                            <Button
                              my={2}
                              onClick={() => {
                                console.log("writeContracts", writeContracts);
                                console.log("transferToGuidlerId[id]", transferToGuidlerId[id]);
                                console.log(parseInt(transferToGuidlerId[id]));

                                if(contract == "Cape") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.Cape["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "Arms") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.Arms["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "Chest") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.Chest["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "CapeFront") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.CapeFront["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "Boots") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.Boots["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "Waist") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.Waist["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "HeadMail") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.HeadMail["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "Helmet") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.Helmet["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "ETHLogo") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.ETHLogo["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else if(contract == "Sword") {
                                  const guidlerIdInBytes =
                                  "0x" + parseInt(transferToGuidlerId[id]).toString(16).padStart(64, "0");
                                  console.log(guidlerIdInBytes);

                                  tx(
                                    writeContracts.Sword["safeTransferFrom(address,address,uint256,bytes)"](
                                      address,
                                      readContracts.Noob.address,
                                      id,
                                      guidlerIdInBytes,
                                    ),
                                  );
                                } else {
                                  // Implement error handling
                                  console.error("Error");;
                                }
                              }}
                            >
                              Transfer
                            </Button>
                          </Flex>
                        </Flex>
                      </GridItem>
                </Container>
                  );
                })}
            </Grid>
          {/* */}
        </Route>
        <Route exact path="/guidlers">
        
            <Grid templateColumns='repeat(3, 1fr)' gap={6}>
              {yourCollectable &&
                yourCollectable.map(item => {
                  const id = item.id.toNumber();
                  return (
                    <Container boxShadow="dark-lg" rounded="2xl" p={4} my={5} w={"fit-content"}>
                      <GridItem key={id + "_" + item.uri + "_" + item.owner}>
                        <Flex direction={"column"} align={"center"}>
                          <Heading>
                            <div>
                              <span style={{ fontSize: 18, marginRight: 8 }}>{item.name}</span>
                            </div>
                          </Heading>
                          <Image h={"244"} src={item.image} />
                          {/* <div>{item.description}</div> */}
                        </Flex>
                        <Flex my={2} alignItems={"center"} justify={"center"} direction={"column"}>
                          <Flex direction={"row"} justify={"center"} align={"center"}>
                            <Text pr={2}>Owner</Text>
                            <Address
                              address={item.owner}
                              ensProvider={mainnetProvider}
                              blockExplorer={blockExplorer}
                              fontSize={16}
                            />
                          </Flex>
                        </Flex>
                      </GridItem>
                </Container>
                  );
                })}
            </Grid>
          {/* */}
        </Route>
      </Switch>
      <div
        style={{
          position: "fixed",
          display: "flex",
          direction: "right",
          right: 0,
          bottom: 20,
          padding: 10,
        }}
      >
        <ThemeSwitch />
      </div>

      {/* 🗺 Extra UI like gas price, eth price, faucet, and support: */}
      <div
        style={{
          position: "fixed",
          display: "flex",
          direction: "right",
          textAlign: "left",
          left: 0,
          bottom: 20,
          padding: 6,
        }}
      >
        <Flex justify={"center"} align={"center"} direction={"left"}>
          <Box>
            <Ramp price={price} address={address} networks={NETWORKS} />
          </Box>

          <Box>
            <GasGauge gasPrice={gasPrice} />
          </Box>
          <Box>
            <Button
              variant={"unstyled"}
              onClick={() => {
                window.open("https://t.me/joinchat/KByvmRe5wkR-8F_zz6AjpA");
              }}
            >
              <span style={{ marginRight: 8 }} role="img" aria-label="support">
                💬
              </span>
              Support
            </Button>
          </Box>
        </Flex>
        {/* 
        <HStack align="middle" gutter={[4, 4]}>
          <VStack span={24}>
            {
             
              faucetAvailable ? (
                <Faucet localProvider={localProvider} price={price} ensProvider={mainnetProvider} />
              ) : (
                ""
              )
            }
          </VStack>
        </HStack> */}
      </div>
    </div>
  );
}

export default App;
