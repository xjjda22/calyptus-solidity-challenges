// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import '../contracts/DualOwnerWalletFix.sol';

contract DualOwnerWalletFixTest is Test {
    DualOwnerWalletFix dualOwnerWalletFix;
    address owner1;
    address owner2;
    address recipient;

    function setUp() public {
        owner1 = address(0x1);
        owner2 = address(0x2);
        recipient = address(0x3);
        dualOwnerWalletFix = new DualOwnerWalletFix([owner1, owner2]);
        payable(address(dualOwnerWalletFix)).transfer(10 ether);
    }

    function testInitialCustodians() public {
        assertEq(dualOwnerWalletFix.custodians(0), owner1);
        assertEq(dualOwnerWalletFix.custodians(1), owner2);
    }

    function testSendFundsWithValidSignatures() public {
        uint amount = 1 ether;
        bytes32 txHash = dualOwnerWalletFix.calculateTxHash(recipient, amount);
        bytes memory signature1 = signHash(txHash, 1);
        bytes memory signature2 = signHash(txHash, 2);
        bytes[2] memory signatures = [signature1, signature2];

        vm.prank(owner1);
        dualOwnerWalletFix.sendFunds(recipient, amount, signatures);

        assertEq(recipient.balance, amount);
    }

    function testFailSendFundsWithInvalidSignatures() public {
        uint amount = 1 ether;
        bytes32 txHash = dualOwnerWalletFix.calculateTxHash(recipient, amount);
        bytes memory invalidSignature = signHash(txHash, 1);
        bytes[2] memory invalidSignatures = [invalidSignature, invalidSignature];

        vm.prank(owner1);
        dualOwnerWalletFix.sendFunds(recipient, amount, invalidSignatures);
    }

    function signHash(bytes32 _hash, uint8 _privateKey) internal pure returns (bytes memory) {
        return _hash.toEthSignedMessageHash().recover(_privateKey);
    }
}
