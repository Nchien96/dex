import simTokenAbi from "./build/contracts/CryptoSimsToken.sol/CryptoSims.json";

import { Web3 } from "web3";
const web3 = new Web3(window.ethereum);

const simsTokenAddress = "0xaCE7f7970BCb344fEA5387e4ecEd6EC0559A3C7D";

const simTokeContract = async () => {
  const simTokeContract = new web3.eth.Contract(
    simTokenAbi.abi,
    simsTokenAddress
  );
  return simTokeContract;
};

export { simTokeContract, simsTokenAddress };
