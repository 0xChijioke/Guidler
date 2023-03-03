import { useState, useEffect } from "react";

const Guidlers = (readContracts ) => {
  async function getAllGuidlers() {
    const totalGuidlers = await readContracts.Noob.totalSupply();
    const allGuidlers = [];

    for (let i = 0; i < totalGuidlers; i++) {
      const tokenId = await readContracts.Guidler.tokenByIndex(i);
      const owner = await readContracts.Guidler.ownerOf(tokenId);
      allGuidlers.push({ id: tokenId, owner: owner });
    }

    return allGuidlers;
  }
};

export default Guidlers;
