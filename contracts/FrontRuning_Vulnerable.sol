// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*

1. Yolanda despliega el contrato con un saldo de X ethers
2. Alice encuentra la palabra correcta, que es "Conquer Blocks" y llama a la funcion solve, pero lo hace con el minimo gas a pagar
3. Bob esta observando el mempool y ve la transaccion de Alice, asi que ejecuta la misma transaccion pero pagando mucho mas gas
4. La transaccion de bob se mina o se valida antes que la de Alice (a pesar de que ella ha sido la primera en adivinar la palabra) y por lo tanto, Bob gana el premio
*/

contract FindTheWord {

    bytes32 public constant secretHash = 0x7ce2480ae379810bd95934eb0abae6daf3a1d1c49a259a0e4d608de64a3700cd;
    constructor () payable {}

    function solve (string memory solution) external {
        require (secretHash == keccak256(abi.encodePacked(solution)), "Incorrect answer");

        (bool sent, ) = msg.sender.call{value: 2 ether}("");
        require (sent, "Failed to send ethers");
    }

}