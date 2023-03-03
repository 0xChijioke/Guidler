async function updateGuidler(readContracts, address, setYourGuidler) {
  const guidlerUpdate = [];

  try {
    console.log("Getting token index 0");
    const tokenId = await readContracts.Noob.tokenOfOwnerByIndex(address, 0);
    console.log("tokenId", tokenId);
    console.log(readContracts.Noob.tokenURI(tokenId));
    const tokenURI = await readContracts.Noob.tokenURI(tokenId);
    console.log("tokenURI", tokenURI);
    const jsonManifestString = Buffer.from(tokenURI.substring(29), "Base64");
    console.log("jsonManifestString", jsonManifestString);

    try {
      const jsonManifest = JSON.parse(jsonManifestString);
      console.log("jsonManifest", jsonManifest);
      setYourGuidler([{ id: tokenId, uri: tokenURI, owner: address, ...jsonManifest }].reverse());
    } catch (e) {
      console.log(e);
    }
  } catch (e) {
    console.log(e);
  }
  setYourGuidler(guidlerUpdate.reverse());
}
export { updateGuidler };
