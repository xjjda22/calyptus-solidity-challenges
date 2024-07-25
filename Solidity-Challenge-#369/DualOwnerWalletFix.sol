// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';

contract DualOwnerWalletFix {
    using ECDSA for bytes32;

    address[2] public custodians;

    constructor(address[2] memory initialCustodians) payable {
        custodians = initialCustodians;
    }

    function contribute() external payable {}

    function sendFunds(address recipient, uint amount, bytes[2] memory signatures) external {
        bytes32 transactionHash = calculateTxHash(recipient, amount);
        require(verifySignatures(signatures, transactionHash), 'Invalid signature');

        (bool success, ) = recipient.call{ value: amount }('');
        require(success, 'Failed to send Ether');
    }

    function calculateTxHash(address recipient, uint amount) public view returns (bytes32) {
        return keccak256(abi.encodePacked(recipient, amount));
    }

    function verifySignatures(bytes[2] memory signatures, bytes32 transactionHash) private view returns (bool) {
        // Use the ECDSA library's toEthSignedMessageHash function
        bytes32 ethSignedHash = transactionHash.toEthSignedMessageHash();
        for (uint i = 0; i < signatures.length; i++) {
            // Use the ECDSA library's recover function
            address signer = ECDSA.recover(ethSignedHash, signatures[i]);
            bool isValid = signer == custodians[i];
            if (!isValid) {
                return false;
            }
        }
        return true;
    }
}
