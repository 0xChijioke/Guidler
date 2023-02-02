import React from 'react';
import { useState, useEffect } from 'react';

const Guidlers = (readContracts, address) => {
    const [allGuidlers, setAllGuidlers] = useState({});
    let allGuidlerUpdate = [];
      
    useEffect(() => {
      try {
        const totalSupply = readContracts.Noob && readContracts.Noob.totalSupply();
        const totalNum = totalSupply && totalSupply.toNumber();
    
        for (let i = 1; i <= totalNum; i++) {
          const tokenId = i;
          const owner = readContracts.Noob && readContracts.Noob.ownerOf(tokenId);
          const tokenURI = readContracts.Noob && readContracts.Noob.tokenURI(tokenId);
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
    })  

   
  return (
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
  )
}

export default Guidlers