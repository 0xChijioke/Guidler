export const updateYourcollectables = async (
  readContracts,
  address,
  yourCapeBalance,
  yourArmsBalance,
  yourBootsBalance,
  yourCapeFrontBalance,
  yourChestBalance,
  yourETHLogoBalance,
  yourHeadmailBalance,
  yourHelmetBalance,
  yourSwordBalance,
  yourWaistBalance,
  setYourCollectable,
) => {
  const collectableUpdate = [];

  if (yourCapeBalance > 0) {
    try {
      const tokenId = await readContracts.Cape.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.Cape.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "Cape",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }

  if (yourArmsBalance > 0) {
    try {
      const tokenId = await readContracts.Arms.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.Arms.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "Arms",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }
  if (yourChestBalance > 0) {
    try {
      const tokenId = await readContracts.Chest.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.Chest.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "Chest",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }
  if (yourCapeFrontBalance > 0) {
    try {
      const tokenId = await readContracts.CapeFront.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.CapeFront.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "CapeFront",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }
  if (yourBootsBalance > 0) {
    try {
      const tokenId = await readContracts.Boots.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.Boots.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "Boots",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }
  if (yourWaistBalance > 0) {
    try {
      const tokenId = await readContracts.Waist.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.Waist.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "Waist",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }
  if (yourHeadmailBalance > 0) {
    try {
      const tokenId = await readContracts.Headmail.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.Headmail.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "Headmail",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }
  if (yourHelmetBalance > 0) {
    try {
      const tokenId = await readContracts.Helmet.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.Helmet.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "Helmet",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }
  if (yourETHLogoBalance > 0) {
    try {
      const tokenId = await readContracts.ETHLogo.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.ETHLogo.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "ETHLogo",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }
  if (yourSwordBalance > 0) {
    try {
      const tokenId = await readContracts.Sword.tokenOfOwnerByIndex(address, 0);
      const tokenURI = await readContracts.Sword.tokenURI(tokenId);
      const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
      const jsonManifest = JSON.parse(jsonManifestString);
      collectableUpdate.push({
        key: tokenId,
        id: tokenId,
        uri: tokenURI,
        owner: address,
        contract: "Sword",
        ...jsonManifest,
      });
    } catch (e) {
      console.log(e);
    }
  }

  // Repeat for each contract

  setYourCollectable(collectableUpdate.reverse());
};
